class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def search
  end

  def edit
    @book = Book.find_by(id: params[:id])
  end

  def update
    @book = Book.find_by(id: params[:id])
    if @book.update(book_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @book = Book.find_by(id: params[:id])
    if @book.delete
      redirect_to root_path
    end
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def search_book
    redis = Redis.new(host: "localhost")
    @book_ids = redis.get(params[:search]) #firstly searching in the redis
    if @book_ids.present? 
      @book_ids = eval(@book_ids)
      @books = Book.where(id: @book_ids).as_json(only: [:id, :title, :author, :isbn, :description, :language], methods: [:cover_image_url])
    end
    # find the data in table if it is not presented in redis
    unless @book_ids.present?
      @books = Book.search params[:search]
      @book_ids = @books.pluck(:id)
      @books = @books.as_json(only: [:id, :title, :author, :isbn, :description, :language], methods: [:cover_image_url])
      redis.set(params[:search], @book_ids, ex: 1.week) if @book_ids.present?
    end
    render status: 200, json: {'books_data' => @books, 'book_ids' => @book_ids}
  end

  def book_delete
    @book = Book.find_by(id: params[:id])
    if @book.destroy
      @books = Book.where(id: params['book_ids']).as_json(only: [:id, :title, :author, :isbn, :description, :language], methods: [:cover_image_url])
      render status: 200, json: {'books_data' => @books, 'book_ids' => params['book_ids'] }  
    end
  end

  private
  
  def book_params
    params.require(:book).permit(:title, :author, :cover_image, :isbn, :description, :language)
  end
end
