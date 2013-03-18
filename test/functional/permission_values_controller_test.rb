require 'test_helper'

class PermissionValuesControllerTest < ActionController::TestCase
  
 setup :activate_authlogic
 
 def setup
   current_user = UserSession.create(users(:admin))
   @perm_attrs = {:code => "newandunique", :web_text => "somethingnotblank", :permission_code => "multiple_hold_permission"}
 end

 test "should create permission value" do
   assert_difference('PermissionValue.count') do
     post :create, :permission_value => @perm_attrs
   end

   assert assigns(:permission)
   assert assigns(:permission_values)
   assert assigns(:permission_value)
   assert_response :redirect
   assert_redirected_to permission_path(assigns(:permission))
 end
 
 test "should NOT create permission value" do
   assert_no_difference('PermissionValue.count') do
     post :create, :permission_value => @perm_attrs.merge({:code => nil})
   end

   assert assigns(:permission)
   assert_response :redirect
   assert_redirected_to permission_path(assigns(:permission))
   assert_not_nil flash[:error]
 end

 test "should show permission value" do
   get :show, :id => PermissionValue.find(:first).id
   assert assigns(:permission)
   assert assigns(:permission_value)
   assert_response :success
   assert_template :show
 end

 test "should get edit" do
  VCR.use_cassette('edit permission value') do
    get :edit, :id => PermissionValue.find(:first).id

    assert assigns(:permission)
    assert assigns(:permission_value)
    assert_response :success
  end
 end

 test "should update permission value" do
   put :update, :id => PermissionValue.find(:first).id, :permission_value => @perm_attrs

   assert assigns(:permission_value)
   assert assigns(:permission)
   assert_redirected_to permission_path(assigns(:permission))
 end
 
 test "should NOT update permission value" do
   put :update, :id => PermissionValue.find(:first).id, :permission_value => @perm_attrs.merge({:code => nil})

   assert assigns(:permission)
   assert_template :edit
 end

 test "should destroy permission value" do
  VCR.use_cassette('destroy permission value') do
   assert_difference('PermissionValue.count', -1) do
     delete :destroy, :id => PermissionValue.find(:first).id
   end

   assert_redirected_to permission_path(assigns(:permission))
  end
 end
 
 
end