class SolicitudeCreditoAutorizacoesController < ApplicationController
  # GET /solicitude_credito_autorizacoes
  # GET /solicitude_credito_autorizacoes.json
  def index
    @solicitude_credito_autorizacoes = SolicitudeCreditoAutorizacao.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @solicitude_credito_autorizacoes }
    end
  end

  # GET /solicitude_credito_autorizacoes/1
  # GET /solicitude_credito_autorizacoes/1.json
  def show
    @solicitude_credito_autorizacao = SolicitudeCreditoAutorizacao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @solicitude_credito_autorizacao }
    end
  end

  # GET /solicitude_credito_autorizacoes/new
  # GET /solicitude_credito_autorizacoes/new.json
  def new
    @solicitude_credito_autorizacao = SolicitudeCreditoAutorizacao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @solicitude_credito_autorizacao }
    end
  end

  # GET /solicitude_credito_autorizacoes/1/edit
  def edit
    @solicitude_credito_autorizacao = SolicitudeCreditoAutorizacao.find(params[:id])
  end

  # POST /solicitude_credito_autorizacoes
  # POST /solicitude_credito_autorizacoes.json
  def create
    @solicitude_credito_autorizacao = SolicitudeCreditoAutorizacao.new(params[:solicitude_credito_autorizacao])

    respond_to do |format|
      if @solicitude_credito_autorizacao.save
        format.html { redirect_to solicitude_credito_path(@solicitude_credito_autorizacao.solicitude_credito_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /solicitude_credito_autorizacoes/1
  # PUT /solicitude_credito_autorizacoes/1.json
  def update
    @solicitude_credito_autorizacao = SolicitudeCreditoAutorizacao.find(params[:id])

    respond_to do |format|
      if @solicitude_credito_autorizacao.update_attributes(params[:solicitude_credito_autorizacao])
        format.html { redirect_to solicitude_credito_path(@solicitude_credito_autorizacao.solicitude_credito_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /solicitude_credito_autorizacoes/1
  # DELETE /solicitude_credito_autorizacoes/1.json
  def destroy
    @solicitude_credito_autorizacao = SolicitudeCreditoAutorizacao.find(params[:id])
    @solicitude_credito_autorizacao.destroy

    respond_to do |format|
      format.html { redirect_to solicitude_credito_path(@solicitude_credito_autorizacao.solicitude_credito_id) }
    end
  end
end
