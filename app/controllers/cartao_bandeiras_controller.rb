class CartaoBandeirasController < ApplicationController
  # GET /cartao_bandeiras
  # GET /cartao_bandeiras.json
  def index
    @cartao_bandeiras = CartaoBandeira.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cartao_bandeiras }
    end
  end

  # GET /cartao_bandeiras/1
  # GET /cartao_bandeiras/1.json
  def show
    @cartao_bandeira = CartaoBandeira.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cartao_bandeira }
    end
  end

  # GET /cartao_bandeiras/new
  # GET /cartao_bandeiras/new.json
  def new
    @cartao_bandeira = CartaoBandeira.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cartao_bandeira }
    end
  end

  # GET /cartao_bandeiras/1/edit
  def edit
    @cartao_bandeira = CartaoBandeira.find(params[:id])
  end

  # POST /cartao_bandeiras
  # POST /cartao_bandeiras.json
  def create
    @cartao_bandeira = CartaoBandeira.new(params[:cartao_bandeira])

    respond_to do |format|
      if @cartao_bandeira.save
        format.html { redirect_to cartao_bandeiras_url }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /cartao_bandeiras/1
  # PUT /cartao_bandeiras/1.json
  def update
    @cartao_bandeira = CartaoBandeira.find(params[:id])

    respond_to do |format|
      if @cartao_bandeira.update_attributes(params[:cartao_bandeira])
        format.html { redirect_to cartao_bandeiras_url }
        
      else
        format.html { render action: "edit" }
        
      end
    end
  end

  # DELETE /cartao_bandeiras/1
  # DELETE /cartao_bandeiras/1.json
  def destroy
    @cartao_bandeira = CartaoBandeira.find(params[:id])
    @cartao_bandeira.destroy

    respond_to do |format|
      format.html { redirect_to cartao_bandeiras_url }
      format.json { head :no_content }
    end
  end
end
