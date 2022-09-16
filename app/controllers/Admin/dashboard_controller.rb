module Admin
  class DashboardController < ApplicationController
    def home
    end
    
    def search
      if params[:search] != ""
        products = Product.where("id LIKE :search or description LIKE :search or price LIKE :search or title LIKE :search or created_at LIKE :search or updated_at LIKE :search", search: "%#{params[:search]}%").as_json
        categories = Category.where("id LIKE :search or category LIKE :search or created_at LIKE :search or updated_at LIKE :search", search: "%#{params[:search]}%").as_json
      end
      
      if(params[:search].is_a? Integer)
        puts "is int"
      end
      
      # orders = Stripe::Charge.search({
      #   query: "amount>\"#{params[:search]}\" or customer:\"#{params[:search]}\"",
      # })
      # return the products, categories, and orders only if they are not empty
      render json: {status: "success", data: {products: products, categories: categories}}
    end
  end
end
