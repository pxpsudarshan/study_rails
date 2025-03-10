Rails.application.routes.draw do
  devise_for :comps, controllers: { passwords: "kaisha/passwords" , registrations: "kaisha/registrations", sessions: "kaisha/sessions" }
  devise_for :users, controllers: { registrations: "users/registrations" }

  namespace :admin do
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
#        get :new_store
#        patch :create_store
#        get :new_job_profile
#        patch :create_job_profile
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
 
  resources :gois do
    collection do
      get :vocab_double
      post :lang
    end
  end

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
    end
  end

  resources :jlpts do
    collection do
      get :page_mylang
    end
  end

  resources :quizes do
    collection do
      get :quiz
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
  root 'mains#index'
end
