Rails.application.routes.draw do
  root 'books#index'
  resources :books
  # get 'books/index'
  # get 'books/search'
  # get 'books/edit'
  # get 'books/update'
  # get 'books/delete'
  post 'books/new'
  post 'books/search_book'
  post 'books/book_delete'
  # get 'books/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
