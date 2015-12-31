class Inventory < ActiveRecord::Base

	has_paper_trail
	belongs_to :card
	belongs_to :machine
	
end