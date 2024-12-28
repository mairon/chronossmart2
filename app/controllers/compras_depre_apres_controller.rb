class ComprasDepreApresController < ApplicationController
  # GET /compras_depre_apres
  # GET /compras_depre_apres.json
  def index
    @compras_depre_apres = ComprasDepreApre.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @compras_depre_apres }
    end
  end

  # GET /compras_depre_apres/1
  # GET /compras_depre_apres/1.json
  def show
    @compras_depre_apre = ComprasDepreApre.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @compras_depre_apre }
    end
  end

  # GET /compras_depre_apres/new
  # GET /compras_depre_apres/new.json
  def new
    @compras_depre_apre = ComprasDepreApre.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @compras_depre_apre }
    end
  end

  # GET /compras_depre_apres/1/edit
  def edit
    @compras_depre_apre = ComprasDepreApre.find(params[:id])
  end

  # POST /compras_depre_apres
  # POST /compras_depre_apres.json
  def create
    @compras_depre_apre = ComprasDepreApre.new(params[:compras_depre_apre])

    respond_to do |format|
      if @compras_depre_apre.save
        format.html { redirect_to @compras_depre_apre, notice: 'Compras depre apre was successfully created.' }
        format.json { render json: @compras_depre_apre, status: :created, location: @compras_depre_apre }
      else
        format.html { render action: "new" }
        format.json { render json: @compras_depre_apre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /compras_depre_apres/1
  # PUT /compras_depre_apres/1.json
  def update
    @compras_depre_apre = ComprasDepreApre.find(params[:id])

    respond_to do |format|
      if @compras_depre_apre.update_attributes(params[:compras_depre_apre])
        format.html { redirect_to @compras_depre_apre, notice: 'Compras depre apre was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @compras_depre_apre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compras_depre_apres/1
  # DELETE /compras_depre_apres/1.json
  def destroy
    @compras_depre_apre = ComprasDepreApre.find(params[:id])
    @compras_depre_apre.destroy

    respond_to do |format|
      format.html { redirect_to compras_depre_apres_url }
      format.json { head :no_content }
    end
  end
end
