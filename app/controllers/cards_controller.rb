class CardsController < ApplicationController

	def index
		if (params[:card_set_id])
			@card_set = CardSet.find(params[:card_set_id])
			@cards = @card_set.cards
		elsif (params[:machine_id])
			@machine = Machine.find(params[:machine_id])
			@cards = @machine.cards
			@inventories = Inventory.where(:machine_id => @machine.id)
		else
			@cards = Card.all
		end
	end

	def show
		@card = Card.find(params[:id])
		@inventories = Inventory.where(:card_id => @card.id)
	end

	def new
		@card = Card.new
		session[:return_to] ||= request.referer
		if (params[:card_set_id])
			@card_set = CardSet.find(params[:card_set_id])
		else
			@card_sets = CardSet.all
		end
	end

	def create
		@card = Card.new(card_params)
		@card.save
		flash[:notice] = "Card successfully created"
		redirect_to session.delete(:return_to)
	end

	def edit
		@card = Card.find(params[:id])
		session[:return_to] ||= request.referer
	end

	def update
		@card = Card.find(params[:id])
		@card.update_attributes(card_params)
		flash[:notice] = "Card successfully updated"
		redirect_to session.delete(:return_to)
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
