class ExpenditureAmountsController < ApplicationController

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
      redirect_to expenditure_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @expenditure_amount = ExpenditureAmount.find(params[:id])
    @expenditure_amount.destroy
    flash[:success] = "金額が削除されました"
    if request.referrer.nil?
      redirect_to expenditure_amount_path, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def expenditure_amount_params
      params.require(:expenditure_amount).permit(:date, :amount, :expenditure_id)
    end

end

