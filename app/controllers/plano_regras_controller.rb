class PlanoRegrasController < ApplicationController
  # GET /plano_regras
  # GET /plano_regras.json
  def index
    @plano_regras = PlanoRegra.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plano_regras }
    end
  end

  # GET /plano_regras/1
  # GET /plano_regras/1.json
  def show
    @plano_regra = PlanoRegra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plano_regra }
    end
  end

  # GET /plano_regras/new
  # GET /plano_regras/new.json
  def new
    @plano_regra = PlanoRegra.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plano_regra }
    end
  end

  # GET /plano_regras/1/edit
  def edit
    @plano_regra = PlanoRegra.find(params[:id])
  end

  # POST /plano_regras
  # POST /plano_regras.json
  def create
    @plano_regra = PlanoRegra.new(params[:plano_regra])

    respond_to do |format|
      if @plano_regra.save
        format.html { redirect_to plano_path(@plano_regra.plano_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /plano_regras/1
  # PUT /plano_regras/1.json
  def update
    @plano_regra = PlanoRegra.find(params[:id])

    respond_to do |format|
      if @plano_regra.update_attributes(params[:plano_regra])
        format.html { redirect_to plano_path(@plano_regra.plano_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /plano_regras/1
  # DELETE /plano_regras/1.json
  def destroy
    @plano_regra = PlanoRegra.find(params[:id])
    @plano_regra.destroy

    respond_to do |format|
      format.html { redirect_to plano_path(@plano_regra.plano_id) }
    end
  end
end
