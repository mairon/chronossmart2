class GrupoPersonasDtsController < ApplicationController
  # GET /grupo_personas_dts
  # GET /grupo_personas_dts.json
  def index
    @grupo_personas_dts = GrupoPersonasDt.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grupo_personas_dts }
    end
  end

  # GET /grupo_personas_dts/1
  # GET /grupo_personas_dts/1.json
  def show
    @grupo_personas_dt = GrupoPersonasDt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grupo_personas_dt }
    end
  end

  # GET /grupo_personas_dts/new
  # GET /grupo_personas_dts/new.json
  def new
    @grupo_personas_dt = GrupoPersonasDt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grupo_personas_dt }
    end
  end

  # GET /grupo_personas_dts/1/edit
  def edit
    @grupo_personas_dt = GrupoPersonasDt.find(params[:id])
  end

  # POST /grupo_personas_dts
  # POST /grupo_personas_dts.json
  def create
    @grupo_personas_dt = GrupoPersonasDt.new(params[:grupo_personas_dt])

    respond_to do |format|
      if @grupo_personas_dt.save
        format.html { redirect_to grupo_persona_path(@grupo_personas_dt.grupo_persona_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /grupo_personas_dts/1
  # PUT /grupo_personas_dts/1.json
  def update
    @grupo_personas_dt = GrupoPersonasDt.find(params[:id])

    respond_to do |format|
      if @grupo_personas_dt.update_attributes(params[:grupo_personas_dt])
        format.html { redirect_to grupo_persona_path(@grupo_personas_dt.grupo_persona_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /grupo_personas_dts/1
  # DELETE /grupo_personas_dts/1.json
  def destroy
    @grupo_personas_dt = GrupoPersonasDt.find(params[:id])
    @grupo_personas_dt.destroy

    respond_to do |format|
      format.html { redirect_to grupo_persona_path(@grupo_personas_dt.grupo_persona_id) }
    end
  end
end
