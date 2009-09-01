require File.dirname(__FILE__) + '/../../test_helper'
require 'radiant/exporter'

class Radiant::ExporterTest < Test::Unit::TestCase
  fixtures :users, :pages, :page_parts, :snippets, :layouts
  
  def setup
    @exporter = Radiant::Exporter
    @output   = @exporter.export
    @hash     = YAML::load(@output)
    @classes  = ['Radiant::Configs', 'Users', 'Pages', 'PageParts', 'Snippets', 'Layouts']
  end
  
  def test_export_is_string
    assert_kind_of String, @output
  end
  def test_export_classes
    @classes.each do |expected|
      assert @hash.keys.include?(expected), "expected hash to contain <#{expected.inspect}> but it did not"
    end
  end
  def test_export_homepage
    assert_equal 'Ruby Home Page', @hash['Pages'][1]['title']
    assert_equal 'Admin User',  @hash['Users'][3]['name']
  end
end