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

      @income_result_months = current_user.income_amounts.where(date: Time.zone.now.all_year).group_by_month(:date).sum(:amount).transform_keys do |key|
        key.strftime("%Y%m").to_s
      end
      @expenditure_result_months = current_user.expenditure_amounts.where(date: Time.zone.now.all_year).group_by_month(:date).sum(:amount).transform_keys do |key|
        key.strftime("%Y%m").to_s
      end
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

      @income_result_months = current_user.income_amounts.where(date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_year).group_by_month(:date).sum(:amount).transform_keys do |key|
        key.strftime("%Y%m").to_s
      end
      @expenditure_result_months = current_user.expenditure_amounts.where(date: Time.new(params["date(1i)"], params["date(2i)"], params["date(3i)"]).all_year).group_by_month(:date).sum(:amount).transform_keys do |key|
        key.strftime("%Y%m").to_s
      end
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

      @income_result_months = current_user.income_amounts.where(date: Time.zone.now.all_year).group_by_month(:date).sum(:amount).transform_keys do |key|
        key.strftime("%Y%m").to_s
      end
      @expenditure_result_months = current_user.expenditure_amounts.where(date: Time.zone.now.all_year).group_by_month(:date).sum(:amount).transform_keys do |key|
        key.strftime("%Y%m").to_s
      end
    end

    @income_result_years = current_user.income_amounts.group_by_year(:date).sum(:amount).transform_keys do |key|
      key.year.to_s
    end
    @expenditure_result_years = current_user.expenditure_amounts.group_by_year(:date).sum(:amount).transform_keys do |key|
      key.year.to_s
    end

    if @income_result_years.present? && @expenditure_result_years.present?
      if @income_result_years.first.first.to_i <= @expenditure_result_years.first.first.to_i
        @in_and_ex_data_years = @income_result_years.map { |year, result| [year, @income_result_years[year].to_i - @expenditure_result_years[year].to_i] }

        if @income_result_years.keys.last.to_i < @expenditure_result_years.keys.last.to_i
          for i in (@income_result_years.keys.last.to_i+1)..@expenditure_result_years.keys.last.to_i
            @in_and_ex_data_years.push([i, -@expenditure_result_years[i.to_s].to_i])
          end
        end

      else
        @in_and_ex_data_years = @expenditure_result_years.map { |year, result| [year, @income_result_years[year].to_i - @expenditure_result_years[year].to_i] }

        if @income_result_years.keys.last.to_i > @expenditure_result_years.keys.last.to_i
          for i in (@expenditure_result_years.keys.last.to_i+1)..@income_result_years.keys.last.to_i
            @in_and_ex_data_years.push([i, -@income_result_years[i.to_s].to_i])
          end
        end
      end
    elsif @income_result_years.present?
      @in_and_ex_data_years = @income_result_years.map { |year, result| [year, @income_result_years[year].to_i] }
    else
      @in_and_ex_data_years = @expenditure_result_years.map { |year, result| [year, -@expenditure_result_years[year].to_i] }
    end

    if @income_result_months.present? && @expenditure_result_months.present?
      if @income_result_months.first.first.to_i <= @expenditure_result_months.first.first.to_i
        @in_and_ex_data_months = @income_result_months.map { |month, result| [month, @income_result_months[month].to_i - @expenditure_result_months[month].to_i] }

        if @income_result_months.keys.last.to_i < @expenditure_result_months.keys.last.to_i
          for i in (@income_result_months.keys.last.to_i+1)..@expenditure_result_months.keys.last.to_i
            @in_and_ex_data_months.push([i, -@expenditure_result_months[i.to_s].to_i])
          end
        end

      else
        @in_and_ex_data_months = @expenditure_result_months.map { |month, result| [month, @income_result_months[month].to_i - @expenditure_result_months[month].to_i] }

        if @income_result_months.keys.last.to_i > @expenditure_result_months.keys.last.to_i
          for i in (@expenditure_result_months.keys.last.to_i+1)..@income_result_months.keys.last.to_i
            @in_and_ex_data_months.push([i, @income_result_months[i.to_s].to_i])
          end
        end
      end
    elsif @income_result_months.present?
      @in_and_ex_data_months = @income_result_months.map { |month, result| [month, @income_result_months[month].to_i] }
    else
      @in_and_ex_data_months = @expenditure_result_months.map { |month, result| [month, -@expenditure_result_months[month].to_i] }
    end
  end
end
