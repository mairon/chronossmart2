class SueldoPagosController < ApplicationController
  # GET /sueldo_pagos
  # GET /sueldo_pagos.json
  def index
    @sueldo_pagos = SueldoPago.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sueldo_pagos }
    end
  end

  # GET /sueldo_pagos/1
  # GET /sueldo_pagos/1.json
  def show
    @sueldo_pago = SueldoPago.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sueldo_pago }
    end
  end

  # GET /sueldo_pagos/new
  # GET /sueldo_pagos/new.json
  def new
    @sueldo_pago = SueldoPago.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sueldo_pago }
    end
  end

  # GET /sueldo_pagos/1/edit
  def edit
    @sueldo_pago = SueldoPago.find(params[:id])
  end

  # POST /sueldo_pagos
  # POST /sueldo_pagos.json
  def create
    @sueldo_pago = SueldoPago.new(params[:sueldo_pago])

    respond_to do |format|
      if @sueldo_pago.save
        format.html { redirect_to "/sueldos/#{@sueldo_pago.sueldo_id}/financas" }
      else
        format.html { render action: "new" }
        format.json { render json: @sueldo_pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sueldo_pagos/1
  # PUT /sueldo_pagos/1.json
  def update
    @sueldo_pago = SueldoPago.find(params[:id])

    respond_to do |format|
      if @sueldo_pago.update_attributes(params[:sueldo_pago])
        format.html { redirect_to "/sueldos/#{@sueldo_pago.sueldo_id}/financas" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sueldo_pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sueldo_pagos/1
  # DELETE /sueldo_pagos/1.json
  def destroy
    @sueldo_pago = SueldoPago.find(params[:id])
    @sueldo_pago.destroy

    respond_to do |format|
      format.html { redirect_to "/sueldos/#{@sueldo_pago.sueldo_id}/financas" }
      format.json { head :no_content }
    end
  end
end
