class ContratoFinancasController < ApplicationController
  before_filter :authenticate

  def index
    @contrato_financas = ContratoFinanca.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def show
    @contrato_financa = ContratoFinanca.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  def new
    @contrato_financa = ContratoFinanca.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end


  def edit
    @contrato_financa = ContratoFinanca.find(params[:id])
  end

  def create
    @contrato_financa = ContratoFinanca.new(params[:contrato_financa])

    respond_to do |format|
      if @contrato_financa.save
        flash[:notice] = "Contrato gerado com sucesso!"
        format.html { redirect_to financas_contrato_path }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @contrato_financa = ContratoFinanca.find(params[:id])

    respond_to do |format|
      if @contrato_financa.update_attributes(params[:contrato_financa])
        format.html { redirect_to @contrato_financa, notice: 'Contrato financa was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end



  def destroy
     ContratoFinanca.where(contrato_id: params[:id]).destroy_all

     respond_to do |format|
        flash[:notice] = "Removido"
        format.html { redirect_to contrato_financas_url }
     end
  end

end
