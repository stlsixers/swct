class MachinesController < ApplicationController
	before_action :authenticate_user!

	include SmartListing::Helper::ControllerExtensions
	helper  SmartListing::Helper

	def index
		machines_scope = Machine.all.sort_by {|a| (a.number.to_i)}
		@machines = smart_listing_create(:machines, machines_scope, partial: "machines/list")
	end

	def new
		@machine = Machine.new
	end

	def create
		@machine = Machine.create(machine_params)
		@machine.save
		flash[:notice] = "Machine successfully created"
		redirect_to machines_path
	end

	def edit
		@machine = Machine.find(params[:id])
		session[:return_to] ||= request.referer
	end

	def update
		@machine = Machine.find(params[:id])
		@machine.update_attributes(machine_params)
		flash[:notice] = "Machine successfully updated"
		redirect_to session.delete(:return_to)
	end

	def destroy
		@machine = Machine.find(params[:id])
		@machine.destroy
		flash[:notice] = "Machine successfully deleted"
		redirect_to machines_path
	end

	private

	def machine_params
		params.require(:machine).permit(:category,:number,:swct_name)
	end

end
