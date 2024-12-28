class ModeloContratosController < ApplicationController
  # GET /modelo_contratos
  # GET /modelo_contratos.json
  def index
    @modelo_contratos = ModeloContrato.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @modelo_contratos }
    end
  end

  # GET /modelo_contratos/1
  # GET /modelo_contratos/1.json
  def show
    @modelo_contrato = ModeloContrato.find(params[:id])

    render layout: 'chart'
  end

  # GET /modelo_contratos/new
  # GET /modelo_contratos/new.json
  def new
    @modelo_contrato = ModeloContrato.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @modelo_contrato }
    end
  end

  # GET /modelo_contratos/1/edit
  def edit
    @modelo_contrato = ModeloContrato.find(params[:id])
  end

  # POST /modelo_contratos
  # POST /modelo_contratos.json
  def create
    @modelo_contrato = ModeloContrato.new(params[:modelo_contrato])

    respond_to do |format|
      if @modelo_contrato.save
        format.html { redirect_to @modelo_contrato, notice: 'Modelo contrato was successfully created.' }
        format.json { render json: @modelo_contrato, status: :created, location: @modelo_contrato }
      else
        format.html { render action: "new" }
        format.json { render json: @modelo_contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /modelo_contratos/1
  # PUT /modelo_contratos/1.json
  def update
    @modelo_contrato = ModeloContrato.find(params[:id])

    respond_to do |format|
      if @modelo_contrato.update_attributes(params[:modelo_contrato])
        format.html { redirect_to @modelo_contrato, notice: 'Modelo contrato was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @modelo_contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modelo_contratos/1
  # DELETE /modelo_contratos/1.json
  def destroy
    @modelo_contrato = ModeloContrato.find(params[:id])
    @modelo_contrato.destroy

    respond_to do |format|
      format.html { redirect_to modelo_contratos_url }
      format.json { head :no_content }
    end
  end
end
