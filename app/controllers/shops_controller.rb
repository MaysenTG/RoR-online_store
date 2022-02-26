class ShopsController < ApplicationController
  
  def home
  end
  
  def index
    @products = Product.all.with_attached_image
    @order_item = current_order.order_items.new
  end

  def show
    @shop = Product.find(params[:id])
    @order_item = current_order.order_items.new
  end
end
