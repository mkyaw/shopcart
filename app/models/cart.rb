class Cart < ActiveRecord::Base

  # "dependent :destroy" - existence of line-items is dependent on existence of cart
  # if cart is destroyed => Rails destroys line-items also
  has_many :line_items, dependent: :destroy
end
