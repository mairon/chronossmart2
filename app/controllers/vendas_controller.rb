class VendasController < ApplicationController
  before_filter :authenticate, :except => [:ticket_cozinha, :comprovante01]

  def pagare_usado
    @venda           = Venda.find(params[:id])
    @produtos        = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
    @produto_sum_gs  = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
    @produto_sum_us  = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
    @venci           = VendasFinanca.where("venda_id = #{params[:id]} AND tipo = 1").last

    render :layout => false
  end

  def pagare_escritura
    @venda           = Venda.find(params[:id])
    @produtos        = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
    @produto_sum_gs  = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
    @produto_sum_us  = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
    @venci           = VendasFinanca.where("venda_id = #{params[:id]} AND tipo = 1").last
    @saldo_pendente  = Cliente.where("persona_id = #{@venda.persona_id} and liquidacao = 0").sum("divida_guarani - cobro_guarani")

    render :layout => false
  end

  def print_contrato
    @venda = Venda.find(params[:id])
    respond_to do |format|
      format.html do
        render  :pdf                    => "print_contrato",
                :layout                 => "layer_relatorios",
                :page_size              => 'Legal',
                :margin => {:top        => '0.20in',
                            :bottom     => '0.27in',
                            :left       => '0.10in',
                            :right      => '0.10in'},
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :spacing    => 0},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7}
      end
    end    
  end

  def certificado_venda
    @venda = Venda.find(params[:id])

    respond_to do |format|
      format.html do
        render  :pdf                    => "certificado_venda",
                :layout                 => "layer_relatorios",
                :page_size              => 'A4',
                :margin => {:top        => '0.20in',
                            :bottom     => '0.27in',
                            :left       => '0.10in',
                            :right      => '0.10in'},
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :spacing    => 0},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "Chronos Software - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
  end


  def preparo_print
    @venda = Venda.find(params[:id])
    render false
  end

  def comprovante_devolucao
    @venda = Venda.find(params[:id])
    render :layout => false
  end
  
  def devolucaos
    @venda = Venda.find(params[:id])

    render layout: 'chart'
  end

  def busca_nota_credito
    @venda = Venda.find(params[:id])
    persona = "SELECT C.DOCUMENTO_NUMERO_01,
                C.DOCUMENTO_NUMERO_02,
                C.DOCUMENTO_NUMERO,
                SUM(C.DIVIDA_DOLAR) AS DIVIDA_DOLAR,
                SUM(C.COBRO_DOLAR) AS COBRO_DOLAR,
                SUM(C.DIVIDA_GUARANI) AS DIVIDA_GUARANI,
                SUM(C.COBRO_GUARANI) AS COBRO_GUARANI
            FROM CLIENTES C

            WHERE C.LIQUIDACAO = 0
            AND C.TABELA in  ('NOTA_CREDITOS_DOCS', 'VENDAS_DEVOLUCAOS')
            AND C.PERSONA_ID = #{params[:persona_id]}

            GROUP BY 1, 2, 3"

    @pagos_antecipados = Cliente.find_by_sql(persona)
    render layout: 'consulta'
  end

  def send_mult_prods

    @venda = Venda.find(params[:venda_id])
    vp = []
    params["itens"].each do |p|

     vp_create = VendasProduto.create(venda_id: params[:venda_id], 
        moeda: params[:moeda], 
        data: params[:data],
        deposito_id: Deposito.where(unidade_id: current_unidade.id, seta_produto: 1).first.id,
        produto_id: p.last["produto_id"],
        produto_nome: p.last["produto_nome"],
        quantidade: p.last["quantidade"],
        unitario_guarani: p.last["preco"],
        preco_guarani: p.last["preco"],
        total_guarani: (p.last["preco"].to_f *  p.last["quantidade"].to_f ),

      )
     
     vp += [vp_create.id]

     puts "___________#{vp}"
    end

    @vendas_produtos = VendasProduto.where(id: vp)

    respond_to do |format|
      format.js
    end

  end

  def update_set_print
    vp = VendasProduto.joins(:produto).select("vendas_produtos.id, vendas_produtos.print, vendas_produtos.venda_id, vendas_produtos.produto_id, vendas_produtos.unitario_guarani, vendas_produtos.quantidade, vendas_produtos.preco_guarani").where("vendas_produtos.venda_id = #{params[:venda_id]} and produtos.preparacao = true and vendas_produtos.print = false")

    list = vp.map {|u| Hash[ id: u.id]}
    return render :json => { :produtos => list}

  end

  def send_print
    render :layout => 'consulta'
  end

  def gerar_cashback
    venda = Venda.find(params[:id])
    cashback_gs    = (VendasProduto.sum(:cashback_gs, :conditions => ['venda_id = ?', venda.id ] ))
    per_api = PersonaApi.where(ruc: venda.persona.ruc).last
    MovVantagen.create(cod_proc: venda.id, sigla_proc: 'VT', persona_id: per_api.id, data: venda.data, descricao: "Cashback Generado, refente a venta #{venda.id}", titulo: "Cashback de #{ActionController::Base.helpers.number_to_currency(cashback_gs, format: '%n', precision: 0 ) } Generaro!", tipo_promo: 0, valor_gs: cashback_gs)


    data = { message:{
                to: per_api.token_device,
                notification:{
                  body: "Cashback Generado, refente a venta #{venda.id}",
                  title: "Cashback de #{ActionController::Base.helpers.number_to_currency(cashback_gs, format: '%n', precision: 0 ) } Generaro!",
                }
              }
            }

    NoftApp.create(cod_proc: venda.id, sigla_proc: 'VT', persona_id: per_api.id, descricao: "Cashback Generado, refente a venta #{venda.id}", titulo: "Cashback de #{ActionController::Base.helpers.number_to_currency(cashback_gs, format: '%n', precision: 0 ) } Generaro!")

    url = URI("https://fcm.googleapis.com/fcm/send")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["authorization"] = "key=AAAAcly59UY:APA91bFkaoOrlj5TW_fFDvuUJncMrOXlBg0dZd2ZaUcT_n2wG8L5PA-NvUrTfLCOEGaBWGQGz7dpjtz0OaJDN3Z2Vz7uhQdLDhCoXGgX6L00j9Z9ygTZ7dNuSHueo9CRKgI3HGr2AHYe"
    request["content-type"] = 'application/json'
    # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
    puts data[:message].to_json
    request.body = data[:message].to_json
    puts '----------------------------------------------------------------------'
    response = http.request(request)
    puts get_resp = JSON.parse(response.body)

    redirect_to "/vendas/#{venda.id}/financas"
  end

  def em_curso
    sql = "SELECT V.ID,
                  VD.NOME AS VENDEDOR,
                  V.DATA,
                  C.NOME AS CLIENTE,
                  V.MOEDA,
                  (SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS QTD,
                  (SELECT SUM(VP.TOTAL_GUARANI) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS TOT_GS,
                  (SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS TOT_US
            FROM VENDAS V
            INNER JOIN PERSONAS C
            ON C.ID = V.PERSONA_ID

            INNER JOIN PERSONAS VD
            ON VD.ID = V.VENDEDOR_ID

            WHERE V.UNIDADE_ID = #{current_unidade.id}
            AND (SELECT COUNT(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID) = 0
            AND (SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) > 0
            AND V.FINALIDADE = 0
            ORDER BY V.DATA DESC,V.PERSONA_ID, V.ID DESC"
    @vendas_pendentes = Venda.paginate_by_sql(sql, page: params[:page], :per_page => 35)
  end

  def painel_cobranca_venda   
  end
 

  def busca_painel_cobranca_venda
    cm = "AND CT.NOME = '#{params[:filtro_comanda]}'" unless params[:filtro_comanda].blank?
    sql = "SELECT V.ID,
                  VD.NOME AS VENDEDOR,
                  V.DATA,
                  C.NOME AS CLIENTE,
                  V.MOEDA,
                  V.OBS,
                  CT.NOME AS CARTAO_NOME,
                  (SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS QTD,
                  (SELECT SUM(VP.TOTAL_GUARANI) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS TOT_GS,
                  (SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS TOT_US
            FROM VENDAS V
            INNER JOIN PERSONAS C
            ON C.ID = V.PERSONA_ID

            INNER JOIN PERSONAS VD
            ON VD.ID = V.VENDEDOR_ID

            LEFT JOIN CARTAOS CT
            ON CT.ID = V.CARTAO_ID

            WHERE V.UNIDADE_ID = #{current_unidade.id}
            AND (SELECT COUNT(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID) = 0
            AND (SELECT COUNT(VP.ID) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) > 0
            #{cm}
            ORDER BY V.DATA DESC,V.PERSONA_ID, V.ID DESC"
    @vendas_pendentes = Venda.paginate_by_sql(sql, page: params[:page], :per_page => 30)
    render :layout => false
  end

  def busca_pago_antecipado

    @venda = Venda.find_by_sql("SELECT SUM(TOTAL_GUARANI) AS TOT_GUARANI,
                                       SUM(TOTAL_DOLAR) AS TOT_DOLAR
                                FROM VENDAS_PRODUTOS 
                                WHERE VENDA_ID = #{params[:venda_id]}").first

    persona = "SELECT C.DOCUMENTO_NUMERO_01,
                C.DOCUMENTO_NUMERO_02,
                C.DOCUMENTO_NUMERO,
                SUM(C.DIVIDA_DOLAR) AS DIVIDA_DOLAR,
                SUM(C.COBRO_DOLAR) AS COBRO_DOLAR,
                SUM(C.DIVIDA_GUARANI) AS DIVIDA_GUARANI,
                SUM(C.COBRO_GUARANI) AS COBRO_GUARANI
            FROM CLIENTES C  
            
            WHERE C.LIQUIDACAO = 0
            AND C.FORMA_PAGO_ID = 12
            AND C.PERSONA_ID = #{params[:persona_id]}

            GROUP BY 1, 2, 3"

    @pagos_antecipados = Cliente.find_by_sql(persona)
    render layout: 'consulta'
  end

  def verifica_financas
    fin = Venda.find_by_sql("SELECT COUNT(ID) FROM VENDAS_FINANCAS WHERE VENDA_ID = #{params[:venda_id]}").first
 
    return render :text => fin.count
  end

  def busca_placas
    @placas = PersonaRodado.where('persona_id = ?',params[:persona_id])
    render :layout => 'consulta'
  end

  def lista_mapa_mesas
    @venda_config = VendasConfig.where(unidade_id: current_unidade.id).last
    ct = "and nome ILIKE '%#{params[:cartao_nome]}%'" unless params[:cartao_nome].blank?
    @mesas = Cartao.where("UNIDADE_ID = #{current_unidade.id} and status = true #{ct}").order('id')
    render layout: false
  end

  def mapa_mesas
    @venda_config = VendasConfig.where(unidade_id: current_unidade.id).last
    sql = "SELECT V.ID,
               V.DATA,
               V.MOEDA,
               V.PERSONA_NOME,
               V.TIPO,
               V.FINALIDADE,
               V.OP,
               V.OBS,
               V.CREATED_AT,
               V.NOME_REF,
               CT.NOME AS CARTAO_NOME,
               S.NOME AS SETOR_NOME,
               (SELECT SUM(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID) AS FIN,
               (SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS QTD,
               (SELECT SUM(VP.TOTAL_GUARANI) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS TOT_GS,
               (SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS TOT_US
        FROM VENDAS V
        LEFT JOIN PERSONAS VD
        ON V.VENDEDOR_ID = VD.ID

        LEFT JOIN CARTAOS CT
        ON CT.ID = V.CARTAO_ID

        LEFT JOIN SETORS S
        ON S.ID = V.SETOR_ID


        WHERE CT.UNIDADE_ID = #{current_unidade.id} and coalesce((SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID),0) > 0
        AND coalesce((SELECT SUM(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID),0) = 0

        ORDER BY 7, 9 desc

           "
    @vendas = Venda.find_by_sql(sql)

    if current_unidade.id.to_i == 1
    sql = "
          SELECT V.ID, 
                 C.NOME AS CARTAO_NOME,
                 VP.PRODUTO_NOME,
                 VP.QUANTIDADE,
                 VP.CREATED_AT,
                 VP.OBS,
                 VP.STATUS_PREPARO
          FROM VENDAS_PRODUTOS VP

          INNER JOIN VENDAS V
          ON V.ID = VP.VENDA_ID

          INNER JOIN CARTAOS C
          ON C.ID = V.CARTAO_ID

          INNER JOIN PRODUTOS P
          ON P.ID = VP.PRODUTO_ID
            
          WHERE V.UNIDADE_ID = 10 AND VP.STATUS_PREPARO IN (0,1)
          AND P.PREPARACAO = TRUE
          AND V.OP = TRUE
          ORDER BY 5 

    "      
    else
    sql = "
          SELECT V.ID, 
                 C.NOME AS CARTAO_NOME,
                 VP.PRODUTO_NOME,
                 VP.QUANTIDADE,
                 VP.CREATED_AT,
                 VP.OBS,
                 VP.STATUS_PREPARO
          FROM VENDAS_PRODUTOS VP

          INNER JOIN VENDAS V
          ON V.ID = VP.VENDA_ID

          INNER JOIN CARTAOS C
          ON C.ID = V.CARTAO_ID

          INNER JOIN PRODUTOS P
          ON P.ID = VP.PRODUTO_ID
            
          WHERE V.UNIDADE_ID = #{current_unidade.id} AND VP.STATUS_PREPARO IN (0,1)
          AND P.PREPARACAO = TRUE
          AND V.OP = TRUE
          ORDER BY 5 

    "      
    end

    @produtos = VendasProduto.find_by_sql(sql)

    render layout: 'crm'
  end

  def valida_processo

    @venda = Venda.find(params[:id])
    
    if @venda.op == true #re-abre venda
      @venda.update_attributes(op: false)
      redirect_to :back
    else
    
      @venda.update_attributes(op: true) #fecha venda
      vd_prod = VendasProduto.where(venda_id: @venda.id, op: false )

      vd_prod.each do |vdp|
        vdp.update_attributes(op: true)
      end

      #se não tiver nenhum produto, reseta o cartão
      if VendasProduto.where(venda_id: @venda.id ).count(:id).to_i == 0
        unless @venda.cartao_id.nil?
          @venda.cartao.update_attributes(status_op: 0, venda_id: 0)
          @venda.update_attributes(cartao_id: 0, cartao_nome: '')  
        end
      end

      render :json => {:status => :ok}
    end
  end

  def comprovante_entrega
    @venda = Venda.find(params[:id])

    respond_to do |format|
      format.html do
        render  :pdf                    => "comprovante_entrega",
                :layout                 => "layer_relatorios",
                :page_size              => 'A4',
                :margin => {:top        => '0.20in',
                            :bottom     => '0.27in',
                            :left       => '0.10in',
                            :right      => '0.10in'},
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :spacing    => 0},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
  end


  def comprovante01
      @venda           = Venda.find(params[:id])
      @venda_produtos   = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
      @produto_sum_gs  = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_us  = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @venci           = VendasFinanca.last(:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      @vencimento           = VendasFinanca.last(:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      render :layout => false
  end

 def comprovante02
      @venda           = Venda.find(params[:id])
      @venda_produtos   = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
      @produto_sum_gs  = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_us  = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @venci           = VendasFinanca.last(:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      @vencimento           = VendasFinanca.last(:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      render :layout => false
  end

  def gerador_codigo
    @venda = Venda.find(params[:id])


 sql = "SELECT VP.PRODUTOS_GRADE_ID,
               MAX(VP.PRODUTO_ID) AS PRODUTO_ID,
               MAX(VP.PRODUTO_ID) AS PRODUTO_ID,
               MAX(VP.FABRICANTE_COD) AS FABRICANTE_COD,
               MAX(VP.COR_ID) AS COR_ID,
               MAX(VP.TAMANHO_ID) AS TAMANHO_ID,
               MAX(VP.TAMANHO_NOME) AS TAMANHO_NOME,
               MAX(VP.PRODUTO_NOME) AS PRODUTO_NOME,
               MAX(VP.COR_NOME) AS COR_NOME,
               MAX(VP.UNITARIO_DOLAR) AS UNITARIO_DOLAR,
               MAX(VP.UNITARIO_GUARANI) AS UNITARIO_GUARANI,
               SUM(VP.QUANTIDADE) AS QUANTIDADE,
               SUM(VP.TOTAL_DOLAR) AS TOTAL_DOLAR,
               SUM(VP.TOTAL_GUARANI) AS TOTAL_GUARANI
            FROM VENDAS_PRODUTOS VP
            WHERE VP.VENDA_ID = #{@venda.id}
            GROUP BY 1
            ORDER BY 1"
            @vendas_produtos = VendasProduto.find_by_sql(sql)
    render layout: false
  end

  def update_individual
    VendasFatura.update(params[:faturas].keys, params[:faturas].values)
    redirect_to("/vendas/"<< params[:id].to_s<< '/vendas_financa')
  end

  def colaboradores
    @venda = Venda.find(params[:id])
  end

  def gerador_cotas
    @venda = Venda.find(params[:id])

    @produto_sum_dolar   = VendasProduto.sum(:total_dolar, :conditions => ['venda_id = ?',params[:id]] )
    @produto_sum_guarani = VendasProduto.sum(:total_guarani, :conditions => ['venda_id = ?',params[:id]] )
    @contado_sum_dolar   = VendasFinanca.sum(:valor_dolar_contado, :conditions => ['venda_id = ?',params[:id]] )
    @contado_sum_guarani = VendasFinanca.sum(:valor_guarani_contado, :conditions => ['venda_id = ?',params[:id]] )

  end

  def gerar_cotas_credito
    @venda = Venda.find(params[:id])
    @vendas_financa = Venda.gerador_cotas(params)

    respond_to do |format|
      format.html {  redirect_to("/vendas/" << @venda.id.to_s << '/financas') }
      format.js
    end
  end

  def novo_produto
    @venda = Venda.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @venda }
    end
  end

  def vendas_financa
      @venda = Venda.find(params[:id])
      @cliente_saldo  = (@venda.persona.limite_credito.to_f - Cliente.sum('divida_guarani - cobro_guarani',:conditions => ["liquidacao = 0 and persona_id = ?", @venda.persona_id]).to_f)

      @saldo_antecipado = Cliente.sum("cobro_guarani - divida_guarani", conditions: "PERSONA_ID = #{@venda.persona_id} AND DOCUMENTO_NUMERO = ('999' || CAST(#{@venda.persona_id} AS VARCHAR) )" )
      @fts = FormFiscal.where("sigla_proc = 'VT' AND cod_proc = #{@venda.id} AND STATUS != 0").select("id,impressao, cod_proc, tot_gs, doc_01, doc_02, doc, status, autorizacao").order('id desc ')
      @vendas_fs      = VendasFatura.where("venda_id = #{params[:id]}").order('1 desc')
      @produto_count       = VendasProduto.sum(:quantidade,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_dolar   = (VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] ) -  @venda.desconto_us.to_f)
      @produto_sum_guarani = (VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] ) -  @venda.desconto_gs.to_f)
      @produto_sum_real    = VendasProduto.sum(:total_real, :conditions => ['venda_id = ?',params[:id]] )

      @produto_sum_exet_us = VendasProduto.sum('total_dolar' ,:conditions => ["taxa = 0 AND venda_id = ?",params[:id]] )
      @produto_sum_exet_gs = VendasProduto.sum('total_guarani' ,:conditions => ["taxa = 0 AND venda_id = ?",params[:id]] )

      @produto_sum_grav10_us = VendasProduto.sum('total_dolar' ,:conditions => ["taxa = 10 AND venda_id = ?",params[:id]] )
      @produto_sum_grav10_gs = VendasProduto.sum('total_guarani' ,:conditions => ["taxa = 10 AND venda_id = ?",params[:id]] )
      @produto_sum_grav05_us = VendasProduto.sum('total_dolar',:conditions => ["taxa = 5 AND venda_id = ?",params[:id]] )
      @produto_sum_grav05_gs = VendasProduto.sum('total_guarani',:conditions => ["taxa = 5 AND venda_id = ?",params[:id]] )

      @produto_sum_iva10_us = VendasProduto.sum('total_dolar / 11' ,:conditions => ["taxa = 10 AND venda_id = ?",params[:id]] )
      @produto_sum_iva10_gs = VendasProduto.sum('total_guarani / 11' ,:conditions => ["taxa = 10 AND venda_id = ?",params[:id]] )
      @produto_sum_iva05_us = VendasProduto.sum('total_dolar / 21',:conditions => ["taxa = 5 AND venda_id = ?",params[:id]] )
      @produto_sum_iva05_gs = VendasProduto.sum('total_guarani / 21',:conditions => ["taxa = 5 AND venda_id = ?",params[:id]] )

      @count_all           = VendasFinanca.count(:id,:conditions => ['venda_id = ?',params[:id]] )

      @cred_us = VendasFinanca.sum(:valor_dolar, :conditions=> ["cred_deb = 0 AND venda_id = #{@venda.id}"])
      @deb_us  = VendasFinanca.sum(:valor_dolar, :conditions=> ["cred_deb = 1 AND venda_id = #{@venda.id}"])

      @cred_gs = VendasFinanca.sum(:valor_guarani, :conditions=> ["cred_deb = 0 AND venda_id = #{@venda.id}"])
      @deb_gs  = VendasFinanca.sum(:valor_guarani, :conditions=> ["cred_deb = 1 AND venda_id = #{@venda.id}"])

      @cred_rs = VendasFinanca.sum(:valor_real, :conditions=> ["cred_deb = 0 AND venda_id = #{@venda.id}"])
      @deb_rs  = VendasFinanca.sum(:valor_real, :conditions=> ["cred_deb = 1 AND venda_id = #{@venda.id}"])

      @cred_ps = VendasFinanca.sum(:valor_peso, :conditions=> ["cred_deb = 0 AND venda_id = #{@venda.id}"])
      @deb_ps  = VendasFinanca.sum(:valor_peso, :conditions=> ["cred_deb = 1 AND venda_id = #{@venda.id}"])
      @produto_desc_guarani = VendasFinanca.sum(:desconto, :conditions => ['venda_id = ?',params[:id]] )

      @tela = 'cliente'

      if @venda.tipo_venda.to_i == 1
        render :layout => 'modal'
      else
        render :layout => 'layout_vendas'
      end

      session[:pagina] = '2'
  end


  def financas
      @venda = Venda.find(params[:id])
      @cliente_saldo  = (@venda.persona.limite_credito.to_f - Cliente.sum('divida_guarani - cobro_guarani',:conditions => ["liquidacao = 0 and persona_id = ?", @venda.persona_id]).to_f)
      @saldo_cashback = MovVantagen.where(tipo_promo: 1, persona_id: @venda.persona_id).sum(:valor_gs)
      @cashback_gs    = (VendasProduto.sum(:cashback_gs, :conditions => ['venda_id = ?',params[:id]] ))
      @saldo_antecipado = Cliente.sum("cobro_guarani - divida_guarani", conditions: "PERSONA_ID = #{@venda.persona_id} AND DOCUMENTO_NUMERO = ('999' || CAST(#{@venda.persona_id} AS VARCHAR) )" )
      @fts = FormFiscal.where("sigla_proc = 'VT' AND cod_proc = #{@venda.id} AND STATUS != 0").select("cdc, tipo_emissao, ruc, persona_nome, id,impressao, cod_proc, tot_gs, doc_01, doc_02, doc, status, autorizacao").order('id desc ')
      @vendas_fs      = VendasFatura.where("venda_id = #{params[:id]}").order('1 desc')
      @produto_count  = VendasProduto.sum(:quantidade,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_us = (VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] ) -  @venda.desconto_us.to_f)
      @produto_sum_gs = (VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] ) -  @venda.desconto_gs.to_f)
      @produto_sum_rs = (VendasProduto.sum(:total_real, :conditions => ['venda_id = ?',params[:id]] )  -  @venda.desconto_rs.to_f)

      @cred_us = VendasFinanca.sum(:valor_dolar, :conditions=> ["cred_deb = 0 AND venda_id = #{@venda.id}"])
      @deb_us  = VendasFinanca.sum(:valor_dolar, :conditions=> ["cred_deb = 1 AND venda_id = #{@venda.id}"])

      @cred_gs = VendasFinanca.sum(:valor_guarani, :conditions=> ["cred_deb = 0 AND venda_id = #{@venda.id}"])
      @deb_gs  = VendasFinanca.sum(:valor_guarani, :conditions=> ["cred_deb = 1 AND venda_id = #{@venda.id}"])

      @cred_rs = VendasFinanca.sum(:valor_real, :conditions=> ["cred_deb = 0 AND venda_id = #{@venda.id}"])
      @deb_rs  = VendasFinanca.sum(:valor_real, :conditions=> ["cred_deb = 1 AND venda_id = #{@venda.id}"])

      @cred_ps = VendasFinanca.sum(:valor_peso, :conditions=> ["cred_deb = 0 AND venda_id = #{@venda.id}"])
      @deb_ps  = VendasFinanca.sum(:valor_peso, :conditions=> ["cred_deb = 1 AND venda_id = #{@venda.id}"])

      @saldo_gs = (@produto_sum_gs.to_f - (@cred_gs.to_f - @deb_gs.to_f))
      @saldo_us = (@produto_sum_us.to_f - (@cred_us.to_f - @deb_us.to_f))
      @saldo_rs = (@produto_sum_rs.to_f - (@cred_rs.to_f - @deb_rs.to_f))

      @venda_config = VendasConfig.where(unidade_id: current_unidade.id).last


      @tela = 'cliente'

      if @venda.tipo_venda.to_i == 1
        render :layout => 'modal'
      else
        render :layout => 'layout_vendas'
      end

      session[:pagina] = '2'
  end

  def vendas_entrada_produto               #
      @venda = Venda.find(params[:id])
      @produto_count       = VendasProduto.sum(:quantidade,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_dolar   = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_guarani = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_iva_guarani = VendasProduto.sum('iva_guarani * quantidade',:conditions => ['venda_id = ?',params[:id]] )
      @produto_iva_dolar   = VendasProduto.sum('iva_dolar * quantidade',:conditions => ['venda_id = ?',params[:id]] )
      @count               = VendasFinanca.count(:id,:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      @count_all           = VendasFinanca.count(:id,:conditions => ['venda_id = ?',params[:id]] )
      render :layout => 'layout_vendas'
  end

  def novo_financa                         #
      @venda = Venda.find(params[:id])
      @cota_count          = VendasFinanca.count(:id,:conditions => ['venda_id = ?',params[:id]] )
      @cota_total          = @cota_count +1
  end

  # FATURAS PENDENTES-------------------------------------------------------

  def faturas_pendentes                    #
      @vendas = Venda.all(:conditions => ["fatura = 0"])
      render :layout => 'application'
  end

  def filtro_faturas_pendentes             #
      @vendas = Venda.find(params[:venda_ids])
      render :layout => 'application'
  end

  def update_faturas_pendentes             #
      @vendas          = Venda.find(params[:venda_ids])

      @vendas.each do |venda|
          venda.update_attributes!(params[:venda].reject { |k,v| v.blank? })
      end
      flash[:notice] = 'Productos Facturados'
      redirect_to  :action => 'filtro_faturas_pendentes_comprovante', :paras =>  params[:venda_ids]
  end

  def filtro_faturas_pendentes_comprovante #
      @vendas = Venda.find(params[:paras])
      render :layout => 'application'
  end

  def detalhes_produto                     #

      @produtos   = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]] )
      render :layout => 'consulta'
  end

  def comprovante
      @venda           = Venda.find(params[:id])
      @venda_produtos   = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
      @produto_sum_gs  = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_us  = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @venci           = VendasFinanca.last(:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      render :layout => false
  end

  def ticket
      @venda           = Venda.find(params[:id])
      @venda_produto   = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
      @produto_sum_gs  = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_us  = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @fin_sum_gs  = VendasFinanca.sum(:cota_guarani_01,:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      @fin_sum_us  = VendasFinanca.sum(:cota_dolar_01,:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      @venci           = VendasFinanca.last(:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      render :layout => false
  end

  def ticket_cozinha
    @venda = Venda.find(params[:id])
    unless params[:painel_preparo].blank?
      pp = PainelPreparo.find(params[:painel_preparo])
      grupos = "AND P.SUB_GRUPO_ID IN (#{pp.grupo_ids}) AND VP.ID = ANY(ARRAY#{params[:vendas_produto_ids]})" 
    else
      grupos = ""
    end

    sp = "AND P.SET_PRINT = '#{params[:set_print]}'" unless params[:set_print].blank?
    sql = "SELECT VP.PRODUTO_NOME,
                  VP.QUANTIDADE,
                  VP.OBS,
                  VP.ID,
                  VP.PRINT,
                  VP.VENDA_ID,
                  VP.PRODUTO_ID,
                  VP.UNITARIO_GUARANI,
                  VP.PRECO_GUARANI,
                  VP.DATA
            FROM VENDAS_PRODUTOS VP
            INNER JOIN PRODUTOS P
            ON P.ID = VP.PRODUTO_ID
            WHERE P.PREPARACAO = TRUE
            AND VP.PRINT = FALSE
            AND VP.VENDA_ID = #{@venda.id}
            #{sp} #{grupos}
            ORDER BY VP.ID"

    @produtos = VendasProduto.find_by_sql(sql)

    @produtos.each do |v|
      v.update_attribute(:print, true)
      v.update_attribute(:status_preparo, 1)
    end

    render :layout => false
  end

  def pagare
      @venda           = Venda.find(params[:id])
      @produtos        = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
      @produto_sum_gs  = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_us  = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @venci           = VendasFinanca.where("venda_id = #{params[:id]} AND tipo = 1").last
      @saldo_pendente  = Cliente.where("persona_id = #{@venda.persona_id} and liquidacao = 0").sum("divida_guarani - cobro_guarani")
      render :layout => false
  end

   def pagaret
      @venda           = Venda.find(params[:id])
      @venda_produtos  = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
      @produto_sum_gs  = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_us  = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @venci           = VendasFinanca.where("venda_id = #{params[:id]} AND tipo = 1").last
      @saldo_pendente  = Cliente.where("persona_id = #{@venda.persona_id} and liquidacao = 0").sum("divida_guarani - cobro_guarani")
      render :layout => false
  end

  def requerimento_ordem_servico                          #
      @venda           = Venda.find(params[:id])
      render :layout => false
  end


  def comprovante_fatura_pendentes         #
      @vendas = Venda.find(params[:paras])
      @venda_produto      = VendasProduto.all(:total_dolar,:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
      @produto_sum_gs     = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_iva5   = VendasProduto.sum(:iva_guarani,:conditions => ['taxa = 5  and venda_id = ?',params[:id]] )
      @produto_sum_iva10  = VendasProduto.sum(:iva_guarani,:conditions => ['taxa = 10 and venda_id = ?',params[:id]] )
      @produto_sum_iva80  = VendasProduto.sum(:iva_guarani,:conditions => ['taxa = 80 and venda_id = ?',params[:id]] )
      @produto_total_iva  = @produto_sum_iva5 + @produto_sum_iva10
      render :layout => false
  end

  def fatura
      agrupamento = "and count_fatura = #{params[:indi]}" unless params[:indi].blank?
      agrupamento_list = "AND VP.COUNT_FATURA = #{params[:indi]}" unless params[:indi].blank?
      @venda                = Venda.find(params[:id])
      @produto_sum_dolar    = VendasProduto.sum(:total_dolar,:conditions => ["venda_id = ?",params[:id]] )
      @produto_sum_guarani  = VendasProduto.sum(:total_guarani,:conditions => ["venda_id = ?",params[:id]] )
      @produto_sum_iva10_us = VendasProduto.sum('total_dolar / 11' ,:conditions => ["taxa = 10 AND venda_id = ?",params[:id]] )
      @produto_sum_iva10_gs = VendasProduto.sum('total_guarani / 11' ,:conditions => ["taxa = 10 AND venda_id = ?",params[:id]] )
      @produto_sum_iva05_us = VendasProduto.sum('total_dolar / 21',:conditions => ["taxa = 5 AND venda_id = ?",params[:id]] )
      @produto_sum_iva05_gs = VendasProduto.sum('total_guarani / 21',:conditions => ["taxa = 5 AND venda_id = ?",params[:id]] )
      @produto_sum_iva80_us = VendasProduto.sum('iva_dolar * quantidade',:conditions => ["taxa = 80 AND venda_id = ?",params[:id]] )
      @produto_sum_iva80_gs = VendasProduto.sum('iva_guarani * quantidade',:conditions => ["taxa = 80 AND venda_id = ?",params[:id]] )

      sql = "SELECT VP.FABRICANTE_COD,
                MAX(VP.TAXA) AS TAXA,
                SUM(VP.QUANTIDADE) AS QUANTIDADE,
                MAX(VP.PRODUTO_NOME) AS PRODUTO_NOME,
                MAX(VP.UNITARIO_DOLAR) AS UNITARIO_DOLAR,
                MAX(VP.UNITARIO_GUARANI) AS UNITARIO_GUARANI,
                SUM(VP.TOTAL_DOLAR) AS TOTAL_DOLAR,
                SUM(VP.TOTAL_GUARANI) AS TOTAL_GUARANI
            FROM VENDAS_PRODUTOS VP
            WHERE VP.VENDA_ID = #{@venda.id} #{agrupamento_list}
            GROUP BY 1
            ORDER BY 1"
            @venda_produto = VendasProduto.find_by_sql(sql)
      @form                 = Form.find(:first,:select => 'form_venda_fatura')

      render :layout => false
  end

  def index
    sql = "SELECT COUNT(V.ID) AS COUNT_VENDAS
            FROM VENDAS V
            INNER JOIN PERSONAS C
            ON C.ID = V.PERSONA_ID

            INNER JOIN PERSONAS VD
            ON VD.ID = V.VENDEDOR_ID

            WHERE V.UNIDADE_ID = #{current_unidade.id}
            AND (SELECT COUNT(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID) = 0
            AND (SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) > 0
            AND V.FINALIDADE = 0"

    @em_curso = Venda.find_by_sql(sql)
  end

  def busca_vendas
    params[:unidade] = current_unidade.id
    @vendas = Venda.filtro_vendas(params)
    respond_to do |format|
        format.html { render :layout => false}
        format.js { render :layout => false }
    end
  end

 def abastecidas

    sql = "SELECT
                A.ID AS ID,
                P.NOME AS FRENTISTA,
                B.NOME AS BICO,
                DP.PRODUTO_ID AS PRODUTO_ID,
                B.DEPOSITO_ID AS DEPOSITO_ID,
                (A.LITROS) AS LITROS,
                B.PRECO_GS AS PRECO,
                B.ID AS BICO_ID,
                A.DATA,
                A.HORA,
                A.CHAVE,
                PD.NOME AS PRODUTO_NOME,
                (B.PRECO_GS * (A.LITROS)) AS TOTAL,
                A.STATUS
                 FROM ABASTECIDAS A
                 INNER JOIN BICOS B
                 ON B.UNIDADE_ID = #{current_unidade.id} AND A.BICO = B.BICO_AUTO
                 LEFT JOIN DEPOSITO_PRODUTOS DP
                 ON B.DEPOSITO_ID = DP.DEPOSITO_ID
                 LEFT JOIN CHAVES C
                 ON C.NOME = A.CHAVE
                 LEFT JOIN PRODUTOS PD
                 ON PD.ID = DP.PRODUTO_ID
                 LEFT JOIN PERSONAS P
                 ON P.ID = C.PERSONA_ID
                 WHERE A.STATUS <> 1
                 AND A.LITROS > 0.001
                 AND A.UNIDADE_ID = #{current_unidade.id}
                 ORDER BY  9 DESC, 10 DESC, 2
                 "
    @abastecidas = Abastecida.find_by_sql(sql)
    respond_to do |format|
      format.js
    end
  end

  def show
    @venda = Venda.find(params[:id])
    @venda_config = VendasConfig.where(unidade_id: current_unidade.id).last
    @vp  =  VendasProduto.find_all_by_venda_id(params[:id],:select =>'id,moeda,fabricante_cod,deposito_nome,produto_nome,quantidade,unitario_dolar,total_dolar,unitario_guarani,total_guarani,total_desconto,iva_dolar,iva_guarani',:order => 'id')

    @total_produto     =  VendasProduto.sum(:quantidade,    :conditions => ['venda_id = ?',params[:id]])
    @total_dolar       =  VendasProduto.sum(:total_dolar,   :conditions => ['venda_id = ?',params[:id]])
    @total_guarani     =  VendasProduto.sum(:total_guarani, :conditions => ['venda_id = ?',params[:id]])
    @total_real        =  VendasProduto.sum(:total_real, :conditions => ['venda_id = ?',params[:id]])

    render :layout => 'layout_vendas_produtos'
  end

  def add_pedidos
    @venda = Venda.find(params[:id])

    @insert_lanz = Presupuesto.find(params[:lanz_ids])

    @insert_lanz.each do |il|
      VendasPedido.create(  :venda_id         => @venda.id,
                            :presupuesto_id => il.id,
                            :vendedor_id => il.vendedor_id,
                            :indicador_id => il.indicador_id
                          )
    end
    redirect_to("/vendas/#{@venda.id}/pedidos")
  end


  def pedidos
      @venda     = Venda.find(params[:id])

      @pedidos         =  Presupuesto.where("persona_id = #{@venda.persona_id} and status != 3")
      @pedidos_faturas =  VendasPedido.where("venda_id = #{@venda.id}")

      if @pedidos_faturas.count > 0
      dp = Deposito.find_by_unidade_id(current_unidade.id)
      sql = "SELECT PP.PRESUPUESTO_ID,
                    PP.FABRICANTE_COD,
                    PP.PRODUTO_ID,
                    P.NOME AS PRODUTO_NOME,
                    PP.TOTAL_DOLAR,
                    PP.TOTAL_GUARANI,
                    (PP.QUANTIDADE - coalesce((SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.PRESUPUESTO_PRODUTO_ID = PP.ID),0)) AS QUANTIDADE,
                    coalesce((SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.DEPOSITO_ID = #{dp.id} AND S.PRODUTO_ID = PP.PRODUTO_ID AND S.DATA <= '#{@venda.data}'),0) AS STOCK
            FROM PRESUPUESTO_PRODUTOS PP
            INNER JOIN PRODUTOS P
            ON PP.PRODUTO_ID = P.ID
            WHERE PRESUPUESTO_ID IN (#{@pedidos_faturas.map  { |t| t.presupuesto_id }.join(',')})
            ORDER BY PP.PRESUPUESTO_ID, PP.ID"
      @produtos_pedido_vendas = PresupuestoProduto.find_by_sql(sql)
      end

      render :layout => 'layout_vendas'
  end

  def add_fatura
    @venda = Venda.find(params[:id])
      @pedidos_faturas =  VendasPedido.where("venda_id = #{@venda.id}")
      dp = Deposito.find_by_unidade_id(current_unidade.id)
      sql = "SELECT
                    PP.ID,
                    PP.PRESUPUESTO_ID,
                    PP.FABRICANTE_COD,
                    PP.PRODUTO_ID,
                    PP.UNITARIO_DOLAR,
                    PP.TOTAL_DOLAR,
                    PP.UNITARIO_GUARANI,
                    PP.TOTAL_GUARANI,
                    PP.PROMEDIO_GUARANI,
                    PP.PROMEDIO_DOLAR,
                    P.NOME AS PRODUTO_NOME,
                    (PP.QUANTIDADE - coalesce((SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.PRESUPUESTO_PRODUTO_ID = PP.ID),0)) AS QUANTIDADE,
                    coalesce((SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.DEPOSITO_ID = #{dp.id} AND S.PRODUTO_ID = PP.PRODUTO_ID AND S.DATA <= '#{@venda.data}'),0) AS STOCK
            FROM PRESUPUESTO_PRODUTOS PP
            INNER JOIN PRODUTOS P
            ON PP.PRODUTO_ID = P.ID
            WHERE PRESUPUESTO_ID IN (#{@pedidos_faturas.map  { |t| t.presupuesto_id }.join(',')})"
      @produtos_pedido_vendas = PresupuestoProduto.find_by_sql(sql)

      @produtos_pedido_vendas.each do |il|

        if il.quantidade.to_f > 0 and il.stock.to_f > 0
          if il.quantidade.to_f >= il.stock.to_f
            saldo = il.stock.to_f

          elsif il.stock.to_f >= il.quantidade.to_f
            saldo = il.quantidade.to_f
            up_status = PresupuestoProduto.find_by_id(il.id)
            up_status.update_attribute :status, 1
          end
        end

        VendasProduto.create( :venda_id         => @venda.id,
                              :persona_id       => @venda.persona_id,
                              :data             => @venda.data,
                              :moeda            => @venda.moeda,
                              :cotacao          => @venda.cotacao,
                              :deposito_id      => dp.id,
                              :presupuesto_produto_id => il.id,
                              :presupuesto_id         => il.presupuesto_id,
                              :promedio_guarani       => il.promedio_guarani,
                              :promedio_dolar         => il.promedio_dolar,
                              :quantidade             => saldo.to_f,
                              :unitario_dolar         => il.unitario_dolar.to_f,
                              :preco_dolar            => il.unitario_dolar.to_f,
                              :total_dolar            => (saldo.to_f * il.unitario_dolar.to_f),
                              :unitario_guarani         => il.unitario_guarani.to_f,
                              :preco_guarani            => il.unitario_guarani.to_f,
                              :total_guarani            => (saldo.to_f * il.unitario_guarani.to_f),
                              :produto_id             => il.produto_id,
                              :produto_nome           => il.produto_nome,
                              :fabricante_cod         => il.fabricante_cod,

                            )
      end
    redirect_to("/vendas/#{@venda.id}")
  end

  def cond_liqs
      @venda     = Venda.find(params[:id])
      @cond_liqs         =  CondLiq.where("unidade_id = #{current_unidade.id} and persona_id = #{@venda.persona_id} and status != 1").order('data,id')
      @cond_liqs_faturas =  VendasCondLiq.where("venda_id = #{@venda.id}")
      if @cond_liqs_faturas.count > 0
      sql = "SELECT PP.COND_LIQ_ID,
                    PP.ID,
                    PP.PRODUTO_ID,
                    PP.FABRICANTE_COD,
                    PP.PRODUTOS_GRADE_ID,
                    PP.PRODUTO_NOME,
                    PP.COR_ID,
                    PP.COR_NOME,
                    PP.TAMANHO_ID,
                    PP.TAMANHO_NOME,
                    PP.QUANTIDADE,
                    PP.TOTAL_GS,
                    PP.UNITARIO_GS,
                    PP.TOTAL_US,
                    PP.UNITARIO_US
            FROM COND_LIQ_VENDIDOS PP
            WHERE COND_LIQ_ID IN (#{@cond_liqs_faturas.map  { |t| t.cond_liq_id }.join(',')})"
        @produtos_pedido_vendas = PresupuestoProduto.find_by_sql(sql)
      end
      render :layout => 'layout_vendas'
  end

  def add_cond_liqs
    @venda = Venda.find(params[:id])
    @insert_lanz = CondLiq.find(params[:lanz_ids])

    @insert_lanz.each do |il|
      VendasCondLiq.create(  :venda_id    => @venda.id,
                             :cond_liq_id => il.id
                          )
    end
    redirect_to("/vendas/#{@venda.id}/cond_liqs")
  end


  def add_cond_liq_fatura
    dp = Deposito.find_by_unidade_id(current_unidade.id)
    @venda = Venda.find(params[:id])
      @cond_liqs         =  CondLiq.where("persona_id = #{@venda.persona_id} and status != 1").order('data,id')
      @cond_liqs_faturas =  VendasCondLiq.where("venda_id = #{@venda.id}")
      sql = "SELECT PP.COND_LIQ_ID,
                    PP.ID,
                    PP.PRODUTO_ID,
                    PP.FABRICANTE_COD,
                    PP.PRODUTOS_GRADE_ID,
                    PP.PRODUTO_NOME,
                    PP.COR_ID,
                    PP.QUANTIDADE,
                    PP.COR_NOME,
                    PP.TAMANHO_ID,
                    PP.TAMANHO_NOME,
                    PP.TOTAL_GS,
                    PP.UNITARIO_GS,
                    PP.TOTAL_US,
                    PP.UNITARIO_US
            FROM COND_LIQ_VENDIDOS PP
            WHERE COND_LIQ_ID IN (#{@cond_liqs_faturas.map  { |t| t.cond_liq_id }.join(',')})"
      @produtos_pedido_vendas = CondLiqVendido.find_by_sql(sql)

      @produtos_pedido_vendas.each do |il|
        VendasProduto.create( :venda_id         => @venda.id,
                              :persona_id       => @venda.persona_id,
                              :data             => @venda.data,
                              :moeda            => @venda.moeda,
                              :cotacao          => @venda.cotacao,
                              :deposito_id      => dp.id,
                              :quantidade             => il.quantidade.to_f,
                              :unitario_dolar         => il.unitario_us.to_f,
                              :preco_dolar            => il.unitario_us.to_f,
                              :total_dolar            => (il.quantidade.to_f * il.unitario_us.to_f),
                              :unitario_guarani       => il.unitario_gs.to_f,
                              :preco_guarani          => il.unitario_gs.to_f,
                              :total_guarani          => (il.quantidade.to_f * il.unitario_gs.to_f),
                              :produto_id             => il.produto_id,
                              :produto_nome           => il.produto_nome,
                              :produtos_grade_id      => il.produtos_grade_id,
                              :cor_nome               => il.cor_nome,
                              :tamanho_nome           => il.tamanho_nome,
                              :cor_id                 => il.cor_id,
                              :tamanho_id             => il.tamanho_id,
                              :fabricante_cod         => il.fabricante_cod,

                            )
      end
    redirect_to("/vendas/#{@venda.id}")
  end


  def visualizacao
      @venda = Venda.find(params[:id])
      @vp    =  VendasProduto.find_all_by_venda_id(params[:id],:select =>'id,moeda,fabricante_cod,deposito_nome,produto_nome,quantidade,unitario_dolar,total_dolar,unitario_guarani,total_guarani,total_desconto,iva_dolar,iva_guarani',:order => 'id')
      @vfc   =  VendasFinanca.find_all_by_venda_id(params[:id], :conditions => ['tipo = 0'])

      @vfcr  =  VendasFinanca.find_all_by_venda_id(params[:id], :conditions => ['tipo = 1'])

      render :layout => 'layout_vendas'
  end

  def new
      @venda = Venda.new

      @vendas_config = VendasConfig.where(unidade_id: current_unidade.id).last
    if params[:tipo_venda] == '1'
      render layout: 'modal'
    else
      render :layout => 'layout_vendas'
    end

    session[:tela] == 'financeiro'
  end


  def edit

      @venda = Venda.find(params[:id])
      sql = "SELECT AC.ID,
                  (AC.ID || ' ' || AC.DATA || ' '  || ' ' || P.USUARIO_NOME || ' '  || TM.NOME || ' ' || T.NOME) AS CAIXA
          FROM ABERTURA_CAIXAS AC
          INNER JOIN TERMINALS TM
          ON TM.ID = AC.TERMINAL_ID
          INNER JOIN TURNOS T
          ON T.ID = AC.TURNO_ID
          INNER JOIN USUARIOS P
          ON P.ID = AC.USUARIO_ID
          WHERE AC.STATUS = TRUE
          AND AC.UNIDADE_ID = #{current_unidade.id}
          OR AC.ID = #{@venda.id}
          ORDER BY AC.DATA"
    @caixas = AberturaCaixa.find_by_sql(sql)
      render :layout => 'layout_vendas'
      session[:pagina] = '1'
      session[:tela] == 'financeiro'
  end

  def create
      @venda = Venda.new(params[:venda])
      @venda.usuario_created = current_user.id.to_i
      @venda.unidade_created = current_unidade.id.to_i
      @venda.unidade_id = current_unidade.id.to_i

      respond_to do |format|
          if @venda.save
            if @venda.pedido.to_i == 1
              format.html { redirect_to("/vendas/#{@venda.id}/pedidos") }
            else
              format.html { redirect_to(@venda) }
            end
          else
              format.html { render :action => "new" }
              format.xml  { render :xml => @venda.errors, :status => :unprocessable_entity }
          end
      end
  end

  def update
      @venda = Venda.find(params[:id])
      @venda.usuario_updated = current_user.id
      @venda.unidade_updated = current_unidade.id
      @venda.cartao.update_attributes(status_op: 0, venda_id: 0) unless @venda.cartao.nil?
      respond_to do |format|
          if @venda.update_attributes(params[:venda])
            #reserva cartao
             @venda.cartao.update_attributes(status_op: 1, venda_id: @venda.id) unless @venda.cartao.nil?
            if  params[:tela] == 'financas'
              format.html { redirect_to("/vendas/#{@venda.id}/financas") }
            elsif params[:tela] == 'cliente_p'
              format.html { redirect_to(@venda) }
            elsif params[:calc_desc] == 'true'
              format.html { redirect_to(venda_path(@venda, calc_desc: 'true')) }
            else
              format.html { redirect_to(@venda) }
            end

            format.json { head :no_content }
            format.js { head :no_content }

          else
              format.html { render :action => "edit" }
              format.xml  { render :xml => @venda.errors, :status => :unprocessable_entity }
          end
      end
  end

  def dynamic_venda_colecao
    @personas = Colecao.find_all_by_sub_grupo_id(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def dynamic_bandeira
    @bandeiras = CartaoBandeira.find_all_by_forma_pago_id(params[:id])
    respond_to do |format|
      format.js
    end
  end


  def destroy
      @venda = Venda.find(params[:id])
      begin
      @venda.destroy
      flash[:notice] = "Removido con Sucesso"
      rescue ActiveRecord::DeleteRestrictionError => e
        @venda.errors.add(:base, e)
        flash[:error] = "No es possible remover lo cadastro porque elle possui  un vinculo con otro cadastro"
      ensure
        redirect_to(vendas_url)
      end
  end
end
