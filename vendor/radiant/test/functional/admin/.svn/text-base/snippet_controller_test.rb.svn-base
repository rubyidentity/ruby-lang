require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/snippet_controller'

# Re-raise errors caught by the controller.
class Admin::SnippetController; def rescue_action(e) raise e end; end

class Admin::SnippetControllerTest < Test::Unit::TestCase
  def test_ancestors
    assert Admin::SnippetController.ancestors.include?(Admin::AbstractModelController)
  end
end
