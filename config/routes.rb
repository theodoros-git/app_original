Rails.application.routes.draw do
  root 'generals#index', as: :index
  get '/contact_us', to: 'generals#contact', as: :contact
  get '/about_us', to: 'generals#about', as: :about

  scope 'customers', as: 'customers' do
    get '/register', to: 'users#customers_register', as: :register
    post '/register', to: 'users#customers_register_form', as: :register_form
    get '/login', to: 'users#customers_login', as: :login
    post '/login', to: 'users#customers_login_form', as: :login_form
    get '/dashboard', to: 'users#customers_dashboard', as: :dashboard
    get '/logout', to: 'users#destroy', as: :logout
    get '/make_order', to: 'users#do_orders', as: :do_orders
    get '/profil', to: 'users#customers_profil', as: :profil
  end


  scope 'admin', as: 'admin' do
    get '/register', to: 'admins#register', as: :register
    post '/register', to: 'admins#register_form', as: :register_form
    get '/register/confirmation', to: 'admins#register_confirm', as: :register_confirm
    post '/register/confirmation', to: 'admins#register_confirm_form', as: :register_confirm_form
    get '/login', to: 'admins#login', as: :login
    post '/login', to: 'admins#login_form', as: :login_form
    get '/dashboard', to: 'admins#dashboard', as: :dashboard
    get '/logout', to: 'admins#destroy', as: :logout
    get '/ajouter_un_produit', to: 'admins#add_product', as: :add_product
    post '/ajouter_un_produit', to: 'admins#add_product_form', as: :add_product_form
    get '/ajouter_un_produit_step_two', to: 'admins#add_product_two', as: :add_product_two
  end

end
