class CardSetsController < ApplicationController

	def index
		@card_sets = CardSet.all
	end

	def new
		@card_set = CardSet.new
	end

	def create
		@card_set = CardSet.new(card_set_params)
		@card_set.save
		redirect_to card_sets_path
	end

	def edit
		@card_set = CardSet.find(params[:id])
	end

	def update
		@card_set = CardSet.find(params[:id])
		@card_set.update_attributes(card_set_params)
		redirect_to card_sets_path
	end

	def destroy
		@card_set = CardSet.find(params[:id])
		@card_set.destroy
		redirect_to card_sets_path
	end

	private
	def card_set_params
		params.require(:card_set).permit(:name)
	end

end
