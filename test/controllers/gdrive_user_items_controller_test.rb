require "test_helper"

class GdriveUserItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gdrive_user_item = gdrive_user_items(:one)
  end

  test "should get index" do
    get gdrive_user_items_url
    assert_response :success
  end

  test "should get new" do
    get new_gdrive_user_item_url
    assert_response :success
  end

  test "should create gdrive_user_item" do
    assert_difference('GdriveUserItem.count') do
      post gdrive_user_items_url, params: { gdrive_user_item: { condomino_id: @gdrive_user_item.condomino_id, folder_id: @gdrive_user_item.folder_id, gdrive_condo_items_id: @gdrive_user_item.gdrive_condo_items_id } }
    end

    assert_redirected_to gdrive_user_item_url(GdriveUserItem.last)
  end

  test "should show gdrive_user_item" do
    get gdrive_user_item_url(@gdrive_user_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_gdrive_user_item_url(@gdrive_user_item)
    assert_response :success
  end

  test "should update gdrive_user_item" do
    patch gdrive_user_item_url(@gdrive_user_item), params: { gdrive_user_item: { condomino_id: @gdrive_user_item.condomino_id, folder_id: @gdrive_user_item.folder_id, gdrive_condo_items_id: @gdrive_user_item.gdrive_condo_items_id } }
    assert_redirected_to gdrive_user_item_url(@gdrive_user_item)
  end

  test "should destroy gdrive_user_item" do
    assert_difference('GdriveUserItem.count', -1) do
      delete gdrive_user_item_url(@gdrive_user_item)
    end

    assert_redirected_to gdrive_user_items_url
  end
end
