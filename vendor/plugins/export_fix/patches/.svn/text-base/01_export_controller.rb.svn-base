require 'application'

class Admin::ExportController < ApplicationController
  model "radiant/exporter", :user, :page, :page_part, :snippet, :layout
  
  def export
    format = params[:format] || "yaml"
    if Radiant::Exporter.formats.include? format
      @response.headers['Content-Type'] = "text/#{format};charset=utf-8"
      render_text Radiant::Exporter.export(format)
    else
      render_text "Invalid format."
    end
  end
  
  alias :yaml :export
  
end
