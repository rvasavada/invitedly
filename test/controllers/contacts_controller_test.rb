require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    @contact = contacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, contact: { address_1: @contact.address_1, address_2: @contact.address_2, cell_phone: @contact.cell_phone, city: @contact.city, contact_id: @contact.contact_id, country: @contact.country, first_name: @contact.first_name, home_phone: @contact.home_phone, last_name: @contact.last_name, max_guests: @contact.max_guests, postal_code: @contact.postal_code, region: @contact.region, spouse_first_name: @contact.spouse_first_name, spouse_last_name: @contact.spouse_last_name, spouse_title: @contact.spouse_title, state: @contact.state, title: @contact.title, user_id: @contact.user_id, zip: @contact.zip }
    end

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should show contact" do
    get :show, id: @contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact
    assert_response :success
  end

  test "should update contact" do
    patch :update, id: @contact, contact: { address_1: @contact.address_1, address_2: @contact.address_2, cell_phone: @contact.cell_phone, city: @contact.city, contact_id: @contact.contact_id, country: @contact.country, first_name: @contact.first_name, home_phone: @contact.home_phone, last_name: @contact.last_name, max_guests: @contact.max_guests, postal_code: @contact.postal_code, region: @contact.region, spouse_first_name: @contact.spouse_first_name, spouse_last_name: @contact.spouse_last_name, spouse_title: @contact.spouse_title, state: @contact.state, title: @contact.title, user_id: @contact.user_id, zip: @contact.zip }
    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, id: @contact
    end

    assert_redirected_to contacts_path
  end
end
