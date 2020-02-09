require 'test_helper'

class TweetControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get tweet_new_url
    assert_response :success
  end

end
