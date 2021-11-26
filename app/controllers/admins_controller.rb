class AdminsController < ApplicationController

	def register
		render "admins/register", layout: "layout"
	end

	def register_form
		if User.where(phone: admin_params[:phone]).exists?
			flash[:user_exist] = "Cet utilisateur existe déjà"
			redirect_back(fallback_location: admin_register_path)
		else

			if admin_params[:password] != admin_params[:confirm_password] or !(admin_params[:phone].to_i.integer?) or admin_params[:phone].length != 8
			 	if admin_params[:password] != admin_params[:confirm_password]
					flash[:user_password] = "Les mots de passe doivent être les mêmes."
					redirect_back(fallback_location: admin_register_path)
				end
				if !(admin_params[:phone].to_i.integer?)
					flash[:user_phone] = "Le numéro de téléphone doit contenir que des chiffres"
					redirect_back(fallback_location: admin_register_path)
				end
				if admin_params[:phone].length != 8
					flash[:user_phone_len] = "Le numéro de téléphone doit contenir 8 caractères."
					redirect_back(fallback_location: admin_register_path)
				end
			else

				session[:admin_name] = admin_params[:nom]+' '+ admin_params[:prenom]
				session[:admin_phone] = admin_params[:phone]
				session[:admin_password] = admin_params[:password]

				flash[:admin_confirmation] = "Veuillez entrer le code confidentiel requis."
				redirect_to admin_register_confirm_path
			end
		end
	end

	def register_confirm
		render "admins/register_confirm", layout: "layout"
	end

	def register_confirm_form
		if admin_params_c[:code_secret] == "je menfou de kelkun@@@___@@@##~&"
			@new_admin = Admin.new
			@new_admin.fullname = session[:admin_name]
			@new_admin.phone = session[:admin_phone]
			@new_admin.password = session[:admin_password]
			@new_admin.save

			@new_user = User.new
			@new_user.phone = session[:admin_phone]
			@new_user.password = session[:admin_password]
			@new_user.is_active = true
			@new_user.is_customer = false
			@new_user.is_admin = true
			@new_user.is_provider = false
			@new_user.save
			flash[:admin_success] = "Compte administrateur créé avec succès. Veuillez vous connecter!!"
			redirect_to admin_login_path

		else
			flash[:admin_error] = "Code confidentiel incorrect. Veuillez contacter le super admin pour plus de détails."
			redirect_back(fallback_location: admin_register_confirm_path)
		end
	end

	def login
		render "admins/login", layout: "layout"
	end


	def login_form
		@user = User.find_by(phone:login_params[:phone])
		if @user && @user.authenticate(login_params[:password]) && @user.is_admin && @user.is_active
			flash[:login_success] = "Bienvenue. Vous vous êtes connecté avec succès en tant qu'administrateur"
			session[:current_user_admin_id] = @user.id
			redirect_to admin_dashboard_path
		else
			flash[:login_error] = "Identifiants incorrects. Êtes-vous vraiment un administrateur?"
			redirect_back(fallback_location: admin_login_path)
		end
	end


	def dashboard
		if session[:current_user_admin_id] 
			@user = User.find(session[:current_user_admin_id])
			if @user.is_active && @user.is_admin
				@admin = Admin.find_by(phone: @user.phone)
				render "admins/dashboard", layout: "users_dashboard_layout"
			else
				flash[:acces_error] = "Vous n'êtes pas autorisé à accéder à cette page."
				redirect_to admin_login_path
			end
		else
			flash[:login_forcer] = "Vous deviez d'abord vous connecter avant d'accéder à cette page."
			redirect_to admin_login_path
		end
	end


	def destroy
	    session[:current_user_admin_id] = nil
	    flash[:notice_logout] = "Vous vous êtes déconnecté avec succès."
	    redirect_to admin_login_path
	end

	def add_product
		if session[:current_user_admin_id] 
			@user = User.find(session[:current_user_admin_id])
			if @user.is_active && @user.is_admin
				@admin = Admin.find_by(phone: @user.phone)
				render "admins/add_product", layout: "users_dashboard_layout"
			else
				flash[:acces_error] = "Vous n'êtes pas autorisé à accéder à cette page."
				redirect_to admin_login_path
			end
		else
			flash[:login_forcer] = "Vous deviez d'abord vous connecter avant d'accéder à cette page."
			redirect_to admin_login_path
		end
	end


	def add_product_form
		if session[:current_user_admin_id] 
			@user = User.find(session[:current_user_admin_id])
			if @user.is_active && @user.is_admin
				@admin = Admin.find_by(phone: @user.phone)
				
				session[:product_name] = product_params[:product_name]
				session[:product_min_price] = product_params[:product_min_price]
				session[:product_max_price] = product_params[:product_max_price]
				session[:product_min_quan] = product_params[:product_min_quan]
				session[:product_max_quan] = product_params[:product_max_quan]
				session[:product_desc] = product_params[:product_desc]

				redirect_to admin_add_product_two_path
			else
				flash[:acces_error] = "Vous n'êtes pas autorisé à accéder à cette page."
				redirect_to admin_login_path
			end
		else
			flash[:login_forcer] = "Vous deviez d'abord vous connecter avant d'accéder à cette page."
			redirect_to admin_login_path
		end
	end


	def add_product_two
		if session[:current_user_admin_id] 
			@user = User.find(session[:current_user_admin_id])
			if @user.is_active && @user.is_admin
				@admin = Admin.find_by(phone: @user.phone)
				render "admins/add_product_two", layout: "users_dashboard_layout"
			else
				flash[:acces_error] = "Vous n'êtes pas autorisé à accéder à cette page."
				redirect_to admin_login_path
			end
		else
			flash[:login_forcer] = "Vous deviez d'abord vous connecter avant d'accéder à cette page."
			redirect_to admin_login_path
		end
	end


	private
		def admin_params
			params.require(:admin).permit(:nom, :prenom,
			 :phone, :password, :confirm_password)
		end
		def admin_params_c
			params.require(:admin_c).permit(:code_secret,)
		end

		def login_params
			params.require(:login).permit(:phone, :password)
		end

		def product_params
			params.require(:product).permit(:product_name, :product_min_price, :product_max_price,
				:product_min_quan, :product_max_quan, :product_desc)
		end
end
