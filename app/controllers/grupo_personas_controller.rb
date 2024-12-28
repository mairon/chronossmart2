class GrupoPersonasController < ApplicationController
  # GET /grupo_personas
  # GET /grupo_personas.json
  def index
    @grupo_personas = GrupoPersona.where(unidade_id: current_unidade.id).order('id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grupo_personas }
    end
  end

  # GET /grupo_personas/1
  # GET /grupo_personas/1.json
  def show
    @grupo_persona = GrupoPersona.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grupo_persona }
    end
  end

  # GET /grupo_personas/new
  # GET /grupo_personas/new.json
  def new
    @grupo_persona = GrupoPersona.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grupo_persona }
    end
  end

  # GET /grupo_personas/1/edit
  def edit
    @grupo_persona = GrupoPersona.find(params[:id])
  end

  # POST /grupo_personas
  # POST /grupo_personas.json
  def create
    @grupo_persona = GrupoPersona.new(params[:grupo_persona])
    @grupo_persona.unidade_id = current_unidade.id.to_i

    respond_to do |format|
      if @grupo_persona.save
        format.html { redirect_to @grupo_persona }
        format.json { render json: @grupo_persona, status: :created, location: @grupo_persona }
      else
        format.html { render action: "new" }
        format.json { render json: @grupo_persona.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /grupo_personas/1
  # PUT /grupo_personas/1.json
  def update
    @grupo_persona = GrupoPersona.find(params[:id])

    respond_to do |format|
      if @grupo_persona.update_attributes(params[:grupo_persona])
        format.html { redirect_to @grupo_persona }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @grupo_persona.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grupo_personas/1
  # DELETE /grupo_personas/1.json
  def destroy
    @grupo_persona = GrupoPersona.find(params[:id])
    @grupo_persona.destroy

    respond_to do |format|
      format.html { redirect_to grupo_personas_url }
      format.json { head :no_content }
    end
  end
end
