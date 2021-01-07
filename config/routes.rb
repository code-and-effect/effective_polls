Rails.application.routes.draw do
  mount EffectivePolls::Engine => '/', as: 'effective_polls'
end

EffectivePolls::Engine.routes.draw do
  scope module: 'effective' do
    resources :polls
  end

  namespace :admin do
    resources :polls, except: [:show] do
      get :results, on: :member
    end
  end

end
