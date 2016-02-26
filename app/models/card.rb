class Card < ActiveRecord::Base
	belongs_to :card_set
	has_many :trades
	has_many :orders, through: :trades
	has_many :inventories, dependent: :destroy
	has_many :machines, through: :inventories

	validates :name, presence: true
end
