class CultivosController < ApplicationController
  # GET /cultivos
  # GET /cultivos.json
  def index
    @cultivos = Cultivo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cultivos }
    end
  end

  # GET /cultivos/1
  # GET /cultivos/1.json
  def show
    @cultivo = Cultivo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cultivo }
    end
  end

  # GET /cultivos/new
  # GET /cultivos/new.json
  def new
    @cultivo = Cultivo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cultivo }
    end
  end

  # GET /cultivos/1/edit
  def edit
    @cultivo = Cultivo.find(params[:id])
  end

  # POST /cultivos
  # POST /cultivos.json
  def create
    @cultivo = Cultivo.new(params[:cultivo])

    respond_to do |format|
      if @cultivo.save
        format.html { redirect_to @cultivo, notice: 'Cultivo was successfully created.' }
        format.json { render json: @cultivo, status: :created, location: @cultivo }
      else
        format.html { render action: "new" }
        format.json { render json: @cultivo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cultivos/1
  # PUT /cultivos/1.json
  def update
    @cultivo = Cultivo.find(params[:id])

    respond_to do |format|
      if @cultivo.update_attributes(params[:cultivo])
        format.html { redirect_to @cultivo, notice: 'Cultivo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cultivo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cultivos/1
  # DELETE /cultivos/1.json
  def destroy
    @cultivo = Cultivo.find(params[:id])
    @cultivo.destroy

    respond_to do |format|
      format.html { redirect_to cultivos_url }
      format.json { head :no_content }
    end
  end
end
