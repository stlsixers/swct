class Trade < ActiveRecord::Base
	has_many :cards
	belongs_to :order
end
