require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_registration_path
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post user_registration_path, params: {
        user: {
          email: "test@example.com",
          password: "password123",
          password_confirmation: "password123",
          first_name: "Test",
          last_name: "User",
          role: "client"
        }
      }
    end
    assert_redirected_to root_path
  end

  test "should not create user with invalid data" do
    assert_no_difference("User.count") do
      post user_registration_path, params: {
        user: {
          email: "invalid",
          password: "short",
          password_confirmation: "different",
          first_name: "",
          last_name: "",
          role: "invalid"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
