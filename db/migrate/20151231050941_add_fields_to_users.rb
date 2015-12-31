class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :star_wars_name, :string
  end
end
