class MachinesController < ApplicationController

	def index
		@machines = Machine.all
	end

	def new
		@machine = Machine.new
	end

	def create
		@machine = Machine.create(machine_params)
		@machine.save
		redirect_to machines_path
	end

	def edit
		@machine = Machine.find(params[:id])
	end

	def update
		@machine = Machine.find(params[:id])
		@machine.update_attributes(machine_params)
		redirect_to machines_path
	end

	def destroy
		@card_set = CardSet.find(params[:card_set_id])
		@card = Card.find(params[:id])
		@card.destroy
		redirect_to card_set_cards_path(@card_set)
	end

	private

	def machine_params
		params.require(:machine).permit(:category,:number)
	end

end
