require File.dirname(__FILE__) + '/../test_helper'

class StatusTest < Test::Unit::TestCase
  def test_initialize
    status = Status.new(:id => 1, :name => 'Test')
    assert_equal 1, status.id
    assert_equal 'Test', status.name
    assert_equal :test, status.symbol
  end
  
  # Class Methods
  
  def test_find
    status = Status.find(1)
    assert_equal 1, status.id
  end
  def test_find__by_string
    status = Status.find('1')
    assert_equal 1, status.id
  end
  def test_find__nonexistant
    status = Status.find(0)
    assert_equal nil, status
  end
  
  def test_brackets
    status = Status[:draft]
    assert_equal 'Draft', status.name
  end
  
  def test_brackets__nonexistant
    status = Status[:drafts]
    assert_equal nil, status
  end
  
  def test_find_all
    statuses = Status.find_all
    assert statuses.size > 0
    statuses.each do |status|
      assert_kind_of Status, status
    end
  end
end
