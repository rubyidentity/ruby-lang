require File.dirname(__FILE__) + '/../test_helper'

class LoginSystemTest < Test::Unit::TestCase
  
  fixtures :users
  
  class StubController < ActionController::Base
    def rescue_action(e)
      raise e
    end
    
    def method_missing(method, *args, &block)
      if (args.size == 0) and not block_given?
        render :text => 'just a test'
      else
        super
      end
    end
  end
  
  class LoginRequiredController < StubController
    include LoginSystem
    
    attr_writer :condition
    
    def condition?
      @condition ||= false
    end
  end
  
  class NoLoginRequiredController < LoginRequiredController
    no_login_required
  end
  
  class OnlyAllowAccessToWhenController < LoginRequiredController
    only_allow_access_to :edit, :new, :when => [:admin, :developer], :denied_url => { :action => :test }, :denied_message => 'Fun.'
  end
  
  class OnlyAllowAccessToWhenDefaultsController < LoginRequiredController
    only_allow_access_to :edit, :when => :admin
  end
  
  class OnlyAllowAccessToIfController < LoginRequiredController
    only_allow_access_to :edit, :if => :condition?
  end
  
  def setup
    @controller = LoginRequiredController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  def test_authenticate__with_user_in_session
    custom_routes do
      get :index, {}, { :user => users(:existing) }
      assert_response :success
    end
  end
  def test_authenticate__without_user_in_session
    custom_routes do
      get :index
      assert_redirected_to login_url
    end
  end
  
  # Class Methods
  
  def test_no_login_required
    custom_routes do
      @controller = NoLoginRequiredController.new
      get :index
      assert_response :success
    end
  end
  
  def test_only_allow_access_to__when_user_in_role
    custom_routes do
      @controller = OnlyAllowAccessToWhenController.new
      get :edit, {}, { :user => users(:admin) }
      assert_response :success
    end
  end
  def test_only_allow_access_to__when_user_in_role_2
    custom_routes do
      @controller = OnlyAllowAccessToWhenController.new
      get :new, {}, { :user => users(:developer) }
      assert_response :success
    end
  end
  def test_only_allow_access_to__when_user_in_role_3
    custom_routes do
      @controller = OnlyAllowAccessToWhenController.new
      get :another, {}, { :user => users(:admin) }
      assert_response :success
    end
  end
  def test_only_allow_access_to__when_user_not_in_role
    custom_routes do
      @controller = OnlyAllowAccessToWhenController.new
      get :edit, {}, { :user => users(:non_admin) }
      assert_redirected_to :action => :test
      assert_equal 'Fun.', flash[:error]
    end
  end
  def test_only_allow_access_to__when_user_not_in_role_2
    custom_routes do
      @controller = OnlyAllowAccessToWhenController.new
      get :new, {}, { :user => users(:non_admin) }
      assert_redirected_to :action => :test
      assert_equal 'Fun.', flash[:error]
    end
  end
  def test_only_allow_access_to__when__user_not_in_role_3
    custom_routes do
      @controller = OnlyAllowAccessToWhenController.new
      get :another, {}, { :user => users(:non_admin) }
      assert_response :success
    end
  end
  def test_only_allow_access_to__when__user_not_in_role__defaults
    custom_routes do
      @controller = OnlyAllowAccessToWhenDefaultsController.new
      get :edit, {}, { :user => users(:non_admin) }
      assert_redirected_to :action => :index
      assert_equal 'Access denied.', flash[:error]
    end
  end
  
  def test_only_allow_access_to__if__condition_true
    custom_routes do
      @controller = OnlyAllowAccessToIfController.new
      @controller.condition = true
      get :edit, {}, { :user => users(:existing) }
      assert_response :success
    end
  end
  def test_only_allow_access_to__if__condition_false
    custom_routes do
      @controller = OnlyAllowAccessToIfController.new
      @controller.condition = false
      get :edit, {}, { :user => users(:existing) }
      assert_response :redirect
    end
  end

  private
  
    def custom_routes
      with_routing do |set|
        set.draw { set.connect ':controller/:action' }
        yield
      end
    end

end
