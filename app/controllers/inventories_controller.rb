class InventoriesController < ApplicationController

	def index
		@inventories = Inventory.all
	end

	def new
		@inventory = Inventory.new
		@card_sets = CardSet.all
	end

	def create
		@inventory = Inventory.create(inventory_params)
	end

	private

	def inventory_params
		params.require(:inventory).permit(:card_id,:machine_id,:quantity)
	end

end
