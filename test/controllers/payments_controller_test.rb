require 'test_helper'

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get webpay_success" do
    get payments_webpay_success_url
    assert_response :success
  end

  test "should get webpay_error" do
    get payments_webpay_error_url
    assert_response :success
  end

  test "should get webpay_nullify" do
    get payments_webpay_nullify_url
    assert_response :success
  end

end
