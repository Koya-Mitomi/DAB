class StaticPagesController < ApplicationController
  def home
    @income = current_user.incomes.build if logged_in?
  end

  def help
  end
end
