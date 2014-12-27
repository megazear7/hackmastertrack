require 'test_helper'

class ClassSpellsControllerTest < ActionController::TestCase
  setup do
    @class_spell = class_spells(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:class_spells)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create class_spell" do
    assert_difference('ClassSpell.count') do
      post :create, class_spell: {  }
    end

    assert_redirected_to class_spell_path(assigns(:class_spell))
  end

  test "should show class_spell" do
    get :show, id: @class_spell
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @class_spell
    assert_response :success
  end

  test "should update class_spell" do
    patch :update, id: @class_spell, class_spell: {  }
    assert_redirected_to class_spell_path(assigns(:class_spell))
  end

  test "should destroy class_spell" do
    assert_difference('ClassSpell.count', -1) do
      delete :destroy, id: @class_spell
    end

    assert_redirected_to class_spells_path
  end
end
