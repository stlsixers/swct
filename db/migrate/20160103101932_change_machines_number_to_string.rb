class ChangeMachinesNumberToString < ActiveRecord::Migration
  def change
  	change_column :machines, :number, :string
  end
end
