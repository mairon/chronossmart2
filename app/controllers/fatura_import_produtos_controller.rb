class FaturaImportProdutosController < ApplicationController
  # GET /fatura_import_produtos
  # GET /fatura_import_produtos.json
  def index
    @fatura_import_produtos = FaturaImportProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fatura_import_produtos }
    end
  end

  # GET /fatura_import_produtos/1
  # GET /fatura_import_produtos/1.json
  def show
    @fatura_import_produto = FaturaImportProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fatura_import_produto }
    end
  end

  # GET /fatura_import_produtos/new
  # GET /fatura_import_produtos/new.json
  def new
    @fatura_import_produto = FaturaImportProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fatura_import_produto }
    end
  end

  # GET /fatura_import_produtos/1/edit
  def edit
    @fatura_import_produto = FaturaImportProduto.find(params[:id])
  end

  # POST /fatura_import_produtos
  # POST /fatura_import_produtos.json
  def create
    @fatura_import_produto = FaturaImportProduto.new(params[:fatura_import_produto])

    respond_to do |format|
      if @fatura_import_produto.save
        format.html { redirect_to @fatura_import_produto, notice: 'Fatura import produto was successfully created.' }
        format.json { render json: @fatura_import_produto, status: :created, location: @fatura_import_produto }
      else
        format.html { render action: "new" }
        format.json { render json: @fatura_import_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fatura_import_produtos/1
  # PUT /fatura_import_produtos/1.json
  def update
    @fatura_import_produto = FaturaImportProduto.find(params[:id])

    respond_to do |format|
      if @fatura_import_produto.update_attributes(params[:fatura_import_produto])
        format.html { redirect_to @fatura_import_produto, notice: 'Fatura import produto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fatura_import_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fatura_import_produtos/1
  # DELETE /fatura_import_produtos/1.json
  def destroy
    @fatura_import_produto = FaturaImportProduto.find(params[:id])
    @fatura_import_produto.destroy

    respond_to do |format|
      format.html { redirect_to fatura_import_produtos_url }
      format.json { head :no_content }
    end
  end
end
