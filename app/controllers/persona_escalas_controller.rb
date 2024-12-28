class PersonaEscalasController < ApplicationController

  def multi_datas

    dt = params[:inicio].split("/").reverse.join("-").to_date
    (params[:inicio].split("/").reverse.join("-").to_date..params[:final].split("/").reverse.join("-").to_date).each do
      PersonaEscala.create(
        :persona_id => params[:busca]["persona"],
        :data => dt,
        :tipo => params[:tipo],
        :obs => params[:obs]
      )
      dt += 1.day
    end

    redirect_to("/persona_escalas")

  end

  def index
    @persona_escalas = PersonaEscala.where(tipo: 1).order('persona_id,data')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_escalas }
    end
  end

  # GET /persona_escalas/1
  # GET /persona_escalas/1.json
  def show
    @persona_escala = PersonaEscala.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_escala }
    end
  end

  # GET /persona_escalas/new
  # GET /persona_escalas/new.json
  def new
    @persona_escala = PersonaEscala.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_escala }
    end
  end

  # GET /persona_escalas/1/edit
  def edit
    @persona_escala = PersonaEscala.find(params[:id])
  end

  # POST /persona_escalas
  # POST /persona_escalas.json
  def create
    @persona_escala = PersonaEscala.new(params[:persona_escala])

    respond_to do |format|
      if @persona_escala.save
        format.html { redirect_to persona_escalas_url }
      else
        format.html { render action: "new" }
        format.json { render json: @persona_escala.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /persona_escalas/1
  # PUT /persona_escalas/1.json
  def update
    @persona_escala = PersonaEscala.find(params[:id])

    respond_to do |format|
      if @persona_escala.update_attributes(params[:persona_escala])
        format.html { redirect_to persona_escalas_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona_escala.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /persona_escalas/1
  # DELETE /persona_escalas/1.json
  def destroy
    @persona_escala = PersonaEscala.find(params[:id])
    @persona_escala.destroy

    respond_to do |format|
      format.html { redirect_to persona_escalas_url }
      format.json { head :no_content }
    end
  end
end
