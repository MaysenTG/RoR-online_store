class ShopsCategoriesController < ApplicationController
  def index
    @categories = Category.all
    @order_item = current_order.order_items.new
  end

  def show
    @category = Category.find(params[:collection_id])
    @products = @category.products.includes([:image_attachment]).includes([:category])
    @order_item = current_order.order_items.new
  end
end
