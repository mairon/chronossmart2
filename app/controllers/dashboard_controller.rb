class DashboardController < ApplicationController
  def index
  end


  def faturamento

    render layout: 'chart'
  end


end
