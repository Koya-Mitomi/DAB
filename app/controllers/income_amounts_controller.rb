class IncomeAmountsController < ApplicationController
  include CheckUserLoginStatus
  before_action :logged_in_user
  before_action :correct_user_before_create, only: [:create, :new]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @income_amount = IncomeAmount.new
  end

  def create
    @income_amount = current_user.income_amounts.create(income_amount_params)

    if @income_amount.save
      flash[:success] = "金額を入力しました！"
      redirect_to income_path(@income_amount.income_id)
    else
      @income_id = @income_amount.income_id
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @income_amount = current_user.income_amounts.find(params[:id])
  end

  def update
    if @income_amount.update(income_amount_params)
      flash[:success] = "金額が変更されました"
      redirect_to income_path(@income_amount.income_id)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @income_amount.destroy
    if request.referrer.nil?
      flash[:success] = "金額が削除されました"
      redirect_to income_amount_path(@income_amount.income_id), status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def income_amount_params
      params.require(:income_amount).permit(:date, :amount, :income_id)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @income_amount = current_user.income_amounts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @income_amount.nil?
    end

    def correct_user_before_create
      income = current_user.incomes.find_by(id: params[:income_id])
      redirect_to root_url, status: :see_other if income.nil?
    end

end
