require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    get root_path
    assert_response :success
    assert_select "h1", "Schedule Your Sessions Seamlessly"
    assert_select ".feature-icon", 3  # Check for all three feature icons
  end

  test "should show sign in and registration links when not signed in" do
    get root_path
    assert_response :success
    assert_select "a", "Get Started"
    assert_select "a", "Sign In"
    assert_select "a", "Sign in to Schedule"
    assert_select "a", "Sign in to Comment"
    assert_select "a", "Sign in to Pay"
  end

  test "should show user specific links when signed in" do
    sign_in users(:one)  # Using the fixture we created earlier
    get root_path
    assert_response :success
    assert_select "a", "View Your Meetings"
    assert_select "a", "View Calendar"
    assert_select "a", "Start Collaborating"
    assert_select "a", "Book & Pay"
  end
end
