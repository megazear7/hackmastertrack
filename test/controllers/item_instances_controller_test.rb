require 'test_helper'

class ItemInstancesControllerTest < ActionController::TestCase
  setup do
    @item_instance = item_instances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_instances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_instance" do
    assert_difference('ItemInstance.count') do
      post :create, item_instance: {  }
    end

    assert_redirected_to item_instance_path(assigns(:item_instance))
  end

  test "should show item_instance" do
    get :show, id: @item_instance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item_instance
    assert_response :success
  end

  test "should update item_instance" do
    patch :update, id: @item_instance, item_instance: {  }
    assert_redirected_to item_instance_path(assigns(:item_instance))
  end

  test "should destroy item_instance" do
    assert_difference('ItemInstance.count', -1) do
      delete :destroy, id: @item_instance
    end

    assert_redirected_to item_instances_path
  end
end
