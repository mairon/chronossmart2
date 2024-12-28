class PresupuestoCotasController < ApplicationController
  # GET /presupuesto_cotas
  # GET /presupuesto_cotas.json
  def index
    @presupuesto_cotas = PresupuestoCota.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @presupuesto_cotas }
    end
  end

  # GET /presupuesto_cotas/1
  # GET /presupuesto_cotas/1.json
  def show
    @presupuesto_cota = PresupuestoCota.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @presupuesto_cota }
    end
  end

  # GET /presupuesto_cotas/new
  # GET /presupuesto_cotas/new.json
  def new
    @presupuesto_cota = PresupuestoCota.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @presupuesto_cota }
    end
  end

  # GET /presupuesto_cotas/1/edit
  def edit
    @presupuesto_cota = PresupuestoCota.find(params[:id])
  end

  # POST /presupuesto_cotas
  # POST /presupuesto_cotas.json
  def create
    @presupuesto_cota = PresupuestoCota.new(params[:presupuesto_cota])

    respond_to do |format|
      if @presupuesto_cota.save
        format.html { redirect_to presupuesto_path(@presupuesto_cota.presupuesto_id)}
      else
      end
    end
  end

  # PUT /presupuesto_cotas/1
  # PUT /presupuesto_cotas/1.json
  def update
    @presupuesto_cota = PresupuestoCota.find(params[:id])

    respond_to do |format|
      if @presupuesto_cota.update_attributes(params[:presupuesto_cota])
        format.html { redirect_to presupuesto_path(@presupuesto_cota.presupuesto_id)}
        
      else
        format.html { render action: "edit" }
        format.json { render json: @presupuesto_cota.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /presupuesto_cotas/1
  # DELETE /presupuesto_cotas/1.json
  def destroy
    @presupuesto_cota = PresupuestoCota.find(params[:id])
    @presupuesto_cota.destroy

    respond_to do |format|
      format.html { redirect_to presupuesto_path(@presupuesto_cota.presupuesto_id)}
      format.json { head :no_content }
    end
  end
end
