class IncomeAmountsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:update, :destroy]

  def new
    @income_amount = IncomeAmount.new
  end

  def create
    @income_amount = current_user.income_amounts.create(income_amount_params)

    if @income_amount.save
      flash[:success] = "金額を入力しました！"
      redirect_to income_amount_path(@income_amount.income_id)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def index
    if params["date(1i)"].present?
      @income_amounts = current_user.income_amounts.where(date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_month, income_id: params[:format]).order(:date)
    else
      @income_amounts = current_user.income_amounts.where(date: Time.zone.today.all_month, income_id: params[:format]).order(:date)
    end
  end

  def edit
    @income_amount = IncomeAmount.find(params[:id])
  end

  def update
    @income_amount = IncomeAmount.find(params[:id])
    if @income_amount.update(income_amount_params)
      flash[:success] = "金額が変更されました"
      redirect_to income_amount_path(@income_amount.income_id)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @income_amount = IncomeAmount.find(params[:id])
    @income_amount.destroy
    flash[:success] = "金額が削除されました"
    if request.referrer.nil?
      redirect_to income_amount_path(@income_amount.income_id), status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def income_amount_params
      params.require(:income_amount).permit(:date, :amount, :income_id)
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
      @income_amount = current_user.income_amounts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @income_amount.nil?
    end

end
