class TurmaPersonasController < ApplicationController
  # GET /turma_personas
  # GET /turma_personas.json
  def index
    @turma_personas = TurmaPersona.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @turma_personas }
    end
  end

  # GET /turma_personas/1
  # GET /turma_personas/1.json
  def show
    @turma_persona = TurmaPersona.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @turma_persona }
    end
  end

  # GET /turma_personas/new
  # GET /turma_personas/new.json
  def new
    @turma_persona = TurmaPersona.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @turma_persona }
    end
  end

  # GET /turma_personas/1/edit
  def edit
    @turma_persona = TurmaPersona.find(params[:id])
  end

  # POST /turma_personas
  # POST /turma_personas.json
  def create
    @turma_persona = TurmaPersona.new(params[:turma_persona])

    respond_to do |format|
      if @turma_persona.save
        format.html { redirect_to turma_path(@turma_persona.turma_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /turma_personas/1
  # PUT /turma_personas/1.json
  def update
    @turma_persona = TurmaPersona.find(params[:id])

    respond_to do |format|
      if @turma_persona.update_attributes(params[:turma_persona])
        format.html { redirect_to turma_path(@turma_persona.turma_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /turma_personas/1
  # DELETE /turma_personas/1.json
  def destroy
    @turma_persona = TurmaPersona.find(params[:id])
    @turma_persona.destroy

    respond_to do |format|
      format.html { redirect_to turma_path(@turma_persona.turma_id) }
    end
  end
end
