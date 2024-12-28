class ProvisController < ApplicationController
  # GET /provis
  # GET /provis.json
  def index
    @provis = Provi.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @provis }
    end
  end

  # GET /provis/1
  # GET /provis/1.json
  def show
    @provi = Provi.find(params[:id])
    @provi_detalhes = ProviDetalhe.where("provi_id = ?", @provi.id )
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @provi }
    end
  end

  # GET /provis/new
  # GET /provis/new.json
  def new
    @provi = Provi.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @provi }
    end
  end

  # GET /provis/1/edit
  def edit
    @provi = Provi.find(params[:id])
  end

  # POST /provis
  # POST /provis.json
  def create
    @provi = Provi.new(params[:provi])

    respond_to do |format|
      if @provi.save
        format.html { redirect_to @provi, notice: 'Provi was successfully created.' }
        format.json { render json: @provi, status: :created, location: @provi }
      else
        format.html { render action: "new" }
        format.json { render json: @provi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /provis/1
  # PUT /provis/1.json
  def update
    @provi = Provi.find(params[:id])

    respond_to do |format|
      if @provi.update_attributes(params[:provi])
        format.html { redirect_to @provi, notice: 'Provi was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @provi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provis/1
  # DELETE /provis/1.json
  def destroy
    @provi = Provi.find(params[:id])
    @provi.destroy

    respond_to do |format|
      format.html { redirect_to provis_url }
      format.json { head :no_content }
    end
  end

    def dynamic_rubro_grupo
      plano = PlanoDeConta.find_by_id(params[:id])
      @rubros = Rubro.where("codigo like '#{plano.codigo}%' ")
      respond_to do |format|
        format.js
      end
    end

end
