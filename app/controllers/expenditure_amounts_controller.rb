class ExpenditureAmountsController < ApplicationController
  include CheckUserLoginStatus
  before_action :logged_in_user
  before_action :correct_user_before_create, only: [:create, :new]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @expenditure_amount = ExpenditureAmount.new
  end

  def create
    @expenditure_amount = current_user.expenditure_amounts.create(expenditure_amount_params)

    if @expenditure_amount.save
      flash[:success] = "金額を入力しました！"
      redirect_to expenditure_path(@expenditure_amount.expenditure_id)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @expenditure_amount = current_user.expenditure_amounts.find(params[:id])
  end

  def update
    if @expenditure_amount.update(expenditure_amount_params)
      flash[:success] = "金額が変更されました"
      redirect_to expenditure_path(@expenditure_amount.expenditure_id)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @expenditure_amount.destroy
    flash[:success] = "金額が削除されました"
    if request.referrer.nil?
      redirect_to expenditure_path(@expenditure_amount.expenditure_id), status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def expenditure_amount_params
      params.require(:expenditure_amount).permit(:date, :amount, :expenditure_id)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @expenditure_amount = current_user.expenditure_amounts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @expenditure_amount.nil?
    end

    def correct_user_before_create
      expenditure = current_user.expenditures.find_by(id: params[:expenditure_id])
      redirect_to root_url, status: :see_other if expenditure.nil?
    end

end

