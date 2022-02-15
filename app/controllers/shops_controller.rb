class ShopsController < ApplicationController
  def index
    @products = Product.all
    
    
    @order_item = current_order.order_items.new
    
    puts "-------------------------"
    puts current_order.order_items.inspect
    puts "-------------------------"
  end

  def show
    @shop = Product.find(params[:id])
  end
end
