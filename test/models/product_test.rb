require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My Life Biography", 
                          description: "Lorem ipsum dolor sit amet", 
                          image_url: "myo.jpg")
    
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  

  test "image URL must end with .gif, .jpg or .png" do
    def new_product(image_url)
      Product.new(title: "My Life Biography",
                  description: "Lorem ipsum dolor sit amet.",
                  price: 1,
                  image_url: image_url)
    end

    ok = %w{ jack.gif jack.jpg jack.png JACK.gif JACK.Png
            http://a.b.c/x/y/z/jack.gif }
    
    bad = %w{ jack.doc jack.gif/more jack.gif.more }
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    
    bad.each do |name|
      assert new_product(name).invalid? "#{name} should NOT be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:myo).title,
                          description: "Lorem ipsum dolor sit amet.",
                          price: 1,
                          image_url: "myo.png")
    assert product.invalid?
    # assert_equal ["has already been taken"], product.errors[:title]

    # Built-in error
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
end
