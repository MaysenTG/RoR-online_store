module Admin
  class OrderController < ApplicationController
    
    def show
      @order = Stripe::Charge.retrieve(params[:order_id])
      customer_id = @order["customer"]
      @customer = Stripe::Customer.retrieve(customer_id)
      @order_items = @order["description"]
      
      # Get the order items from the order and fine the product
      # that matches the order item
      @total_order_cost = 0
      @order_products = []
      JSON.parse(@order_items).each do |item|
        product = Product.find(item["id"]).as_json
        product["quantity"] = item["quantity"]
        product["total_price"] = item["quantity"].to_i * product["price"].to_i
        @order_products.push(product)
        @total_order_cost += product["total_price"]
      end
    end
    
    def all
      @has_filter = false
      
      customers = Stripe::Customer.list
      
      @all_customers = []
      customers.each do |customer|
        @all_customers.push({ customer_id: customer["id"], customer_name: customer["name"] }.as_json)
      end
      
      @charges = Stripe::Charge.list({limit: 100})
      @orders = @charges["data"]
          
      if (params[:order] != nil)
        if(params[:order][:filter][:customer_id] != "")
          puts "Filtering by customer with the ID #{params[:order][:filter][:customer_id]}"
          @charges = Stripe::Charge.search({
            query: "customer: \"#{params[:order][:filter][:customer_id]}\"",
          })
          @orders = @charges["data"]
          @current_filter = params[:order][:filter][:customer_id]
          @has_filter = true
        else
          @charges = Stripe::Charge.list({limit: 100})
          @orders = @charges["data"]
        end
      end
    end
  end
end
