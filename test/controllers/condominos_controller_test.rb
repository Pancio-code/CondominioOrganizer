require "test_helper"

class CondominosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @condomino = condominos(:one)
  end

  test "should get index" do
    get condominos_url
    assert_response :success
  end

  test "should get new" do
    get new_condomino_url
    assert_response :success
  end

  test "should create condomino" do
    assert_difference('Condomino.count') do
      post condominos_url, params: { condomino: {  } }
    end

    assert_redirected_to condomino_url(Condomino.last)
  end

  test "should show condomino" do
    get condomino_url(@condomino)
    assert_response :success
  end

  test "should get edit" do
    get edit_condomino_url(@condomino)
    assert_response :success
  end

  test "should update condomino" do
    patch condomino_url(@condomino), params: { condomino: {  } }
    assert_redirected_to condomino_url(@condomino)
  end

  test "should destroy condomino" do
    assert_difference('Condomino.count', -1) do
      delete condomino_url(@condomino)
    end

    assert_redirected_to condominos_url
  end
end
