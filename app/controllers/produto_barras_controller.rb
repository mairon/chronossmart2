class ProdutoBarrasController < ApplicationController
  # GET /produto_barras
  # GET /produto_barras.json
  def index
    @produto_barras = ProdutoBarra.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @produto_barras }
    end
  end

  # GET /produto_barras/1
  # GET /produto_barras/1.json
  def show
    @produto_barra = ProdutoBarra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @produto_barra }
    end
  end

  # GET /produto_barras/new
  # GET /produto_barras/new.json
  def new
    @produto_barra = ProdutoBarra.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @produto_barra }
    end
  end

  # GET /produto_barras/1/edit
  def edit
    @produto_barra = ProdutoBarra.find(params[:id])
  end

  # POST /produto_barras
  # POST /produto_barras.json
  def create
    @produto_barra = ProdutoBarra.new(params[:produto_barra])

    respond_to do |format|
      if @produto_barra.save
        format.html { redirect_to "/produtos/#{@produto_barra.produto_id}/cod_barra"}
        format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @produto_barra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /produto_barras/1
  # PUT /produto_barras/1.json
  def update
    @produto_barra = ProdutoBarra.find(params[:id])

    respond_to do |format|
      if @produto_barra.update_attributes(params[:produto_barra])
        format.html { redirect_to "/produtos/#{@produto_barra.produto_id}/cod_barra"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @produto_barra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produto_barras/1
  # DELETE /produto_barras/1.json
  def destroy
    @produto_barra = ProdutoBarra.find(params[:id])
    @produto_barra.destroy

    respond_to do |format|
      format.html { redirect_to "/produtos/#{@produto_barra.produto_id}/cod_barra"}
      format.json { head :no_content }
    end
  end
end
