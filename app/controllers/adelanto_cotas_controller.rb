class AdelantoCotasController < ApplicationController
  # GET /adelanto_cotas
  # GET /adelanto_cotas.json

  def update_individual
       AdelantoCota.update(params[:adelanto_cotas].keys, params[:adelanto_cotas].values)
        flash[:notice] = "Products updated"
        redirect_to adelanto_path(params[:id])
  end

  def index
    @adelanto_cotas = AdelantoCota.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @adelanto_cotas }
    end
  end

  # GET /adelanto_cotas/1
  # GET /adelanto_cotas/1.json
  def show
    @adelanto_cota = AdelantoCota.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @adelanto_cota }
    end
  end

  # GET /adelanto_cotas/new
  # GET /adelanto_cotas/new.json
  def new
    @adelanto_cota = AdelantoCota.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @adelanto_cota }
    end
  end

  # GET /adelanto_cotas/1/edit
  def edit
    @adelanto_cota = AdelantoCota.find(params[:id])
  end

  # POST /adelanto_cotas
  # POST /adelanto_cotas.json
  def create
    @adelanto_cota = AdelantoCota.new(params[:adelanto_cota])

    respond_to do |format|
      if @adelanto_cota.save
        format.html { redirect_to "/adelantos/#{@adelanto_cota.adelanto_id}" }
        format.json { render json: @adelanto_cota, status: :created, location: @adelanto_cota }
      else
        format.html { render action: "new" }
        format.json { render json: @adelanto_cota.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adelanto_cotas/1
  # PUT /adelanto_cotas/1.json
  def update
    @adelanto_cota = AdelantoCota.find(params[:id])

    respond_to do |format|
      if @adelanto_cota.update_attributes(params[:adelanto_cota])
        format.html { redirect_to "/adelantos/#{@adelanto_cota.adelanto_id}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @adelanto_cota.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adelanto_cotas/1
  # DELETE /adelanto_cotas/1.json
  def destroy
    @adelanto_cota = AdelantoCota.find(params[:id])
    @adelanto_cota.destroy

    respond_to do |format|
      format.html { redirect_to "/adelantos/#{@adelanto_cota.adelanto_id}" }
      format.json { head :no_content }
    end
  end
end
