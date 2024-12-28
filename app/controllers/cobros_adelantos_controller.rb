class CobrosAdelantosController < ApplicationController
  # GET /cobros_adelantos
  # GET /cobros_adelantos.json
  def index
    @cobros_adelantos = CobrosAdelanto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cobros_adelantos }
    end
  end

  # GET /cobros_adelantos/1
  # GET /cobros_adelantos/1.json
  def show
    @cobros_adelanto = CobrosAdelanto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cobros_adelanto }
    end
  end

  # GET /cobros_adelantos/new
  # GET /cobros_adelantos/new.json
  def new
    @cobros_adelanto = CobrosAdelanto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cobros_adelanto }
    end
  end

  # GET /cobros_adelantos/1/edit
  def edit
    @cobros_adelanto = CobrosAdelanto.find(params[:id])
  end

  # POST /cobros_adelantos
  # POST /cobros_adelantos.json
  def create
    @cobros_adelanto = CobrosAdelanto.new(params[:cobros_adelanto])

    respond_to do |format|
      if @cobros_adelanto.save
        format.html { redirect_to "/cobros/#{@cobros_adelanto.cobro_id}/cobro_adelanto"}
        format.json { render json: @cobros_adelanto, status: :created, location: @cobros_adelanto }
      else
        format.html { render action: "new" }
        format.json { render json: @cobros_adelanto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cobros_adelantos/1
  # PUT /cobros_adelantos/1.json
  def update
    @cobros_adelanto = CobrosAdelanto.find(params[:id])

    respond_to do |format|
      if @cobros_adelanto.update_attributes(params[:cobros_adelanto])
        format.html { redirect_to "/cobros/#{@cobros_adelanto.cobro_id}/cobro_adelanto"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cobros_adelanto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cobros_adelantos/1
  # DELETE /cobros_adelantos/1.json
  def destroy
    @cobros_adelanto = CobrosAdelanto.find(params[:id])
    @cobros_adelanto.destroy

    respond_to do |format|
      format.html { redirect_to "/cobros/#{@cobros_adelanto.cobro_id}/cobro_adelanto"}
      format.json { head :no_content }
    end
  end
end
