class FormaPagosController < ApplicationController
  # GET /forma_pagos
  # GET /forma_pagos.json
  def index
    @forma_pagos = FormaPago.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @forma_pagos }
    end
  end

  # GET /forma_pagos/1
  # GET /forma_pagos/1.json
  def show
    @forma_pago = FormaPago.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @forma_pago }
    end
  end

  # GET /forma_pagos/new
  # GET /forma_pagos/new.json
  def new
    @forma_pago = FormaPago.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forma_pago }
    end
  end

  # GET /forma_pagos/1/edit
  def edit
    @forma_pago = FormaPago.find(params[:id])
  end

  # POST /forma_pagos
  # POST /forma_pagos.json
  def create
    @forma_pago = FormaPago.new(params[:forma_pago])

    respond_to do |format|
      if @forma_pago.save
        format.html { redirect_to forma_pagos_url }
        format.json { render json: @forma_pago, status: :created, location: @forma_pago }
      else
        format.html { render action: "new" }
        format.json { render json: @forma_pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forma_pagos/1
  # PUT /forma_pagos/1.json
  def update
    @forma_pago = FormaPago.find(params[:id])

    respond_to do |format|
      if @forma_pago.update_attributes(params[:forma_pago])
        format.html { redirect_to forma_pagos_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @forma_pago.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forma_pagos/1
  # DELETE /forma_pagos/1.json
  def destroy
    @forma_pago = FormaPago.find(params[:id])
    @forma_pago.destroy

    respond_to do |format|
      format.html { redirect_to forma_pagos_url }
      format.json { head :no_content }
    end
  end
end
