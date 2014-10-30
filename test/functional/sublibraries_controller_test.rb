require 'test_helper'

class SublibrariesControllerTest < ActionController::TestCase

  setup :activate_authlogic

  def setup
   current_user = UserSession.create(users(:admin))
  end

  test "should get index" do
    VCR.use_cassette('get all admin sublibraries') do
      get :index
      assert_not_nil assigns(:sublibraries)
      assert assigns(:sublibraries).is_a? Sunspot::Search::StandardSearch
      assert_response :success
      assert_template :index
    end
  end

  test "should test sorting" do
    VCR.use_cassette('get sorted admin sublibraries') do
      get :index, :sort => "sort_text"

      assert assigns(:sublibraries)
      assert_template :index
    end
  end

  test "should get new" do
   get :new
   assert_not_nil assigns(:sublibrary)
   assert_response :success
   assert_template :new
  end

  test "should create sublibrary" do
    VCR.use_cassette('create sublibrary') do
     assert_difference('Sublibrary.count') do
       post :create, :sublibrary => { :code => "uniqueness82937465", :from_aleph => true }
     end

     assert_response :redirect
     assert_redirected_to sublibrary_path(assigns(:sublibrary))
   end
  end

  test "should NOT create sublibrary" do
   assert_no_difference('Sublibrary.count') do
     post :create, :sublibrary => { :code => nil, :from_aleph => false }
   end

   assert assigns(:sublibrary)
   assert_no_match(/^nyu_ag_noaleph_/, assigns(:sublibrary).code)
   assert_template :new
  end

  test "should show sublibrary" do
   get :show, :id => sublibraries(:aleph_one)
   assert_not_nil assigns(:sublibrary)
   assert_response :success
   assert_template :show
  end

  test "should get edit" do
    VCR.use_cassette('edit sublibrary') do
     get :edit, :id => Sublibrary.first.id
     assert_response :success
   end
  end

  test "should update sublibrary" do
    VCR.use_cassette('update sublibrary') do
      put :update, :id => sublibraries(:aleph_one)

      assert assigns(:sublibrary)
      assert_redirected_to sublibrary_path(assigns(:sublibrary))
    end
  end

  test "should NOT update sublibrary" do
    VCR.use_cassette('dont update sublibrary') do
      put :update, :id => Sublibrary.first.id, :sublibrary => { :web_text => nil, :from_aleph => false }

      assert assigns(:sublibrary)
      assert_template :edit
    end
  end

  test "should destroy sublibrary" do
    VCR.use_cassette('destroy sublibrary') do
     assert_difference('Sublibrary.count', -1) do
       delete :destroy, :id => sublibraries(:aleph_one)
     end

     assert_redirected_to sublibraries_path
   end
  end

end
