module Admin
  class DashboardController < ApplicationController
    def home
    end
    
    def orders
      # Grab orders from Stripe API which have been paid
      @charges = Stripe::Charge.list({limit: 100})
      @orders = @charges["data"]
      
      puts @orders[0]
    end
  end
end
