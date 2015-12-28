class InventoriesController < ApplicationController

	def index
		@inventories = Inventory.all
	end

	def new
		@inventory = Inventory.new
		@card_sets = CardSet.all
		@cards = Card.where("card_set_id = ?", CardSet.first.id)
		@machines = Machine.where("category = ?", Category.first.id)
	end

	def create
		@inventory = Inventory.create(inventory_params)
		@inventory.save
		flash[:notice] = "Pull successfully listed"
		redirect_to inventories_path
	end

	def update_cards
    @cards = Card.where("card_set_id = ?", params[:card_set_id])
    respond_to do |format|
      format.js
    end
  end

  def update_machines
    @machines = Machine.where("category = ?", params[:category_id])
    respond_to do |format|
      format.js
    end
  end

	private

	def inventory_params
		params.permit(:card_id,:machine_id,:quantity)
	end

end