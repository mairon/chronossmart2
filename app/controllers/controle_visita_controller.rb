class ControleVisitaController < ApplicationController
  # GET /controle_visita
  # GET /controle_visita.json
  def index
    @controle_visita = ControleVisitum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @controle_visita }
    end
  end

  # GET /controle_visita/1
  # GET /controle_visita/1.json
  def show
    @controle_visitum = ControleVisitum.find(params[:id])

    respond_to do |format|
      format.html { redirect_to controle_visita_url }
      format.json { head :no_content }
    end
  end

  # GET /controle_visita/new
  # GET /controle_visita/new.json
  def new
    @controle_visitum = ControleVisitum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @controle_visitum }
    end
  end

  # GET /controle_visita/1/edit
  def edit
    @controle_visitum = ControleVisitum.find(params[:id])
  end

  # POST /controle_visita
  # POST /controle_visita.json
  def create
    @controle_visitum = ControleVisitum.new(params[:controle_visitum])

    respond_to do |format|
      if @controle_visitum.save
        format.html { redirect_to controle_visita_url }
      format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @controle_visitum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /controle_visita/1
  # PUT /controle_visita/1.json
  def update
    @controle_visitum = ControleVisitum.find(params[:id])

    respond_to do |format|
      if @controle_visitum.update_attributes(params[:controle_visitum])
        format.html { redirect_to controle_visita_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @controle_visitum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /controle_visita/1
  # DELETE /controle_visita/1.json
  def destroy
    @controle_visitum = ControleVisitum.find(params[:id])
    @controle_visitum.destroy

    respond_to do |format|
      format.html { redirect_to controle_visita_url }
      format.json { head :no_content }
    end
  end
end
