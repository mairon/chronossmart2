class AjustePrecoDetalhesController < ApplicationController
  # GET /ajuste_preco_detalhes
  # GET /ajuste_preco_detalhes.json
  def index
    @ajuste_preco_detalhes = AjustePrecoDetalhe.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ajuste_preco_detalhes }
    end
  end

  # GET /ajuste_preco_detalhes/1
  # GET /ajuste_preco_detalhes/1.json
  def show
    @ajuste_preco_detalhe = AjustePrecoDetalhe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ajuste_preco_detalhe }
    end
  end

  # GET /ajuste_preco_detalhes/new
  # GET /ajuste_preco_detalhes/new.json
  def new
    @ajuste_preco_detalhe = AjustePrecoDetalhe.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ajuste_preco_detalhe }
    end
  end

  # GET /ajuste_preco_detalhes/1/edit
  def edit
    @ajuste_preco_detalhe = AjustePrecoDetalhe.find(params[:id])
  end

  # POST /ajuste_preco_detalhes
  # POST /ajuste_preco_detalhes.json
  def create
    @ajuste_preco_detalhe = AjustePrecoDetalhe.new(params[:ajuste_preco_detalhe])

    respond_to do |format|
      if @ajuste_preco_detalhe.save
        format.html { redirect_to @ajuste_preco_detalhe, notice: 'Ajuste preco detalhe was successfully created.' }
        format.json { render json: @ajuste_preco_detalhe, status: :created, location: @ajuste_preco_detalhe }
      else
        format.html { render action: "new" }
        format.json { render json: @ajuste_preco_detalhe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ajuste_preco_detalhes/1
  # PUT /ajuste_preco_detalhes/1.json
  def update
    @ajuste_preco_detalhe = AjustePrecoDetalhe.find(params[:id])

    respond_to do |format|
      if @ajuste_preco_detalhe.update_attributes(params[:ajuste_preco_detalhe])
        format.html { redirect_to @ajuste_preco_detalhe, notice: 'Ajuste preco detalhe was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ajuste_preco_detalhe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ajuste_preco_detalhes/1
  # DELETE /ajuste_preco_detalhes/1.json
  def destroy
    @ajuste_preco_detalhe = AjustePrecoDetalhe.find(params[:id])
    @ajuste_preco_detalhe.destroy

    respond_to do |format|
      format.html { redirect_to ajuste_preco_detalhes_url }
      format.json { head :no_content }
    end
  end
end
