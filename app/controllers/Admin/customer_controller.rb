module Admin
  class CustomerController < ApplicationController
    
    def show
      @customer = Stripe::Customer.retrieve(params[:customer_id])
      @orders = Stripe::Charge.list({customer: params[:customer_id]})
      @order_data = @orders["data"]
    end
    
    def all
      @customers = Stripe::Customer.list({limit: 3})
      @customer_data = @customers["data"]
      puts @customer_data
    end
  end
end
