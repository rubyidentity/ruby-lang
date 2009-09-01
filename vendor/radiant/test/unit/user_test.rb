require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  
  fixtures :users
  test_helper :users
  test_helper :validations
  
  def setup
    @model = @user = User.new(VALID_USER_PARAMS)
    @user.confirm_password = false
  end
  
  def teardown
    @user.destroy unless @user.new_record?
  end
  
  def test_after_initialize
    @user = User.new
    assert_equal true, @user.confirm_password?
  end
  
  def test_confirm_password
    assert_equal false, @user.confirm_password?
  end
  
  def test_validates_length_of
    assert_invalid :name, '100-character limit', 'x' * 101
    assert_valid :name, 'x' * 100
    
    assert_invalid :email, '255-character limit', ('x' * 247) + '@test.com'
    assert_valid :email, ('x' * 246) + '@test.com'
  end
  
  def test_validates_length_of__ranges
    {
      :login => 3..40,
      :password => 5..40
    }.each do |field, range|
      max = 'x' * range.max
      min = 'x' * range.min
      one_over = 'x' + max
      one_under = min[1..-1]
      assert_invalid field, ('%d-character limit' % range.max), one_over
      assert_invalid field, ('%d-character minimum' % range.min), one_under
      assert_valid field, max, min
    end
  end
  
  def test_validates_length_of__ranges__on_existing
    assert @user.save
    {
      :password => 5..40
    }.each do |field, range|
      max = 'x' * range.max
      min = 'x' * range.min
      one_over = 'x' + max
      one_under = min[1..-1]
      assert_invalid field, ('%d-character limit' % range.max), one_over
      assert_invalid field, ('%d-character minimum' % range.min), one_under
      assert_valid field, max, min
    end
  end
  
  def test_validates_presence_of
    [:name, :login, :password, :password_confirmation].each do |field|
      assert_invalid field, 'required', '', ' ', nil
    end
  end
  
  def test_validates_numericality_of
    [:id].each do |field|
      assert_valid field, '1', '0'
      assert_invalid field, 'must be a number', 'abcd', '1,2', '1.3'
    end
  end

  def test_validates_confirmation_of
    @user.confirm_password = true
    assert_invalid :password, 'must match confirmation', 'test'
  end
  
  def test_validates_uniqueness_of
    assert_invalid :login, 'login already in use', 'existing'
  end

  def test_validates_format_of
    assert_invalid :email, 'invalid e-mail address', '@test.com', 'test@', 'testtest.com',
      'test@test', 'test me@test.com', 'test@me.c'
    assert_valid :email, '', 'test@test.com'
  end
  
  def test_save__password_encrypted
    @user.confirm_password = true
    @user.password_confirmation = @user.password = 'test_password'
    assert @user.save, "Errors: #{@user.errors.inspect}"
    assert_equal User.sha1('test_password'), @user.password
  end
  
  def test_save__existing_but_empty_password
    assert @user.save
    @user.password_confirmation = @user.password = ''
    assert @user.save, "Errors: #{@user.errors.inspect}"
    assert_equal User.sha1('coolness'), @user.password
  end
  
  def test_save__existing_but_different_password
    assert @user.save
    @user.password_confirmation = @user.password = 'cool beans'
    assert @user.save, "Errors: #{@user.errors.inspect}"
    assert_equal User.sha1('cool beans'), @user.password
  end
  
  def test_save__existing_but_same_password
    assert @user.save && @user.save
    assert_equal User.sha1('coolness'), @user.password
  end

  # Class Methods
  
  def test_authenticate
    expected = users(:existing)
    user = User.authenticate('existing', 'password')
    assert_equal expected, user
  end

  def test_authenticate__bad_password
    assert_nil User.authenticate('existing', 'bad password')
  end

  def test_authenticate__bad_user
    assert_nil User.authenticate('nonexisting', 'password')
  end

  def test_sha1
    assert_equal 'a304e6063c3cdc261ae04bf1f938d7d9d579fee5', User.sha1('test')
  end
end
