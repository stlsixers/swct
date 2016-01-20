class AddEmailAndNotesToMachines < ActiveRecord::Migration
  def change
  	add_column :machines, :email, :string
  	add_column :machines, :notes, :string
  end
end
