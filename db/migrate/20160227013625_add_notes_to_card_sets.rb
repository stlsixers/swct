class AddNotesToCardSets < ActiveRecord::Migration
  def change
  	add_column :card_sets, :notes, :string
  end
end
