class RomaneiosController < ApplicationController
  # GET /romaneios
  # GET /romaneios.json
  def index
    @romaneios = Romaneio.all
    
    render layout: 'chart'
  end

  # GET /romaneios/1
  # GET /romaneios/1.json
  def show
    @romaneio = Romaneio.find(params[:id])

    render layout: 'chart'
  end

  # GET /romaneios/new
  # GET /romaneios/new.json
  def new
    @romaneio = Romaneio.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @romaneio }
    end
  end

  # GET /romaneios/1/edit
  def edit
    @romaneio = Romaneio.find(params[:id])
  end

  # POST /romaneios
  # POST /romaneios.json
  def create
    @romaneio = Romaneio.new(params[:romaneio])

    respond_to do |format|
      if @romaneio.save
        format.html { redirect_to @romaneio, notice: 'Romaneio was successfully created.' }
        format.json { render json: @romaneio, status: :created, location: @romaneio }
      else
        format.html { render action: "new" }
        format.json { render json: @romaneio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /romaneios/1
  # PUT /romaneios/1.json
  def update
    @romaneio = Romaneio.find(params[:id])

    respond_to do |format|
      if @romaneio.update_attributes(params[:romaneio])
        format.html { redirect_to @romaneio, notice: 'Romaneio was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @romaneio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /romaneios/1
  # DELETE /romaneios/1.json
  def destroy
    @romaneio = Romaneio.find(params[:id])
    @romaneio.destroy

    respond_to do |format|
      format.html { redirect_to romaneios_url }
      format.json { head :no_content }
    end
  end
end
