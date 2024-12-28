class UnidadeMedidasController < ApplicationController
  # GET /unidade_medidas
  # GET /unidade_medidas.json
  def index
    @unidade_medidas = UnidadeMedida.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @unidade_medidas }
    end
  end

  # GET /unidade_medidas/1
  # GET /unidade_medidas/1.json
  def show
    @unidade_medida = UnidadeMedida.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @unidade_medida }
    end
  end

  # GET /unidade_medidas/new
  # GET /unidade_medidas/new.json
  def new
    @unidade_medida = UnidadeMedida.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @unidade_medida }
    end
  end

  # GET /unidade_medidas/1/edit
  def edit
    @unidade_medida = UnidadeMedida.find(params[:id])
  end

  # POST /unidade_medidas
  # POST /unidade_medidas.json
  def create
    @unidade_medida = UnidadeMedida.new(params[:unidade_medida])

    respond_to do |format|
      if @unidade_medida.save
        format.html { redirect_to unidade_medidas_url }
        format.json { render json: @unidade_medida, status: :created, location: @unidade_medida }
      else
        format.html { render action: "new" }
        format.json { render json: @unidade_medida.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /unidade_medidas/1
  # PUT /unidade_medidas/1.json
  def update
    @unidade_medida = UnidadeMedida.find(params[:id])

    respond_to do |format|
      if @unidade_medida.update_attributes(params[:unidade_medida])
        format.html { redirect_to unidade_medidas_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @unidade_medida.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unidade_medidas/1
  # DELETE /unidade_medidas/1.json
  def destroy
    @unidade_medida = UnidadeMedida.find(params[:id])
    @unidade_medida.destroy

    respond_to do |format|
      format.html { redirect_to unidade_medidas_url }
      format.json { head :no_content }
    end
  end
end
