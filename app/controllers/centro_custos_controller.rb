class CentroCustosController < ApplicationController
  # GET /centro_custos
  # GET /centro_custos.json
  def index
    @centro_custos = CentroCusto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @centro_custos }
    end
  end

  # GET /centro_custos/1
  # GET /centro_custos/1.json
  def show
    @centro_custo = CentroCusto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @centro_custo }
    end
  end

  # GET /centro_custos/new
  # GET /centro_custos/new.json
  def new
    @centro_custo = CentroCusto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @centro_custo }
    end
  end

  # GET /centro_custos/1/edit
  def edit
    @centro_custo = CentroCusto.find(params[:id])
  end

  # POST /centro_custos
  # POST /centro_custos.json
  def create
    @centro_custo = CentroCusto.new(params[:centro_custo])

    respond_to do |format|
      if @centro_custo.save
        format.html { redirect_to centro_custos_url }
        format.json { render json: @centro_custo, status: :created, location: @centro_custo }
      else
        format.html { render action: "new" }
        format.json { render json: @centro_custo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /centro_custos/1
  # PUT /centro_custos/1.json
  def update
    @centro_custo = CentroCusto.find(params[:id])

    respond_to do |format|
      if @centro_custo.update_attributes(params[:centro_custo])
        format.html { redirect_to centro_custos_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @centro_custo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /centro_custos/1
  # DELETE /centro_custos/1.json
  def destroy
    @centro_custo = CentroCusto.find(params[:id])
    @centro_custo.destroy

    respond_to do |format|
      format.html { redirect_to centro_custos_url }
      format.json { head :no_content }
    end
  end
end
