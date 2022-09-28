class LineItem
  include ActiveModel::Model
  # Add attributes
  attr_accessor :title, :price, :quantity, :total_price, :product_id, :image_url
end
