require "application_system_test_case"

class GdriveUserItemsTest < ApplicationSystemTestCase
  setup do
    @gdrive_user_item = gdrive_user_items(:one)
  end

  test "visiting the index" do
    visit gdrive_user_items_url
    assert_selector "h1", text: "Gdrive User Items"
  end

  test "creating a Gdrive user item" do
    visit gdrive_user_items_url
    click_on "New Gdrive User Item"

    fill_in "Condomino", with: @gdrive_user_item.condomino_id
    fill_in "Folder", with: @gdrive_user_item.folder_id
    fill_in "Gdrive condo items", with: @gdrive_user_item.gdrive_condo_items_id
    click_on "Create Gdrive user item"

    assert_text "Gdrive user item was successfully created"
    click_on "Back"
  end

  test "updating a Gdrive user item" do
    visit gdrive_user_items_url
    click_on "Edit", match: :first

    fill_in "Condomino", with: @gdrive_user_item.condomino_id
    fill_in "Folder", with: @gdrive_user_item.folder_id
    fill_in "Gdrive condo items", with: @gdrive_user_item.gdrive_condo_items_id
    click_on "Update Gdrive user item"

    assert_text "Gdrive user item was successfully updated"
    click_on "Back"
  end

  test "destroying a Gdrive user item" do
    visit gdrive_user_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Gdrive user item was successfully destroyed"
  end
end
