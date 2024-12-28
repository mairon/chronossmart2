class PersonasTabelaPrecosController < ApplicationController
  # GET /personas_tabela_precos
  # GET /personas_tabela_precos.json
  def index
    @personas_tabela_precos = PersonasTabelaPreco.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @personas_tabela_precos }
    end
  end

  # GET /personas_tabela_precos/1
  # GET /personas_tabela_precos/1.json
  def show
    @personas_tabela_preco = PersonasTabelaPreco.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @personas_tabela_preco }
    end
  end

  # GET /personas_tabela_precos/new
  # GET /personas_tabela_precos/new.json
  def new
    @personas_tabela_preco = PersonasTabelaPreco.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @personas_tabela_preco }
    end
  end

  # GET /personas_tabela_precos/1/edit
  def edit
    @personas_tabela_preco = PersonasTabelaPreco.find(params[:id])
  end

  # POST /personas_tabela_precos
  # POST /personas_tabela_precos.json
  def create
    @personas_tabela_preco = PersonasTabelaPreco.new(params[:personas_tabela_preco])

    respond_to do |format|
      if @personas_tabela_preco.save
        format.html { redirect_to @personas_tabela_preco, notice: 'Personas tabela preco was successfully created.' }
        format.json { render json: @personas_tabela_preco, status: :created, location: @personas_tabela_preco }
      else
        format.html { render action: "new" }
        format.json { render json: @personas_tabela_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /personas_tabela_precos/1
  # PUT /personas_tabela_precos/1.json
  def update
    @personas_tabela_preco = PersonasTabelaPreco.find(params[:id])

    respond_to do |format|
      if @personas_tabela_preco.update_attributes(params[:personas_tabela_preco])
        format.html { redirect_to @personas_tabela_preco, notice: 'Personas tabela preco was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @personas_tabela_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personas_tabela_precos/1
  # DELETE /personas_tabela_precos/1.json
  def destroy
    @personas_tabela_preco = PersonasTabelaPreco.find(params[:id])
    @personas_tabela_preco.destroy

    respond_to do |format|
      format.html { redirect_to personas_tabela_precos_url }
      format.json { head :no_content }
    end
  end
end
