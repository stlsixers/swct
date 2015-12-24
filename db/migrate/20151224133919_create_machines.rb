class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
    	t.string :category
    	t.integer :number

      t.timestamps null: false
    end
  end
end
