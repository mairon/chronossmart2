class GruposPrazosController < ApplicationController
  # GET /grupos_prazos
  # GET /grupos_prazos.json
  def index
    @grupos_prazos = GruposPrazo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grupos_prazos }
    end
  end

  # GET /grupos_prazos/1
  # GET /grupos_prazos/1.json
  def show
    @grupos_prazo = GruposPrazo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grupos_prazo }
    end
  end

  # GET /grupos_prazos/new
  # GET /grupos_prazos/new.json
  def new
    @grupos_prazo = GruposPrazo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grupos_prazo }
    end
  end

  # GET /grupos_prazos/1/edit
  def edit
    @grupos_prazo = GruposPrazo.find(params[:id])
  end

  # POST /grupos_prazos
  # POST /grupos_prazos.json
  def create
    @grupos_prazo = GruposPrazo.new(params[:grupos_prazo])

    respond_to do |format|
      if @grupos_prazo.save
        format.html { redirect_to @grupos_prazo, notice: 'Grupos prazo was successfully created.' }
        format.json { render json: @grupos_prazo, status: :created, location: @grupos_prazo }
      else
        format.html { render action: "new" }
        format.json { render json: @grupos_prazo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /grupos_prazos/1
  # PUT /grupos_prazos/1.json
  def update
    @grupos_prazo = GruposPrazo.find(params[:id])

    respond_to do |format|
      if @grupos_prazo.update_attributes(params[:grupos_prazo])
        format.html { redirect_to @grupos_prazo, notice: 'Grupos prazo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @grupos_prazo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grupos_prazos/1
  # DELETE /grupos_prazos/1.json
  def destroy
    @grupos_prazo = GruposPrazo.find(params[:id])
    @grupos_prazo.destroy

    respond_to do |format|
      format.html { redirect_to grupos_prazos_url }
      format.json { head :no_content }
    end
  end
end
