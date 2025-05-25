require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, options: {
    browser: :remote,
    url: "http://chrome:4444/wd/hub"
  }
end
