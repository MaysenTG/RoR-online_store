class OrderItemsController < ApplicationController
    def create
        @order = current_order        
        @order_item = @order.order_items.new(order_params)
        @order.save
        session[:order_id] = @order.id
    end
    
    def update
        puts "----------------"
        puts "update"
        puts "----------------"
        @order = current_order
        @order_item = @order.order_items.find(params[:id])
        @order_item.update!(order_params)
        @order_items = current_order.order_items
    end
    
    def destroy
        @order = current_order
        @order_item = @order.order_items.find(params[:id])
        @order_item.destroy
        @order_items = current_order.order_items
    end
    
    
    
    
<<<<<<< HEAD
    private    
=======
    private
    
    def set_order_items
        @product = Product.find(params[:id])
      end
    
>>>>>>> e9f48b3f534d0837a929832b5e4006e135a1aa26
    def order_params
        params.require(:order_item).permit(:product_id, :quantity)
    end
end
