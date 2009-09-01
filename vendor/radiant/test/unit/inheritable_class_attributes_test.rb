require File.dirname(__FILE__) + '/../test_helper'
require 'inheritable_class_attributes'

class InheritableClassAttributesTest < Test::Unit::TestCase
  class A
    include InheritableClassAttributes
    
    cattr_inheritable_reader :reader
    @reader = :test
    
    cattr_inheritable_writer :writer
    @writer = :test
    
    cattr_inheritable_accessor :accessor
    @accessor = :test
  end
  
  def test_inheritable_reader
    assert_equal :test, A.reader
  end
  
  def test_inheritable_writer
    A.writer = :changed
    assert_equal :changed, A.module_eval(%{@writer})
  end
  
  def test_inheritable_accessor
    A.accessor = :changed
    assert_equal :changed, A.accessor
  end
  
  def test_inheritance
    A.accessor = :unchanged
    Kernel.module_eval %{ class B < A; end }
    B.accessor = :changed
    assert_equal :changed, B.accessor
    assert_equal :unchanged, A.accessor
  end
  
  def test_array_inheritance
    A.accessor = [1,2,3]
    Kernel.module_eval %{ class C < A; end }
    C.accessor << 4
    assert_equal [1,2,3,4], C.accessor
    assert_equal [1,2,3], A.accessor
  end
end