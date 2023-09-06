class IncomesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :destroy

  def new
    @income = Income.new
  end

  def create
    @income = current_user.incomes.build(income_params)
    if @income.save
      flash[:success] = "収入科目を追加しました!"
      redirect_to income_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def index
    @incomes = current_user.incomes.order(:name)
  end

  def edit
    @income = current_user.incomes.find_by(id: params[:id])
  end

  def update
    @income = current_user.incomes.find_by(id: params[:id])
    if @income.update(income_params)
      flash[:success] = "収入科目名が更新されました"
      redirect_to @income
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @income.destroy
    if request.referrer.nil?
      flash[:success] = "収入科目が削除されました"
      redirect_to income_path, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def income_params
      params.require(:income).permit(:name)
    end

    # ログイン済みかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url, status: :see_other
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @income = current_user.incomes.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @income.nil?
    end
end
