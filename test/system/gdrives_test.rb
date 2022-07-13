require "application_system_test_case"

class GdrivesTest < ApplicationSystemTestCase
  setup do
    @gdrife = gdrives(:one)
  end

  test "visiting the index" do
    visit gdrives_url
    assert_selector "h1", text: "Gdrives"
  end

  test "creating a Gdrive" do
    visit gdrives_url
    click_on "New Gdrive"

    fill_in "Cartella", with: @gdrife.cartella_id
    fill_in "Condo cartella", with: @gdrife.condo_cartella_id
    fill_in "Condomino", with: @gdrife.condomino_id
    click_on "Create Gdrive"

    assert_text "Gdrive was successfully created"
    click_on "Back"
  end

  test "updating a Gdrive" do
    visit gdrives_url
    click_on "Edit", match: :first

    fill_in "Cartella", with: @gdrife.cartella_id
    fill_in "Condo cartella", with: @gdrife.condo_cartella_id
    fill_in "Condomino", with: @gdrife.condomino_id
    click_on "Update Gdrive"

    assert_text "Gdrive was successfully updated"
    click_on "Back"
  end

  test "destroying a Gdrive" do
    visit gdrives_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Gdrive was successfully destroyed"
  end
end
