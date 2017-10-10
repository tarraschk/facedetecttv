require 'test_helper'

class ChainesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chaine = chaines(:one)
  end

  test "should get index" do
    get chaines_url
    assert_response :success
  end

  test "should get new" do
    get new_chaine_url
    assert_response :success
  end

  test "should create chaine" do
    assert_difference('Chaine.count') do
      post chaines_url, params: { chaine: { name: @chaine.name, parser: @chaine.parser } }
    end

    assert_redirected_to chaine_url(Chaine.last)
  end

  test "should show chaine" do
    get chaine_url(@chaine)
    assert_response :success
  end

  test "should get edit" do
    get edit_chaine_url(@chaine)
    assert_response :success
  end

  test "should update chaine" do
    patch chaine_url(@chaine), params: { chaine: { name: @chaine.name, parser: @chaine.parser } }
    assert_redirected_to chaine_url(@chaine)
  end

  test "should destroy chaine" do
    assert_difference('Chaine.count', -1) do
      delete chaine_url(@chaine)
    end

    assert_redirected_to chaines_url
  end
end
