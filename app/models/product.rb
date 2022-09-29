class Product < ApplicationRecord
    has_one_attached :image, :dependent => :destroy
    has_many :order_items, :dependent => :destroy
    belongs_to :category
    
    validates :title, :description, :price, :category, presence: true
    
    scope :product_search, -> (search) { where("id LIKE :search or description LIKE :search or price LIKE :search or title LIKE :search or created_at LIKE :search or updated_at LIKE :search", search: "%#{search}%") }
end
