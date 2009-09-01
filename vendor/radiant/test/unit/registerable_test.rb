require File.dirname(__FILE__) + '/../test_helper'

class RegisterableTest < Test::Unit::TestCase
  
  module TestModule
    include Registerable
    
    class TestClass < Base
      register 'test'
    end
    
    class Unregistered < Base
    end
  end
  
  def test_registered
    assert_kind_of Hash, TestModule.registered
  end
  
  def test_registered_id
    assert_equal nil, TestModule::Unregistered.registered_id
    assert_equal 'test', TestModule::TestClass.registered_id
    assert_equal 'test', TestModule::TestClass.new.registered_id
  end
  
  def test_brackets
    assert_equal TestModule::TestClass, TestModule['test']
  end
  def test_brackets__symbol
    assert_equal TestModule::TestClass, TestModule[:test]
  end
  def test_brackets__with_padding
    assert_equal TestModule::TestClass, TestModule['  test  ']
  end
  def test_brackets__nil_value
    assert_equal TestModule::Base, TestModule[nil]
  end
  def test_brackets__empty_value
    assert_equal TestModule::Base, TestModule['  ']
  end
  def test_brackets__unknown_value
    assert_equal TestModule::Base, TestModule['Unknown']
  end
  def test_brackets__return_same_instance_every_time
    assert_same TestModule['test'], TestModule['test']
    assert_same TestModule[nil], TestModule[nil]
    assert_same TestModule[' '], TestModule[' ']
  end

  def test_create
    assert_instance_of TestModule::TestClass, TestModule.create('test')
  end

  def test_register
    assert_equal TestModule::TestClass, TestModule['test']
    assert_equal 'test', TestModule::TestClass.registered_id
  end

  def test_register__already_registered
    e = assert_raises(RuntimeError) { TestModule::Base.register 'test' }
    assert_equal "ID `test' already registered. Choose another ID.", e.message
  end

  def test_find_all
    expected = [TestModule::TestClass]
    assert_equal expected, TestModule.find_all
  end
end