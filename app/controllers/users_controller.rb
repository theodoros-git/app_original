class UsersController < ApplicationController
	protect_from_forgery

	def customers_register
		render "users/register", layout: "layout"
	end

	def customers_register_form
		if User.where(phone: customer_params[:phone]).exists?
			flash[:user_exist] = "Cet utilisateur existe déjà"
			redirect_back(fallback_location: customers_register_path)
		else

			if customer_params[:password] != customer_params[:confirm_password] or !(customer_params[:phone].to_i.integer?) or customer_params[:phone].length != 8
			 	if customer_params[:password] != customer_params[:confirm_password]
					flash[:user_password] = "Les mots de passe doivent être les mêmes."
					redirect_back(fallback_location: customers_register_path)
				end
				if !(customer_params[:phone].to_i.integer?)
					flash[:user_phone] = "Le numéro de téléphone doit contenir que des chiffres"
					redirect_back(fallback_location: customers_register_path)
				end
				if customer_params[:phone].length != 8
					flash[:user_phone_len] = "Le numéro de téléphone doit contenir 8 caractères."
					redirect_back(fallback_location: customers_register_path)
				end
			else

				@new_customer = Customer.new
				@new_customer.fullname = customer_params[:nom]+' '+ customer_params[:prenom]
				@new_customer.phone = customer_params[:phone]
				@new_customer.address = customer_params[:address]
				@new_customer.ville = customer_params[:ville]
				@new_customer.profession = customer_params[:profession]
				@new_customer.terms_of_use = customer_params[:terms_conditions]
				@new_customer.card_id = customer_params[:nom]+' '+ customer_params[:prenom]
				@new_customer.save

				@new_user = User.new
				@new_user.phone = customer_params[:phone]
				@new_user.password = customer_params[:password]
				@new_user.is_active = true
				@new_user.is_customer = true
				@new_user.is_admin = false
				@new_user.is_provider = false
				@new_user.save

				flash[:user_create] = "Votre compte a été créé avec succès. Veuillez donc vous connecter!!"
				redirect_to customers_login_path
			end
		end
	end

	def customers_login
		render "users/login", layout: "layout"
	end

	def customers_login_form
		@user = User.find_by(phone:login_params[:phone])
		if @user && @user.authenticate(login_params[:password]) && @user.is_customer && @user.is_active
			flash[:login_success] = "Bienvenue. Vous vous êtes connecté avec succès."
			session[:current_user_id] = @user.id
			redirect_to customers_dashboard_path
		else
			flash[:login_error] = "Identifiants incorrects. Êtes-vous vraiment un client?"
			redirect_back(fallback_location: customers_login_path)
		end
	end


	def customers_dashboard
		if session[:current_user_id] 
			@user = User.find(session[:current_user_id])
			if @user.is_active && @user.is_customer
				@customer = Customer.find_by(phone: @user.phone)
				render "users/dashboard", layout: "users_dashboard_layout"
			else
				flash[:acces_error] = "Vous n'êtes pas autorisé à accéder à cette page."
				redirect_to customers_login_path
			end
		else
			flash[:login_forcer] = "Vous deviez d'abord vous connecter avant d'accéder à cette page."
			redirect_to customers_login_path
		end
	end

	def do_orders
		if session[:current_user_id] 
			@user = User.find(session[:current_user_id])
			if @user.is_active && @user.is_customer
				@customer = Customer.find_by(phone: @user.phone)
				render "users/commandes", layout: "users_dashboard_layout"
			else
				flash[:acces_error] = "Vous n'êtes pas autorisé à accéder à cette page."
				redirect_to customers_login_path
			end
		else
			flash[:login_forcer] = "Vous deviez d'abord vous connecter avant d'accéder à cette page."
			redirect_to customers_login_path
		end
	end

	def customers_profil
		if session[:current_user_id] 
			@user = User.find(session[:current_user_id])
			if @user.is_active && @user.is_customer
				@customer = Customer.find_by(phone: @user.phone)
				render "users/profil", layout: "users_dashboard_layout"
			else
				flash[:acces_error] = "Vous n'êtes pas autorisé à accéder à cette page."
				redirect_to customers_login_path
			end
		else
			flash[:login_forcer] = "Vous deviez d'abord vous connecter avant d'accéder à cette page."
			redirect_to customers_login_path
		end
	end

	def destroy
	    session[:current_user_id] = nil
	    flash[:notice_logout] = "Vous vous êtes déconnecté avec succès."
	    redirect_to customers_login_path
	end


	private
		def customer_params
			params.require(:customer_register).permit(:nom, :prenom,
			 :address, :ville, :profession, :phone, :terms_conditions, :password, :confirm_password)
		end

		def login_params
			params.require(:login).permit(:phone, :password)
		end

		def current_user
	    	@current_user ||= User.find(session[:current_user_id]) if session[:current_user_id]
	  	end

  		helper_method :current_user
end
