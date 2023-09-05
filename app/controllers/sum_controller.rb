class SumController < ApplicationController
  def income_sum
    if params["date(1i)"].present?
      @income_amounts = current_user.income_amounts.where(date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_month).order(:date)
    else
      @income_amounts = current_user.income_amounts.where(date: Time.zone.today.all_month).order(:date)
    end
  end

  def expenditure_sum
    if params["date(1i)"].present?
      @expenditure_amounts = current_user.expenditure_amounts.where(date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_month).order(:date)
    else
      @expenditure_amounts = current_user.expenditure_amounts.where(date: Time.zone.today.all_month).order(:date)
    end
  end

  def check
  end
end
