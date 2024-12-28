class CobrosRecibosController < ApplicationController
  # GET /cobros_recibos
  # GET /cobros_recibos.json
  def index
    @cobros_recibos = CobrosRecibo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cobros_recibos }
    end
  end

  # GET /cobros_recibos/1
  # GET /cobros_recibos/1.json
  def show
    @cobros_recibo = CobrosRecibo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cobros_recibo }
    end
  end

  # GET /cobros_recibos/new
  # GET /cobros_recibos/new.json
  def new
    @cobros_recibo = CobrosRecibo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cobros_recibo }
    end
  end

  # GET /cobros_recibos/1/edit
  def edit
    @cobros_recibo = CobrosRecibo.find(params[:id])
  end

  # POST /cobros_recibos
  # POST /cobros_recibos.json
  def create
    @cobros_recibo = CobrosRecibo.new(params[:cobros_recibo])

    respond_to do |format|
      if @cobros_recibo.save
        format.html { redirect_to @cobros_recibo, notice: 'Cobros recibo was successfully created.' }
        format.json { render json: @cobros_recibo, status: :created, location: @cobros_recibo }
      else
        format.html { render action: "new" }
        format.json { render json: @cobros_recibo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cobros_recibos/1
  # PUT /cobros_recibos/1.json
  def update
    @cobros_recibo = CobrosRecibo.find(params[:id])

    respond_to do |format|
      if @cobros_recibo.update_attributes(params[:cobros_recibo])
        format.html { redirect_to @cobros_recibo, notice: 'Cobros recibo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cobros_recibo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cobros_recibos/1
  # DELETE /cobros_recibos/1.json
  def destroy
    @cobros_recibo = CobrosRecibo.find(params[:id])
    @cobros_recibo.destroy

    respond_to do |format|
      format.html { redirect_to cobros_recibos_url }
      format.json { head :no_content }
    end
  end
end
