require 'test_helper'

class PrivilegesControllerTest < ActionController::TestCase

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "show all patron statuses list" do
    get :index_patron_statuses
    assert assigns(:patron_status_search)

    assert_template :index_patron_statuses
  end

  test "redirect to individual patron status" do
    sign_in users(:nonadmin)
    get :index_patron_statuses
    assert assigns(:patron_status_search)
    assert_equal assigns(:patron_status).stored(:code), users(:nonadmin).patron_status

    assert_redirected_to patron_path("#{assigns(:patron_status).primary_key}-#{@controller.send(:urlize, assigns(:patron_status).stored(:web_text))}")
  end

  test "show individual patron status" do
    get :show_patron_status, :id => patron_statuses(:aleph_one)
    assert assigns(:patron_status)
    assert assigns(:sublibraries_with_access)
    assert assigns(:sublibraries)
    assert !assigns(:sublibrary)

    assert_template "show_patron_status"
  end

  test "show individual patron status with sublibrary permissions" do
    get :show_patron_status, :id => patron_statuses(:aleph_one), :sublibrary_code => sublibraries(:aleph_one).code
    assert assigns(:sublibrary)
    assert assigns(:patron_status_permissions)

    assert_template "show_patron_status"
  end

  test "search for patron status and redirect to search results" do
    get :search, :q => "Student"
    assert assigns(:patron_status_search)
    #assert assigns(:patron_statuses).total > 0

    assert_template "search"
  end

  test "search for patron status and redirect to patron status page" do
    get :search, :q => "Adjunct Faculty"
    assert assigns(:patron_status_search)
    assert assigns(:patron_status_search).total == 1

    #assert_redirected_to patron_path("41-nyu-adjunct-faculty")
  end

end
