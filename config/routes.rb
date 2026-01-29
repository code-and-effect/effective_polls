Rails.application.routes.draw do
  mount EffectivePolls::Engine => '/', as: 'effective_polls'
end

EffectivePolls::Engine.routes.draw do
  scope module: 'effective' do
    resources :polls, only: [:show] do
      resources :ballots, only: [:new, :show, :destroy] do
        resources :build, controller: :ballots, only: [:show, :update]
      end
    end
  end

  namespace :admin do
    resources :polls
    resources :poll_notifications, except: [:show]
  end

end
