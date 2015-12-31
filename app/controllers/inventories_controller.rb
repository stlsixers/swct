class InventoriesController < ApplicationController

	before_action :authenticate_user!

	include SmartListing::Helper::ControllerExtensions
	helper  SmartListing::Helper

	def index
		inventories_scope = Inventory.all.limit(30)
		@inventories = smart_listing_create(:inventories, inventories_scope, partial: "inventories/list", default_sort: {updated_at: "desc"})
	end

	def new
		@inventory = Inventory.new
		@card_sets = CardSet.all
		@cards = Card.where("card_set_id = ?", CardSet.first.id).order(:name)
		@machines = Machine.where("category = ?", Category.first.id).order(:number)
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
		if params[:swap]
			# look for better way to do this using whitelisted paramters
			@inventory = Inventory.find(params[:id])
			@inventory.quantity -= params[:quantity].to_i
			@inventory.update_attribute('quantity', @inventory.quantity)

			@swap_inventory = Inventory.where(:card_id => params[:card_id], :machine_id => params[:swap_machine_id])
			if @swap_inventory.empty?
				Inventory.create(:card_id => params[:card_id], :machine_id => params[:swap_machine_id], :quantity => params[:quantity])
			else
				@swap_inventory = @swap_inventory.first
				@swap_inventory.quantity += params[:quantity].to_i
				@swap_inventory.update_attribute('quantity', @swap_inventory.quantity)	
			end
			flash[:notice] = "Swap successfully updated"
			redirect_to inventories_path
			
		else
			
			@inventory = Inventory.find(params[:id])
			@inventory.update_attributes(inventory_params_edit)
			flash[:notice] = "Inventory successfully updated"
			redirect_to session.delete(:return_to)					

		end
	end

	def destroy
		session[:return_to] ||= request.referer
		@inventory = Inventory.find(params[:id])
		@inventory.destroy
		flash[:notice] = "Inventory successfully deleted"
		redirect_to session.delete(:return_to)
	end

	def swap
		@card = Card.find(params[:card_id])
		@machine = Machine.find(params[:machine_id])
		@inventory = Inventory.find(params[:id])
		@machines = Machine.all.order(:category).order(:number)
		# @inventories = Inventory.select("card_id").distinct
		# @card_sets = CardSet.all
		# @cards = Card.all.distinct.order(:name)
		# @machines = Machine.where("category = ?", Category.first.id).order(:number)
		# @machines = Machine.all.order(:number)
		#Inventory.select("machine_id").where(:card_id => c.id).distinct
		# @cards2 = Card.where("card_set_id = ?", CardSet.first.id).order(:name)
		# @machines2 = Machine.where("category = ?", Category.first.id).order(:number)

		# @inventoried = []
		# @inventories.each do |i|
		# 	@cards.each do |c|
		# 		if i.card_id == c.id
		# 			@card_set = CardSet.find(c.card_set_id)
		# 			@card_name = "#{@card_set.name} - #{c.name}"
		# 			@inventoried.push([@card_name,c.id])
		# 		end
		# 	end
		# end
		# @inventoried = @inventoried.sort_by{ |x,y| x }

		# @in_machine = []
		# @machines.each do |m|
		# 	@machine_name = "#{Category.find(m.category).try(:title)} #{m.number}"
		# 	@in_machine.push([@machine_name, m.id])
		# end
	end

	def update_cards
    @cards = Card.where("card_set_id = ?", params[:card_set_id]).order(:name)
    respond_to do |format|
      format.js
    end
  end

  def update_machines
    @machines = Machine.where("category = ?", params[:category_id]).order(:number)
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