require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/welcome_controller'

# Re-raise errors caught by the controller.
class Admin::WelcomeController; def rescue_action(e) raise e end; end

class Admin::WelcomeControllerTest < Test::Unit::TestCase
  
  fixtures :users
  
  def setup
    @controller = Admin::WelcomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_redirected_to page_index_url
  end

  def test_login
    get :login
    assert_response :success
  end
  def test_login__post
    post :login, :user => { :login => 'existing', :password => 'password' }
    assert_redirected_to welcome_url
    
    user = session[:user]
    assert_kind_of User, user
    assert_equal 'existing', user.login
  end
  def test_login__post_invalid_user
    post :login, :user => { :login => 'invalid', :password => 'password' }
    assert_response :success
    assert_match /invalid/i, flash[:error]
    assert_nil session[:user]
  end
  
  def test_logout
    get :logout, nil, { :user => users(:existing) }
    assert_redirected_to login_url
    assert_nil session[:user]
    assert_match /logged out/i, flash[:notice]
  end
  
end
