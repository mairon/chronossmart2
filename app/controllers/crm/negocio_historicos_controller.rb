class NegocioHistoricosController < ApplicationController
  # GET /negocio_historicos
  # GET /negocio_historicos.json
  def index
    @negocio_historicos = NegocioHistorico.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @negocio_historicos }
    end
  end

  # GET /negocio_historicos/1
  # GET /negocio_historicos/1.json
  def show
    @negocio_historico = NegocioHistorico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @negocio_historico }
    end
  end

  # GET /negocio_historicos/new
  # GET /negocio_historicos/new.json
  def new
    @negocio_historico = NegocioHistorico.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @negocio_historico }
    end
  end

  # GET /negocio_historicos/1/edit
  def edit
    @negocio_historico = NegocioHistorico.find(params[:id])
  end

  # POST /negocio_historicos
  # POST /negocio_historicos.json
  def create
    @negocio_historico = NegocioHistorico.new(params[:negocio_historico])

    respond_to do |format|
      if @negocio_historico.save
        format.html { redirect_to @negocio_historico, notice: 'Negocio historico was successfully created.' }
        format.json { render json: @negocio_historico, status: :created, location: @negocio_historico }
      else
        format.html { render action: "new" }
        format.json { render json: @negocio_historico.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /negocio_historicos/1
  # PUT /negocio_historicos/1.json
  def update
    @negocio_historico = NegocioHistorico.find(params[:id])

    respond_to do |format|
      if @negocio_historico.update_attributes(params[:negocio_historico])
        format.html { redirect_to @negocio_historico, notice: 'Negocio historico was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @negocio_historico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /negocio_historicos/1
  # DELETE /negocio_historicos/1.json
  def destroy
    @negocio_historico = NegocioHistorico.find(params[:id])
    @negocio_historico.destroy

    respond_to do |format|
      format.html { redirect_to negocio_historicos_url }
      format.json { head :no_content }
    end
  end
end
