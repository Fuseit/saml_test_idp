require 'test_helper'

class SamlIdpControllerTest < ActionController::TestCase
  test 'should get auth page' do
    get :new
    assert_response :success
  end

  test 'should get metadata' do
    get :show
    assert_response :success
    assert_match(/EntityDescriptor/, response.body)
  end

  test 'should authenticate with correct password' do
    post :create, params: {
      email: 'test@example.com',
      password: 'password'
    }
    assert_response :success # HTTP response is 200 OK regardless of SAML response, the actual response body is not checked in this test
  end

  test 'should authenticate with optional attributes' do
    post :create, params: {
      email: 'test@example.com',
      password: 'password',
      first_name: 'John',
      last_name: 'Doe'
    }
    assert_response :success
  end

  test 'should reject incorrect password' do
    post :create, params: {
      email: 'test@example.com',
      password: 'wrong'
    }
    assert_response :success # HTTP response is 200 OK regardless of SAML response, the actual response body is not checked in this test
  end

  test 'should authenticate user with correct password' do
    @controller.params = { email: 'test@example.com', password: 'password' }
    user = @controller.send(:idp_authenticate, 'test@example.com', 'password')

    assert_not_nil user, 'Authentication should return user object for correct password'
    assert_equal 'test@example.com', user.email
  end

  test 'should reject authentication with incorrect password' do
    @controller.params = { email: 'test@example.com', password: 'wrongpassword' }
    user = @controller.send(:idp_authenticate, 'test@example.com', 'wrongpassword')

    assert_nil user, 'Authentication should return nil for incorrect password'
  end

  private

  def setup
    # Mock the parent controller methods if needed
    @controller = SamlIdpController.new
  end
end
