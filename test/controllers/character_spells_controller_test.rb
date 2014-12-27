require 'test_helper'

class CharacterSpellsControllerTest < ActionController::TestCase
  setup do
    @character_spell = character_spells(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:character_spells)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create character_spell" do
    assert_difference('CharacterSpell.count') do
      post :create, character_spell: {  }
    end

    assert_redirected_to character_spell_path(assigns(:character_spell))
  end

  test "should show character_spell" do
    get :show, id: @character_spell
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @character_spell
    assert_response :success
  end

  test "should update character_spell" do
    patch :update, id: @character_spell, character_spell: {  }
    assert_redirected_to character_spell_path(assigns(:character_spell))
  end

  test "should destroy character_spell" do
    assert_difference('CharacterSpell.count', -1) do
      delete :destroy, id: @character_spell
    end

    assert_redirected_to character_spells_path
  end
end
