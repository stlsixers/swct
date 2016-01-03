class CardSet < ActiveRecord::Base
	has_many :cards, -> { order(:name => :asc) }, dependent: :destroy
end
