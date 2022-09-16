class ApplicationController < ActionController::Base    
    include ApplicationHelper
    #protect_from_forgery with: :null_session
    
    # Disable protect_from_forgery
    skip_before_action :verify_authenticity_token
    before_action :get_order_data
    
    def get_order_data
        if request.path == "/admin"
            # Query the Stripe Charge API for all orders and then sum the data per day of the week
            # and return the data to the view
            orders = Stripe::Charge.list({
                limit: 100,
            })
            @orders = orders.data
            @order_data = []
            @order_data[0] = 0 #Monday
            @order_data[1] = 0
            @order_data[2] = 0
            @order_data[3] = 0
            @order_data[4] = 0
            @order_data[5] = 0
            @order_data[6] = 0 # Sunday
            @orders.each do |order|
                # If the date is between today and 7 days ago
                if order.created > (Time.now - 7.days).to_i
                    # Get the day of the week
                    @order_data[Time.at(order.created).to_datetime.wday] += (order.amount / 100)
                end
            end
        end
    end
    
    
    
end
