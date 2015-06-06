require 'test_helper'

class Ms::DrugsControllerTest < ActionController::TestCase
  setup do
    @ms_drug = ms_drugs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ms_drugs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ms_drug" do
    assert_difference('Ms::Drug.count') do
      post :create, ms_drug: { byname: @ms_drug.byname, inventory: @ms_drug.inventory, name: @ms_drug.name, notice: @ms_drug.notice, resume: @ms_drug.resume, type: @ms_drug.type, unit: @ms_drug.unit, unit_price: @ms_drug.unit_price }
    end

    assert_redirected_to ms_drug_path(assigns(:ms_drug))
  end

  test "should show ms_drug" do
    get :show, id: @ms_drug
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ms_drug
    assert_response :success
  end

  test "should update ms_drug" do
    patch :update, id: @ms_drug, ms_drug: { byname: @ms_drug.byname, inventory: @ms_drug.inventory, name: @ms_drug.name, notice: @ms_drug.notice, resume: @ms_drug.resume, type: @ms_drug.type, unit: @ms_drug.unit, unit_price: @ms_drug.unit_price }
    assert_redirected_to ms_drug_path(assigns(:ms_drug))
  end

  test "should destroy ms_drug" do
    assert_difference('Ms::Drug.count', -1) do
      delete :destroy, id: @ms_drug
    end

    assert_redirected_to ms_drugs_path
  end
end
