class CardsController < ApplicationController

	before_action :authenticate_user!

	include SmartListing::Helper::ControllerExtensions
	helper  SmartListing::Helper

	def index
		if (params[:card_set_id])
			@card_set = CardSet.find(params[:card_set_id])
			cards_scope = @card_set.cards.includes(:inventories)
			cards_scope = cards_scope.where("lower(name) LIKE '%#{params[:filter].downcase}%'") if params[:filter]
			@cards = smart_listing_create(:cards, cards_scope, partial: "cards/list", default_sort: {name: "asc"})
		elsif (params[:machine_id])
			@machine = Machine.find(params[:machine_id])
			@cards = @machine.cards
			@inventories = @machine.inventories
			cards_scope = @cards
			@cards = smart_listing_create(:cards, cards_scope.joins(:card_set), partial: "cards/list", sort_attributes: [[:set_name, "card_sets.name"]], default_sort: {set_name: "asc"})
		else
			@cards = Card.includes(:card_set, :inventories)
			cards_scope = @cards
			cards_scope = Card.includes(:card_set, :inventories).where('lower(cards.name) LIKE ?', "%#{params[:filter].downcase}%").uniq if params[:filter]
			@cards = smart_listing_create(:cards, cards_scope, partial: "cards/list", sort_attributes: [[:set_name, "card_sets.name"]], default_sort: {set_name: "asc"})
		end
	end

	def show
		@card = Card.find(params[:id])
		@inventories = @card.machines.sort_by {|a| (a.number.to_i)}
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

		respond_to do |format|
	    if @card.update_attributes(card_params)
	      format.html { redirect_to(@card, :notice => 'Machine was successfully updated.') }
	      format.json { respond_with_bip(@card) }
	    else
	      format.html { render :action => "edit" }
	      format.json { respond_with_bip(@card) }
	    end
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
