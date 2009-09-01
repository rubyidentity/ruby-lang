require File.dirname(__FILE__) + '/../test_helper'
require 'site_controller'

# Re-raise errors caught by the controller.
class ApplicationController; def rescue_action(e) raise e end; end

class ApplicationControllerTest < Test::Unit::TestCase
  fixtures :users
  
  class TestController < ApplicationController
    def test
      render :text => 'test'
    end
  end
  
  def setup
    @controller = TestController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @user = users(:existing)
  end
  
  def test_ancestors
    assert ApplicationController.include?(LoginSystem)
  end
  
  def test_initialize
    assert_equal Radiant::Config, @controller.config
  end
  
  def test_default_parts
    assert_equal ['body', 'extended'], @controller.default_parts
  end
  
  def test_before_filter
    with_routing do |routes|
      routes.map ':controller/:action'
      UserActionObserver.current_user = nil
      get :test, {}, { :user => @user }
      assert_response :success
      assert_equal @user, UserActionObserver.current_user
    end
  end
end