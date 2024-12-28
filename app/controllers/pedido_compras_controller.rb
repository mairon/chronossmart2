class PedidoComprasController < ApplicationController
  before_filter :authenticate

  def financas
    @pedido_compra = PedidoCompra.find(params[:id])
    @saldo_gs = (PedidoCompraProduto.where(pedido_compra_id: @pedido_compra.id).sum(:total_guarani) - PedidoCompraFinanca.where(pedido_compra_id: @pedido_compra.id).sum(:valor_gs))
    @saldo_us = (PedidoCompraProduto.where(pedido_compra_id: @pedido_compra.id).sum(:total_dolar) - PedidoCompraFinanca.where(pedido_compra_id: @pedido_compra.id).sum(:valor_us))
    @saldo_rs = (PedidoCompraProduto.where(pedido_compra_id: @pedido_compra.id).sum(:total_real) - PedidoCompraFinanca.where(pedido_compra_id: @pedido_compra.id).sum(:valor_rs))
  end

  def print_pedido
    @pedido_compra = PedidoCompra.find(params[:id])
    @pcp = PedidoCompraProduto.all(:conditions => ["pedido_compra_id = ?",@pedido_compra.id])

        head =
        "       
                                                           #{current_unidade.nome_sys}
  Ciudad..: #{current_unidade.cidade.nome}                                                      
  Direcion: #{current_unidade.direcao}
  Bario...: #{current_unidade.bairro}
  RUC.....: #{current_unidade.ruc}
  Fone....: #{current_unidade.telefone}                                                        
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_fechamento_caixa",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '0.90in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 19},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "CHRONOS - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end

  end

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def busca_pedido_compra
        params[:unidade] = current_unidade.id
        @pc = PedidoCompra.filtro_busca_pedido(params)
        render :layout => false
  end

  def show
    @pedido_compra = PedidoCompra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pedido_compra }
    end
  end

  def new
    @pedido_compra = PedidoCompra.new

    render :layout => 'application'
  end

  def edit
    @pedido_compra = PedidoCompra.find(params[:id])
  end

  def create
    @pedido_compra = PedidoCompra.new(params[:pedido_compra])
    @pedido_compra.usuario_created = current_user.usuario_nome
    @pedido_compra.unidade_created = current_unidade.unidade_nome
    @pedido_compra.unidade_id = current_unidade.id.to_i

    respond_to do |format|
      if @pedido_compra.save
        format.html { redirect_to("/pedido_compras/#{@pedido_compra.id}") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @pedido_compra = PedidoCompra.find(params[:id])

    @pedido_compra.usuario_updated = current_user.usuario_nome
    @pedido_compra.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @pedido_compra.update_attributes(params[:pedido_compra])
        format.html { redirect_to("/pedido_compras/#{@pedido_compra.id}") }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @pedido_compra = PedidoCompra.find(params[:id])
    @pedido_compra.destroy

    respond_to do |format|
      format.html { redirect_to(pedido_compras_url) }
    end
  end

    def dynamic_cole
      @marcas = Colecao.find_all_by_sub_grupo_id(params[:id])
      respond_to do |format|
        format.js
      end
    end

end