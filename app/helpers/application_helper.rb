module ApplicationHelper
    def account_roles
        [
            {name: "Admin", value: "admin"},
            {name: "Customer", value: "customer"},
            {name: "Guest", value: "guest"},
        ]
    end

    def current_order
        if session[:order_id].nil?
            Order.new
        else
            Order.find(session[:order_id])
        end
    end
    
    def total_items_in_cart
        sum = 0
        begin
            session["cart_contents"]["items"].each do |item|
                sum += item["quantity"].to_i
            end
        rescue => e
            sum = 0
        end
        
        return sum
    end
    
    def sub_total_in_cart
        subtotal = 0
        begin
            session["cart_contents"]["items"].each do |item|
                subtotal += item["quantity"].to_i * item["price"].to_i
            end
        rescue => e
            subtotal = 0
        end
        
        return subtotal
    end
end
