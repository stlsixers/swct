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

	def edit
		@inventory = Inventory.find(params[:id])
		session[:return_to] ||= request.referer
	end

	def update
		@inventory = Inventory.find(params[:id])
		@inventory.update_attributes(inventory_params_edit)
		flash[:notice] = "Inventory successfully updated"
		redirect_to session.delete(:return_to)
	end

	def destroy
		session[:return_to] ||= request.referer
		@inventory = Inventory.find(params[:id])
		@inventory.destroy
		flash[:notice] = "Inventory successfully deleted"
		redirect_to session.delete(:return_to)
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

	def inventory_params_edit
		params.require(:inventory).permit(:card_id,:machine_id,:quantity)
	end

end