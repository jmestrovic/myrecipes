require 'test_helper'

class ChefsSignupTest < ActionDispatch::IntegrationTest
  
  test "should get signup path" do
    get signup_path
    assert_response :success
  end
  
  test "reject an invalid signup" do
    get signup_path
    assert_template 'chefs/new'
    assert_no_difference 'Chef.count' do
      post chefs_path, params: { chef: { chefname: " ", email: " ", password: "password", password_confirmation: "password" } }
    end
    assert_template 'chefs/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "accept valid signup" do
    get signup_path
    assert_template 'chefs/new'
    assert_difference 'Chef.count', 1 do
      post chefs_path, params: { chef: { chefname: "jakov", email: "ime@tvrtka.hr", password: "password", password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'chefs/show'
    assert_not flash.empty?
  end
  
end
