class IncomeAmountsController < ApplicationController

  def new
    @income_amount = IncomeAmount.new
  end

  def create
    @income_amount = IncomeAmount.create(income_amount_params)

    if @income_amount.save
      flash[:success] = "金額を入力しました！"
      redirect_to income_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def index
    @income_amounts = IncomeAmount.order(:date)
  end

  def edit
    @income_amount = IncomeAmount.find(params[:id])
  end

  def update
    @income_amount = IncomeAmount.find(params[:id])
    if @income_amount.update(income_amount_params)
      flash[:success] = "金額が変更されました"
      redirect_to income_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @income_amount = IncomeAmount.find(params[:id])
    @income_amount.destroy
    flash[:success] = "金額が削除されました"
    if request.referrer.nil?
      redirect_to income_amount_path, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def income_amount_params
      params.require(:income_amount).permit(:date, :amount, :income_id)
    end

end
