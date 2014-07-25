Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root 'information#data'

  get 'metric_results/:id/descendant_values' => 'metric_results#descendant_values'

  get 'module_results/:id/get' => 'module_results#get'
  get 'module_results/:id/metric_results' => 'module_results#metric_results'
  get 'module_results/:id/children' => 'module_results#children'

  resources :projects, except: [:index, :new, :edit]
  get 'projects/:id/exists' => 'projects#exists'
  get 'projects' => 'projects#all'
  get 'projects/:id/repositories_of' => 'projects#repositories_of'

  get 'repositories/types' => 'repositories#types'
  get 'repositories/:id/process' => 'repositories#process_repository'
  get 'repositories/:id/cancel_process' => 'repositories#cancel_process'
  get 'repositories/:id/has_processing' => 'repositories#has_processing'
  get 'repositories/:id/has_ready_processing' => 'repositories#has_ready_processing'
  get 'repositories/:id/last_ready_processing' => 'repositories#last_ready_processing'
  get 'repositories/:id/last_processing_state' => 'repositories#last_processing_state'
  get 'repositories/:id/cancel_process' => 'repositories#cancel_process'
  post 'repositories/:id/first_processing(/:after_or_before)' => 'repositories#first_processing_in_time' # after_or_before is optional for this route
  post 'repositories/:id/last_processing(/:after_or_before)' => 'repositories#last_processing_in_time' # after_or_before is optional for this route
  post 'repositories/:id/has_processing/:after_or_before' => 'repositories#has_processing_in_time'
  post 'repositories/:id/module_result_history_of' => 'repositories#module_result_history_of'
  post 'repositories/:id/metric_result_history_of' => 'repositories#metric_result_history_of'
  resources :repositories , except: [:index, :new, :edit]

  get 'base_tools' => 'base_tools#all_names'
  get 'base_tools/:name/find' => 'base_tools#find'

  post 'tests/clean_database' => 'tests#clean_database'

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
