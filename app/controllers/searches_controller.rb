class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
      render 'index'
    else
      @books = Book.looks(params[:search], params[:word])
      render 'index'
    end
  end




end