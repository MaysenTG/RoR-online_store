module Admin
  class CustomerController < ApplicationController
    before_action :check_admin, only: %i[ edit_customer ]
    
    def show
      @customer = Stripe::Customer.retrieve(params[:customer_id])
      @orders = Stripe::Checkout::Session.list({customer: params[:customer_id]})
      
      puts "-------"
      puts "-------"
      puts "-------"
      puts @orders
      puts "-------"
      puts "-------"
      
      @order_data = @orders["data"]
    end
    
    def all
      @customers = Stripe::Customer.list()
      @customer_data = @customers["data"]
    end
    
    def edit_customer
      Stripe::Customer.update(
        params[:customer_id],
        {
          address: {
            city: params["customer"]["address"]["city"],
            country: params["customer"]["address"]["country"],
            line1: params["customer"]["address"]["line1"],
            line2: params["customer"]["address"]["line2"],
            postal_code: params["customer"]["address"]["postal_code"],
            state: params["customer"]["address"]["state"]
          },
          name: params["customer"]["info"]["name"],
          email: params["customer"]["info"]["email"],
          description: params["customer"]["info"]["description"],
        }
      )
      
      redirect_to "/admin/customers/#{params[:customer_id]}/edit"
    end
    
    def check_admin
      unless current_user.role == "admin"
        redirect_to admin_customer_url
      end
    end
  end
end
