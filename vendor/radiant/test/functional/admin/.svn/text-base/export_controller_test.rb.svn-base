require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/export_controller'

# Re-raise errors caught by the controller.
class Admin::ExportController; def rescue_action(e) raise e end; end

class Admin::ExportControllerTest < Test::Unit::TestCase
  fixtures :users, :pages
  
  def setup
    @controller = ExportController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = users(:developer)
  end

  def test_yaml
    get :yaml
    assert_kind_of Hash, YAML.load(@response.body)
    assert_equal 'text/yaml', @response.headers['Content-Type']
  end
end
