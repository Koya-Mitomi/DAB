class SumController < ApplicationController
  def income_sum
    if params["date(1i)"].present?
      @income_amounts = current_user.income_amounts.where(date: Time.new(params[:year], params["date(2i)"], params["date(3i)"]).all_month).order(:date)
    else
      @income_amounts = current_user.income_amounts.where(date: Time.zone.today.all_month).order(:date)
    end
  end

  def expenditure_sum
    if params["date(1i)"].present?
      @expenditure_amounts = current_user.expenditure_amounts.where(date: Time.new(params[:year], params["date(2i)"], params["date(3i)"]).all_month).order(:date)
    else
      @expenditure_amounts = current_user.expenditure_amounts.where(date: Time.zone.today.all_month).order(:date)
    end
  end

  def income_sum_year
    @income_amounts = current_user.income_amounts.where(date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_year).order(:date)
  end

  def expenditure_sum_year
    @expenditure_amounts = current_user.expenditure_amounts.where(date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_year).order(:date)
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
  end
end
