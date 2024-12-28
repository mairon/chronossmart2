class ImportaDadosController < ApplicationController
  def index
  end

  def imp

    ImportaDados.import(params[:file])
    redirect_to farben_produtos_url, notice: "Products imported."
  end
end
