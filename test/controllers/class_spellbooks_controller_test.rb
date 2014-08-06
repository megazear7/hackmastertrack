require 'test_helper'

class ClassSpellbooksControllerTest < ActionController::TestCase
  setup do
    @class_spellbook = class_spellbooks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:class_spellbooks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create class_spellbook" do
    assert_difference('ClassSpellbook.count') do
      post :create, class_spellbook: { character_class_id: @class_spellbook.character_class_id, level: @class_spellbook.level, spell_id: @class_spellbook.spell_id }
    end

    assert_redirected_to class_spellbook_path(assigns(:class_spellbook))
  end

  test "should show class_spellbook" do
    get :show, id: @class_spellbook
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @class_spellbook
    assert_response :success
  end

  test "should update class_spellbook" do
    patch :update, id: @class_spellbook, class_spellbook: { character_class_id: @class_spellbook.character_class_id, level: @class_spellbook.level, spell_id: @class_spellbook.spell_id }
    assert_redirected_to class_spellbook_path(assigns(:class_spellbook))
  end

  test "should destroy class_spellbook" do
    assert_difference('ClassSpellbook.count', -1) do
      delete :destroy, id: @class_spellbook
    end

    assert_redirected_to class_spellbooks_path
  end
end
