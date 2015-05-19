require 'test_helper'

class PatronStatusPermissionsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.cookies["_check_passive_login"] = true
    @psp_perm_attrs = {:sublibrary_code => sublibraries(:aleph_one).code, :permission_value_id => permission_values(:pv_nonaleph_one).id, :patron_status_code => patron_statuses(:aleph_nonvisible).code}
    sign_in users(:admin)
  end

  test "should create patron status permission" do
    VCR.use_cassette('create patron status permission') do
      assert_difference('PatronStatusPermission.count') do
        post :create, :patron_status_permission => @psp_perm_attrs
      end

      assert_response :redirect
      assert_redirected_to patron_status_path(assigns(:patron_status), :sublibrary_code => assigns(:sublibrary_code))
    end
  end

  test "should not create patron status permission" do
    VCR.use_cassette('dont create patron status permission') do
       assert_no_difference('PatronStatusPermission.count') do
         post :create, :patron_status_permission => @psp_perm_attrs.merge({:sublibrary_code => nil})
       end

       assert_response :redirect
       assert_redirected_to patron_status_path(assigns(:patron_status), :sublibrary_code => assigns(:sublibrary_code))
       assert_not_nil flash[:danger]
    end
   end

  test "should update patron status permission" do
    VCR.use_cassette('update patron status permission') do
      put :update, :id => patron_status_permissions(:psp_aleph_one).id, :patron_status_permission => @psp_perm_attrs

      assert_redirected_to patron_status_path(assigns(:patron_status), :sublibrary_code => assigns(:sublibrary_code))
      assert_response :redirect
    end
  end

  test "should not update patron status permission" do
    VCR.use_cassette('dont update patron status permission') do
      put :update, :id => patron_status_permissions(:psp_aleph_one).id, :patron_status_permission => @psp_perm_attrs.merge({:patron_status_code => nil})

      assert_response :redirect
      assert_redirected_to patron_status_path(assigns(:patron_status), :sublibrary_code => assigns(:sublibrary_code))
      assert_not_nil flash[:danger]
    end
  end

  test "should destroy patron status permission" do
    VCR.use_cassette('destroy patron status permission') do
      assert_difference('PatronStatusPermission.count', -1) do
        delete :destroy, :id => patron_status_permissions(:psp_aleph_one).id
      end

      assert_redirected_to patron_status_path(assigns(:patron_status), :sublibrary_code => assigns(:sublibrary_code))
    end
  end

  test "updating multiple patron status permissions at once" do
    VCR.use_cassette('update multiple patron status permissions') do
      get :update_multiple, :patron_status_permission => { :patron_status_code => 52 }, :update_permission_ids => [[patron_status_permissions(:psp_aleph_one).id, permission_values(:pv_aleph_two).id], [patron_status_permissions(:psp_aleph_two).id, permission_values(:pv_aleph_one).id]]

      one = PatronStatusPermission.find(patron_status_permissions(:psp_aleph_one).id)
      two = PatronStatusPermission.find(patron_status_permissions(:psp_aleph_two).id)

      assert_equal one.permission_value_id, permission_values(:pv_aleph_two).id
      assert_equal two.permission_value_id, permission_values(:pv_aleph_one).id

      assert_redirected_to patron_status_path(assigns(:patron_status), :sublibrary_code => assigns(:sublibrary_code))
      assert_response :redirect
    end
  end

end
