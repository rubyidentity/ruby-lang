require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/layout_controller'

# Re-raise errors caught by the controller.
class Admin::LayoutController; def rescue_action(e) raise e end; end

class Admin::LayoutControllerTest < Test::Unit::TestCase
  fixtures :users, :layouts
  test_helper :users, :layouts
  
  def setup
    @controller = Admin::LayoutController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @request.session[:user] = users(:developer)
  end

  def test_ancestors
    assert Admin::LayoutController.ancestors.include?(Admin::AbstractModelController)
  end
  
  [:index, :new, :edit, :remove].each do |action|
    define_method "test_#{action}_action_allowed_if_admin" do
      get action, { :id => 1 }, { :user => users(:admin) }
      assert_response :success, "action: #{action}"
    end
    
    define_method "test_#{action}_action__allowed_if_developer" do
      get action, { :id => 1 }
      assert_response :success, "action: #{action}"
    end
    
    define_method "test_#{action}_action__not_allowed_if_other" do
      get action, { :id => 1 }, { :user => users(:existing) }, {}
      assert_redirected_to page_index_url, "action: #{action}"
      assert_match /privileges/, flash[:error], "action: #{action}"
    end
  end
  
end
