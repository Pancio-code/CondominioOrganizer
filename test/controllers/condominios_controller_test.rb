require "test_helper"

class CondominiosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @condominio = condominios(:one)
  end

  test "should get index" do
    get condominios_url
    assert_response :success
  end

  test "should get new" do
    get new_condominio_url
    assert_response :success
  end

  test "should create condominio" do
    assert_difference('Condominio.count') do
      post condominios_url, params: { condominio: { comune_condo: @condominio.comune_condo, condo_id: @condominio.condo_id, coord_condo: @condominio.coord_condo, fk_superutenti_condo_id_id: @condominio.fk_superutenti_condo_id_id, fk_utenti_condo_id_id: @condominio.fk_utenti_condo_id_id, nome_cond: @condominio.nome_cond, via_condo: @condominio.via_condo } }
    end

    assert_redirected_to condominio_url(Condominio.last)
  end

  test "should show condominio" do
    get condominio_url(@condominio)
    assert_response :success
  end

  test "should get edit" do
    get edit_condominio_url(@condominio)
    assert_response :success
  end

  test "should update condominio" do
    patch condominio_url(@condominio), params: { condominio: { comune_condo: @condominio.comune_condo, condo_id: @condominio.condo_id, coord_condo: @condominio.coord_condo, fk_superutenti_condo_id_id: @condominio.fk_superutenti_condo_id_id, fk_utenti_condo_id_id: @condominio.fk_utenti_condo_id_id, nome_cond: @condominio.nome_cond, via_condo: @condominio.via_condo } }
    assert_redirected_to condominio_url(@condominio)
  end

  test "should destroy condominio" do
    assert_difference('Condominio.count', -1) do
      delete condominio_url(@condominio)
    end

    assert_redirected_to condominios_url
  end
end
