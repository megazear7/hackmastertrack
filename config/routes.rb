Rails.application.routes.draw do
  resources :class_spells

  resources :character_spells

  resources :class_spellbooks

  get '/users/', to: 'users#index'

  get '/specialization/retrieve', to: 'specializations#retrieve'
  resource :specializations

  resources :item_instances do
    member do
      post :take
    end
  end
  resources :bp_cost_by_race_classes

  resources :levels

  resources :ability_scores

  resources :campaigns

  resources :monsters

  resources :spells

  resources :races

  resources :character_classes

  resources :skills

  resources :proficiencies

  resources :talents

  resources :items

  resources :characters do
    member do
      get  :remove_proficiency
      get  :add_proficiency
      get  :add_spell
      get  :add_talent
      post :add_talent
      get  :add_skill
      post :add_skill
      post :add_silver
      post :boost_stat
      post :add_xp
      post :equip_items
      post :add_items
      get :add_items
      get  :level_up_edit
      post :level_up_update
    end

    collection do
      get :step1
      post :step2
    end

    member do
      post :step3
      post :step4
      post :step5
      post :step6
      post :step7
      post :step8
      post :step9
      post :step10
      post :step11
      post :step12
      post :step13
      post :finish
      get :leave
    end
  end

  resources :encounters

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root :to => "characters#index"

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
