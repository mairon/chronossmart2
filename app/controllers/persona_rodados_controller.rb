class PersonaRodadosController < ApplicationController
  # GET /persona_rodados
  # GET /persona_rodados.json
  def index
    @persona_rodados = PersonaRodado.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_rodados }
    end
  end

  # GET /persona_rodados/1
  # GET /persona_rodados/1.json
  def show
    @persona_rodado = PersonaRodado.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_rodado }
    end
  end

  # GET /persona_rodados/new
  # GET /persona_rodados/new.json
  def new
    @persona_rodado = PersonaRodado.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_rodado }
    end
  end

  # GET /persona_rodados/1/edit
  def edit
    @persona_rodado = PersonaRodado.find(params[:id])
    render layout: 'chart'
  end

  # POST /persona_rodados
  # POST /persona_rodados.json
  def create
    @persona_rodado = PersonaRodado.new(params[:persona_rodado])

    respond_to do |format|
      if @persona_rodado.save
        format.html { redirect_to "/personas/#{@persona_rodado.persona_id}"}
        format.json { render json: @persona_rodado, status: :created, location: @persona_rodado }
      else
        format.html { render action: "new" }
        format.json { render json: @persona_rodado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /persona_rodados/1
  # PUT /persona_rodados/1.json
  def update
    @persona_rodado = PersonaRodado.find(params[:id])

    respond_to do |format|
      if @persona_rodado.update_attributes(params[:persona_rodado])
        format.html { redirect_to "/personas/#{@persona_rodado.persona_id}"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona_rodado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /persona_rodados/1
  # DELETE /persona_rodados/1.json
  def destroy
    @persona_rodado = PersonaRodado.find(params[:id])
    @persona_rodado.destroy

    respond_to do |format|
      format.html { redirect_to "/personas/#{@persona_rodado.persona_id}"}
      format.json { head :no_content }
    end
  end
end
