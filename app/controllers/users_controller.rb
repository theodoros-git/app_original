class UsersController < ApplicationController

	def customers_register
		render "users/register", layout: "layout"
	end

	def customers_register_form
		@user = User.find_by(phone:customer_params[:phone])
		if @user.exists?
			flash[:user_exist] = "Cet utilisateur existe déjà"
			redirect_to :back
		else

		end
	end

	def customers_login
		render "users/login", layout: "layout"
	end



	private
		def customer_params
			params.require(:customer_register).permit(:nom, :prenom,
			 :address, :ville, :profession, :phone, :customer_card, :terms_conditions, :password)
		end

end
