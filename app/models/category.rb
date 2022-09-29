class Category < ApplicationRecord
    has_many :products, :dependent => :destroy
    
    scope :category_search, -> (search) { where("id LIKE :search or category LIKE :search or created_at LIKE :search or updated_at LIKE :search", search: "%#{search}%") }
end
