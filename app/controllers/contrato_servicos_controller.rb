class ContratoServicosController < ApplicationController
  before_filter :authenticate


  def index
    @contrato_servicos = ContratoServico.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contrato_servicos }
    end
  end


  def show
    @contrato_servico = ContratoServico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contrato_servico }
    end
  end


  def new
    @contrato_servico = ContratoServico.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contrato_servico }
    end
  end


  def edit
    @contrato_servico = ContratoServico.find(params[:id])
  end


  def create
    @contrato_servico = ContratoServico.new(params[:contrato_servico])

    respond_to do |format|
      if @contrato_servico.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to contrato_path(@contrato_servico.contrato_id) }
      else
        format.html { render action: "new" }
      end
    end
  end


  def update
    @contrato_servico = ContratoServico.find(params[:id])

    respond_to do |format|
      if @contrato_servico.update_attributes(params[:contrato_servico])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to contrato_path(@contrato_servico.contrato_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end


  def destroy
    @contrato_servico = ContratoServico.find(params[:id])
    @contrato_servico.destroy

    respond_to do |format|
      format.html { redirect_to contrato_path(@contrato_servico.contrato_id) }
    end
  end
end
