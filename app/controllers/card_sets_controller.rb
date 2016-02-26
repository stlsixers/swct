class CardSetsController < ApplicationController
	before_action :authenticate_user!

	include SmartListing::Helper::ControllerExtensions
	helper  SmartListing::Helper

	def index
		card_sets_scope = CardSet.all
		card_sets_scope = card_sets_scope.where("lower(name) LIKE '%#{params[:filter].downcase}%'") if params[:filter]
		@card_sets = smart_listing_create(:card_sets, card_sets_scope, partial: "card_sets/list", default_sort: {name: "asc"})
	end

	def new
		@card_set = CardSet.new
	end

	def create
		@card_set = CardSet.new(card_set_params)
		if @card_set.save
			flash[:notice] = "Card set successfully created."
			redirect_to card_set_cards_path(@card_set)
		else
			flash.now[:error] = "Card set was not created successfully. Please enter a title."
			render :new
		end
	end

	def edit
		@card_set = CardSet.find(params[:id])
	end

	def update
		@card_set = CardSet.find(params[:id])
		if @card_set.update_attributes(card_set_params)
			flash[:notice] = "Card set successfully updated."
			redirect_to card_set_cards_path(@card_set)
		else
			flash.now[:error] = "Card set was not updated successfully. Please do not leave the name blank."
			render :edit
		end
	end

	def destroy
		@card_set = CardSet.find(params[:id])
		@card_set.destroy
		flash[:notice] = "Card Set successfully deleted"
		redirect_to card_sets_path
	end

	def set_builder
		@card_set = CardSet.find(params[:id])
		@cards = @card_set.cards.where("name NOT LIKE '%Complete%'")
		@machine_ids = []
		@machines = []
		@real_machines = []
		@cards.each do |c|
			c.inventories.each do |i|
				if i.quantity != 0
					@machine_ids.push([c.id,i.machine_id])
				end
			end
		end
		@unique = @machine_ids.uniq {|machine_ids| machine_ids[1]}
		@diff = @machine_ids - @unique
		@diff.each do |d|
			@machines.push(d[1])
		end
		@machines = @machines.uniq
		@machines.each do |m|
			@real_machines.push(Machine.find(m))
		end
	end

	private
	def card_set_params
		params.require(:card_set).permit(:name)
	end

end
