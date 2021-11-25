class Customer < ApplicationRecord

	validates :phone, presence: true,length: { is: 8 }
	validates :fullname, presence: true
	validates :address, presence: true
	validates :ville, presence: true
	validates :profession, presence: true
	validates :card_id, presence: true
end
