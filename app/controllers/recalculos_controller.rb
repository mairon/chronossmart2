class RecalculosController < ApplicationController
  def index
  end

  def gera_recalc
    Recalculo.gera_recalculo_individual(params)
    redirect_to("/recalculos")
    flash[:notice] = 'Pronto!'
  end
 end
