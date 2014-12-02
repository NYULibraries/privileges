require 'test_helper'

class PermissionsControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:admin)
  end

  test "should get index" do
   get :index

   assert_not_nil assigns(:permissions)
   assert_response :success
   assert_template :index
  end

  test "should get new" do
    get :new
    assert_not_nil assigns(:permission)
    assert_response :success
    assert_template :new
  end

  test "should create permission" do
    assert_difference('Permission.count') do
      post :create, :permission => {:code => "uniquecode1234", :from_aleph => true}
    end

    assert_response :redirect
    assert_redirected_to permission_path(assigns(:permission))
  end

  test "should NOT create permission" do
    assert_no_difference('Permission.count') do
      post :create, :permission => {:code => nil, :from_aleph => true}
    end

    assert assigns(:permission)
    assert_no_match(/^nyu_ag_noaleph_/, assigns(:permission).code)
    assert_template :new
  end

  test "should show permission" do
    get :show, :id => Permission.first.id
    assert_not_nil assigns(:permission)
    assert_response :success
    assert_template :show
  end

  test "should get edit" do
    VCR.use_cassette('edit permission') do
      get :edit, :id => Permission.first.id
      assert_response :success
    end
  end

  test "should update permission" do
    VCR.use_cassette('update permission') do
      put :update, :id => Permission.first.id, :permission => {:code => "uniquecode1234"}

      assert assigns(:permission)
      assert_redirected_to permission_path(assigns(:permission))
    end
  end

  test "should NOT update permission" do
    put :update, :id => Permission.first.id, :permission => {:code => nil }

    assert assigns(:permission)
    assert_not_nil flash[:danger]
    assert_template :edit
  end

  test "should destroy permission" do
    VCR.use_cassette('destroy permission') do
      assert_difference('Permission.count', -1) do
        delete :destroy, :id => Permission.first.id
      end

      assert_redirected_to permissions_path
    end
  end

  test "should update order" do
    VCR.use_cassette('update order permission') do
      post :update_order, :permissions => [permissions(:aleph_two).id, permissions(:aleph_one).id]

      assert_equal permissions(:aleph_two).id, Permission.by_sort_order.first.id
      assert_equal permissions(:aleph_one).id, Permission.by_sort_order.offset(1).limit(1).first.id
      assert_redirected_to permissions_url
    end
  end

end
