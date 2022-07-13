require "test_helper"

class GdriveCondoItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gdrive_condo_item = gdrive_condo_items(:one)
  end

  test "should get index" do
    get gdrive_condo_items_url
    assert_response :success
  end

  test "should get new" do
    get new_gdrive_condo_item_url
    assert_response :success
  end

  test "should create gdrive_condo_item" do
    assert_difference('GdriveCondoItem.count') do
      post gdrive_condo_items_url, params: { gdrive_condo_item: { condominio_id: @gdrive_condo_item.condominio_id, folder_id: @gdrive_condo_item.folder_id } }
    end

    assert_redirected_to gdrive_condo_item_url(GdriveCondoItem.last)
  end

  test "should show gdrive_condo_item" do
    get gdrive_condo_item_url(@gdrive_condo_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_gdrive_condo_item_url(@gdrive_condo_item)
    assert_response :success
  end

  test "should update gdrive_condo_item" do
    patch gdrive_condo_item_url(@gdrive_condo_item), params: { gdrive_condo_item: { condominio_id: @gdrive_condo_item.condominio_id, folder_id: @gdrive_condo_item.folder_id } }
    assert_redirected_to gdrive_condo_item_url(@gdrive_condo_item)
  end

  test "should destroy gdrive_condo_item" do
    assert_difference('GdriveCondoItem.count', -1) do
      delete gdrive_condo_item_url(@gdrive_condo_item)
    end

    assert_redirected_to gdrive_condo_items_url
  end
end
