require "sidekiq/web" # require the web UI

Rails.application.routes.draw do
  devise_for :comps, controllers: { unlocks: "kaisha/unlocks", passwords: "kaisha/passwords" , registrations: "kaisha/registrations", sessions: "kaisha/sessions" }
  devise_for :users, controllers: { registrations: "users/registrations" }

  authenticate :user, lambda { |u| u.access_type == User::ACCESS_TYPE::KANRISHA } do 
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :admin do
    resources :parts_tables do
    end
    resources :kanji_tables do
    end
    resources :vocab_tables do
      collection do
        post :update_vocab_nation_ids
      end
    end
    resources :vocab_genres do
    end

    resources :tokuteis do
    end

    resources :tokutei_questions do
    end

    resources :tokutei_answers do
    end

    resources :audio_as do
      resources :audio_bs do
      end
    end

    resources :audio_bs do
      resources :audio_cs do
      end
    end

    resources :audio_cs do
      resources :audio_c_contents do
      end
    end

    resources :audio_c_contents do
      resources :audio_ds do
      end
    end

    resources :users do
    end

    resources :channels do
    end

    resources :block_ips do
    end
  end


  namespace :kaisha do
    root 'menus#index'
    resources :menus do
    end

    resources :company_stores do
    end

    resources :offers do
      collection do
        post :mail_request
      end
    end

    resources :job_profiles do
      collection do
        post :excel_upload
      end
    end

    resources :comps do
      member do
        get :invite
      end
    end

    resources :users do
      member do
        get :new_user
      end
    end

    resources :progress do
      collection do
        get :chart
        get :sub_genre_chart
      end
    end    
  end

  resources :mains do
  end

  resources :menus do
#    collection do
#      get :goi
#    end
  end
   
  resources :charts do
    collection do
      get :sub_genre_chart
    end
  end
  
  resources :gois do
    collection do
      get :vocab_double
      post :lang
      get :toggle
    end
  end

#  resources :webhook_events do
#    collection do
#      post :
#    end
#  end
  post '/webhook_events/:source', to: 'webhook_events#create'

  resources :foreigns do
    collection do
      get :kanji_vocab
      post :lang
    end
  end

  resources :kanjis do
    collection do
      get :kanji_vocab
#      post :lang
    end
  end

  resources :kanji_scrolls do
    collection do
      get :kanji_vocab
#      post :lang
    end
  end

  resources :kanji_units do
    collection do
      get :kanji_vocab
      get :parts_kanji
#      post :lang
    end
  end

  resources :parts do
    collection do
      get :kanji_vocab
      get :parts_kanji
      get :part
      get :vocab_info
      get :kanji_info
    end
  end

  resources :stores do
  end

  resources :jobs do
    collection do
      post :apply
    end
  end

  resources :users do
    collection do
      get :verify_email
      get :edit_verification_email
      patch :update_verification_email
      post :resend_verification_email
      post :back_to_login
    end
    member do
      get :profile
      post :update_profile
      patch :update_profile
    end
  end

  resources :vocab_mycards do
    collection do
      get :page_mylang
      get :vocab
      get :toggle
    end
  end

  resources :jlpts do
    collection do
      get :page_mylang
    end
  end

  resources :vocab_genres do
  end

  resources :quizes do
    collection do
      get :period
      get :jlpt
      get :genre
      post :next_ques
    end
  end

  resources :tokutei_contents do
  end

  resources :specified_vocabs do
    collection do
      get :vocab_word
      get :page_mylang
    end
  end

  resources :specified_conversations do
    collection do
      get :audio_c
      get :audio_d
      get :case_name
      get :get_case_name
    end
  end

  resources :quizes do
    member do
      post 'update_mycard_level'
    end
  end

  # Defines the root path route ("/")
  # root "articles#index"
  root 'menus#index'
end

