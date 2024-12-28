class ControleKmsController < ApplicationController
  # GET /controle_kms
  # GET /controle_kms.json
  def index
    @controle_kms = ControleKm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @controle_kms }
    end
  end

  # GET /controle_kms/1
  # GET /controle_kms/1.json
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

    respond_to do |format|
      if @controle_km.save
        format.html { redirect_to @controle_km, notice: 'Controle km was successfully created.' }
        format.json { render json: @controle_km, status: :created, location: @controle_km }
      else
        format.html { render action: "new" }
        format.json { render json: @controle_km.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /controle_kms/1
  # PUT /controle_kms/1.json
  def update
    @controle_km = ControleKm.find(params[:id])

    respond_to do |format|
      if @controle_km.update_attributes(params[:controle_km])
        format.html { redirect_to @controle_km, notice: 'Controle km was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @controle_km.errors, status: :unprocessable_entity }
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
