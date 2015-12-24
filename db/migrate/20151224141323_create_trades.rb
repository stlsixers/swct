class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
    	t.integer :card_id
    	t.integer :order_id
    	t.integer :quantity

      t.timestamps null: false
    end
  end
end
