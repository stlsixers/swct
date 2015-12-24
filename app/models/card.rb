class Card < ActiveRecord::Base
	belongs_to :card_set
	has_many :trades
	has_many :orders, through: :trades
	has_many :inventories
	has_many :machines, through: :inventories
end
