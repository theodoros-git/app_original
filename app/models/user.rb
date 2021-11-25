class User < ApplicationRecord

	validates :phone, presence: true,length: { is: 8 },uniqueness: true
	has_secure_password
	validates :password, length: { minimum: 6 }
end
