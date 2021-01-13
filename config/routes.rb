Rails.application.routes.draw do
  mount EffectivePolls::Engine => '/', as: 'effective_polls'
end

EffectivePolls::Engine.routes.draw do
  scope module: 'effective' do
    resources :ballots, only: [:index, :show, :new, :destroy] do
      resources :build, controller: :ballots, only: [:show, :update]
    end

    resources :polls, only: [:index]
  end

  namespace :admin do
    resources :ballots, except: [:destroy]

    resources :polls, except: [:show] do
      get :results, on: :member
    end

    resources :poll_questions, except: [:show]
  end

end
