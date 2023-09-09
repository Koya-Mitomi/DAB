class ExpendituresController < ApplicationController
  include CheckUserLoginStatusHelper
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit, :destroy]

  def new
    @expenditure = Expenditure.new
  end

  def create
    @expenditure = current_user.expenditures.build(expenditure_params)
    if @expenditure.save
      flash[:success] = "支出科目を追加しました!"
      redirect_to action: :index
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    if params["date(2i)"].present?
      @expenditure_amounts = current_user.expenditure_amounts.where(date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_month, expenditure_id: params[:id]).order(:date)
    else
      @expenditure_amounts = current_user.expenditure_amounts.where(date: Time.zone.today.all_month, expenditure_id: params[:id]).order(:date)
    end
  end

  def index
    @expenditures = current_user.expenditures.order(:name)
  end

  def edit
    @expenditure = current_user.expenditures.find_by(id: params[:id])
  end

  def update
    @expenditure = current_user.expenditures.find_by(id: params[:id])
    if @expenditure.update(expenditure_params)
      flash[:success] = "収入科目名が更新されました"
      redirect_to @expenditure
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @expenditure.destroy
    flash[:success] = "収入科目が削除されました"
    if request.referrer.nil?
      redirect_to expenditures_path, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def expenditure_params
      params.require(:expenditure).permit(:name)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @expenditure = current_user.expenditures.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @expenditure.nil?
    end
end
