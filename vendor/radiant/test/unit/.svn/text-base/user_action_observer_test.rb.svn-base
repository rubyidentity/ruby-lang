require File.dirname(__FILE__) + '/../test_helper'

class UserActionObserverTest < Test::Unit::TestCase
  fixtures :users, :pages, :layouts, :snippets
  test_helper :users, :pages, :layouts, :snippets
  
  def setup
    @user = users(:existing)
    UserActionObserver.current_user = @user
    @page_title = 'User Action Test Page'
    destroy_test_user
    destroy_test_page
    destroy_test_layout
    destroy_test_snippet
  end
  
  def test_create
    [
      create_test_user,
      create_test_page,
      create_test_layout,
      create_test_snippet
    ].each do |model|
      assert_equal @user, model.created_by
    end
  end
  
  def test_update
    [
      users(:existing),
      pages(:homepage),
      layouts(:main),
      snippets(:first)
    ].each do |model|
      model.attributes = model.attributes.dup
      assert model.save, "Errors: #{model.errors.inspect}, Model: #{model.class.name}"
      assert_equal @user, model.updated_by, "Model: #{model.class.name}"
    end
  end
end