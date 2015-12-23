class CardSetsController < ApplicationController

	def new
		@card_set = CardSet.new
	end

	def create
		@card_set = CardSet.new(card_set_params)
		if @card_set.save!

		else

		end
	end

	def card_set_params
		params.require(:card_set).permit(:name)
	end
end
