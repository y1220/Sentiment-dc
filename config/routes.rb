Rails.application.routes.draw do

  root 'home#index'
  resources :products

  get 'home/index'
  get 'reports/daily'
  get 'recommenders/index'
  get 'recommenders/update_clickup'

  get 'question/index'
  get 'question/create'

  get 'tasks/index'
  get 'tasks/show'
  get 'tasks/update_clickup'

  get 'commits/index'
  get 'commits/update_link'
  get 'commits/update_github'
  get 'commits/assign_git/:cid', to: 'commits#assign_git'
  get 'commits/task_registration/:cid', to: 'commits#task_registration'
  get 'commits/show_task_commit/:cid', to: 'commits#show_task_commit'
  post 'commits/register_task_commit'

  post 'branches/update_git_url'
  post 'branches/register_git_branch'

  post 'reports/daily_insert'
  post 'reports/create_report_db'
  post 'reports/update_daily_reports'
  post 'reports/create_availability_db'
  post 'reports/update_daily_availabilities'


  get 'property_settings/index'
  get 'property_settings/setup'

  post 'property_settings/update_key_value'
  put 'property_settings/edit/:id', to: 'property_settings#edit'
  put 'property_settings/disable_record/:id', to: 'property_settings#disable_record'
  put 'property_settings/enable_record/:id', to: 'property_settings#enable_record'

  get 'notion/index'
  post 'notion/import_daily_reports'
  post 'notion/import_daily_availabilities'






  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
