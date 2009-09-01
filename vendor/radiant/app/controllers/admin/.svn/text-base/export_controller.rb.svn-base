class Admin::ExportController < ApplicationController
  model :exporter, :user, :page, :page_part, :snippet, :layout
  
  def yaml
    @response.headers['Content-Type'] = "text/yaml"
    render_text Radiant::Exporter.export
  end
end
