require 'test_helper'

class Admin::ShrinesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_shrines_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_shrines_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_shrines_edit_url
    assert_response :success
  end

  test "should get new" do
    get admin_shrines_new_url
    assert_response :success
  end

end
