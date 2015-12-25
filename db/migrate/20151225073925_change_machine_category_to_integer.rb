class ChangeMachineCategoryToInteger < ActiveRecord::Migration
  def change
  	change_column :machines, :category, :integer
  end
end
