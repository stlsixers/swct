class InventoriesController < ApplicationController

	before_action :authenticate_user!

	include SmartListing::Helper::ControllerExtensions
	helper  SmartListing::Helper

	def index
		inventories_scope = PaperTrail::Version.where('whodunnit IS NOT ?', nil).order(:created_at => :desc).limit(50).includes(:item)
		@inventories = smart_listing_create(:inventories, inventories_scope, partial: "inventories/list", default_sort: {created_at: "desc"})
		user_ids = inventories_scope.collect(&:whodunnit).reject(&:blank?).map(&:to_i).uniq 
		@version_users = User.where(:id => user_ids)
	end

	def new
		@inventory = Inventory.new
		@card_sets = CardSet.all
		@cards = Card.where("card_set_id = ?", CardSet.first.id).order(:name)
		@machines = Machine.where("category = ?", Category.first.id).order(:number)
	end

	def create
		if Inventory.find_by_card_id_and_machine_id(params[:card_id], params[:machine_id]).nil?
			@inventory = Inventory.create(inventory_params)
			@inventory.save
			flash[:notice] = "Pull successfully listed"
			redirect_to inventories_path
		else
			flash[:error] = "Inventory for that card in the device already exists. Please edit the device count"
			redirect_to inventories_path
		end
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

			@swap_inventory = Inventory.find_by_card_id_and_machine_id(params[:card_id], params[:swap_machine_id])
			if @swap_inventory.nil?
				Inventory.create(:card_id => params[:card_id], :machine_id => params[:swap_machine_id], :quantity => params[:quantity])
			else
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