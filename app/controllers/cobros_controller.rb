class CobrosController < ApplicationController
  before_filter :authenticate

  def lista_adelantos

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
                      P.NOME AS ALUNO_NOME,
                      C.DOCUMENTO_NUMERO,
                      C.COTA,
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
                      C.TOT_COTAS,
                      CC.NOME AS CC_NOME,
                      C.CENTRO_CUSTO_ID,
                      ARRAY(SELECT (VP.PRODUTO_NOME) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = C.VENDA_ID) AS array_venda_produtos,
                      (SELECT SUM(AT.DIVIDA_DOLAR) FROM CLIENTES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_US,
                      (SELECT SUM(AT.DIVIDA_GUARANI) FROM CLIENTES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_GS,
                      (SELECT SUM(AT.DIVIDA_REAL) FROM CLIENTES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_RS
            FROM CLIENTES C

            LEFT JOIN UNIDADES U
            ON C.UNIDADE_ID = U.ID

            INNER JOIN PERSONAS P
            ON P.ID = C.PERSONA_ID

            LEFT JOIN CENTRO_CUSTOS CC
            ON C.CENTRO_CUSTO_ID = CC.ID

            WHERE C.UNIDADE_ID = #{current_unidade.id} AND  C.TABELA = 'ADELANTO_COTAS'  AND C.PERSONA_ID = #{params[:persona_id]} AND C.LIQUIDACAO = 0 AND (C.COBRO_GUARANI + C.COBRO_DOLAR + C.COBRO_REAL ) > 0
            ORDER BY 12,16
                      "

    @adelantos = Cliente.find_by_sql(sql)
    render layout: false
  end

    def visualizar
      @cobro       = Cobro.find(params[:id])
      render layout: 'consulta'
    end

    def financa_painel_receber
      @cobro       = Cobro.find(params[:id])
      @cd          = CobrosDetalhe.all(:conditions => ['cobro_id = ?',params[:id]])
      @tot_cobro_us = CobrosDetalhe.sum( :cobro_dolar,     :conditions => ['cobro_id = ?',params[:id]])
      @tot_cobro_gs = CobrosDetalhe.sum( :cobro_guarani,   :conditions => ['cobro_id = ?',params[:id]])
      @tot_cobro_rs = CobrosDetalhe.sum( :cobro_real,      :conditions => ['cobro_id = ?',params[:id]])
      @tot_des_us   = CobrosDetalhe.sum( :desconto_dolar,  :conditions => ['cobro_id = ?',params[:id]])
      @tot_des_gs   = CobrosDetalhe.sum( :desconto_guarani,:conditions => ['cobro_id = ?',params[:id]])
      @tot_des_rs   = CobrosDetalhe.sum( :desconto_real,   :conditions => ['cobro_id = ?',params[:id]])
      @tot_int_us   = CobrosDetalhe.sum( :interes_dolar,   :conditions => ['cobro_id = ?',params[:id]])
      @tot_int_gs   = CobrosDetalhe.sum( :interes_guarani, :conditions => ['cobro_id = ?',params[:id]])
      @tot_int_rs   = CobrosDetalhe.sum( :interes_real, :conditions => ['cobro_id = ?',params[:id]])
      @tot_ade_us   = CobrosAdelanto.sum( :valor_us,   :conditions => ['cobro_id = ?',params[:id]])
      @tot_ade_gs   = CobrosAdelanto.sum( :valor_gs, :conditions => ['cobro_id = ?',params[:id]])
      @tot_ade_rs   = CobrosAdelanto.sum( :valor_rs, :conditions => ['cobro_id = ?',params[:id]])

      @fecha_result_us = ( ( @tot_cobro_us.to_f + @tot_int_us.to_f ) - ( @tot_des_us.to_f + @tot_ade_us.to_f ) )
      @fecha_result_gs = ( ( @tot_cobro_gs.to_f + @tot_int_gs.to_f ) - ( @tot_des_gs.to_f + @tot_ade_gs.to_f ) )
      @fecha_result_rs = ( ( @tot_cobro_rs.to_f + @tot_int_rs.to_f ) - ( @tot_des_rs.to_f + @tot_ade_rs.to_f ) )

      @financ_cred_us = CobrosFinanca.sum(:valor_dolar, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])
      @financ_cred_gs = CobrosFinanca.sum(:valor_guarani, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])
      @financ_cred_rs = CobrosFinanca.sum(:valor_real, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])

      @financ_deb_us = CobrosFinanca.sum(:valor_dolar, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])
      @financ_deb_gs = CobrosFinanca.sum(:valor_guarani, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])
      @financ_deb_rs = CobrosFinanca.sum(:valor_real, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])

      if ( ( @fecha_result_us.to_f + @financ_deb_us.to_f ) - @financ_cred_us ) < 0
        @saldo_fina_us = ( ( @fecha_result_us.to_f + @financ_deb_us.to_f ) - @financ_cred_us ) * -1
        @vuelto = 'true'
      else
        @saldo_fina_us = ( ( @fecha_result_us.to_f + @financ_deb_us.to_f ) - @financ_cred_us )
      end

      if ( ( @fecha_result_gs.to_f + @financ_deb_gs.to_f ) - @financ_cred_gs ) < 0
        @saldo_fina_gs = ( ( @fecha_result_gs.to_f + @financ_deb_gs.to_f ) - @financ_cred_gs ) * -1
        @vuelto = 'true'
      else
        @saldo_fina_gs = ( ( @fecha_result_gs.to_f + @financ_deb_gs.to_f ) - @financ_cred_gs )
      end

      if ( ( @fecha_result_rs.to_f + @financ_deb_rs.to_f ) - @financ_cred_rs ) < 0
        @saldo_fina_rs = ( ( @fecha_result_rs.to_f + @financ_deb_rs.to_f ) - @financ_cred_rs ) * -1
        @vuelto = 'true'
      else
        @saldo_fina_rs = ( ( @fecha_result_rs.to_f + @financ_deb_rs.to_f ) - @financ_cred_rs )
      end
      #ncs
      @ncs = FormFiscal.where("status != 0 and sigla_proc = 'CB' AND cod_proc = #{@cobro.id} and tipo_doc = 3").select("id, tot_gs, doc_01, doc_02, doc, status")
      @fts = FormFiscal.where("status != 0 and sigla_proc = 'CB' AND cod_proc = #{@cobro.id} and tipo_doc = 1").select("id, tot_gs, doc_01, doc_02, doc, status")
      render :layout => 'modal'
    end

    def cheque_terceiros
      @diferido = Financa.all( select: "saida_guarani,cod_proc,sigla_proc,data,diferido,titular,banco,persona_nome,conta_nome,cheque,entrada_dolar,entrada_guarani,id",:conditions => ["CONTA_ID = ? AND MOEDA = ? AND CHEQUE_STATUS IN (1,3)",params[:conta_id],params[:moeda]])
      render :layout => 'consulta'
    end

    def valida_processo
      @cobro       = Cobro.find(params[:id])
      @cobro.update_attributes(op: true)
      redirect_to(cobros_url)
    end

    def baixa_divida
      @cobro = Cobro.find(params[:id])
      empresa = Empresa.last(:select => "taxa_interes")
      @dividas = Cliente.find(params[:cobro]["dividas_ids"])
        @dividas.each do |d|
          anterior_gs = Cliente.sum(:cobro_guarani, conditions: ["persona_id = #{d.persona_id} and cota = #{d.cota} and documento_numero_01 ='#{d.documento_numero_01}' and documento_numero_02 ='#{d.documento_numero_02}' and documento_numero ='#{d.documento_numero}' "])
          anterior_us = Cliente.sum(:cobro_dolar, conditions: ["persona_id = #{d.persona_id} and cota = #{d.cota} and documento_numero_01 ='#{d.documento_numero_01}' and documento_numero_02 ='#{d.documento_numero_02}' and documento_numero ='#{d.documento_numero}' "])
          anterior_rs = Cliente.sum(:cobro_real, conditions: ["persona_id = #{d.persona_id} and cota = #{d.cota} and documento_numero_01 ='#{d.documento_numero_01}' and documento_numero_02 ='#{d.documento_numero_02}' and documento_numero ='#{d.documento_numero}' "])
          #calculo de interes
          dias = Date.today - d.vencimento.to_date if d.liquidacao == 0
          if dias >= 0
            interes_gs = ( ( dias.to_i * empresa.taxa_interes.to_f ) * (d.divida_guarani.to_f - anterior_gs.to_f)) / 100
            interes_us = ( ( dias.to_i * empresa.taxa_interes.to_f ) * (d.divida_dolar.to_f - anterior_us.to_f)) / 100
            interes_rs = ( ( dias.to_i * empresa.taxa_interes.to_f ) * (d.divida_real.to_f - anterior_rs.to_f)) / 100
          else
            interes_gs = 0
            interes_us = 0
            interes_rs = 0
          end

          CobrosDetalhe.create(  cobro_id:    @cobro.id,
                                persona_id:  d.persona_id,
                                documento_numero_01: d.documento_numero_01,
                                documento_numero_02: d.documento_numero_02,
                                documento_numero:    d.documento_numero,
                                cota:                d.cota,
                                venda_id:            d.venda_id,
                                vendedor_id:         d.vendedor_id,
                                data:                @cobro.data,
                                data_lanz:           d.data,
                                vencimento:          d.vencimento,
                                moeda:               @cobro.moeda,

                                valor_dolar:         d.divida_dolar.to_f,
                                valor_guarani:       d.divida_guarani.to_f,
                                valor_real:          d.divida_real.to_f,

                                cobro_dolar:         d.divida_dolar.to_f - anterior_us.to_f,
                                cobro_guarani:       d.divida_guarani.to_f - anterior_gs.to_f,
                                cobro_real:          d.divida_real.to_f,

                                saldo_dolar:         d.divida_dolar.to_f  - anterior_us.to_f,
                                saldo_guarani:       d.divida_guarani.to_f - anterior_gs.to_f,
                                saldo_real:          d.divida_real.to_f - anterior_rs.to_f,

                                desconto_dolar:      0,
                                desconto_guarani:    0,
                                desconto_real:       0,
                                interes_dolar:       interes_us.to_f,
                                interes_guarani:     interes_gs.to_f,
                                interes_real:        interes_rs.to_f,
                                tot_cotas:           d.tot_cotas,
                                centro_custo_id:     d.centro_custo_id,
                                estado:              1,
                                liquidacao:          1
                                )
        end

      redirect_to(cobro_path(@cobro))
    end

    def cobro_adelanto
        @cobro       = Cobro.find(params[:id])
        @adelantos  = Cliente.all(:conditions => ["persona_id = ? AND  tabela = 'ADELANTO_COTAS' AND liquidacao = 0 AND  ( cobro_dolar + cobro_guarani + cobro_real)  > 0 ",@cobro.persona_id],:order => 'vencimento')
    end

    def comprovante
        @cobro       = Cobro.find(params[:id])
        @detalhes    = CobrosDetalhe.all( :conditions => ['cobro_id = ?',params[:id]])
        @financas    = CobrosFinanca.all( :conditions => ['cobro_id = ?',params[:id]], :order=>'diferido')
        @adelantos   = CobrosAdelanto.all( :conditions => ['cobro_id = ?',params[:id]])
        @cf_last     = CobrosFinanca.last(:conditions => ['cobro_id = ?',params[:id]])
        @tot_cobro_us = CobrosDetalhe.sum( "(cobro_dolar + interes_dolar) - desconto_dolar",     :conditions => ['cobro_id = ?',params[:id]])
        @tot_cobro_gs = CobrosDetalhe.sum( "(cobro_guarani + interes_guarani) - desconto_guarani",   :conditions => ['cobro_id = ?',params[:id]])
        @tot_cobro_rs = CobrosDetalhe.sum( "(cobro_real + interes_real) - desconto_real",      :conditions => ['cobro_id = ?',params[:id]])

        render :layout => false
    end

    def get_codigo           #
    @persona =  Persona.find(:first, :conditions =>  [ "id = ?", params[:codigo]])

                return render :text => "<script type='text/javascript'>
                                      document.getElementById('cobro_persona_id').value         = '#{@persona.id.to_i}';
                                      document.getElementById('cobro_persona_cod').value        = '#{@persona.cod_velho.to_i}';
                                      document.getElementById('cobro_persona_nome').value       = '#{@persona.nome.to_s}';
                                      document.getElementById('cobro_ruc').value                = '#{@persona.ruc.to_s}';
                                    </script>"
  end

    def get_moeda            #
        @moeda =  Moeda.find(:first, :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('cobro_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                            </script>"
    end


    def get_moeda_real            #
        @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('cobro_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end


    def nova_cota            #
        @cobro = Cobro.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @cobro }
        end
    end


    def nc_ft            #
        @cobro = Cobro.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @cobro }
        end
    end


    def busca_cliente        #
        @cobro    = Cobro.find(params[:id])

        @cliente  = Cliente.all( :select => ' id,
                                              persona_id,
                                              persona_nome,
                                              vendedor_id,
                                              vendedor_nome,
                                              pagare,
                                              liquidacao,
                                              tipo,
                                              data,
                                              vencimento,
                                              venda_id,
                                              documento_nome,
                                              documento_numero,
                                              numero_ordem,
                                              cota,
                                              clase_produto,
                                              original,
                                              divida_dolar,
                                              divida_guarani,
                                              divida_real,
                                              cobro_dolar,
                                              cobro_guarani,
                                              cobro_real,
                                              diferido,
                                              descricao,
                                              documento_numero_01,
                                              documento_numero_02',

                                 :conditions => ["persona_id = ? AND liquidacao = 0 AND (divida_guarani + divida_dolar) > 0"],:order => 'vencimento,cota')
                                 render :layout => false
                               end

    def filtro_busca_cliente #

    end

    def cobro_final
      @cobro       = Cobro.find(params[:id])
      @cd          = CobrosDetalhe.all(:conditions => ['cobro_id = ?',params[:id]])
      @tot_cobro_us = CobrosDetalhe.sum( :cobro_dolar,     :conditions => ['cobro_id = ?',params[:id]])
      @tot_cobro_gs = CobrosDetalhe.sum( :cobro_guarani,   :conditions => ['cobro_id = ?',params[:id]])
      @tot_cobro_rs = CobrosDetalhe.sum( :cobro_real,      :conditions => ['cobro_id = ?',params[:id]])
      @tot_des_us   = CobrosDetalhe.sum( :desconto_dolar,  :conditions => ['cobro_id = ?',params[:id]])
      @tot_des_gs   = CobrosDetalhe.sum( :desconto_guarani,:conditions => ['cobro_id = ?',params[:id]])
      @tot_des_rs   = CobrosDetalhe.sum( :desconto_real,   :conditions => ['cobro_id = ?',params[:id]])
      @tot_int_us   = CobrosDetalhe.sum( :interes_dolar,   :conditions => ['cobro_id = ?',params[:id]])
      @tot_int_gs   = CobrosDetalhe.sum( :interes_guarani, :conditions => ['cobro_id = ?',params[:id]])
      @tot_int_rs   = CobrosDetalhe.sum( :interes_real, :conditions => ['cobro_id = ?',params[:id]])
      @tot_ade_us   = CobrosAdelanto.sum( :valor_us,   :conditions => ['cobro_id = ?',params[:id]])
      @tot_ade_gs   = CobrosAdelanto.sum( :valor_gs, :conditions => ['cobro_id = ?',params[:id]])
      @tot_ade_rs   = CobrosAdelanto.sum( :valor_rs, :conditions => ['cobro_id = ?',params[:id]])

      @fecha_result_us = ( ( @tot_cobro_us.to_f + @tot_int_us.to_f ) - ( @tot_des_us.to_f + @tot_ade_us.to_f ) )
      @fecha_result_gs = ( ( @tot_cobro_gs.to_f + @tot_int_gs.to_f ) - ( @tot_des_gs.to_f + @tot_ade_gs.to_f ) )
      @fecha_result_rs = ( ( @tot_cobro_rs.to_f + @tot_int_rs.to_f ) - ( @tot_des_rs.to_f + @tot_ade_rs.to_f ) )

      @financ_cred_us = CobrosFinanca.sum(:valor_dolar, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])
      @financ_cred_gs = CobrosFinanca.sum(:valor_guarani, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])
      @financ_cred_rs = CobrosFinanca.sum(:valor_real, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])

      @financ_deb_us = CobrosFinanca.sum(:valor_dolar, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])
      @financ_deb_gs = CobrosFinanca.sum(:valor_guarani, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])
      @financ_deb_rs = CobrosFinanca.sum(:valor_real, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])

      if ( ( @fecha_result_us.to_f + @financ_deb_us.to_f ) - @financ_cred_us ) < 0
        @saldo_fina_us = ( ( @fecha_result_us.to_f + @financ_deb_us.to_f ) - @financ_cred_us ) * -1
        @vuelto = 'true'
      else
        @saldo_fina_us = ( ( @fecha_result_us.to_f + @financ_deb_us.to_f ) - @financ_cred_us )
      end

      if ( ( @fecha_result_gs.to_f + @financ_deb_gs.to_f ) - @financ_cred_gs ) < 0
        @saldo_fina_gs = ( ( @fecha_result_gs.to_f + @financ_deb_gs.to_f ) - @financ_cred_gs ) * -1
        @vuelto = 'true'
      else
        @saldo_fina_gs = ( ( @fecha_result_gs.to_f + @financ_deb_gs.to_f ) - @financ_cred_gs )
      end

      if ( ( @fecha_result_rs.to_f + @financ_deb_rs.to_f ) - @financ_cred_rs ) < 0
        @saldo_fina_rs = ( ( @fecha_result_rs.to_f + @financ_deb_rs.to_f ) - @financ_cred_rs ) * -1
        @vuelto = 'true'
      else
        @saldo_fina_rs = ( ( @fecha_result_rs.to_f + @financ_deb_rs.to_f ) - @financ_cred_rs )
      end

      #ficals
      @ncs = FormFiscal.where("status != 0 and sigla_proc = 'CB' AND cod_proc = #{@cobro.id} and tipo_doc = 3").select("ruc, persona_nome, cdc, tipo_emissao, id, tot_gs, doc_01, doc_02, doc, status")
      @fts = FormFiscal.where("status != 0 and sigla_proc = 'CB' AND cod_proc = #{@cobro.id} and tipo_doc = 1").select("id, tot_gs, doc_01, doc_02, doc, status, cdc, tipo_emissao, ruc, persona_nome")
      @rds = FormFiscal.where("status != 0 and sigla_proc = 'CB' AND cod_proc = #{@cobro.id} and tipo_doc = 15").select("id, tot_gs, doc_01, doc_02, doc, status, autorizacao")
      render layout: 'chart'
    end

    def recibo
        @cobro        = Cobro.find(params[:id])
        @cd           = CobrosDetalhe.all(:conditions => ['cobro_id = ?',params[:id]])
        @cf           = CobrosFinanca.all(:conditions => ['cobro_id = ?',params[:id]])
        @total_gs     = CobrosDetalhe.sum( :cobro_guarani,   :conditions => ['cobro_id = ?',params[:id]])
        @total_us     = CobrosFinanca.sum('valor_dolar',:conditions => ['cobro_id = ?',params[:id]])
        @cf_last      = CobrosFinanca.last(:conditions => ['cobro_id = ?',params[:id]])
        @cheque_true  = CobrosFinanca.all(:conditions => ['cheque_status = 1 and cobro_id = ?',params[:id]])
        @cheque_false = CobrosFinanca.all(:conditions => ['cheque_status = 0 and cobro_id = ?',params[:id]])
        @cd          = CobrosDetalhe.all(:conditions => ['cobro_id = ?',params[:id]])
        @tot_cobro_us = CobrosDetalhe.sum( :cobro_dolar,     :conditions => ['cobro_id = ?',params[:id]])
        @tot_cobro_gs = CobrosDetalhe.sum( :cobro_guarani,   :conditions => ['cobro_id = ?',params[:id]])
        @tot_cobro_rs = CobrosDetalhe.sum( :cobro_real,      :conditions => ['cobro_id = ?',params[:id]])
        @tot_des_us   = CobrosDetalhe.sum( :desconto_dolar,  :conditions => ['cobro_id = ?',params[:id]])
        @tot_des_gs   = CobrosDetalhe.sum( :desconto_guarani,:conditions => ['cobro_id = ?',params[:id]])
        @tot_des_rs   = CobrosDetalhe.sum( :desconto_real,   :conditions => ['cobro_id = ?',params[:id]])
        @tot_int_us   = CobrosDetalhe.sum( :interes_dolar,   :conditions => ['cobro_id = ?',params[:id]])
        @tot_int_gs   = CobrosDetalhe.sum( :interes_guarani, :conditions => ['cobro_id = ?',params[:id]])
        @tot_int_rs   = CobrosDetalhe.sum( :interes_real, :conditions => ['cobro_id = ?',params[:id]])
        @tot_ade_us   = CobrosAdelanto.sum( :valor_us,   :conditions => ['cobro_id = ?',params[:id]])
        @tot_ade_gs   = CobrosAdelanto.sum( :valor_gs, :conditions => ['cobro_id = ?',params[:id]])
        @tot_ade_rs   = CobrosAdelanto.sum( :valor_rs, :conditions => ['cobro_id = ?',params[:id]])

        @fecha_result_us = ( ( @tot_cobro_us.to_f + @tot_int_us.to_f ) - ( @tot_des_us.to_f + @tot_ade_us.to_f ) )
        @fecha_result_gs = ( ( @tot_cobro_gs.to_f + @tot_int_gs.to_f ) - ( @tot_des_gs.to_f + @tot_ade_gs.to_f ) )
        @fecha_result_rs = ( ( @tot_cobro_rs.to_f + @tot_int_rs.to_f ) - ( @tot_des_rs.to_f + @tot_ade_rs.to_f ) )

        @financ_cred_us = CobrosFinanca.sum(:valor_dolar, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])
        @financ_cred_gs = CobrosFinanca.sum(:valor_guarani, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])
        @financ_cred_rs = CobrosFinanca.sum(:valor_real, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 0 "])

        @financ_deb_us = CobrosFinanca.sum(:valor_dolar, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])
        @financ_deb_gs = CobrosFinanca.sum(:valor_guarani, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])
        @financ_deb_rs = CobrosFinanca.sum(:valor_real, :conditions => ["cobro_id = #{@cobro.id} and cred_deb = 1 "])

        @saldo_fina_us = ( ( @fecha_result_us.to_f + @financ_deb_us.to_f ) - @financ_cred_us )
        @saldo_fina_gs = ( ( @fecha_result_gs.to_f + @financ_deb_gs.to_f ) - @financ_cred_gs )
        @saldo_fina_rs = ( ( @fecha_result_rs.to_f + @financ_deb_rs.to_f ) - @financ_cred_rs )
        render  :layout => false
    end


    #METHOD BASE------------------------------------------------------------------

    def index
      render layout: 'chart'
      #Cobro.destroy_all("usuario_created = #{current_user.id} and op = false" )
    end

    def busca
        params[:unidade] = current_unidade.id
        @cobros = Cobro.filtro(params)
        render :layout => false
    end

    def gera_pdf_cobros      #
        @cobro       = Cobro.find(params[:id])
        @count                  = CobrosDetalhe.count( :id,            :conditions => ['cobro_id = ?',params[:id]])
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
                      SG.DESCRICAO AS MARCA,
                      CL.NOME AS COLEC,
                      U.UNIDADE_NOME,
                      V.COTACAO AS COTACAO_VENDA,
                      (SELECT SUM(AT.COBRO_DOLAR) FROM CLIENTES AT WHERE AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_US,
                      (SELECT SUM(AT.COBRO_GUARANI) FROM CLIENTES AT WHERE AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_GS
            FROM CLIENTES C

            LEFT JOIN VENDAS V
            ON C.VENDA_ID = V.ID

            LEFT JOIN SUB_GRUPOs SG
            ON V.SUB_GRUPO_ID = SG.ID

            LEFT JOIN UNIDADES U
            ON C.UNIDADE_ID = U.ID

            WHERE C.PERSONA_ID = #{@cobro.persona_id} AND C.LIQUIDACAO = 0 AND (C.DIVIDA_GUARANI + C.DIVIDA_DOLAR ) > 0
            ORDER BY 11,15
                      "
    @cliente  = Cliente.find_by_sql(sql)
    respond_to do |format|
      format.html do
        render  :pdf                    => "relatorio_contas_receber",
                :layout                 => "layer_relatorios",
                :formats => [:html],
                :user_style_sheet       => '/assets/relatorios.css',
                :show_as_html           => params[:debug].present?,
                :margin => {:top        => '0.90in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :spacing    => 20},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Enterprise - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end

    end

    def show
        @cobro = Cobro.find(params[:id])
        @count = CobrosDetalhe.count( :id, :conditions => ['cobro_id = ?',params[:id]])
        ps = Persona.find(@cobro.persona_id)
        if Empresa.last.segmento.to_i != 1

          sql = "SELECT
                      C.PERSONA_ID,
                      C.DOCUMENTO_NUMERO_01 || '-' || C.documento_numero_02 || '-' || C.DOCUMENTO_NUMERO as doc,
                      C.COTA,
                      MIN(C.ID) AS ID,
                      MIN(C.VENCIMENTO) AS VENCIMENTO,
                      MIN(C.DOCUMENTO_NUMERO_01) AS DOCUMENTO_NUMERO_01,
                      MIN(C.DOCUMENTO_NUMERO_02) AS DOCUMENTO_NUMERO_02,
                      MIN(C.DOCUMENTO_NUMERO) AS DOCUMENTO_NUMERO,
                      MAX(C.PERSONA_NOME) AS PERSONA_NOME,
                      MIN(C.VENDEDOR_NOME) AS VENDEDOR_NOME,
                      MIN(C.VENDEDOR_ID) AS VENDEDOR_ID,
                      MIN(C.VENDEDOR_NOME) AS VENDEDOR_NOME,
                      MIN(C.COD_PROC) AS COD_PROC,
                      MIN(C.SIGLA_PROC) AS SIGLA_PROC,
                      MAX(C.MOEDA) AS MOEDA,
                      MAX(C.COD_PROC) AS COD_PROC,
                      MAX(C.SIGLA_PROC) AS SIGLA_PROC,
                      MIN(C.DATA) AS DATA,
                      MIN(C.LIQUIDACAO) AS LIQUIDACAO,
                      MIN(C.DESCRICAO) AS DESCRICAO,
                      MIN(P.NOME) AS ALUNO_NOME,
                      MIN(C.TOT_COTAS) AS TOT_COTAS,
                      MIN(C.VENDA_ID) AS VENDA_ID,
                      MIN(CC.NOME) AS CC_NOME,
                      MIN(C.CENTRO_CUSTO_ID) AS CENTRO_CUSTO_ID,
                      MIN(V.COTACAO) AS COTACAO_VENDA,
                      ARRAY(SELECT (VP.PRODUTO_NOME) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = MIN(C.VENDA_ID) ) AS array_venda_produtos,
                      SUM(COALESCE(C.DIVIDA_DOLAR,0)) AS DIVIDA_DOLAR,
                      SUM(COALESCE(C.DIVIDA_GUARANI,0)) AS DIVIDA_GUARANI,
                      SUM(COALESCE(C.DIVIDA_REAL,0)) AS DIVIDA_REAL,
                      SUM(COALESCE(C.COBRO_DOLAR,0)) AS COBRO_DOLAR,
                      SUM(COALESCE(C.COBRO_GUARANI,0)) AS COBRO_GUARANI,
                      SUM(COALESCE(C.COBRO_REAL,0)) AS COBRO_REAL,
                      SUM(COALESCE(C.COBRO_DOLAR,0) ) AS ANTERIOR_US,
                      SUM(COALESCE(C.COBRO_GUARANI,0)) AS ANTERIOR_GS,
                      SUM(COALESCE(C.COBRO_REAL,0)) AS ANTERIOR_RS

            FROM CLIENTES C

            LEFT JOIN VENDAS V
            ON C.VENDA_ID = V.ID

            LEFT JOIN UNIDADES U
            ON C.UNIDADE_ID = U.ID

            INNER JOIN PERSONAS P
            ON P.ID = C.PERSONA_ID

            LEFT JOIN CENTRO_CUSTOS CC
            ON C.CENTRO_CUSTO_ID = CC.ID

            WHERE C.UNIDADE_ID = #{current_unidade.id} AND C.PERSONA_ID = #{@cobro.persona_id} AND C.LIQUIDACAO = 0

            GROUP BY 1,2,3
            ORDER BY 5,2,3"

        sql2 = "SELECT C.ID,
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
                      P.NOME AS ALUNO_NOME,
                      C.DOCUMENTO_NUMERO,
                      C.COTA,
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
                      C.TOT_COTAS,
                      CC.NOME AS CC_NOME,
                      C.CENTRO_CUSTO_ID,
                      V.COTACAO AS COTACAO_VENDA,
                      ARRAY(SELECT (VP.PRODUTO_NOME) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = C.VENDA_ID) AS array_venda_produtos,
                      (SELECT SUM(AT.COBRO_DOLAR) FROM CLIENTES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_US,
                      (SELECT SUM(AT.COBRO_GUARANI) FROM CLIENTES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_GS,
                      (SELECT SUM(AT.COBRO_REAL) FROM CLIENTES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_RS
            FROM CLIENTES C

            LEFT JOIN VENDAS V
            ON C.VENDA_ID = V.ID

            LEFT JOIN UNIDADES U
            ON C.UNIDADE_ID = U.ID

            INNER JOIN PERSONAS P
            ON P.ID = C.PERSONA_ID

            LEFT JOIN CENTRO_CUSTOS CC
            ON C.CENTRO_CUSTO_ID = CC.ID

            WHERE C.UNIDADE_ID = #{current_unidade.id} AND C.PERSONA_ID = #{@cobro.persona_id} AND C.LIQUIDACAO = 0
            ORDER BY 12,16
                      "
        else

sql = "
            SELECT C.ID,
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
                      P.NOME AS ALUNO_NOME,
                      C.DOCUMENTO_NUMERO,
                      C.COTA,
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
                      C.TOT_COTAS,
                      CC.NOME AS CC_NOME,
                      C.CENTRO_CUSTO_ID,
                      V.COTACAO AS COTACAO_VENDA,
                      ARRAY(SELECT (VP.PRODUTO_NOME) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = C.VENDA_ID) AS array_venda_produtos,
                      (SELECT SUM(AT.COBRO_DOLAR) FROM CLIENTES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_US,
                      (SELECT SUM(AT.COBRO_GUARANI) FROM CLIENTES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_GS,
                      (SELECT SUM(AT.COBRO_REAL) FROM CLIENTES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_RS
            FROM CLIENTES C

            LEFT JOIN VENDAS V
            ON C.VENDA_ID = V.ID

            LEFT JOIN UNIDADES U
            ON C.UNIDADE_ID = U.ID

            INNER JOIN PERSONAS P
            ON P.ID = C.PERSONA_ID

            LEFT JOIN CENTRO_CUSTOS CC
            ON C.CENTRO_CUSTO_ID = CC.ID

            WHERE C.UNIDADE_ID = #{current_unidade.id} AND P.VEND_RESPONSAVEL_ID = #{@cobro.persona_id} AND C.LIQUIDACAO = 0 AND (C.DIVIDA_GUARANI + C.DIVIDA_DOLAR + C.DIVIDA_REAL ) > 0

            ORDER BY 12,16
                      "

        end


@cliente  = Cliente.find_by_sql(sql)

       render layout: 'chart'
    end

    def new                  #
        @cobro = Cobro.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @cobro }
        end
    end

    def edit
        @cobro = Cobro.find(params[:id])
    end

    def create
        @cobro = Cobro.new(params[:cobro])
        @cobro.usuario_created = current_user.id
        @cobro.unidade_created = current_unidade.id
        @cobro.unidade_id = current_unidade.id


        respond_to do |format|
            if @cobro.save
                flash[:notice] = t('COBRO_CREATION_MESSAGE')
                if @cobro.adelanto == 1
                  format.html { redirect_to("/cobros/#{@cobro.id}/cobro_adelanto") }
                else
                  format.html { redirect_to(@cobro) }
                end
                format.xml  { render :xml => @cobro, :status => :created, :location => @cobro }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @cobro.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update               #
        @cobro = Cobro.find(params[:id])
        @cobro.usuario_updated = current_user.id
        @cobro.unidade_updated = current_unidade.id

        respond_to do |format|

            if @cobro.update_attributes(params[:cobro])
                if @cobro.adelanto == 1
                  format.html { redirect_to("/cobros/#{@cobro.id}/cobro_adelanto") }
                else
                  format.html { redirect_to(@cobro) }
                end
                format.js   { render :nothing => true }

            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @cobro.errors, :status => :unprocessable_entity }
            end

        end
    end

    def destroy              #
        @cobro = Cobro.find(params[:id])
        @cobro.destroy

        respond_to do |format|
            format.html { redirect_to(cobros_url) }
            format.xml  { head :ok }
        end
    end
end
