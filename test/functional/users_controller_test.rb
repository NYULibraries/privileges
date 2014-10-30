require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  setup :activate_authlogic

  def setup
   current_user = UserSession.create(users(:admin))
  end

  test "should get index" do
    get :index
    assert_not_nil assigns(:users)
    assert_response :success
    assert_template :index
  end
  
  test "should get CSV from index" do
    get :index, :format => :csv
    assert_response :success
  end

  test "search returns result" do
    get :index, :search => "admin"
    assert_not_nil assigns(:users)
  end
  
  test "should get edit action" do
    get :edit, :id => User.first.username

    assert assigns(:user)
    assert_redirected_to root_path
  end

  test "should show user" do
    get :show, :id => User.first.id
    assert_not_nil assigns(:user)
    assert_response :success
    assert_template :show
  end
  
  test "should toggle user admin status" do
    put :update, :id => users(:nonadmin).id, :user => { :access_grid_admin => 1 }

    assert assigns(:user)
    assert_redirected_to user_path(assigns(:user))
    assert assigns(:user).user_attributes[:access_grid_admin], "Admin attr was not toggled"
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
     delete :destroy, :id => users(:nonadmin).id
    end

    assert_redirected_to users_path
  end
   
end