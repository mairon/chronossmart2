class PedidoCompraProdutosController < ApplicationController
  before_filter :authenticate

  def index
    @pedido_compra_produtos = PedidoCompraProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pedido_compra_produtos }
    end
  end

  def show
    @pedido_compra_produto = PedidoCompraProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pedido_compra_produto }
    end
  end

  def new
    @pedido_compra_produto = PedidoCompraProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pedido_compra_produto }
    end
  end

  def edit
    @pedido_compra_produto = PedidoCompraProduto.find(params[:id])
  end

  def create
    @pedido_compra_produto = PedidoCompraProduto.new(params[:pedido_compra_produto])

    @pedido_compra_produto.usuario_created = current_user.usuario_nome
    @pedido_compra_produto.unidade_created = current_unidade.unidade_nome
    
    respond_to do |format|
      if @pedido_compra_produto.save
        format.html { redirect_to "/pedido_compras/#{@pedido_compra_produto.pedido_compra_id}" }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @pedido_compra_produto = PedidoCompraProduto.find(params[:id])

    @pedido_compra_produto.usuario_updated = current_user.usuario_nome
    @pedido_compra_produto.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @pedido_compra_produto.update_attributes(params[:pedido_compra_produto])
        format.html { redirect_to "/pedido_compras/#{@pedido_compra_produto.pedido_compra_id}" }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @pedido_compra_produto = PedidoCompraProduto.find(params[:id])
    @pedido_compra_produto.destroy

    respond_to do |format|
        format.html { redirect_to "/pedido_compras/#{@pedido_compra_produto.pedido_compra_id}" }
    end
  end
end
