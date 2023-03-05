class BooksController < ApplicationController
before_action :is_matching_login_user, only: [:edit, :update]
  def show
    @book = Book.find(params[:id])
    @books = Book.new
    @book_comment = BookComment.new

    @book_detail = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_count.create(book_id: @book_detail.id)
    end
  end

  def index
    #Time.current はconfig/application.rbに設定してあるタイムゾーンを元に現在日時を取得しています。
     #at_end_of_day は1日の終わりを23:59に設定しています。
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    #at_beginning_of_day　は1日の始まりの時刻を0:00に設定しています。
    @books = Book.includes(:favorited_users).
    #sort_byメソッドを使っていいね数を少ない順に取り出しています。
    #ブロック変数 |x| を定義してあげないと、2よりも10,11の方が小さいと判定されてしまうのでこのように対処するそうです。
    #ただ、このままだと少ない順に表示されてしまうので最後にreverseをつけてあげましょう。
    #これで昇順、降順を入れ替えることができます。
    sort_by {|x| x.favorited_users.includes(:favorites).where(created_at:from...to).size}.reverse
    @book = Book.new

   

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    user_id = params[:id].to_i
    unless book.user_id == current_user.id
      redirect_to books_path
    end
  end

end
