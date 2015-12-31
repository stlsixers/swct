class Inventory < ActiveRecord::Base

	has_paper_trail
	belongs_to :card
	belongs_to :machine
	validates :card_id, :machine_id, :quantity, presence: true
	
end