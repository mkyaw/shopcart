require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    
    # Expect at least 4 elements under #column > #side > a
    assert_select '#columns #side a', minimum: 4
    
    # Expect there to be 3 elements under #main > .entry
    assert_select '#main .entry', 3
    
    # Expect "Myo's Autobriography" under <h3>
    assert_select 'h3', "Myo's Autobiography"
    
    # Expect price to have: "$" > at least 1 digit > "." > 2 digits
    assert_select '.price', /\$[,\d]+\.\d\d/
  end

end
