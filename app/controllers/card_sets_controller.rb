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
		@card_set.save
		flash[:notice] = "Card Set successfully created"
		redirect_to card_sets_path
	end

	def edit
		@card_set = CardSet.find(params[:id])
	end

	def update
		@card_set = CardSet.find(params[:id])
		@card_set.update_attributes(card_set_params)
		flash[:notice] = "Card Set successfully updated"
		redirect_to card_sets_path
	end

	def destroy
		@card_set = CardSet.find(params[:id])
		@card_set.destroy
		flash[:notice] = "Card Set successfully deleted"
		redirect_to card_sets_path
	end

	private
	def card_set_params
		params.require(:card_set).permit(:name)
	end

end
