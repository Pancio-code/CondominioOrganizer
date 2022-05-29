require "application_system_test_case"

class CondominiosTest < ApplicationSystemTestCase
  setup do
    @condominio = condominios(:one)
  end

  test "visiting the index" do
    visit condominios_url
    assert_selector "h1", text: "Condominios"
  end

  test "creating a Condominio" do
    visit condominios_url
    click_on "New Condominio"

    fill_in "Codice", with: @condominio.codice
    fill_in "Comune", with: @condominio.comune
    fill_in "Indirizzo", with: @condominio.indirizzo
    fill_in "Latitudine", with: @condominio.latitudine
    fill_in "Longitudine", with: @condominio.longitudine
    fill_in "Nome", with: @condominio.nome
    click_on "Create Condominio"

    assert_text "Condominio was successfully created"
    click_on "Back"
  end

  test "updating a Condominio" do
    visit condominios_url
    click_on "Edit", match: :first

    fill_in "Codice", with: @condominio.codice
    fill_in "Comune", with: @condominio.comune
    fill_in "Indirizzo", with: @condominio.indirizzo
    fill_in "Latitudine", with: @condominio.latitudine
    fill_in "Longitudine", with: @condominio.longitudine
    fill_in "Nome", with: @condominio.nome
    click_on "Update Condominio"

    assert_text "Condominio was successfully updated"
    click_on "Back"
  end

  test "destroying a Condominio" do
    visit condominios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Condominio was successfully destroyed"
  end
end
