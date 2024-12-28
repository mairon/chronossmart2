class NotaCreditoProveedorProdutosController < ApplicationController
  # GET /nota_credito_proveedor_produtos
  # GET /nota_credito_proveedor_produtos.xml
  def index
    @nota_credito_proveedor_produtos = NotaCreditoProveedorProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nota_credito_proveedor_produtos }
    end
  end

  # GET /nota_credito_proveedor_produtos/1
  # GET /nota_credito_proveedor_produtos/1.xml
  def show
    @nota_credito_proveedor_produto = NotaCreditoProveedorProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nota_credito_proveedor_produto }
    end
  end

  # GET /nota_credito_proveedor_produtos/new
  # GET /nota_credito_proveedor_produtos/new.xml
  def new
    @nota_credito_proveedor_produto = NotaCreditoProveedorProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nota_credito_proveedor_produto }
    end
  end

  # GET /nota_credito_proveedor_produtos/1/edit
  def edit
    @nota_credito_proveedor_produto = NotaCreditoProveedorProduto.find(params[:id])
  end

  def create
    @nota_credito_proveedor_produto = NotaCreditoProveedorProduto.new(params[:nota_credito_proveedor_produto])

    respond_to do |format|
      if @nota_credito_proveedor_produto.save
        format.html { redirect_to("/nota_credito_proveedors/#{@nota_credito_proveedor_produto.nota_credito_proveedor_id}")}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nota_credito_proveedor_produto.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @nota_credito_proveedor_produto = NotaCreditoProveedorProduto.find(params[:id])

    respond_to do |format|
      if @nota_credito_proveedor_produto.update_attributes(params[:nota_credito_proveedor_produto])


        format.html { redirect_to("/nota_credito_proveedors/#{@nota_credito_proveedor_produto.nota_credito_proveedor_id}")}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nota_credito_proveedor_produto.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @nota_credito_proveedor_produto = NotaCreditoProveedorProduto.find(params[:id])
    @nota_credito_proveedor_produto.destroy


    respond_to do |format|
        format.html { redirect_to("/nota_credito_proveedors/#{@nota_credito_proveedor_produto.nota_credito_proveedor_id}")}
      format.xml  { head :ok }
    end
  end
end
