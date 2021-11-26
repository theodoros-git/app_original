class Admin < ApplicationRecord
	validates :phone, presence: true,length: { is: 8 },uniqueness: true
end
