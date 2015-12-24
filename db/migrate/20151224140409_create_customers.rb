class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
    	t.string :ebayName
    	t.string :swctName

      t.timestamps null: false
    end
  end
end
