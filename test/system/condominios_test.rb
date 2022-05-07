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

    fill_in "Comune condo", with: @condominio.comune_condo
    fill_in "Condo", with: @condominio.condo_id
    fill_in "Coord condo", with: @condominio.coord_condo
    fill_in "Fk superutenti condo id", with: @condominio.fk_superutenti_condo_id_id
    fill_in "Fk utenti condo id", with: @condominio.fk_utenti_condo_id_id
    fill_in "Nome cond", with: @condominio.nome_cond
    fill_in "Via condo", with: @condominio.via_condo
    click_on "Create Condominio"

    assert_text "Condominio was successfully created"
    click_on "Back"
  end

  test "updating a Condominio" do
    visit condominios_url
    click_on "Edit", match: :first

    fill_in "Comune condo", with: @condominio.comune_condo
    fill_in "Condo", with: @condominio.condo_id
    fill_in "Coord condo", with: @condominio.coord_condo
    fill_in "Fk superutenti condo id", with: @condominio.fk_superutenti_condo_id_id
    fill_in "Fk utenti condo id", with: @condominio.fk_utenti_condo_id_id
    fill_in "Nome cond", with: @condominio.nome_cond
    fill_in "Via condo", with: @condominio.via_condo
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
