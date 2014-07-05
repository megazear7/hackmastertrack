require 'test_helper'

class BpCostByRaceClassesControllerTest < ActionController::TestCase
  setup do
    @bp_cost_by_race_class = bp_cost_by_race_classes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bp_cost_by_race_classes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bp_cost_by_race_class" do
    assert_difference('BpCostByRaceClass.count') do
      post :create, bp_cost_by_race_class: {  }
    end

    assert_redirected_to bp_cost_by_race_class_path(assigns(:bp_cost_by_race_class))
  end

  test "should show bp_cost_by_race_class" do
    get :show, id: @bp_cost_by_race_class
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bp_cost_by_race_class
    assert_response :success
  end

  test "should update bp_cost_by_race_class" do
    patch :update, id: @bp_cost_by_race_class, bp_cost_by_race_class: {  }
    assert_redirected_to bp_cost_by_race_class_path(assigns(:bp_cost_by_race_class))
  end

  test "should destroy bp_cost_by_race_class" do
    assert_difference('BpCostByRaceClass.count', -1) do
      delete :destroy, id: @bp_cost_by_race_class
    end

    assert_redirected_to bp_cost_by_race_classes_path
  end
end
