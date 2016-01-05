class AddSwctNameToMachines < ActiveRecord::Migration
  def change
  	add_column :machines, :swct_name, :string
  end
end
