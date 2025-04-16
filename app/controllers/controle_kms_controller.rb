class ControleKmsController < ApplicationController
  def index
    @controle_km = ControleKm.new
    render layout: 'chart'
  end

  def busca
    params[:unidade] = current_unidade.id
    @controle_kms = ControleKm.filtro_busca(params)
    render :layout => false
  end

  def show
    @controle_km = ControleKm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @controle_km }
    end
  end

  # GET /controle_kms/new
  # GET /controle_kms/new.json
  def new
    @controle_km = ControleKm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @controle_km }
    end
  end

  # GET /controle_kms/1/edit
  def edit
    @controle_km = ControleKm.find(params[:id])
  end

  # POST /controle_kms
  # POST /controle_kms.json
  def create
    @controle_km = ControleKm.new(params[:controle_km])
    @controle_km.unidade_id = current_unidade.id

    respond_to do |format|
      if @controle_km.save
        format.html { redirect_to controle_kms_url }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /controle_kms/1
  # PUT /controle_kms/1.json
  def update
    @controle_km = ControleKm.find(params[:id])

    respond_to do |format|
      if @controle_km.update_attributes(params[:controle_km])
        format.html { redirect_to controle_kms_url }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /controle_kms/1
  # DELETE /controle_kms/1.json
  def destroy
    @controle_km = ControleKm.find(params[:id])
    @controle_km.destroy

    respond_to do |format|
      format.html { redirect_to controle_kms_url }
      format.json { head :no_content }
    end
  end
end
