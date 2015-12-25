class CardsController < ApplicationController

	def index
		@card_set = CardSet.find(params[:card_set_id])
		@cards = @card_set.cards
	end

	def new
		@card_set = CardSet.find(params[:card_set_id])
		@card = Card.new
	end

	def create
		@card = Card.new(card_params)
		@card.save
		@card_set = CardSet.find(params[:card_set_id])
		redirect_to card_set_cards_path(@card_set)
	end

	def edit
		@card_set = CardSet.find(params[:card_set_id])
		@card = Card.find(params[:id])
	end

	def update
		@card = Card.find(params[:id])
		@card.update_attributes(card_params)
		@card_set = CardSet.find(params[:card_set_id])
		redirect_to card_set_cards_path(@card_set)
	end

	def destroy
		@card_set = CardSet.find(params[:card_set_id])
		@card = Card.find(params[:id])
		@card.destroy
		redirect_to card_set_cards_path(@card_set)
	end

	private
	def card_params
		params.require(:card).permit(:name,:card_set_id,:notes)
	end
	
end
