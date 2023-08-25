require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "ホームページ | DAB"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "ヘルプ | DAB"
  end
end
