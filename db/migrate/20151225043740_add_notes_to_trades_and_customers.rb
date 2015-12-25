class AddNotesToTradesAndCustomers < ActiveRecord::Migration
  def change
  	add_column :trades, :notes, :string
  	add_column :customers, :notes, :string
  end
end
