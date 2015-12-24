class Order < ActiveRecord::Base
	belongs_to :customer
	belongs_to :user
	has_many :trades
	has_many :cards, through: :trades
end
