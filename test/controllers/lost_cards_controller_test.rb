require "test_helper"

class LostCardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lost_card = lost_cards(:one)
  end

  test "should get index" do
    get lost_cards_url
    assert_response :success
  end

  test "should get new" do
    get new_lost_card_url
    assert_response :success
  end

  test "should create lost_card" do
    assert_difference("LostCard.count") do
      post lost_cards_url, params: { lost_card: { description: @lost_card.description, time: @lost_card.time, user_id: @lost_card.user_id } }
    end

    assert_redirected_to lost_card_url(LostCard.last)
  end

  test "should show lost_card" do
    get lost_card_url(@lost_card)
    assert_response :success
  end

  test "should get edit" do
    get edit_lost_card_url(@lost_card)
    assert_response :success
  end

  test "should update lost_card" do
    patch lost_card_url(@lost_card), params: { lost_card: { description: @lost_card.description, time: @lost_card.time, user_id: @lost_card.user_id } }
    assert_redirected_to lost_card_url(@lost_card)
  end

  test "should destroy lost_card" do
    assert_difference("LostCard.count", -1) do
      delete lost_card_url(@lost_card)
    end

    assert_redirected_to lost_cards_url
  end
end
