require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = comments(:one)
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "content should be present" do
    @comment.content = "     "
    assert_not @comment.valid?
  end

  test "user should be present" do
    @comment.user = nil
    assert_not @comment.valid?
  end

  test "meeting should be present" do
    @comment.meeting = nil
    assert_not @comment.valid?
  end
end
