class CartsController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :set_product, only: %i[ add_item edit update destroy remove_item update_quantity ]
  before_action :set_cart_session, only: %i[ add_item ]
  before_action :update_cart_info, only: %i[ add_item remove_item update_quantity get_cart ]
  
  def show
    @cart_items = [] 
    
    begin
      session["cart_contents"]["items"].each do |line|
        if line.include?("id")
          product = Product.find(line["id"])
          image_url = product.image.url
          
          product_image_url = image_url
          line["image_url"] = product_image_url
          @cart_items << line
        end
      end
    rescue => e
      @cart_items = []
    end
    
    @total_items_in_cart = total_items_in_cart
  end
  
  def update_quantity
    session["cart_contents"]["items"].detect { |e| e['id'] == @product.id }['quantity'] = @quantity.to_i
    
    if @quantity.to_i <= 0
      new_data = []
    
      session["cart_contents"]["items"].each do |item|
        if item["id"] != @product.id
          new_data.push(item)
        end
      end
      session["cart_contents"]["items"] = new_data
    end
    
    @cart_items = session["cart_contents"]["items"]
    respond_to do |format|
      format.turbo_stream { render turbo_stream: [turbo_stream.update("cart-show", partial: "carts/carts_item", locals: { cart_items: @cart_items }), turbo_stream.update("cart", partial: "carts/cart")] }
      format.json { render json: {status => session["cart_contents"]["items"].length} }
    end
  end
  
  def remove_item
    #session["cart_contents"].delete(@product.id)
    new_data = []
    
    session["cart_contents"]["items"].each do |item|
      if item["id"] != @product.id
        new_data.push(item)
      end
    end
    session["cart_contents"]["items"] = new_data
    
    @cart_items = session["cart_contents"]["items"]
    respond_to do |format|
      format.turbo_stream { render turbo_stream: [turbo_stream.update("cart-show", partial: "carts/carts_item", locals: { cart_items: @cart_items }), turbo_stream.update("cart", partial: "carts/cart")] }
      format.json { render json: {status => session["cart_contents"].length} }
    end
  end
  
  def add_item
    if !session["cart_contents"]["items"].nil?
      if session["cart_contents"]["items"].detect { |e| e['id'] == @product.id }
        current_quantity = session["cart_contents"]["items"].detect { |e| e['id'] == @product.id }['quantity']
        new_quantity = (current_quantity.to_i + @quantity.to_i) * 1
        session["cart_contents"]["items"].detect { |e| e['id'] == @product.id }['quantity'] = new_quantity.to_i
      else
        @cart_product = @product.as_json
        url = rails_blob_path(@product.image, only_path: true)
        @cart_product["image_url"] = url
        @cart_product["quantity"] = @quantity
        session["cart_contents"]["items"] << (@cart_product) 
      end
    else #session["cart_contents"]["items"].size <= 1
      @cart_product = @product.as_json
      url = rails_blob_path(@product.image, only_path: true)
      @cart_product["image_url"] = url
      @cart_product["quantity"] = @quantity
      session["cart_contents"]["items"] = [@cart_product]
    end
      
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("cart", partial: "carts/cart") }
      format.json { render json: {status => session["cart_contents"].length} }
    end
  end
  
  def update_cart_info
    unless session["cart_contents"].nil? 
      session["cart_contents"]["info"]["subtotal"] = sub_total_in_cart
      session["cart_contents"]["info"]["total_items"] = total_items_in_cart
    end
    
  end
  
  def get_cart
    cart = session["cart_contents"]
    if !cart.nil?
      session["cart_contents"]["items"].each do |item|
        # Get the URL of the active storage image
        product = Product.find(item["id"])
        image_url = product.image.url
        
        puts "------"
        puts "------"
        puts "------"
        the_url = product.image.url
        puts the_url
        puts "------"
        puts "------"
        puts "------"
          
        product_image_url = image_url
        item["image_url"] = product_image_url
      end
    end
    
    @cart_items = [] 
    
    begin
      session["cart_contents"]["items"].each do |line|
        if line.include?("id")
          product = Product.find(line["id"])
          #url = rails_blob_path(product.image, only_path: true)
          image_url = product.image.url
          
          product_image_url = image_url
          line["image_url"] = product_image_url
          @cart_items << line
        end
      end
    rescue => e
      puts "Error VV"
      puts e
      puts "Error ^^"
      @cart_items = []
    end
    
    @total_items_in_cart = total_items_in_cart
    
    respond_to do |format|
      format.html { render :show }
      format.json { render json: cart }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
  def set_product
    begin
      json_params = JSON.parse(request.raw_post)
      @quantity = json_params["quantity"]
      @product = Product.find(json_params["product_id"])
    rescue => e
      begin
        @product = Product.find(params[:id])
        @quantity = params[:quantity]
      rescue
        @product = Product.find(params[:product_id])
        @quantity = params[:quantity]
      end
    end
  end
  
  def set_cart_session
    if session["cart_contents"].nil?
      session["cart_contents"] = {
        #"items": [{"1": "1"}],
        "items": [],
        "info": {
          "subtotal": 0,
          "total_items": 0
        },
      }.as_json
    else

    end
  end
  
  def reset_session 
    session["cart_contents"].reset_session
  end 

    # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:title, :price, :product_id, :quantity)
  end
end
