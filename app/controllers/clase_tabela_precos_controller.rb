class ClaseTabelaPrecosController < ApplicationController
  # GET /clase_tabela_precos
  # GET /clase_tabela_precos.json
  def index
    @clase_tabela_precos = ClaseTabelaPreco.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clase_tabela_precos }
    end
  end

  # GET /clase_tabela_precos/1
  # GET /clase_tabela_precos/1.json
  def show
    @clase_tabela_preco = ClaseTabelaPreco.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @clase_tabela_preco }
    end
  end

  # GET /clase_tabela_precos/new
  # GET /clase_tabela_precos/new.json
  def new
    @clase_tabela_preco = ClaseTabelaPreco.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @clase_tabela_preco }
    end
  end

  # GET /clase_tabela_precos/1/edit
  def edit
    @clase_tabela_preco = ClaseTabelaPreco.find(params[:id])
  end

  # POST /clase_tabela_precos
  # POST /clase_tabela_precos.json
  def create
    @clase_tabela_preco = ClaseTabelaPreco.new(params[:clase_tabela_preco])

    respond_to do |format|
      if @clase_tabela_preco.save
        format.html { redirect_to @clase_tabela_preco, notice: 'Clase tabela preco was successfully created.' }
        format.json { render json: @clase_tabela_preco, status: :created, location: @clase_tabela_preco }
      else
        format.html { render action: "new" }
        format.json { render json: @clase_tabela_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clase_tabela_precos/1
  # PUT /clase_tabela_precos/1.json
  def update
    @clase_tabela_preco = ClaseTabelaPreco.find(params[:id])

    respond_to do |format|
      if @clase_tabela_preco.update_attributes(params[:clase_tabela_preco])
        format.html { redirect_to @clase_tabela_preco, notice: 'Clase tabela preco was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @clase_tabela_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clase_tabela_precos/1
  # DELETE /clase_tabela_precos/1.json
  def destroy
    @clase_tabela_preco = ClaseTabelaPreco.find(params[:id])
    @clase_tabela_preco.destroy

    respond_to do |format|
      format.html { redirect_to clase_tabela_precos_url }
      format.json { head :no_content }
    end
  end
end
