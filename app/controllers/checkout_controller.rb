require 'stripe'

Stripe.api_key = 'sk_test_51Lh5hlACYImz8K7GqqE3FKHP0KCZJUpgS192Wv8DQEm7Hn3Cl9JaNVVZMr0ygTHkAsT28dVwHs2oxVi3kkYj5DQg00d9dMutjH'

class CheckoutController < ApplicationController
  before_action :require_items
  
  def show
    @line_items = session["cart_contents"]["items"]
    @cart_total_cost = session["cart_contents"]["info"]["subtotal"]
    @cart_total_items = session["cart_contents"]["info"]["total_items"]
  end
  
  def order_page
    # Get Stripe customer info from session ID
    @line_items = session["cart_contents"]["items"]
    @cart_total_cost = session["cart_contents"]["info"]["subtotal"]
    @cart_total_items = session["cart_contents"]["info"]["total_items"]
    @customer = Stripe::Customer.retrieve(session["new_order_customer_id"])
  end
  
  def create_order
    Stripe::Charge.create({
      amount: @cart_total_cost.to_i,
      currency: 'usd',
      source: 'tok_mastercard',
      description: 'My First Test Charge (created for API docs at https://www.stripe.com/docs/api)',
      receipt_email: "greenwood.maysen@gmail.com",
      address: {
        city: "Cambridge",
        country: "NZ",
        line1: "85 Thompson street",
        postal_code: "3432",
        state: "Waikato"
      }
    })
  end
  
  
  def require_items
    if session["cart_contents"]["items"] and sub_total_in_cart > 0
      return true
    else
      redirect_to carts_show_path
    end
  end
  
  def create_customer
    potential_customer = Stripe::Customer.search({
      query: "email: \"#{params['customer']['email']}\"",
    })
    
    if potential_customer["data"].length > 0
      #puts potential_customer
      session["new_order_customer_id"] = potential_customer["data"][0]["id"]
      # If address params is different to object, update customer
      if potential_customer["data"][0]["address"]["line1"] != params["address"]["address_1"]
        updated_customer_address = Stripe::Customer.update(
          potential_customer["data"][0]["id"],
          {
            address: {
              city: params["address"]["city"],
              country: params["address"]["country"],
              line1: params["address"]["address_1"],
              postal_code: params["address"]["zip"],
              state: params["address"]["region"]
            }
          })
          
          session["new_order_customer_info"] = updated_customer_address
      else
        session["new_order_customer_info"] = potential_customer["data"][0]
      end
    else
      new_customer = Stripe::Customer.create({
        address: {
          city: params["customer"]["address"]["city"],
          country: params["address"]["country"],
          line1: params["address"]["address_1"],
          postal_code: params["address"]["zip"],
          state: params["address"]["region"],
        },
        name: params["customer"]["first_name"] + " " + params["customer"]["last_name"],
        email: params["customer"]["email"],
      })
      session["new_order_customer_id"] = new_customer["id"]
      session["new_order_customer_info"] = new_customer
    end
    
    
    redirect_to "/checkout/payment"
  end
  
  # An endpoint to start the payment process
  def create_payment_intent
    data = JSON.parse(session["cart_contents"]["items"].to_json)
    
    # # Loop through the cart contents and add all the items ID and quantity to an array
    items = []
    data.each do |item|
      items.push({
        id: item["id"],
        quantity: item["quantity"]
      })
    end
    
    items_json = items.to_json
    
    customer_id = session["new_order_customer_id"]
    
    #data = JSON.parse(request.body.read)
    # Create a PaymentIntent with amount and currency
    payment_intent = Stripe::PaymentIntent.create(
      amount: sub_total_in_cart.to_i * 100,
      currency: 'usd',
      automatic_payment_methods: {
        enabled: true,
      },
      customer: customer_id,
      description: items_json
      #metadata: items_json
    )
    
    #session["checkout_payment_intent_secret"] = payment_intent['client_secret']
    render json: { clientSecret: payment_intent['client_secret'] }.as_json
    # {
    #   clientSecret: payment_intent['client_secret']
    # }.to_json
  end
  
  def payment
    @shipping_info = session["new_order_customer_info"]["address"]
    @line_items = session["cart_contents"]["items"]
    @cart_total_cost = session["cart_contents"]["info"]["subtotal"]
    @cart_total_items = session["cart_contents"]["info"]["total_items"]
  end
end
