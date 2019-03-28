require 'test_helper'

class SublibrariesControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_not_nil assigns(:sublibrary_search)
    assert assigns(:sublibrary_search).is_a? Privileges::Search::SublibrarySearch
    assert_response :success
    assert_template :index
  end

  test "should test sorting" do
    get :index, params: { :sort => "sort_text" }

    assert assigns(:sublibrary_search)
    assert_template :index
  end

  test "should get new" do
   get :new
   assert_not_nil assigns(:sublibrary)
   assert_response :success
   assert_template :new
  end

  test "should create sublibrary" do
    assert_difference('Sublibrary.count') do
      post :create, params: { :sublibrary => { :code => "uniqueness82937465", :from_aleph => true } }
    end

    assert_response :redirect
    assert_redirected_to sublibrary_path(assigns(:sublibrary))
  end

  test "should NOT create sublibrary" do
   assert_no_difference('Sublibrary.count') do
     post :create, params: { :sublibrary => { :code => nil, :from_aleph => false } }
   end

   assert assigns(:sublibrary)
   assert_no_match(/^nyu_ag_noaleph_/, assigns(:sublibrary).code)
   assert_template :new
  end

  test "should show sublibrary" do
   get :show, params: { :id => sublibraries(:aleph_one) }
   assert_not_nil assigns(:sublibrary)
   assert_response :success
   assert_template :show
  end

  test "should get edit" do
    get :edit, params: { :id => Sublibrary.first.id }
    assert_response :success
  end

  test "should update sublibrary" do
    put :update, params: { :id => sublibraries(:aleph_one) }

    assert assigns(:sublibrary)
    assert_redirected_to sublibrary_path(assigns(:sublibrary))
  end

  test "should NOT update sublibrary" do
    put :update, params: { :id => Sublibrary.first.id, :sublibrary => { :web_text => nil, :from_aleph => false } }

    assert assigns(:sublibrary)
    assert_template :edit
  end

  test "should destroy sublibrary" do
    assert_difference('Sublibrary.count', -1) do
      delete :destroy, params: { :id => sublibraries(:aleph_one) }
    end

    assert_redirected_to sublibraries_path
  end

end
