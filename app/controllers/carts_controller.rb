class CartsController < ApplicationController
  before_action :set_product, only: %i[ add_item edit update destroy remove_item update_quantity ]
  before_action :set_cart_session, only: %i[ add_item ]
  before_action :update_cart_info, only: %i[ add_item remove_item update_quantity get_cart ]
  
  def show
    @cart_items = [] 
    
    begin
      session["cart_contents"]["items"].each do |line|
        if line.include?("id")
          product = Product.find(line["id"])
          #url = Rails.application.routes.url_helpers.rails_blob_path(product.image, disposition: "attachment", only_path: true)
          #line["image"] = url
          @cart_items << line
        end
      end
    rescue => e
      @cart_items = []
    end
    
    sum = 0
    if @cart_items != nil
      @cart_items.each do |item|
        sum += item["quantity"].to_i
      end
      @total_items_in_cart = sum
    else
      @total_items_in_cart = 0
    end
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
    
    respond_to do |format|
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
    
    respond_to do |format|
      #format.js { render :file => "rerender.js.erb" }
      #format.html { render partial: "rerender.html.erb" }
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
        @cart_product["quantity"] = @quantity
        session["cart_contents"]["items"] << (@cart_product) 
      end
    else #session["cart_contents"]["items"].size <= 1
      @cart_product = @product.as_json
      @cart_product["quantity"] = @quantity
      session["cart_contents"]["items"] = [@cart_product]
    end
      
    respond_to do |format|
      format.json { render json: {status => session["cart_contents"].length} }
    end
  end
  
  def update_cart_info    
    session["cart_contents"]["info"]["subtotal"] = sub_total_in_cart
    session["cart_contents"]["info"]["total_items"] = total_items_in_cart
  end
  
  def get_cart
    cart = session["cart_contents"]
    render json: session["cart_contents"].as_json
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
  def set_product
    begin
      json_params = JSON.parse(request.raw_post)
      puts json_params["product_id"]
      @quantity = json_params["quantity"]
      @product = Product.find(json_params["product_id"])
    rescue => e
      @product = Product.find(params[:id])
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
      #session["cart_contents"].clear
      #session.clear
      #reset_session
      #session["cart_contents"] = []
      #puts session["cart_contents"]
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
