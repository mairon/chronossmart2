class ProveedoresController < ApplicationController
  before_filter :authenticate

  def consolidado_interno
    render layout: 'chart'
  end

  def edit_doc
    titulo = Proveedore.where(titulo: params[:titulo])
    titulo.each do |t|
      t.update_attributes(documento_numero_01: params[:documento_numero_01], documento_numero_02: params[:documento_numero_02], documento_numero: params[:documento_numero] )
    end

    redirect_to(painel_pagar_proveedores_path)
  end

  def titulo_historico
    @proveedores = Proveedore.titulo_historico(params)
    render :layout => 'modal'
  end

  def multi_pagamentos

        sql = "SELECT
                   P.TITULO,
                   MIN(P.DOCUMENTO_NUMERO_01) AS DOCUMENTO_NUMERO_01,
                   MIN(P.DOCUMENTO_NUMERO_02) AS DOCUMENTO_NUMERO_02,
                   MAX(P.DOCUMENTO_NUMERO) AS DOCUMENTO_NUMERO,
                   MIN(P.COTA) AS COTA,
                   MIN(P.VENCIMENTO) AS VENCIMENTO,
                   MIN(P.ID) AS ID,
                   MAX(P.DATA) AS DATA,
                   MAX(U.USUARIO_NOME) AS USUARIO_NOME,
                   MIN(U.USUARIO_NOME) AS USUARIO_PAGO,
                   MAX(PD.NOME) AS PERSONA_NOME,
                   MAX(C.NOME) AS CONTA_NOME,
                   MAX(P.MOEDA) AS MOEDA,
                   MAX(P.COTA) AS COTA,
                   MAX(P.COD_PROC) AS COD_PROC,
                   MAX(P.PERSONA_ID) AS PERSONA_ID,
                   MAX(P.DESCRICAO) AS DESCRICAO,
                   MAX(P.TOT_COTAS) AS TOT_COTAS,
                   MAX(P.CONTA_ID) AS CONTA_ID,
                   MAX(P.RUBRO_ID) AS RUBRO_ID,
                   MAX(P.FAVORECIDO) AS FAVORECIDO,
                   MAX(P.RUC) AS RUC,
                   MAX(P.BC_AGENCIA) AS BC_AGENCIA,
                   MAX(P.BC_CONTA) AS BC_CONTA,
                   MAX(P.TIPO_CONTA) AS TIPO_CONTA,
                   MAX( COALESCE(BC.NOME, '' ) || P.BANCO_NOME) AS BANCO_NOME,
                   MAX(R.DESCRICAO) AS RUBRO_NOME,
                   COUNT(P.ID) AS COUNT_MOV,
                   SUM(P.DIVIDA_GUARANI) AS DIVIDA_GUARANI,
                   SUM(P.DIVIDA_DOLAR) AS DIVIDA_DOLAR,
                   SUM(P.DIVIDA_REAL) AS DIVIDA_REAL

             FROM PROVEEDORES P

             LEFT JOIN PERSONAS PD
             ON PD.ID = P.PERSONA_ID

             LEFT JOIN CONTAS C
             ON C.ID = P.CONTA_ID

             LEFT JOIN RUBROS R
             ON R.ID = P.RUBRO_ID

             LEFT JOIN PERSONAS BC
             ON BC.ID = P.BANCO_ID

             LEFT JOIN USUARIOS U
             ON U.ID = P.USUARIO_CREATED

             WHERE P.TITULO IN (#{params[:titulo_ids].to_s.gsub('[', '').gsub(']','').gsub('"','\'')})

             GROUP BY 1
             ORDER BY 6, 1
             "
    provs = Proveedore.find_by_sql(sql)

    provs.each do |pv|

      Proveedore.create(
        :liquidacao => 0,
        :sigla_proc => 'PGR',
        :cota => pv.cota,
        :documento_numero => pv.documento_numero,
        :documento_numero_01 => pv.documento_numero_01,
        :documento_numero_02 => pv.documento_numero_02,
        :descricao => pv.descricao,
        :rubro_id => pv.rubro_id,
        :tot_cotas => pv.tot_cotas,
        :persona_id => pv.persona_id,
        :titulo => pv.titulo,
        :usuario_created => params[:usuario_id],
        :conta_id => params[:busca]["conta"],
        :data => params[:data],
        :vencimento => pv.vencimento,
        :moeda => pv.moeda,
        :finan => true,
        :banco_nome => pv.banco_nome,
        :bc_agencia => pv.bc_agencia,
        :bc_conta => pv.bc_conta,
        :tipo_conta => pv.tipo_conta,
        :favorecido => pv.favorecido,
        :total_divida_real => (pv.divida_real.to_f),
        :divida_dolar => (pv.divida_dolar.to_f),
        :divida_guarani => (pv.divida_guarani.to_f),
        :divida_real => (pv.divida_real.to_f)
      )

    end

    redirect_to("/proveedores/painel_pagar?usuario_id=#{params[:usuario_id]}")
  end

  def atualiza_pagar_por

    titulo = Proveedore.where(titulo: params[:titulo], finan: false).first
    if titulo.pagar_por.to_i > 0
      return render :text => '999999'
    else
      titulo.update_attributes(pagar_por: params[:usuario_id].to_i)

      qtd =  Proveedore.where("pagar_por = #{params[:usuario_id]} and finan = false and liquidacao = 0 ").count(:id)
      return render :text => qtd

    end

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def atualiza_voltar_pagar_por

    titulo = Proveedore.where(titulo: params[:titulo], finan: false).first
        titulo.update_attributes(pagar_por: 0)

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def atualiza_cancela_titulo
    if params[:st] == 'true'
      titulo = Proveedore.where(titulo: params[:titulo], finan: false).first
      titulo.update_attributes(status: true)
    else
      titulo = Proveedore.where(titulo: params[:titulo], finan: false).first
      titulo.update_attributes(status: false)
    end

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def consolidado
    @proveedores = Proveedore.consolidado(params)
    render layout: 'chart'
  end

  def consolidado_modal
    @proveedores = Proveedore.consolidado_modal(params)
    render layout: 'chart'
  end


  def estorno_titulo
    pv = Proveedore.find(params[:estorno_id])
    Proveedore.create(
      :liquidacao => pv.liquidacao,
      :sigla_proc => 'PGE',
      :cota => pv.cota,
      :documento_numero => pv.documento_numero,
      :documento_numero_01 => pv.documento_numero_01,
      :documento_numero_02 => pv.documento_numero_02,
      :descricao => params[:estorno_motivo],
      :rubro_id => pv.rubro_id,
      :tot_cotas => pv.tot_cotas,
      :persona_id => pv.persona_id,
      :titulo => pv.titulo,
      :usuario_created => pv.usuario_created,
      :conta_id => pv.conta_id,
      :data => params[:estorno_data],
      :vencimento => pv.vencimento,
      :moeda => pv.moeda,
      :finan => true,
      :divida_dolar => (pv.divida_dolar.to_f * -1),
      :divida_guarani => (pv.divida_guarani.to_f * -1),
      :divida_real => (pv.divida_real.to_f * -1)
    )

    redirect_to('/proveedores/painel_pagar')
  end

  def titulo_historico
    @proveedores = Proveedore.titulo_historico(params)
    render :layout => 'modal'
  end

  def imp
    Proveedore.import(params[:file], params)

    redirect_to('/proveedores/painel_pagar')
  end

  def painel_opcoes
    render :layout => 'modal'
  end

  def cancelacao_titulo
    cl = Proveedore.find_by_id(params[:titulo])

    saldo_gs = Proveedore.where("persona_id = #{cl.persona_id} and documento_numero = '#{cl.documento_numero}' and cota = #{cl.cota}").sum('divida_guarani - pago_guarani')
    saldo_rs = Proveedore.where("persona_id = #{cl.persona_id} and documento_numero = '#{cl.documento_numero}' and cota = #{cl.cota}").sum('divida_real - pago_real')
    saldo_us = Proveedore.where("persona_id = #{cl.persona_id} and documento_numero = '#{cl.documento_numero}' and cota = #{cl.cota}").sum('divida_dolar - pago_dolar')
    cobro = Pago.create( persona_id: cl.persona_id, 
                       persona_nome: cl.persona.nome,
                       proveedore_id: cl.id,
                       moeda: cl.moeda,
                       unidade_id: current_unidade.id,
                       cotacao: Moeda.last.dolar_compra,
                       cotacao_real: Moeda.last.real_compra,
                       cotacao_rs_us: Moeda.last.rs_us_compra,
                       data: Time.now,
                       usuario_created: current_user.id)

    PagosDetalhe.create(  pago_id: cobro.id,
                persona_id: cl.persona_id, 
                persona_nome: cl.persona.nome,
                moeda: cl.moeda,
                data: Time.now,
                vencimento: cl.vencimento,
                pago_guarani: saldo_gs.to_f,
                pago_dolar: saldo_us.to_f,
                pago_real: saldo_rs.to_f,
                saldo_guarani: saldo_gs.to_f,
                saldo_dolar: saldo_us.to_f,
                saldo_real: saldo_rs.to_f,
                estado: 1,
                liquidacao: 1,
                documento_numero: cl.documento_numero,
                documento_numero_01: cl.documento_numero_01,
                documento_numero_02: cl.documento_numero_02,
                cota: cl.cota,
                )

    redirect_to(financa_painel_pagar_pago_path(cobro.id))

  end

  def baixa_parcial_titulo
    cl = Proveedore.find_by_id(params[:titulo])

    cobro = Pago.create( persona_id: cl.persona_id, 
                       persona_nome: cl.persona.nome,
                       proveedore_id: cl.id,
                       moeda: cl.moeda,
                       unidade_id: current_unidade.id,
                       cotacao: Moeda.last.dolar_compra,
                       cotacao_real: Moeda.last.real_compra,
                       cotacao_rs_us: Moeda.last.rs_us_compra,
                       data: Time.now,
                       usuario_created: current_user.id)

    PagosDetalhe.create(  pago_id: cobro.id,
                persona_id: cl.persona_id, 
                persona_nome: cl.persona.nome,
                moeda: cl.moeda,
                data: Time.now,
                vencimento: cl.vencimento,
                pago_guarani: params[:valor_gs].to_f,
                pago_dolar: params[:valor_us].to_f,
                pago_real: params[:valor_rs].to_f,
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

    redirect_to(financa_painel_pagar_pago_path(cobro.id))

  end

  def painel_pagar
    @hoje_us = Proveedore.where(liquidacao: 0, moeda: 0, vencimento: Time.now.strftime("%Y-%m-%d")).sum('divida_dolar - pago_dolar')
    @hoje_gs = Proveedore.where(liquidacao: 0, moeda: 1, vencimento: Time.now.strftime("%Y-%m-%d")).sum('divida_guarani - pago_guarani')
    @hoje_rs = Proveedore.where(liquidacao: 0, moeda: 2, vencimento: Time.now.strftime("%Y-%m-%d")).sum('divida_real - pago_real')

    @ctz = Moeda.order('data').last;

    @saldo_us = Proveedore.joins(:persona).where("personas.tipo_funcionario = 0
                and proveedores.liquidacao = 0
                and proveedores.moeda = 0
                and date_part('month', proveedores.vencimento) = ?
                and date_part('year', proveedores.vencimento) = ?",
                Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") ).sum('divida_dolar - pago_dolar')
    @saldo_gs = Proveedore.joins(:persona).where("personas.tipo_funcionario = 0
                and proveedores.liquidacao = 0
                and proveedores.moeda = 1
                and date_part('month', proveedores.vencimento) = ?
                and date_part('year', proveedores.vencimento) = ?",
                Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") ).sum('divida_guarani - pago_guarani')
    @saldo_rs = Proveedore.joins(:persona).where("personas.tipo_funcionario = 0
                and proveedores.liquidacao = 0
                and proveedores.moeda = 2
                and date_part('month', proveedores.vencimento) = ?
                and date_part('year', proveedores.vencimento) = ?",
                Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") ).sum('divida_real - pago_real')

    @pago_us = Proveedore.joins(:persona)
        .where("personas.tipo_funcionario = 0
                and proveedores.moeda = 0
                and date_part('month', proveedores.vencimento) = ?
                and date_part('year', proveedores.vencimento) = ?",
                Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
        .sum('proveedores.pago_dolar')

    @pago_gs = Proveedore.joins(:persona)
        .where("personas.tipo_funcionario = 0
                and proveedores.moeda = 1
                and date_part('month', proveedores.vencimento) = ?
                and date_part('year', proveedores.vencimento) = ?",
                Time.now.to_date.strftime("%m"), Time.now.to_date.strftime("%Y") )
        .sum('proveedores.pago_guarani')



      @cheques_diferidos = Financa.where("cheque <> '' and cheque_status = 1 and date_part('month', diferido) = #{ Time.now.to_date.strftime("%m")} and date_part('year', diferido) = #{ Time.now.to_date.strftime("%Y")}")
    if params[:lp] == 'consulta'
      render layout: 'consulta'
    else
      render layout: 'chart'
    end

  end

  def painel_pagar_lancamento
    unless params[:date_month_f].present?
      params[:mes] = Time.now.strftime("%m")
      params[:ano] = Time.now.strftime("%Y")      
    else
      params[:mes] = params[:date_month_f]
      params[:ano] = params[:date_year_f]
    end

    @proveedores = Proveedore.painel_pagar(params)

    render layout: false
  end

  def index_inicio
    @clientes = Proveedore.find(:all, :conditions => ["tabela = 'SALDO' AND UNIDADE_ID = #{current_unidade.id}"])

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def relatorio_contas_pagar
    params[:unidade] = current_unidade.id
    if params[:moeda].to_s == '0'
      moeda = 'DOLAR'
    elsif params[:moeda].to_s == '1'
      moeda = 'GUARANI'
    elsif params[:moeda].to_s == '2'
      moeda = 'REAIS'
    elsif params[:moeda].to_s == '4'
      moeda = 'EURO'
    end 

    if params[:filtro].to_s == '0'
      filtro = 'EN ABERTAS'
    elsif params[:filtro].to_s == '1'
      filtro = 'CANCELADAS'        
    else 
      filtro = 'TODOS'        
    end 
    #VERIFICA SE  TEM CC E IMPRIME
    if params[:busca]["cc"].blank?
        cc = 'TODOS...'
    else
        busca_cc = CentroCusto.find_by_id(params[:busca]["cc"], :select => 'nome')
        cc = "#{params[:busca]["cc"]} - #{busca_cc.nome}"
    end

    #VERIFICA SE  TEM CC E IMPRIME
    if params[:busca]["clasif"].blank?
        rb = 'TODOS...'
    else
        busca_rb = PlanoDeConta.find_by_id(params[:busca]["clasif"], :select => 'descricao')
        rb = "#{params[:busca]["clasif"]} - #{busca_rb.descricao}"
    end
	if params[:detalhe] == "2"
		@resumo = Proveedore.contas_pagar_resumido(params)

    head =
        "                                                   #{current_unidade.nome_sys}
                                                        #{t('ACCOUNT')} a Pagar Resumido Por Prov.
- #{t('DATE')}.....: #{params[:inicio]} hasta #{params[:final]}
- Filtro....: #{filtro}
- #{t('COIN')}....: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
Cod.   Proveedor                                                                                                 Saldo      Ultimo Venci.
-----------------------------------------------------------------------------------------------------------------------------------------
"
	elsif params[:detalhe] == "3"
		@proveedores = Proveedore.extrato_proveedor(params)


    head =
"                                                             #{current_unidade.nome_sys}
                                             #{t('ACCOUNT').upcase}S A PAGAR DETALHADO POR #{t('QUOTA').upcase}
- #{t('DATE')}: #{params[:inicio]} HASTA #{params[:final]}
- FILTRO.: #{filtro}
- #{t('COIN')}..: #{moeda}
- CC.....: #{cc}
- #{t('CLASSIFICATION')}.....: #{rb}
-----------------------------------------------------------------------------------------------------------------------------------------
   #{t('DATE')}     Venc.   #{t('DATE')} Pg CC                Desc.                                 Doc.      #{t('QUOTA')}      Valor         Pg        Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"


	else

	    @proveedores = Proveedore.relatorio_contas_pagar(params)
    	@saldo_anterior = Proveedore.relatorio_contas_pagar_saldo_anterior(params)

    head =
"                                                             #{current_unidade.nome_sys}
                                             #{t('ACCOUNT').upcase}S A PAGAR
- #{t('DATE')}: #{params[:inicio]} HASTA #{params[:final]}
- FILTRO.: #{filtro}
- #{t('COIN')}..: #{moeda}
- CC.....: #{cc}
- #{t('CLASSIFICATION')}: #{rb}
-----------------------------------------------------------------------------------------------------------------------------------------
   #{t('DATE')}     Venc.   #{t('DATE')} Pg  CC               Desc.                                 Doc.      #{t('QUOTA')}      Valor         Pg        Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"


	end
    
    respond_to do |format|
      if params[:tipo] == '1'
        format.html {
          render :xlsx => "relatorio_contas_pagar", 
          filename: "Cuentas-Pagar-#{params[:inicio]}-#{params[:final]}"
        }
      else
      format.html do
        render  :pdf                    => "relatorio_contas_pagar",                
                :layout                 => "layer_relatorios",
                 :formats => [:html],
                :user_style_sheet       => '/assets/relatorios.css',
                :show_as_html           => params[:debug].present?,
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
      end
    end
  end

  #METHODS BASE ----------------------------------------------------------------

  def index                       #

    respond_to do |format|
      format.html # index.html.erb

    end
  end

  def show                        #
    @proveedore = Proveedore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proveedore }
    end
  end

  def new                         #
    @proveedore = Proveedore.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proveedore }
    end
  end

  def edit                        #
    @proveedore = Proveedore.find(params[:id])
  end

  def create                      #
    @proveedore = Proveedore.new(params[:proveedore])
    @proveedore.unidade_id = current_unidade.id.to_i
    respond_to do |format|
      if @proveedore.save
        if params[:proc] == 'prov_gasto'
          format.html { redirect_to('/proveedores/index_inicio') }
        else
          if @proveedore.tabela == 'PG'
            if @proveedore.pagar_por

            end
            format.html { redirect_to("/proveedores/painel_pagar?usuario_id=#{@proveedore.usuario_created}") }

          else
            format.html { redirect_to('/proveedores/painel_pagar') }
          end

        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @proveedore.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @proveedore = Proveedore.find(params[:id])
    respond_to do |format|
      if @proveedore.update_attributes(params[:proveedore])
      	if params[:proc] == 'prov_gasto'
      			format.html { redirect_to(prov_gasto_path(@proveedore.cod_proc)) }
      	else
      		format.html { redirect_to('/proveedores/painel_pagar') }
      	end
          
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy                     #
    @proveedore = Proveedore.find(params[:id])
    @proveedore.destroy

    respond_to do |format|
    	if params[:proc] == 'prov_gasto'
    		format.html { redirect_to(prov_gasto_path(params[:id_proc])) }
      else
      	format.html { redirect_to('/proveedores/painel_pagar') }
      end
    end
  end
end
