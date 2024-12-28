class PersonaAcoesController < ApplicationController
  # GET /persona_acoes
  # GET /persona_acoes.json
  def index
    @persona_acoes = PersonaAcao.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_acoes }
    end
  end

  # GET /persona_acoes/1
  # GET /persona_acoes/1.json
  def show
    @persona_acao = PersonaAcao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_acao }
    end
  end

  # GET /persona_acoes/new
  # GET /persona_acoes/new.json
  def new
    @persona_acao = PersonaAcao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_acao }
    end
  end

  # GET /persona_acoes/1/edit
  def edit
    @persona_acao = PersonaAcao.find(params[:id])
  end

  # POST /persona_acoes
  # POST /persona_acoes.json
  def create
    @persona_acao = PersonaAcao.new(params[:persona_acao])

    respond_to do |format|
      if @persona_acao.save
        format.html { redirect_to @persona_acao, notice: 'Persona acao was successfully created.' }
        format.json { render json: @persona_acao, status: :created, location: @persona_acao }
      else
        format.html { render action: "new" }
        format.json { render json: @persona_acao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /persona_acoes/1
  # PUT /persona_acoes/1.json
  def update
    @persona_acao = PersonaAcao.find(params[:id])

    respond_to do |format|
      if @persona_acao.update_attributes(params[:persona_acao])
        format.html { redirect_to @persona_acao, notice: 'Persona acao was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona_acao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /persona_acoes/1
  # DELETE /persona_acoes/1.json
  def destroy
    @persona_acao = PersonaAcao.find(params[:id])
    @persona_acao.destroy

    respond_to do |format|
      format.html { redirect_to persona_acoes_url }
      format.json { head :no_content }
    end
  end
end
