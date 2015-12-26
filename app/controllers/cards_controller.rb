class CardsController < ApplicationController

	def index
		if (params[:card_set_id])
			@card_set = CardSet.find(params[:card_set_id])
			@cards = @card_set.cards
		elsif (params[:machine_id])
			@machine = Machine.find(params[:machine_id])
			@cards = @machine.cards
		else
			@cards = Card.all
		end
	end

	def show
		@card = Card.find(params[:id])
	end

	def new
		@card_set = CardSet.find(params[:card_set_id])
		@card = Card.new
	end

	def create
		@card = Card.new(card_params)
		@card.save
		flash[:notice] = "Card successfully created"
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
		flash[:notice] = "Card successfully updated"
		@card_set = CardSet.find(params[:card_set_id])
		redirect_to card_set_cards_path(@card_set)
	end

	def destroy
		@card_set = CardSet.find(params[:card_set_id])
		@card = Card.find(params[:id])
		@card.destroy
		flash[:notice] = "Card successfully deleted"
		redirect_to card_set_cards_path(@card_set)
	end

	private
	def card_params
		params.require(:card).permit(:name,:card_set_id,:notes)
	end
	
end
