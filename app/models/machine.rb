class Machine < ActiveRecord::Base
	has_many :inventories
	has_many :cards, through: :inventories, dependent: :destroy

	validates :number, presence: true
end