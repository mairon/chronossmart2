class FormaPagosPersonasController < ApplicationController
  # GET /forma_pagos_personas
  # GET /forma_pagos_personas.json
  def index
    @forma_pagos_personas = FormaPagosPersona.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @forma_pagos_personas }
    end
  end

  # GET /forma_pagos_personas/1
  # GET /forma_pagos_personas/1.json
  def show
    @forma_pagos_persona = FormaPagosPersona.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @forma_pagos_persona }
    end
  end

  # GET /forma_pagos_personas/new
  # GET /forma_pagos_personas/new.json
  def new
    @forma_pagos_persona = FormaPagosPersona.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forma_pagos_persona }
    end
  end

  # GET /forma_pagos_personas/1/edit
  def edit
    @forma_pagos_persona = FormaPagosPersona.find(params[:id])
  end

  # POST /forma_pagos_personas
  # POST /forma_pagos_personas.json
  def create
    @forma_pagos_persona = FormaPagosPersona.new(params[:forma_pagos_persona])

    respond_to do |format|
      if @forma_pagos_persona.save
        format.html { redirect_to @forma_pagos_persona, notice: 'Forma pagos persona was successfully created.' }
        format.json { render json: @forma_pagos_persona, status: :created, location: @forma_pagos_persona }
      else
        format.html { render action: "new" }
        format.json { render json: @forma_pagos_persona.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forma_pagos_personas/1
  # PUT /forma_pagos_personas/1.json
  def update
    @forma_pagos_persona = FormaPagosPersona.find(params[:id])

    respond_to do |format|
      if @forma_pagos_persona.update_attributes(params[:forma_pagos_persona])
        format.html { redirect_to @forma_pagos_persona, notice: 'Forma pagos persona was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @forma_pagos_persona.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forma_pagos_personas/1
  # DELETE /forma_pagos_personas/1.json
  def destroy
    @forma_pagos_persona = FormaPagosPersona.find(params[:id])
    @forma_pagos_persona.destroy

    respond_to do |format|
      format.html { redirect_to forma_pagos_personas_url }
      format.json { head :no_content }
    end
  end
end
