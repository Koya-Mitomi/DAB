class ExpenditureAmountsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:update, :destroy]

  def new
    @expenditure_amount = ExpenditureAmount.new
  end

  def create
    @expenditure_amount = current_user.expenditure_amounts.create(expenditure_amount_params)

    if @expenditure_amount.save
      flash[:success] = "金額を入力しました！"
      redirect_to expenditure_amount_path(@expenditure_amount.expenditure_id)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def index
    @expenditure_amounts = ExpenditureAmount.order(:date)
  end

  def edit
    @expenditure_amount = ExpenditureAmount.find(params[:id])
  end

  def update
    @expenditure_amount = ExpenditureAmount.find(params[:id])
    if @expenditure_amount.update(expenditure_amount_params)
      flash[:success] = "金額が変更されました"
      redirect_to expenditure_amount_path(@expenditure_amount.income_id)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @expenditure_amount = ExpenditureAmount.find(params[:id])
    @expenditure_amount.destroy
    flash[:success] = "金額が削除されました"
    if request.referrer.nil?
      redirect_to expenditure_amount_path(@expenditure_amount.income_id), status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def expenditure_amount_params
      params.require(:expenditure_amount).permit(:date, :amount, :expenditure_id)
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
      @expenditure_amount = current_user.expenditure_amounts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @expenditure_amount.nil?
    end

end

