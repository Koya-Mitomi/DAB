class IncomesController < ApplicationController
  include CheckUserLoginStatusHelper
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit, :destroy]

  def new
    @income = Income.new
  end

  def create
    @income = current_user.incomes.build(income_params)
    if @income.save
      flash[:success] = "収入科目を追加しました!"
      redirect_to action: :index
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    if params["date(2i)"].present?
      @income_amounts = current_user.income_amounts.where(date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_month, income_id: params[:id]).order(:date)
    else
      @income_amounts = current_user.income_amounts.where(date: Time.zone.today.all_month, income_id: params[:id]).order(:date)
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
    flash[:success] = "収入科目が削除されました"
    if request.referrer.nil?
      redirect_to incomes_path, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def income_params
      params.require(:income).permit(:name)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @income = current_user.incomes.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @income.nil?
    end
end
