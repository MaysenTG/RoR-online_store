module Admin
  class DashboardController < ApplicationController
    def home
    end
    
    def orders
      # Grab orders from Stripe API
      @charges = Stripe::Charge.list({limit: 3})
      @orders = @charges["data"]
    end
  end
end
