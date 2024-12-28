class PersonaLocaisEntregasController < ApplicationController
  # GET /persona_locais_entregas
  # GET /persona_locais_entregas.json
  def index
    @persona_locais_entregas = PersonaLocaisEntrega.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_locais_entregas }
    end
  end

  # GET /persona_locais_entregas/1
  # GET /persona_locais_entregas/1.json
  def show
    @persona_locais_entrega = PersonaLocaisEntrega.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_locais_entrega }
    end
  end

  # GET /persona_locais_entregas/new
  # GET /persona_locais_entregas/new.json
  def new
    @persona_locais_entrega = PersonaLocaisEntrega.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_locais_entrega }
    end
  end

  # GET /persona_locais_entregas/1/edit
  def edit
    @persona_locais_entrega = PersonaLocaisEntrega.find(params[:id])
  end

  # POST /persona_locais_entregas
  # POST /persona_locais_entregas.json
  def create
    @persona_locais_entrega = PersonaLocaisEntrega.new(params[:persona_locais_entrega])

    respond_to do |format|
      if @persona_locais_entrega.save
        format.html { redirect_to "/personas/#{@persona_locais_entrega.persona_id}/local_entregas"}
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /persona_locais_entregas/1
  # PUT /persona_locais_entregas/1.json
  def update
    @persona_locais_entrega = PersonaLocaisEntrega.find(params[:id])

    respond_to do |format|
      if @persona_locais_entrega.update_attributes(params[:persona_locais_entrega])
        format.html { redirect_to "/personas/#{@persona_locais_entrega.persona_id}/local_entregas"}
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /persona_locais_entregas/1
  # DELETE /persona_locais_entregas/1.json
  def destroy
    @persona_locais_entrega = PersonaLocaisEntrega.find(params[:id])
    @persona_locais_entrega.destroy

    respond_to do |format|
      format.html { redirect_to "/personas/#{@persona_locais_entrega.persona_id}/local_entregas"}
    end
  end
end
