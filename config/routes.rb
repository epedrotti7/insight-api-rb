Rails.application.routes.draw do
  get 'hello', to: 'greetings#hello'
  post '/nomes', to: 'censo_nomes#create'
end
