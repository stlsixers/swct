class Machine < ActiveRecord::Base
	has_many :inventories
	has_many :cards, through: :inventories
end