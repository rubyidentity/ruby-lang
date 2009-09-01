require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/user_controller'

# Re-raise errors caught by the controller.
class Admin::UserController; def rescue_action(e) raise e end; end

class Admin::UserControllerTest < Test::Unit::TestCase
  
  fixtures :users

  def setup
    @controller = Admin::UserController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @user = @request.session[:user] = users(:existing)
  end

  def test_ancestors
    assert Admin::UserController.ancestors.include?(Admin::AbstractModelController)
  end
  
  [:index, :new, :edit, :remove].each do |action|
    define_method "test_#{action}_action_allowed_if_admin" do
      get action, { :id => 1 }, { :user => users(:admin) }
      assert_response :success, "action: #{action}"
    end

    define_method "test_#{action}_action_not_allowed_if_other" do
      get action, { :id => 1 }, { :user => users(:non_admin) }
      assert_redirected_to page_index_url, "action: #{action}"
      assert_match /privileges/, flash[:error], "action: #{action}"
    end
  end
  
  def test_remove__cannot_remove_self
    @user = users(:admin)
    get :remove, { :id => @user.id }, { :user => @user }
    assert_redirected_to user_index_url
    assert_match /cannot.*self/i, flash[:error]
    assert_not_nil User.find(@user.id)
  end
  
  def test_preferences
    get :preferences, :user => { :email => 'updated@email.com' }
    assert_response :success
    assigned_user = assigns(:user)
    assert_equal @user, assigned_user
    assert @user.object_id != assigned_user.object_id
    assert_equal 'existing.user@gmail.com', assigned_user.email
  end
  def test_preferences__post
    @user = User.new(:name => 'Test', :login => 'pref_test', :password => 'whoa!', :password_confirmation => 'whoa!')
    assert @user.save
    post(
      :preferences,
      { :user => { :password => '', :password_confirmation => '', :email => 'updated@gmail.com' } },
      { :user => @user }
    )
    @user = User.find(@user.id)
    assert_redirected_to page_index_url
    assert_match /preferences.*?saved/i, flash[:notice] 
    assert_equal('updated@gmail.com', @user.email)
    @user.destroy
  end
  def test_preferences__post_with_bad_data
    get :preferences, :user => { :login => 'superman' }
    assert_response :success
    assert_match /bad form data/i, flash[:error]
  end

end
