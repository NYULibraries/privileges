require 'test_helper'

class ApplicationDetailsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_not_nil assigns(:application_details)
    assert_response :success
    assert_template :index
  end

  test "should get edit action" do
   get :edit, params: { id: ApplicationDetail.first.id }
   assert_response :success
  end

  test "should update application detail" do
   put :update, params: { id: ApplicationDetail.first.id, application_detail: {the_text: "updating this text"} }

   assert assigns(:application_detail)
   assert_equal assigns(:application_detail).the_text, "updating this text"
   assert_redirected_to application_details_path
  end

  test "should throw update error" do
   put :update, params: { id: ApplicationDetail.first.id, application_detail: {the_text: nil} }

   assert_template :edit
  end

end
