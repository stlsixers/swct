class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
    	t.integer :card_id
    	t.integer :machine_id
    	t.integer :quantity

      t.timestamps null: false
    end
  end
end
