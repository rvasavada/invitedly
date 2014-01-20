require 'test_helper'

class GuestsControllerTest < ActionController::TestCase
  setup do
    @guest = guests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:guests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create guest" do
    assert_difference('Guest.count') do
      post :create, guest: { address_1: @guest.address_1, address_2: @guest.address_2, cell_phone: @guest.cell_phone, city: @guest.city, guest_id: @guest.guest_id, country: @guest.country, first_name: @guest.first_name, home_phone: @guest.home_phone, last_name: @guest.last_name, max_guests: @guest.max_guests, postal_code: @guest.postal_code, region: @guest.region, spouse_first_name: @guest.spouse_first_name, spouse_last_name: @guest.spouse_last_name, spouse_title: @guest.spouse_title, state: @guest.state, title: @guest.title, user_id: @guest.user_id, zip: @guest.zip }
    end

    assert_redirected_to guest_path(assigns(:guest))
  end

  test "should show guest" do
    get :show, id: @guest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @guest
    assert_response :success
  end

  test "should update guest" do
    patch :update, id: @guest, guest: { address_1: @guest.address_1, address_2: @guest.address_2, cell_phone: @guest.cell_phone, city: @guest.city, guest_id: @guest.guest_id, country: @guest.country, first_name: @guest.first_name, home_phone: @guest.home_phone, last_name: @guest.last_name, max_guests: @guest.max_guests, postal_code: @guest.postal_code, region: @guest.region, spouse_first_name: @guest.spouse_first_name, spouse_last_name: @guest.spouse_last_name, spouse_title: @guest.spouse_title, state: @guest.state, title: @guest.title, user_id: @guest.user_id, zip: @guest.zip }
    assert_redirected_to guest_path(assigns(:guest))
  end

  test "should destroy guest" do
    assert_difference('Guest.count', -1) do
      delete :destroy, id: @guest
    end

    assert_redirected_to guests_path
  end
end
