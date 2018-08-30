Rails.application.routes.draw do
  root to: redirect('/links/new')
  resources 'links', :only => [:new, :create]
end
