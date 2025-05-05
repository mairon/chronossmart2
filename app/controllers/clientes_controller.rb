class ClientesController < ApplicationController

  def titulo_historico
    @clientes = Cliente.titulo_historico(params)
    render :layout => 'modal'
  end

  def resultado_acerto_modal
    respond_to do |format|
          if params[:tipo] == '1'
            format.xls
           else

          format.html do
            render  :pdf                    => "resultado_acerto_modal",
                    :layout                 => "layer_relatorios",
                    :orientation            => 'Landscape',
                    :margin => {:top        => '0.80in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},
                   :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :spacing    => 25},
                    :footer => {:font_name  => 'arial, 900',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "Chronos Smart - impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
      end
    end
  end


  def resultado_acerto_clientes
    respond_to do |format|
          if params[:tipo] == '1'
            format.html {
              xls = render_to_string :action => "resultado_acerto_clientes", :layout => false
              send_data(xls,:filename => "Acerto-#{params[:inicio]}-#{params[:final]}.xls")
            }
           else

          format.html do
            render  :pdf                    => "resultado_acerto_clientes",
                    :layout                 => "layer_relatorios",
                    :orientation            => 'Landscape',
                    :margin => {:top        => '0.80in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},
                   :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :spacing    => 25},
                    :footer => {:font_name  => 'arial, 900',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "Chronos Smart - impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
      end

    end
  end

  def painel_opcoes
    render :layout => 'modal'
  end

  def faturamento
    @cliente = Cliente.find(params[:id])
    @contra_servis = ContratoServico.where(contrato_id: @cliente.cod_proc).order(:id)
    @fts = FormFiscal.where("sigla_proc = 'CL' AND cod_proc = #{params[:id]} AND STATUS != 0").select("id, arquivo_pdf,ruc, persona_nome,tipo_emissao,impressao, cod_proc, tot_gs, doc_01, doc_02, doc, status, cdc").order('id desc ')
    render layout: 'chart'
  end

  def cancelacao_titulo
    cl = Cliente.find_by_id(params[:titulo])
    cobro = Cobro.create( persona_id: cl.persona_id,
                       persona_nome: cl.persona.nome,
                       cliente_id: cl.id,
                       moeda: cl.moeda,
                       unidade_id: current_unidade.id,
                       cotacao: Moeda.last.dolar_compra,
                       cotacao_real: Moeda.last.real_compra,
                       cotacao_rs_us: Moeda.last.rs_us_compra,
                       data: Time.now,
                       usuario_created: current_user.id)

    CobrosDetalhe.create(  cobro_id: cobro.id,
                persona_id: cl.persona_id,
                persona_nome: cl.persona.nome,
                moeda: cl.moeda,
                data: Time.now,
                vencimento: cl.vencimento,
                cobro_guarani: cl.divida_guarani,
                cobro_dolar: cl.divida_dolar,
                cobro_real: cl.divida_real,
                saldo_guarani: cl.divida_guarani,
                saldo_dolar: cl.divida_dolar,
                saldo_real: cl.divida_real,
                estado: 1,
                liquidacao: 1,
                documento_numero: cl.documento_numero,
                documento_numero_01: cl.documento_numero_01,
                documento_numero_02: cl.documento_numero_02,
                cota: cl.cota,
                )

    redirect_to(financa_painel_receber_cobro_path(cobro.id))

  end

  def baixa_parcial_titulo
    cl = Cliente.find_by_id(params[:titulo])
    cobro = Cobro.create( persona_id: cl.persona_id,
                       persona_nome: cl.persona.nome,
                       cliente_id: cl.id,
                       moeda: cl.moeda,
                       cotacao: Moeda.last.dolar_compra,
                       cotacao_real: Moeda.last.real_compra,
                       cotacao_rs_us: Moeda.last.rs_us_compra,
                       data: Time.now,
                       usuario_created: current_user.id)

    CobrosDetalhe.create(  cobro_id: cobro.id,
                persona_id: cl.persona_id,
                persona_nome: cl.persona.nome,
                moeda: cl.moeda,
                data: Time.now,
                vencimento: cl.vencimento,
                cobro_guarani: params[:valor_gs].to_f,
                cobro_dolar: params[:valor_us].to_f,
                cobro_real: params[:valor_rs].to_f,
                saldo_guarani: cl.divida_guarani,
                saldo_dolar: cl.divida_dolar,
                saldo_real: cl.divida_real,
                estado: 0,
                liquidacao: 0,
                documento_numero: cl.documento_numero,
                documento_numero_01: cl.documento_numero_01,
                documento_numero_02: cl.documento_numero_02,
                cota: cl.cota,
                )

    redirect_to(financa_painel_receber_cobro_path(cobro.id))

  end

  def painel_receber

    @hoje_us = Cliente.where(liquidacao: 0, moeda: 0, vencimento: Time.now.strftime("%Y-%m-%d")).sum('divida_dolar')
    @hoje_gs = Cliente.where(liquidacao: 0, moeda: 1, vencimento: Time.now.strftime("%Y-%m-%d")).sum('divida_guarani')
    @hoje_rs = Cliente.where(liquidacao: 0, moeda: 2, vencimento: Time.now.strftime("%Y-%m-%d")).sum('divida_real')
    @saldo_us = Cliente.where("liquidacao = 0 and moeda = 0 and date_part('month', vencimento) = ?
                and date_part('year', vencimento) = ?", Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
      .sum('divida_dolar')

    @saldo_gs = Cliente.where("liquidacao = 0 and moeda = 1 and date_part('month', vencimento) = ? and date_part('year', vencimento) = ?",
                Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
      .sum('divida_guarani')

    @saldo_rs = Cliente.where("liquidacao = 0 and moeda = 2 and date_part('month', vencimento) = ? and date_part('year', vencimento) = ?",
                Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
      .sum('divida_real')

    @recebido_us = Cliente.where("moeda = 0 and divida_dolar < 0 and date_part('month', vencimento) = ? and date_part('year', vencimento) = ?",
                Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
      .sum('divida_dolar')

    @recebido_gs = Cliente.where("moeda = 1 and divida_guarani < 0 and date_part('month', vencimento) = ? and date_part('year', vencimento) = ?",
                Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
        .sum('divida_guarani')

    @recebido_rs = Cliente.where("moeda = 2 and divida_real < 0 and date_part('month', vencimento) = ? and date_part('year', vencimento) = ?",
                Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
        .sum('divida_real')

    render layout: 'chart'

  end

  def painel_receber_lancamento
    params[:unidade] = current_unidade.id
    unless params[:date_month_f].present?
      params[:mes] = Time.now.strftime("%m")
      params[:ano] = Time.now.strftime("%Y")
    else
      params[:mes] = params[:date_month_f]
      params[:ano] = params[:date_year_f]
    end
    @clientes = Cliente.painel_receber(params)
    render layout: false
  end


  def resultado_consulta_simples
    sql = "SELECT C.ID,
                  C.PERSONA_ID,
                  C.PERSONA_NOME,
                  C.VENDEDOR_ID,
                  C.VENDEDOR_NOME,
                  C.COD_PROC,
                  C.SIGLA_PROC,
                  C.LIQUIDACAO,
                  C.MOEDA,
                  C.TIPO,
                  C.DATA,
                  C.VENCIMENTO,
                  C.VENDA_ID,
                  C.DOCUMENTO_NOME,
                  C.DOCUMENTO_NUMERO,
                  C.COTA,
                  C.CLASE_PRODUTO,
                  C.ORIGINAL,
                  C.DIVIDA_DOLAR,
                  C.DIVIDA_GUARANI,
                  C.DIVIDA_REAL,
                  C.COBRO_DOLAR,
                  C.COBRO_GUARANI,
                  C.COBRO_REAL,
                  C.DESCRICAO,
                  C.DOCUMENTO_NUMERO_01,
                  C.documento_numero_02,
                  U.UNIDADE_NOME,
                  V.COTACAO AS COTACAO_VENDA,
                  (SELECT SUM(AT.COBRO_DOLAR) FROM CLIENTES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_US,
                  (SELECT SUM(AT.COBRO_GUARANI) FROM CLIENTES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_GS
        FROM CLIENTES C
        LEFT JOIN VENDAS V
        ON C.VENDA_ID = V.ID
        INNER JOIN PERSONAS P
        ON P.ID = C.PERSONA_ID
        LEFT JOIN UNIDADES U
        ON C.UNIDADE_ID = U.ID
        WHERE P.TIPO_FUNCIONARIO = 0 AND C.UNIDADE_ID = #{current_unidade.id} AND C.PERSONA_ID = #{params[:persona_id]} AND C.LIQUIDACAO = 0 AND (C.DIVIDA_GUARANI + C.DIVIDA_DOLAR ) > 0
        ORDER BY 11,15"
    @cliente  = Cliente.find_by_sql(sql)
    @persona = Persona.find_by_id(params[:persona_id])
    render layout: false
  end

  def busca_cliente
        @cliente  = Cliente.all( :select => ' id,
                                              persona_id,
                                              persona_nome,
                                              liquidacao,
                                              tipo,
                                              data,
                                              vencimento,
                                              venda_id,
                                              documento_nome,
                                              documento_numero,
                                              cota,
                                              original,
                                              divida_dolar,
                                              divida_guarani,
                                              cobro_dolar,
                                              cobro_guarani,
                                              diferido,
                                              documento_numero_01,
                                              documento_numero_02',
                                 :conditions => [" persona_id = ? AND documento_numero LIKE '%#{params[:filtro]}%' AND liquidacao != 2  AND tipo = '1'",params[:busca]],:order => 'data,venda_id,cota')

    respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @cobros }
    end
  end

    def filtro_busca_cliente        #
        @cobro    = Cobro.find(params[:id])
        @cliente  = Cliente.all( :select => ' id,
                                              persona_id,
                                              persona_nome,
                                              liquidacao,
                                              tipo,
                                              data,
                                              vencimento,
                                              venda_id,
                                              documento_nome,
                                              documento_numero,
                                              cota,
                                              original,
                                              divida_dolar,
                                              divida_guarani,
                                              cobro_dolar,
                                              cobro_guarani,
                                              diferido,
                                              documento_numero_01,
                                              documento_numero_02',
                                 :conditions => [" persona_id = ? AND documento_numero LIKE '%#{params[:filtro]}%' AND liquidacao != 2  AND tipo = '1'",params[:busca]],:order => 'data,venda_id,cota')

    end

  def relatorio_contas_receber
    params[:unidade] = current_unidade.id
    if params[:detalhe] == "0" #Sintetico por Cliente
    	@resumo = Cliente.contas_receber_resumido(params)
    elsif params[:detalhe] == "3"
      @clientes  = Cliente.relatorio_por_fatura(params)
    elsif params[:detalhe] == "4"
      @clientes = Cliente.contas_receber_resumido_vencimento(params)
    elsif params[:detalhe] == "9" #Extracto Cliente
      @clientes = Cliente.relatorio_contas_receber_detalhado_produto(params)
    elsif params[:detalhe] == "10" #Cuentas a Recebir Detallado Tutor/Aluno
      @clientes = Cliente.relatorio_contas_receber_detalhado_tutor_aluno(params)
    elsif params[:detalhe] == "6"
      @clientes = Cliente.relatorio_por_fatura(params)
    elsif params[:detalhe] == "7"
      @clientes = Cliente.relatorio_acerto_entre_contas(params)
    else #Detalhado
      @clientes = Cliente.relatorio_contas_receber(params)
      @saldo_anterior = Cliente.relatorio_contas_receber_saldo_anterior(params)
    end

    if params[:tipo] == '1'
      render :xlsx => "relatorio_contas_receber",
      filename: "Receber-#{params[:inicio]}-#{params[:final]}"
    else
      render :layout => 'relatorio_view'
    end
  end

  def resultado_extracto_funcionario
    params[:unidade] = current_unidade.id

    if params[:moeda].to_s == '0'
      moeda = 'DOLAR'
    elsif params[:moeda].to_s == '1'
      moeda = 'GUARANI'
    else
      moeda = 'REAIS'
    end

    if params[:filtro].to_s == '0'
      filtro = 'EN ABERTAS'
    elsif params[:filtro].to_s == '1'
      filtro = 'CANCELADAS'
    else
      filtro = 'TODOS'
    end
    #VERIFICA SE  TEM SETOR E IMPRIME
    if params[:busca]["clase_produto"].blank?
        setor = 'TODOS...'
    else
        busca_setor = Setor.find_by_id(params[:busca]["clase_produto"], :select => 'nome')
        setor = "#{params[:busca]["clase_produto"]} - #{busca_setor.nome}"
    end


if params[:detalhe] == "0"
    folha = 'portrait'
  @resumo       = Cliente.contas_receber_resumido(params)

    head =
        "                                                      #{$empresa_nome}
                                                       Cuentas a Receber Por Cliente
- De....: #{params[:inicio]} hasta #{params[:final]}
- Filtro...: #{filtro}
- Moneda...: #{moeda}
- Sector...: #{setor}
-----------------------------------------------------------------------------------------------------------------------------------------
Cod. Cliente                                                                            Divida        Cobrado          Saldo  Ult. Venci.
-----------------------------------------------------------------------------------------------------------------------------------------
"
elsif params[:detalhe] == "3"
    folha = 'portrait'

    @clientes       = Cliente.relatorio_por_fatura(params)

    head =
"                                                             #{$empresa_nome}
                                                            Cuentas a Receber
- De....: #{params[:inicio]} hasta #{params[:final]}
- Filtro...: #{filtro}
- Moneda...: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
    Doc.    Cuota         Deudas        #{t('CHARGE')}                     Saldos                   Interes   Saldo Corrig.     Dias           Venci.
-----------------------------------------------------------------------------------------------------------------------------------------
"

elsif params[:detalhe] == "4"
    folha = 'portrait'
    @clientes       = Cliente.contas_receber_resumido_vencimento(params)
    head =
"                                                         #{$empresa_nome}
                                                      Cuentas a Receber Por Vencimiento
- De....: #{params[:inicio]} hasta #{params[:final]}
- Filtro...: #{filtro}
- Moneda...: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
 Cod. Cliente                                                            Venc. Desde   Dias        Vencido          A Venc.         Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"

elsif params[:detalhe] == "8"
    folha = 'Landscape'
    @clientes       = Cliente.relatorio_contas_receber_detalhado_produto_funcionario(params)
    head =
"                                                                                     #{current_unidade.nome_sys}
                                                                            CUENTAS A RECEBER EMPLEADO DETALHADO PRODUCTOS
- De: #{params[:inicio]} HASTA #{params[:final]}
- FILTRO: #{filtro}
- MONEDA: #{moeda}
_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

  De          VENCI.       DOCUMIENTO    CUOTA     DESCRIPCION                                   DIVIDA             #{t('CHARGE').upcase}              SALDO    DIAS          INTERES     SALDO CORIG.
_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
"

elsif params[:detalhe] == "6"
    folha = 'portrait'

    @clientes       = Cliente.relatorio_por_fatura(params)

    head =
"                                                        #{$empresa_nome}
                                                        Extracto de Clientes
- De....: #{params[:inicio]} hasta #{params[:final]}
- Filtro...: #{filtro}
- Moneda...: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
    De Fac.     Doc.    Cuota         Deudas        #{t('CHARGE')}                    Saldos                   Dias          Venci.
-----------------------------------------------------------------------------------------------------------------------------------------
"



elsif params[:detalhe] == "7"
    folha = 'portrait'

    @clientes       = Cliente.relatorio_acerto_entre_contas(params)

    head =
"                                                    #{$empresa_nome}
                                                        Arreglo entre Contas
- De....: #{params[:inicio]} hasta #{params[:final]}
- Filtro...: #{filtro}
- Moneda...: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
    De Fac.     Doc.     Cuota            Deudas       #{t('CHARGE')}/Pago                  Saldos                  Dias          Venci.
-----------------------------------------------------------------------------------------------------------------------------------------
"



else
    folha = 'portrait'
   @clientes       = Cliente.resultado_extracto_funcionario(params)
   @saldo_anterior = Cliente.relatorio_contas_receber_saldo_anterior_funcionario(params)

if params[:int].to_s == "2"
    head =
"                                                           #{$empresa_nome}
                                                            CUENTA A RECEBIR EMPLEADO DETALHADO
- De....: #{params[:inicio]} hasta #{params[:final]}
- Filtro...: #{filtro}
- Moneda...: #{moeda}
- Sector...: #{setor}
-----------------------------------------------------------------------------------------------------------------------------------------
  De    Vend.              Doc.             Numero       Cuota   Venc.    Dias    Int.      Con Int.     Deuda       Pago       Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"
else
  folha = 'portrait'
    head =
"                                                          #{$empresa_nome}
                                                          CUENTA A RECEBIR EMPLEADO DETALHADO
- De....: #{params[:inicio]} hasta #{params[:final]}
- Filtro...: #{filtro}
- Moneda...: #{moeda}
- Sector...: #{setor}
-----------------------------------------------------------------------------------------------------------------------------------------
  De  Concepto                             Doc.   Numero          Cuota   Venc.     Dias        Deuda         Pago         Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"

end


end

  respond_to do |format|
    if params[:tipo] == '1'
      format.html {
        xls = render_to_string :action => "relatorio_contas_receber", :layout => false
        kit = PDFKit.new(xls, :encoding => 'UTF-8')
        send_data(xls,:filename => "Receber-#{params[:inicio]}-#{params[:final]}.xls")
      }
    else
        format.html do
          render  :pdf                    => "relatorio_contas_receber",
                  :layout                 => "layer_relatorios",
                  :orientation            => folha,
                  :margin => {:top        => '1.20in',
                              :bottom     => '0.25in',
                              :left       => '0.10in',
                              :right      => '0.10in'},
                 :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                              :font_size  => 7,
                              :left       => head,
                              :spacing    => 25},
                  :footer => {:font_name  => 'arial, 900',
                              :font_size  => 7,
                              :right      => "Pagina [page] de [toPage]",
                              :left       => "Chronos Smart - De de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
        end
      end
    end
  end




  def index
  end

  def index_inicio
    @clientes = Cliente.find(:all, :conditions => ["tabela IN ('SALDO','IMPORT')"], :order => 'persona_nome, cota, id')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clientes }
    end
  end


  def show
    @cliente = Cliente.find(params[:id])

    render :layout => false
  end

  def new
    @cliente = Cliente.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cliente }
    end
  end

  def edit
    @cliente = Cliente.find(params[:id])
    session[:pagina] = ''
  end

  def create
    @cliente = Cliente.new(params[:cliente])
    @cliente.unidade_id = current_unidade.id.to_i
    respond_to do |format|
      if @cliente.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        if params[:proc] == 'menu'
          format.html { redirect_to('/fluxo_caixa/movimentos') }
        elsif params[:origin] == 'painel-receber'
          format.html { redirect_to(painel_receber_clientes_path) }
        else
          format.html { redirect_to('/clientes/new') }
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @cliente = Cliente.find(params[:id])

    respond_to do |format|
      if @cliente.update_attributes(params[:cliente])
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        if params[:proc] == 'contrato'
            format.html { redirect_to(contrato_path(@cliente.cod_proc)) }
        elsif params[:proc] == 'menu'
          format.html { redirect_to('/fluxo_caixa/movimentos') }
        else
          format.html { redirect_to('/clientes/index_inicio') }
        end
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @cliente = Cliente.find(params[:id])
    @cliente.destroy

    respond_to do |format|
      if params[:proc] == 'contrato'
          format.html { redirect_to(contrato_path(@cliente.cod_proc)) }
      elsif params[:proc] == 'menu'
        format.html { redirect_to('/fluxo_caixa/movimentos') }
      elsif params[:proc] == 'pedido_traslado'
        redirect_to(:back)
      else
        format.html { redirect_to('/clientes/index_inicio') }
      end

    end
  end
end
