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
  end
end
