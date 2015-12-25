class AddNotesToCards < ActiveRecord::Migration
  def change
  	add_column :cards, :notes, :string
  end
end
