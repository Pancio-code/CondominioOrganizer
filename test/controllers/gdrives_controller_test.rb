require "test_helper"

class GdrivesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gdrife = gdrives(:one)
  end

  test "should get index" do
    get gdrives_url
    assert_response :success
  end

  test "should get new" do
    get new_gdrife_url
    assert_response :success
  end

  test "should create gdrife" do
    assert_difference('Gdrive.count') do
      post gdrives_url, params: { gdrife: { cartella_id: @gdrife.cartella_id, condo_cartella_id: @gdrife.condo_cartella_id, condomino_id: @gdrife.condomino_id } }
    end

    assert_redirected_to gdrife_url(Gdrive.last)
  end

  test "should show gdrife" do
    get gdrife_url(@gdrife)
    assert_response :success
  end

  test "should get edit" do
    get edit_gdrife_url(@gdrife)
    assert_response :success
  end

  test "should update gdrife" do
    patch gdrife_url(@gdrife), params: { gdrife: { cartella_id: @gdrife.cartella_id, condo_cartella_id: @gdrife.condo_cartella_id, condomino_id: @gdrife.condomino_id } }
    assert_redirected_to gdrife_url(@gdrife)
  end

  test "should destroy gdrife" do
    assert_difference('Gdrive.count', -1) do
      delete gdrife_url(@gdrife)
    end

    assert_redirected_to gdrives_url
  end
end
