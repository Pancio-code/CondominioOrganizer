require "application_system_test_case"

class CondominosTest < ApplicationSystemTestCase
  setup do
    @condomino = condominos(:one)
  end

  test "visiting the index" do
    visit condominos_url
    assert_selector "h1", text: "Condominos"
  end

  test "creating a Condomino" do
    visit condominos_url
    click_on "New Condomino"

    click_on "Create Condomino"

    assert_text "Condomino was successfully created"
    click_on "Back"
  end

  test "updating a Condomino" do
    visit condominos_url
    click_on "Edit", match: :first

    click_on "Update Condomino"

    assert_text "Condomino was successfully updated"
    click_on "Back"
  end

  test "destroying a Condomino" do
    visit condominos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Condomino was successfully destroyed"
  end
end
