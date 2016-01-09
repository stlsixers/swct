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
		@inventory = []
		# just a quick workaround
		for i in 0..9
			@inventory << Inventory.new
		end
		@card_sets = CardSet.all.order(:name)
		@cards = Card.all.order(:name)
		@card = Card.find(params[:card_id]) if params[:card_id]
		@machines = Machine.all.sort_by {|a| (a.number.to_i)}

		@grouped_card_sets = []
		@card_sets.each do |c|
			@parts = []
			@cards.each do |card|
				if c.id == card.card_set_id
					@parts.push([c.name + " - " + card.name, card.id])
				end
			end
			@grouped_card_sets.push([c.name, @parts])
		end

		@categories = Category.all
		@grouped_machines = []
		@categories.each do |c|
			@parts = []
			@machines.each do |m|
				if m.category == c.id
					@parts.push([c.title + " - " + m.number.to_s, m.id])
				end
			end
			@grouped_machines.push([c.title, @parts])
		end
		
	end

	def create
			
			params[:inventories].each do |i|
				
				if i[:quantity] == ""

				elsif Inventory.find_by_card_id_and_machine_id(params[:card_id], i[:machine_id]).nil?
					Inventory.create(:card_id => params[:card_id], :machine_id => i[:machine_id], :quantity => i[:quantity]).save
					# dont do it this way
				else
					inventory = Inventory.find_by_card_id_and_machine_id(params[:card_id], i[:machine_id])
					quantity = inventory.quantity + i[:quantity].to_i
					inventory.update_attribute('quantity', quantity)
				end
			end

			flash[:notice] = "Pull successfully listed"
			redirect_to inventories_path

			# if @inventory.save
			# 	flash[:notice] = "Pull successfully listed"
			# 	redirect_to inventories_path
			# else
			# 	flash[:error] = "Please don't leave any fields blank"
			# 	redirect_to inventories_path
			# end

		# else
		# 	flash[:error] = "Inventory for that card in the device already exists. Please edit the device count"
		# 	redirect_to inventories_path
		# end
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
			redirect_to session.delete(:return_to)
			
		else
			
			session[:return_to] ||= request.referer
			@inventory = Inventory.find(params[:id])
			if !params[:status].nil?
				@inventory.update_attributes(inventory_params2)
			else
				@inventory.update_attributes(inventory_params_edit)
			end
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
		@machines = Machine.all.order(:category).sort_by {|a| (a.number.to_i)}

		@categories = Category.all
		@grouped_machines = []
		@categories.each do |c|
			@parts = []
			@machines.each do |m|
				if m.category == c.id
					@parts.push([c.title + " - " + m.number.to_s, m.id])
				end
			end
			@grouped_machines.push([c.title, @parts])
		end
		session[:return_to] ||= request.referer
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

	def inventory_params2
		params.permit(:card_id,:machine_id,:quantity)
	end

	def inventory_params_edit
		params.require(:inventory).permit(:card_id,:machine_id,:quantity)
	end

	def inventory_params(my_params)
    my_params.permit(:card_id, :machine_id, :quantity)
  end

end