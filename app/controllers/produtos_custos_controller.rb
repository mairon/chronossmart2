class ProdutosCustosController < ApplicationController
  # GET /produtos_custos
  # GET /produtos_custos.json
  def index
    @produtos_custos = ProdutosCusto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @produtos_custos }
    end
  end

  # GET /produtos_custos/1
  # GET /produtos_custos/1.json
  def show
    @produtos_custo = ProdutosCusto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @produtos_custo }
    end
  end

  # GET /produtos_custos/new
  # GET /produtos_custos/new.json
  def new
    @produtos_custo = ProdutosCusto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @produtos_custo }
    end
  end

  # GET /produtos_custos/1/edit
  def edit
    @produtos_custo = ProdutosCusto.find(params[:id])
  end

  # POST /produtos_custos
  # POST /produtos_custos.json
  def create
    @produtos_custo = ProdutosCusto.new(params[:produtos_custo])

    respond_to do |format|
      if @produtos_custo.save
        format.html { redirect_to @produtos_custo, notice: 'Produtos custo was successfully created.' }
        format.json { render json: @produtos_custo, status: :created, location: @produtos_custo }
      else
        format.html { render action: "new" }
        format.json { render json: @produtos_custo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /produtos_custos/1
  # PUT /produtos_custos/1.json
  def update
    @produtos_custo = ProdutosCusto.find(params[:id])

    respond_to do |format|
      if @produtos_custo.update_attributes(params[:produtos_custo])
        format.html { redirect_to @produtos_custo, notice: 'Produtos custo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @produtos_custo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produtos_custos/1
  # DELETE /produtos_custos/1.json
  def destroy
    @produtos_custo = ProdutosCusto.find(params[:id])
    @produtos_custo.destroy

    respond_to do |format|
      format.html { redirect_to produtos_custos_url }
      format.json { head :no_content }
    end
  end
end
