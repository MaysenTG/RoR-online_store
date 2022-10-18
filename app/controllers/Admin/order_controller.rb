module Admin
  class OrderController < ApplicationController
    
    def show
      @order = Stripe::Checkout::Session.retrieve(params[:order_id])
    
      @line_items = Stripe::Checkout::Session.list_line_items(params[:order_id])["data"]
      
      puts "---------"
      puts @line_items
      puts "---------"
      
      @customer = Stripe::Customer.retrieve(@order["customer"])
      
      @customer_account_info = @order["customer_details"]
      @customer_address = @customer_account_info["address"]
      
      @payment_intent = Stripe::PaymentIntent.retrieve(@order["payment_intent"])
    
      @payment_method_details = @payment_intent["charges"]["data"][0]["payment_method_details"]
      
      @total_order_cost = @order["amount_total"]
    end
    
    def all
      @has_filter = false
      
      customers = Stripe::Customer.list
      
      @all_customers = []
      customers.each do |customer|
        @all_customers.push({ customer_id: customer["id"], customer_name: customer["name"] }.as_json)
      end
      
      @sessions = Stripe::Checkout::Session.list()

      @orders = @sessions["data"]
      
      # Delete all non-complete/non-purchased orders
      @orders.delete_if {|order| order["status"] != "complete" }
          
      # if (params[:order] != nil)
      #   if(params[:order][:filter][:customer_id] != "")
      #     puts "Filtering by customer with the ID #{params[:order][:filter][:customer_id]}"
      #     @charges = Stripe::Charge.search({
      #       query: "customer: \"#{params[:order][:filter][:customer_id]}\"",
      #     })
      #     @orders = @charges["data"]
      #     @current_filter = params[:order][:filter][:customer_id]
      #     @has_filter = true
      #   else
      #     @charges = Stripe::Charge.list({limit: 100})
      #     @orders = @charges["data"]
      #   end
      # end
    end
  end
end
