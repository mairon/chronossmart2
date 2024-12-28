class PersonaAtivosController < ApplicationController
  # GET /persona_ativos
  # GET /persona_ativos.json
  def index
    @persona_ativos = PersonaAtivo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_ativos }
    end
  end

  # GET /persona_ativos/1
  # GET /persona_ativos/1.json
  def show
    @persona_ativo = PersonaAtivo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_ativo }
    end
  end

  # GET /persona_ativos/new
  # GET /persona_ativos/new.json
  def new
    @persona_ativo = PersonaAtivo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_ativo }
    end
  end

  # GET /persona_ativos/1/edit
  def edit
    @persona_ativo = PersonaAtivo.find(params[:id])
  end

  # POST /persona_ativos
  # POST /persona_ativos.json
  def create
    @persona_ativo = PersonaAtivo.new(params[:persona_ativo])

    respond_to do |format|
      if @persona_ativo.save
        format.html { redirect_to decla_jurada_persona_path(@persona_ativo.persona_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /persona_ativos/1
  # PUT /persona_ativos/1.json
  def update
    @persona_ativo = PersonaAtivo.find(params[:id])

    respond_to do |format|
      if @persona_ativo.update_attributes(params[:persona_ativo])
        format.html { redirect_to decla_jurada_persona_path(@persona_ativo.persona_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /persona_ativos/1
  # DELETE /persona_ativos/1.json
  def destroy
    @persona_ativo = PersonaAtivo.find(params[:id])
    @persona_ativo.destroy

    respond_to do |format|
      format.html { redirect_to decla_jurada_persona_path(@persona_ativo.persona_id) }
      format.json { head :no_content }
    end
  end
end
