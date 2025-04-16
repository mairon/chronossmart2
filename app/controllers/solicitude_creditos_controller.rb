class SolicitudeCreditosController < ApplicationController

  def gera_venda
    pedido_venda = PlanoVenda.find(params[:plano_venda_id])
    vd =  Venda.create(
            data: Date.current,
            persona_id: pedido_venda.persona_id,
            persona_nome: pedido_venda.persona.nome,
            moeda: pedido_venda.moeda,
            tipo_venda: 0,
            vendedor_id: pedido_venda.vendedor_id,
            tabela_preco_id: pedido_venda.tabela_preco_id,
            usuario_id: current_user.id,
            terminal_id: 1,
            unidade_id: current_unidade.id,
            status_op: 0,
            dados_contrato: ModeloContrato.find(pedido_venda.solicitude_creditos.last.solicitude_credito_autorizacoes.last.modelo_contrato_id).modelo
              .gsub('|dia|', Date.current.strftime("%d") )
              .gsub('|mes|', l(Date.current, format: "%B") )
              .gsub('|ano|', Date.current.strftime("%Y") )
              .gsub('|marca|', pedido_venda.produto.clase.descricao )
              .gsub('|modelo|', pedido_venda.produto.nome )
              .gsub('|ano|', pedido_venda.produto.ano )
              .gsub('|color|', pedido_venda.produto.ano )
              .gsub('|chasis|', pedido_venda.produto.chassi ),

            plano_venda_id: pedido_venda.id
          )
          VendasProduto.create(
            venda_id: vd.id,
            data: vd.data,
            produto_id: pedido_venda.produto_id,
            produto_nome: pedido_venda.produto.nome,
            obs: "MARCA: #{pedido_venda.produto.clase.descricao} MODELO: #{pedido_venda.produto.nome} COLOR: #{pedido_venda.produto.cor} AÑO: #{pedido_venda.produto.ano} CHASIS N: #{pedido_venda.produto.chassi}",
            quantidade: 1,
            unitario_dolar: pedido_venda.valor_us,
            preco_dolar: pedido_venda.valor_us,
            unitario_guarani: pedido_venda.valor_gs,
            preco_guarani: pedido_venda.valor_gs,
            total_dolar: pedido_venda.valor_us,
            total_guarani: pedido_venda.valor_gs,
            deposito_id: 1,
            moeda: vd.moeda,            

          )

    redirect_to venda_path(vd.id)
  end

  def comprovante
      @solicitude_credito = SolicitudeCredito.find(params[:id])


    respond_to do |format|
          format.html do
            render  :pdf                    => "Solicitud-Credito-#{@solicitude_credito.id}",                
                    :layout                 => "layer_relatorios",
                    :margin => {:top        => '0.20in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},        
                    :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :spacing    => 19},
                    :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "Chronos Software - Fecha de la Impresion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
        end
  end


  def index
    @solicitude_creditos = SolicitudeCredito.order('id desc')
    
    render layout: 'chart'
  end

  # GET /solicitude_creditos/1
  # GET /solicitude_creditos/1.json
  def show
    @solicitude_credito = SolicitudeCredito.find(params[:id])

    render layout: 'chart'
  end

  # GET /solicitude_creditos/new
  # GET /solicitude_creditos/new.json
  def new
    @solicitude_credito = SolicitudeCredito.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @solicitude_credito }
    end
  end

  # GET /solicitude_creditos/1/edit
  def edit
    @solicitude_credito = SolicitudeCredito.find(params[:id])
  end

  # POST /solicitude_creditos
  # POST /solicitude_creditos.json
  def create
    @solicitude_credito = SolicitudeCredito.new(params[:solicitude_credito])

    respond_to do |format|
      if @solicitude_credito.save
        format.html { redirect_to @solicitude_credito }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /solicitude_creditos/1
  # PUT /solicitude_creditos/1.json
  def update
    @solicitude_credito = SolicitudeCredito.find(params[:id])

    respond_to do |format|
      if @solicitude_credito.update_attributes(params[:solicitude_credito])
        format.html { redirect_to @solicitude_credito }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /solicitude_creditos/1
  # DELETE /solicitude_creditos/1.json
  def destroy
    @solicitude_credito = SolicitudeCredito.find(params[:id])
    @solicitude_credito.destroy

    respond_to do |format|
      format.html { redirect_to solicitude_creditos_url }
    end
  end
end
