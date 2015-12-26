class MachinesController < ApplicationController

	def index
		@machines = Machine.all
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
	end

	def update
		@machine = Machine.find(params[:id])
		@machine.update_attributes(machine_params)
		flash[:notice] = "Machine successfully updated"
		redirect_to machines_path
	end

	def destroy
		@machine = Machine.find(params[:id])
		@machine.destroy
		flash[:notice] = "Machine successfully deleted"
		redirect_to machines_path
	end

	private

	def machine_params
		params.require(:machine).permit(:category,:number)
	end

end
