Rails.application.routes.draw do
  root 'generals#index', as: :index
  get '/contact_us', to: 'generals#contact', as: :contact
  get '/about_us', to: 'generals#about', as: :about

  scope 'customers', as: 'customers' do
    get '/register', to: 'users#customers_register', as: :register
    post '/register', to: 'users#customers_register_form', as: :register_form
    get '/login', to: 'users#customers_login', as: :login
  end

end
