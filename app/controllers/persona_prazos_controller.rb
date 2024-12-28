class PersonaPrazosController < ApplicationController
  # GET /persona_prazos
  # GET /persona_prazos.json
  def index
    @persona_prazos = PersonaPrazo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_prazos }
    end
  end

  # GET /persona_prazos/1
  # GET /persona_prazos/1.json
  def show
    @persona_prazo = PersonaPrazo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_prazo }
    end
  end

  # GET /persona_prazos/new
  # GET /persona_prazos/new.json
  def new
    @persona_prazo = PersonaPrazo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_prazo }
    end
  end

  # GET /persona_prazos/1/edit
  def edit
    @persona_prazo = PersonaPrazo.find(params[:id])
  end

  # POST /persona_prazos
  # POST /persona_prazos.json
  def create
    @persona_prazo = PersonaPrazo.new(params[:persona_prazo])

    respond_to do |format|
      if @persona_prazo.save
        format.html { redirect_to "/personas/#{@persona_prazo.persona_id}/prazos" }
        format.json { render json: @persona_prazo, status: :created, location: @persona_prazo }
      else
        format.html { render action: "new" }
        format.json { render json: @persona_prazo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /persona_prazos/1
  # PUT /persona_prazos/1.json
  def update
    @persona_prazo = PersonaPrazo.find(params[:id])

    respond_to do |format|
      if @persona_prazo.update_attributes(params[:persona_prazo])
        format.html { redirect_to "/personas/#{@persona_prazo.persona_id}/prazos" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona_prazo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /persona_prazos/1
  # DELETE /persona_prazos/1.json
  def destroy
    @persona_prazo = PersonaPrazo.find(params[:id])
    @persona_prazo.destroy

    respond_to do |format|
      format.html { redirect_to "/personas/#{@persona_prazo.persona_id}/prazos" }
      format.json { head :no_content }
    end
  end
end
