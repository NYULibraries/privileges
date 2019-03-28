require 'test_helper'

class PermissionValuesControllerTest < ActionController::TestCase

 def setup
   @request.env["devise.mapping"] = Devise.mappings[:user]
   sign_in users(:admin)
   @perm_attrs = {code: "newandunique", web_text: "somethingnotblank", permission_code: "multiple_hold_permission"}
 end

 test "should create permission value" do
   assert_difference('PermissionValue.count') do
     post :create, params: { permission_value: @perm_attrs }
   end

   assert assigns(:permission)
   assert assigns(:permission_values)
   assert assigns(:permission_value)
   assert_response :redirect
   assert_redirected_to permission_path(assigns(:permission))
 end

 test "should NOT create permission value" do
   assert_no_difference('PermissionValue.count') do
     post :create, params: { permission_value: @perm_attrs.merge({code: nil}) }
   end

   assert assigns(:permission)
   assert_response :redirect
   assert_redirected_to permission_path(assigns(:permission))
   assert_not_nil flash[:danger]
 end

 test "should show permission value" do
   get :show, params: { id: PermissionValue.first.id }
   assert assigns(:permission)
   assert assigns(:permission_value)
   assert_response :success
   assert_template :show
 end

 test "should get edit" do
  get :edit, params: { id: PermissionValue.first.id }

  assert assigns(:permission)
  assert assigns(:permission_value)
  assert_response :success
 end

 test "should update permission value" do
  put :update, params: { id: PermissionValue.first.id, permission_value: @perm_attrs }

  assert assigns(:permission_value)
  assert assigns(:permission)
  assert_redirected_to permission_path(assigns(:permission))
 end

 test "should NOT update permission value" do
   put :update, params: { id: PermissionValue.first.id, permission_value: @perm_attrs.merge({code: nil}) }

   assert assigns(:permission)
   assert_template :edit
 end

 test "should destroy permission value" do
  assert_difference('PermissionValue.count', -1) do
    delete :destroy, params: { id: PermissionValue.first.id }
  end

  assert_redirected_to permission_path(assigns(:permission))
 end


end
