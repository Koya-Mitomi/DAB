class SumController < ApplicationController
  def income_sum
    if params["date(1i)"].present?
      @income_amounts = current_user.income_amounts.where(date: Time.new(params[:year], params["date(2i)"], params["date(3i)"]).all_month).order(:date)
    else
      @income_amounts = current_user.income_amounts.where(date: Time.zone.today.all_month).order(:date)
    end
    @income_by_name = @income_amounts.group(:income_id).sum(:amount)
    @income_data = @income_by_name.map { |income_id, total| [current_user.incomes.find(income_id).name, total] }
  end

  def expenditure_sum
    if params["date(1i)"].present?
      @expenditure_amounts = current_user.expenditure_amounts.where(date: Time.new(params[:year], params["date(2i)"], params["date(3i)"]).all_month).order(:date)
    else
      @expenditure_amounts = current_user.expenditure_amounts.where(date: Time.zone.today.all_month).order(:date)
    end
    @expenditure_by_name = @expenditure_amounts.group(:expenditure_id).sum(:amount)
    @expenditure_data = @expenditure_by_name.map { |expenditure_id, total| [current_user.expenditures.find(expenditure_id).name, total] }
  end

  def income_sum_year
    @income_amounts = current_user.income_amounts.where(date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_year).order(:date)
    @income_by_name = @income_amounts.group(:income_id).sum(:amount)
    @income_data = @income_by_name.map { |income_id, total| [current_user.incomes.find(income_id).name, total] }
  end

  def expenditure_sum_year
    @expenditure_amounts = current_user.expenditure_amounts.where(date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_year).order(:date)
    @expenditure_by_name = @expenditure_amounts.group(:expenditure_id).sum(:amount)
    @expenditure_data = @expenditure_by_name.map { |expenditure_id, total| [current_user.expenditures.find(expenditure_id).name, total] }
  end

  def check
    if params[:year].present?
      @income_amounts = current_user.income_amounts.where(
        date: Time.new(params[:year], 1, 1).all_year
      )
      @pre_i = current_user.income_amounts.where(
        date: Time.new(params[:year], 1, 1).years_ago(1).all_year
      ).sum(:amount)
      @expenditure_amounts = current_user.expenditure_amounts.where(
        date: Time.new(params[:year], 1, 1).all_year
      )
      @pre_e = current_user.expenditure_amounts.where(
        date: Time.new(params[:year], 1, 1).years_ago(1).all_year
      ).sum(:amount)
    elsif params["date(1i)"].present?
      @income_amounts = current_user.income_amounts.where(
        date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_month
      )
      @pre_i = current_user.income_amounts.where(
        date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).months_ago(1).all_month
      ).sum(:amount)
      @expenditure_amounts = current_user.expenditure_amounts.where(
        date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_month
      )
      @pre_e = current_user.expenditure_amounts.where(
        date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).months_ago(1).all_month
      ).sum(:amount)
    else
      @income_amounts = current_user.income_amounts.where(
        date: Time.zone.today.all_month
      )
      @pre_i = current_user.income_amounts.where(
        date: Time.zone.today.months_ago(1).all_month
      ).sum(:amount)
      @expenditure_amounts = current_user.expenditure_amounts.where(
        date: Time.zone.today.all_month
      )
      @pre_e = current_user.expenditure_amounts.where(
        date: Time.zone.today.months_ago(1).all_month
      ).sum(:amount)
    end

    # @income_result_years = current_user.income_amounts.group("strftime('%Y', date)").sum(:amount)
    # @expenditure_result_years = current_user.expenditure_amounts.group("strftime('%Y', date)").sum(:amount)

  end
end
