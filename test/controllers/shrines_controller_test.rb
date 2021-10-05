require 'test_helper'

class ShrinesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shrines_index_url
    assert_response :success
  end

  test "should get show" do
    get shrines_show_url
    assert_response :success
  end

end
