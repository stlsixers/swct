class CardsController < ApplicationController

	before_action :authenticate_user!

	include SmartListing::Helper::ControllerExtensions
	helper  SmartListing::Helper

	def index
		if (params[:card_set_id])
			@card_set = CardSet.find(params[:card_set_id])
			cards_scope = @card_set.cards
			cards_scope = cards_scope.where("lower(name) LIKE '%#{params[:filter].downcase}%'") if params[:filter]
			@cards = smart_listing_create(:cards, cards_scope, partial: "cards/list", default_sort: {name: "asc"})
		elsif (params[:machine_id])
			@machine = Machine.find(params[:machine_id])
			@cards = @machine.cards
			@inventories = @machine.inventories
			cards_scope = @cards
			cards_scope = cards_scope.joins(:card_set).where('lower(card_sets.name) LIKE ? OR lower(cards.name) LIKE ?', "%#{params[:filter].downcase}%", "%#{params[:filter].downcase}%").uniq.order('card_sets.name') if params[:filter]
			# cards_scope = cards_scope.where("lower(name) LIKE '%#{params[:filter].downcase}%'") if params[:filter]
			@cards = smart_listing_create(:cards, cards_scope.joins(:card_set), partial: "cards/list", sort_attributes: [[:set_name, "card_sets.name"]], default_sort: {set_name: "asc"})
		else
			# @cards = CardSet.includes(:cards).all
			@cards = Card.includes(:card_set, :inventories).all
			# @cards = Card.joins(:card_set)
			# check why uniq and distinct dont make a difference
			cards_scope = @cards
			cards_scope = CardSet.joins(:cards).where('lower(card_sets.name) LIKE ? OR lower(cards.name) LIKE ?', "%#{params[:filter].downcase}%", "%#{params[:filter].downcase}%").uniq if params[:filter]
			@cards = smart_listing_create(:cards, cards_scope, partial: "cards/list", sort_attributes: [[:set_name, "card_sets.name"]], default_sort: {set_name: "asc"})
		end
	end

	def show
		@card = Card.find(params[:id])
		@inventories = @card.machines.sort_by {|a| (a.number.to_i)}
		@machines = smart_listing_create(:machines, @inventories, partial: "cards/listing")
	end

	def new
		@card = Card.new
		if (params[:card_set_id])
			@card_set = CardSet.find(params[:card_set_id])
		else
			@card_sets = CardSet.all.order(:name)
		end
	end

	def create
		@card = Card.new(card_params)
		if @card.save
			flash[:notice] = "Card successfully created"
			redirect_to card_path(@card)
		else
			flash.now[:error] = "Card was not created successfully. Please enter a title."
			render :new
		end
	end

	def edit
		@card = Card.find(params[:id])
	end

	def update
		@card = Card.find(params[:id])
		 if @card.update_attributes(card_params)
			flash[:notice] = "Card successfully updated"
			redirect_to card_set_cards_path(@card)
		else
			flash.now[:error] = "Card was not updated successfully. Please do not leave the name blank."
			render :edit
		end
	end

	def destroy
		session[:return_to] ||= request.referer
		@card = Card.find(params[:id])
		@card.destroy
		flash[:notice] = "Card successfully deleted"
		redirect_to session.delete(:return_to)
	end

	private
	def card_params
		params.require(:card).permit(:name,:card_set_id,:notes)
	end
	
end
