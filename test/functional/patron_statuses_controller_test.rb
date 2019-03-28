require 'test_helper'

class PatronStatusesControllerTest < ActionController::TestCase


  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_not_nil assigns(:patron_status_search)
    assert assigns(:patron_status_search).is_a? Privileges::Search::PatronStatusSearch
    assert_response :success
    assert_template :index
  end

  test "should ignore blank params" do
    get :index, params: { sort: "" }
    assert_not_nil assigns(:patron_status_search)
    assert assigns(:patron_status_search).is_a? Privileges::Search::PatronStatusSearch
    assert_response :success
    assert_template :index
  end

  test "should test sorting" do
    get :index, params: { sort: "web_text" }

    assert assigns(:patron_status_search)
    assert_template :index
  end

  test "should redirect nonadmin user to root" do
    sign_in users(:nonadmin)
    get :index
    assert_redirected_to root_url
  end

  test "should get new" do
   get :new
   assert_not_nil assigns(:patron_status)
   assert_template "new"
  end

  test "should get edit action" do
   get :edit, params: { :id => PatronStatus.first.id }
   assert_not_nil assigns(:patron_status)
   assert_template "edit"
  end

  test "should create patron status" do
    assert_difference('PatronStatus.count') do
      post :create, params: { :patron_status => { :code => "uniqueness1203946", :web_text => "Test2" } }
    end

    assert_response :redirect
    assert_redirected_to patron_status_path(assigns(:patron_status))

    # If not from aleph, this should create without web_text
    assert_difference('PatronStatus.count') do
      post :create, params: { :patron_status => { :code => "uniqueness82937465", :from_aleph => true } }
    end
  end

  test "should NOT create patron status" do
    assert_no_difference('PatronStatus.count') do
       post :create, params: { :patron_status => { :code => nil, :web_text => "Test2" } }
    end
    assert_template "new"
  end

  test "should show patron status" do
    get :show, params: { :id => PatronStatus.first.id }
    assert assigns(:patron_status)
    assert assigns(:sublibraries)
    assert assigns(:permissions)
    assert assigns(:patron_status_permission)
    assert !assigns(:patron_status_permissions)
    assert !assigns(:sublibrary)
    assert_template "show"
  end

  test "should show patron status permissions" do
    get :show, params: { :id => PatronStatus.first.id, :sublibrary_code => sublibraries(:aleph_one).code }
    assert assigns(:sublibrary)
    assert assigns(:patron_status_permissions)
    assert_template "show"
  end

  test "should update patron status" do
    put :update, params: { :id => PatronStatus.first.id, :patron_status => { :web_text => "Get some new text in here" } }

    assert assigns(:patron_status)
    assert_equal assigns(:patron_status).web_text, "Get some new text in here"
    assert_redirected_to patron_status_path(assigns(:patron_status))
  end

  test "should NOT update patron status" do
    put :update, params: { :id => PatronStatus.find_by_code("nyu_ag_noaleph_law").id, :patron_status => { :web_text => "" } }

    assert_template "edit"
  end

  test "should destroy patron status" do
    assert_difference('PatronStatus.count', -1) do
      delete :destroy, params: { :id => PatronStatus.first.id }
    end

    assert_redirected_to patron_statuses_path
  end

end
