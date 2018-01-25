require 'test_helper'

class QuranControllerTest < ActionDispatch::IntegrationTest
  test "should get q01" do
    get quran_q01_url
    assert_response :success
  end

  test "should get q02" do
    get quran_q02_url
    assert_response :success
  end

end
