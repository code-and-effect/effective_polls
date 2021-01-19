Rails.application.routes.draw do
  mount EffectivePolls::Engine => '/', as: 'effective_polls'
end

EffectivePolls::Engine.routes.draw do
  scope module: 'effective' do
    resources :polls, only: [] do
      resources :ballots, only: [:new, :show] do
        resources :build, controller: :ballots, only: [:show, :update]
      end
    end
  end

  namespace :admin do
    resources :polls, except: [:show] do
      get :results, on: :member
    end

    resources :poll_notifications, except: [:show]
    resources :poll_questions, except: [:show]
  end

end
