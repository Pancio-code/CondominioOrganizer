require "application_system_test_case"

class GdriveCondoItemsTest < ApplicationSystemTestCase
  setup do
    @gdrive_condo_item = gdrive_condo_items(:one)
  end

  test "visiting the index" do
    visit gdrive_condo_items_url
    assert_selector "h1", text: "Gdrive Condo Items"
  end

  test "creating a Gdrive condo item" do
    visit gdrive_condo_items_url
    click_on "New Gdrive Condo Item"

    fill_in "Condominio", with: @gdrive_condo_item.condominio_id
    fill_in "Folder", with: @gdrive_condo_item.folder_id
    click_on "Create Gdrive condo item"

    assert_text "Gdrive condo item was successfully created"
    click_on "Back"
  end

  test "updating a Gdrive condo item" do
    visit gdrive_condo_items_url
    click_on "Edit", match: :first

    fill_in "Condominio", with: @gdrive_condo_item.condominio_id
    fill_in "Folder", with: @gdrive_condo_item.folder_id
    click_on "Update Gdrive condo item"

    assert_text "Gdrive condo item was successfully updated"
    click_on "Back"
  end

  test "destroying a Gdrive condo item" do
    visit gdrive_condo_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Gdrive condo item was successfully destroyed"
  end
end
