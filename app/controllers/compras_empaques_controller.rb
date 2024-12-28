class ComprasEmpaquesController < ApplicationController
  # GET /compras_empaques
  # GET /compras_empaques.json
  def index
    @compras_empaques = ComprasEmpaque.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @compras_empaques }
    end
  end

  # GET /compras_empaques/1
  # GET /compras_empaques/1.json
  def show
    @compras_empaque = ComprasEmpaque.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @compras_empaque }
    end
  end

  # GET /compras_empaques/new
  # GET /compras_empaques/new.json
  def new
    @compras_empaque = ComprasEmpaque.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @compras_empaque }
    end
  end

  # GET /compras_empaques/1/edit
  def edit
    @compras_empaque = ComprasEmpaque.find(params[:id])
  end

  # POST /compras_empaques
  # POST /compras_empaques.json
  def create
    @compras_empaque = ComprasEmpaque.new(params[:compras_empaque])

    respond_to do |format|
      if @compras_empaque.save
        format.html { redirect_to "/compras/#{@compras_empaque.compra_id}/empaque" }
      else
        format.html { render action: "new" }
        format.json { render json: @compras_empaque.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /compras_empaques/1
  # PUT /compras_empaques/1.json
  def update
    @compras_empaque = ComprasEmpaque.find(params[:id])

    respond_to do |format|
      if @compras_empaque.update_attributes(params[:compras_empaque])
        format.html { redirect_to "/compras/#{@compras_empaque.compra_id}/empaque" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @compras_empaque.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compras_empaques/1
  # DELETE /compras_empaques/1.json
  def destroy
    @compras_empaque = ComprasEmpaque.find(params[:id])
    @compras_empaque.destroy

    respond_to do |format|
      format.html { redirect_to "/compras/#{@compras_empaque.compra_id}/empaque" }
      format.json { head :no_content }
    end
  end
end
