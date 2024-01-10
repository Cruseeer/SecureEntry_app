require "application_system_test_case"

class LostCardsTest < ApplicationSystemTestCase
  setup do
    @lost_card = lost_cards(:one)
  end

  test "visiting the index" do
    visit lost_cards_url
    assert_selector "h1", text: "Lost cards"
  end

  test "should create lost card" do
    visit lost_cards_url
    click_on "New lost card"

    fill_in "Description", with: @lost_card.description
    fill_in "Time", with: @lost_card.time
    fill_in "User", with: @lost_card.user_id
    click_on "Create Lost card"

    assert_text "Lost card was successfully created"
    click_on "Back"
  end

  test "should update Lost card" do
    visit lost_card_url(@lost_card)
    click_on "Edit this lost card", match: :first

    fill_in "Description", with: @lost_card.description
    fill_in "Time", with: @lost_card.time
    fill_in "User", with: @lost_card.user_id
    click_on "Update Lost card"

    assert_text "Lost card was successfully updated"
    click_on "Back"
  end

  test "should destroy Lost card" do
    visit lost_card_url(@lost_card)
    click_on "Destroy this lost card", match: :first

    assert_text "Lost card was successfully destroyed"
  end
end
