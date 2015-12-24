class Inventory < ActiveRecord::Base
	belongs_to :card
	belongs_to :machine
end