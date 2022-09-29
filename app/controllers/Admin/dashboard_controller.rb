module Admin
  class DashboardController < ApplicationController
    # Include the turbo stream helper
    helper Turbo::StreamsHelper
    
    def home
    end
    
    def search
      puts "searching"
      puts params[:query]
      puts "source: #{params[:source]}"
      puts "searching"
      
      if params[:query] != ""
        @products = Product.where("id LIKE :search or description LIKE :search or price LIKE :search or title LIKE :search or created_at LIKE :search or updated_at LIKE :search", search: "%#{params[:query]}%")
        @categories = Category.where("id LIKE :search or category LIKE :search or created_at LIKE :search or updated_at LIKE :search", search: "%#{params[:query]}%")
      end
      
      respond_to do |format|
        if params[:query] == ""
          format.turbo_stream do
            if params[:source] == "modal"
              render turbo_stream: turbo_stream.update("search-results-modal", partial: "admin/dashboard/partials/blank-results")
            else
              render turbo_stream: turbo_stream.update("search-results", partial: "admin/dashboard/partials/blank-results")
            end
          end
        else
          format.turbo_stream do
            if params[:source] == "modal"
              render turbo_stream: turbo_stream.update("search-results-modal", partial: "admin/dashboard/partials/search-results", locals: {products: @products, categories: @categories})
            else
              render turbo_stream: turbo_stream.update("search-results", partial: "admin/dashboard/partials/search-results", locals: {products: @products, categories: @categories})
            end
          end
        end
        format.html do
          render params[:query]
        end
      end
    end
    
    def new_search
      # if params[:search] != ""
      #   products = Product.where("id LIKE :search or description LIKE :search or price LIKE :search or title LIKE :search or created_at LIKE :search or updated_at LIKE :search", search: "%#{params[:search]}%").as_json
      #   categories = Category.where("id LIKE :search or category LIKE :search or created_at LIKE :search or updated_at LIKE :search", search: "%#{params[:search]}%").as_json
      # end
      
      # if(params[:search].is_a? Integer)
      #   puts "is int"
      # end
      
      # # orders = Stripe::Charge.search({
      # #   query: "amount>\"#{params[:search]}\" or customer:\"#{params[:search]}\"",
      # # })
      # # return the products, categories, and orders only if they are not empty
      # render json: {status: "success", data: {products: products, categories: categories}}
    end
  end
end
