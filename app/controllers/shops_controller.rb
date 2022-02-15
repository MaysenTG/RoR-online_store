class ShopsController < ApplicationController
  
  def index
    @products = Product.all
    @order_item = current_order.order_items.new
  end

  def show
    @shop = Product.find(params[:id])
    @order_item = current_order.order_items.new
  end
end
