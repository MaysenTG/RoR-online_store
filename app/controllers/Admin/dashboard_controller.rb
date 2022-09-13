require 'stripe'

Stripe.api_key = 'sk_test_51Lh5hlACYImz8K7GqqE3FKHP0KCZJUpgS192Wv8DQEm7Hn3Cl9JaNVVZMr0ygTHkAsT28dVwHs2oxVi3kkYj5DQg00d9dMutjH'

module Admin
  class DashboardController < ApplicationController
    def home
    end
    
    def orders
      # Grab orders from Stripe API
      @charges = Stripe::Charge.list({limit: 3})
      @orders = @charges["data"]
    end
    
    def customers
      @customers = Stripe::Customer.list({limit: 3})
      @customer_data = @customers["data"]
      puts @customer_data
    end
  end
end
