require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @request.session[:user_id] = users(:one).id
  end

  test "should be logged in" do
    @request.session[:user_id] = nil
    get :index
    assert_response :redirect
  end

 test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => {
        :name => 'name3',
        :hashed_password => 'woop',
        :salt => 'salty'
      }
    end

    assert_redirected_to :action => 'index'
  end

  test "should show user" do
    get :show, :id => users(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => users(:one).id
    assert_response :success
  end

  test "should update user" do
    put :update, :id => users(:one).id, :user => {
        :name => 'name3',
        :hashed_password => 'woop',
        :salt => 'salty'
      }
    assert_redirected_to :action => 'index'
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:one).id
    end
    assert_redirected_to users_path
  end

  #thanks bill / mailing list
  self.use_transactional_fixtures = false
  test "destroy last fails1" do
    assert_raise(RuntimeError) do
      User.find(:all).each do |user|
        user.destroy
      end
    end
    assert_equal 1, User.count
 end

end
