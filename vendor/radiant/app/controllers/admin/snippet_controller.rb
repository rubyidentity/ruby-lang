require_dependency 'admin/model_controller'
require_dependency 'response_cache'

class Admin::SnippetController < Admin::AbstractModelController
  model :snippet
end