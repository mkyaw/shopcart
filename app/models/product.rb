class Product < ActiveRecord::Base

  has_many :line_items

  # hook method - called before Rails destroy a row in database
  # if returned false the row will not be destroyed
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: "Must be a URL for GIF, JPG or PNG image."
  }

  def self.latest
    Product.order(:updated_at).last
  end

  private

    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item 
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line Items present')
        return false 
      end
    end
end
