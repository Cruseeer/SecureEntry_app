class LostCardsController < ApplicationController
  before_action :set_lost_card, only: %i[ show edit update destroy ]

  def all_lost_cards
    @all_lost_cards = LostCard.all
  end

  # GET /lost_cards or /lost_cards.json
  def index
    @lost_cards = LostCard.all
  end

  # GET /lost_cards/1 or /lost_cards/1.json
  def show
  end

  # GET /lost_cards/new
  def new
    @lost_card = LostCard.new
  end

  # GET /lost_cards/1/edit
  def edit
  end

  # POST /lost_cards or /lost_cards.json
  def create
    @lost_card = LostCard.new(lost_card_params)

    respond_to do |format|
      if @lost_card.save
        format.html { redirect_to lost_card_url(@lost_card), notice: "Lost card was successfully created." }
        format.json { render :show, status: :created, location: @lost_card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lost_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lost_cards/1 or /lost_cards/1.json
  def update
    respond_to do |format|
      if @lost_card.update(lost_card_params)
        format.html { redirect_to lost_card_url(@lost_card), notice: "Lost card was successfully updated." }
        format.json { render :show, status: :ok, location: @lost_card }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lost_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lost_cards/1 or /lost_cards/1.json
  def destroy
    @lost_card.destroy!

    respond_to do |format|
      format.html { redirect_to all_lost_cards_path, notice: "Zgłoszenie zgubionej karty zostało usunięte." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lost_card
      @lost_card = LostCard.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lost_card_params
      params.require(:lost_card).permit(:time, :description, :user_id)
    end
end
