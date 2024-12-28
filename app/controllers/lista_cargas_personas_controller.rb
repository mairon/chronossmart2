class ListaCargasPersonasController < ApplicationController
  # GET /lista_cargas_personas
  # GET /lista_cargas_personas.json
  def index
    @lista_cargas_personas = ListaCargasPersona.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lista_cargas_personas }
    end
  end

  # GET /lista_cargas_personas/1
  # GET /lista_cargas_personas/1.json
  def show
    @lista_cargas_persona = ListaCargasPersona.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lista_cargas_persona }
    end
  end

  # GET /lista_cargas_personas/new
  # GET /lista_cargas_personas/new.json
  def new
    @lista_cargas_persona = ListaCargasPersona.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lista_cargas_persona }
    end
  end

  # GET /lista_cargas_personas/1/edit
  def edit
    @lista_cargas_persona = ListaCargasPersona.find(params[:id])
  end

  # POST /lista_cargas_personas
  # POST /lista_cargas_personas.json
  def create
    @lista_cargas_persona = ListaCargasPersona.new(params[:lista_cargas_persona])

    respond_to do |format|
      if @lista_cargas_persona.save
        format.html { redirect_to @lista_cargas_persona, notice: 'Lista cargas persona was successfully created.' }
        format.json { render json: @lista_cargas_persona, status: :created, location: @lista_cargas_persona }
      else
        format.html { render action: "new" }
        format.json { render json: @lista_cargas_persona.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lista_cargas_personas/1
  # PUT /lista_cargas_personas/1.json
  def update
    @lista_cargas_persona = ListaCargasPersona.find(params[:id])

    respond_to do |format|
      if @lista_cargas_persona.update_attributes(params[:lista_cargas_persona])
        format.html { redirect_to @lista_cargas_persona, notice: 'Lista cargas persona was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lista_cargas_persona.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lista_cargas_personas/1
  # DELETE /lista_cargas_personas/1.json
  def destroy
    @lista_cargas_persona = ListaCargasPersona.find(params[:id])
    @lista_cargas_persona.destroy

    respond_to do |format|
      format.html { redirect_to lista_cargas_personas_url }
      format.json { head :no_content }
    end
  end
end
