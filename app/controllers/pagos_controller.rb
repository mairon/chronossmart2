class PagosController < ApplicationController
    before_filter :authenticate
    def print_cheque
      @pago = PagosFinanca.find(params[:pf])
      render layout: false
    end
    def valida_processo
      @pago       = Pago.find(params[:id])
      @pago.update_attributes(op: true)
      redirect_to(pagos_url)
    end

    def financa_painel_pagar
        @pago    = Pago.find(params[:id])
        @tot_pago_us = PagosDetalhe.sum( :pago_dolar,     :conditions => ['pago_id = ?',params[:id]])
        @tot_pago_gs = PagosDetalhe.sum( :pago_guarani,   :conditions => ['pago_id = ?',params[:id]])
        @tot_pago_rs = PagosDetalhe.sum( :pago_real,      :conditions => ['pago_id = ?',params[:id]])
        @tot_des_us   = PagosDetalhe.sum( :desconto_dolar,  :conditions => ['pago_id = ?',params[:id]])
        @tot_des_gs   = PagosDetalhe.sum( :desconto_guarani,:conditions => ['pago_id = ?',params[:id]])
        @tot_des_rs   = PagosDetalhe.sum( :desconto_real,   :conditions => ['pago_id = ?',params[:id]])
        @tot_int_us   = PagosDetalhe.sum( :interes_dolar,   :conditions => ['pago_id = ?',params[:id]])
        @tot_int_gs   = PagosDetalhe.sum( :interes_guarani, :conditions => ['pago_id = ?',params[:id]])
        @tot_int_rs   = PagosDetalhe.sum( :interes_real, :conditions => ['pago_id = ?',params[:id]])
        @tot_ade_us   = PagosAdelanto.sum( :valor_us,   :conditions => ['pago_id = ?',params[:id]])
        @tot_ade_gs   = PagosAdelanto.sum( :valor_gs, :conditions => ['pago_id = ?',params[:id]])
        @tot_ade_rs   = PagosAdelanto.sum( :valor_rs, :conditions => ['pago_id = ?',params[:id]])

        @fecha_result_us = ( ( @tot_pago_us.to_f + @tot_int_us.to_f ) - ( @tot_des_us.to_f + @tot_ade_us.to_f ) )
        @fecha_result_gs = ( ( @tot_pago_gs.to_f + @tot_int_gs.to_f ) - ( @tot_des_gs.to_f + @tot_ade_gs.to_f ) )
        @fecha_result_rs = ( ( @tot_pago_rs.to_f + @tot_int_rs.to_f ) - ( @tot_des_rs.to_f + @tot_ade_rs.to_f ) )

        @financ_cred_us = PagosFinanca.sum(:valor_dolar, :conditions => ["pago_id = #{@pago.id} and cred_deb = 0 "])
        @financ_cred_gs = PagosFinanca.sum(:valor_guarani, :conditions => ["pago_id = #{@pago.id} and cred_deb = 0 "])
        @financ_cred_rs = PagosFinanca.sum(:valor_real, :conditions => ["pago_id = #{@pago.id} and cred_deb = 0 "])

        @financ_deb_us = PagosFinanca.sum(:valor_dolar, :conditions => ["pago_id = #{@pago.id} and cred_deb = 1 "])
        @financ_deb_gs = PagosFinanca.sum(:valor_guarani, :conditions => ["pago_id = #{@pago.id} and cred_deb = 1 "])
        @financ_deb_rs = PagosFinanca.sum(:valor_real, :conditions => ["pago_id = #{@pago.id} and cred_deb = 1 "])

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

        @rts = FormFiscal.where("status != 0 and sigla_proc = 'PG' AND cod_proc = #{@pago.id} and tipo_doc = 14").select("sigla_proc, id, tot_us, tot_gs, doc_01, doc_02, doc, status")
      render :layout => 'modal'
    end

    def gera_pdf_pagos
        @pago       = Pago.find(params[:id])
        sql = "SELECT C.ID,
                              C.PERSONA_ID,
                              C.PERSONA_NOME,
                              C.LIQUIDACAO,
                              C.MOEDA,
                              C.TIPO,
                              C.DATA,
                              C.VENCIMENTO,
                              C.COMPRA_ID,
                              C.DOCUMENTO_NOME,
                              C.DOCUMENTO_NUMERO,
                              C.COTA,
                              C.ORIGINAL,
                              C.DIVIDA_DOLAR,
                              C.DIVIDA_GUARANI,
                              C.DIVIDA_REAL,
                              C.PAGO_DOLAR,
                              C.PAGO_GUARANI,
                              C.PAGO_REAL,
                              C.DESCRICAO,
                              C.DOCUMENTO_NUMERO_01,
                              C.documento_numero_02,
                              SG.DESCRICAO AS MARCA,
                              C.TABELA,
                              V.COTACAO AS COTACAO_VENDA,
                              V.COTACAO_RS_US AS COTZ_RS_US,
                              (V.IMPOSTO_05_DOLAR + V.IMPOSTO_10_DOLAR) AS IMPOSTO_US,
                              (V.IMPOSTO_05_GUARANI + V.IMPOSTO_10_GUARANI) AS IMPOSTO_GS,
                              ((V.IMPOSTO_05_DOLAR + V.IMPOSTO_10_DOLAR)  * 0.3) AS RETENCAO_US,
                              ((V.IMPOSTO_05_GUARANI + V.IMPOSTO_10_GUARANI) * 0.3) AS RETENCAO_GS,

                              ( SELECT SUM(AT.PAGO_DOLAR) FROM PROVEEDORES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} and  AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_US,
                              ( SELECT SUM(AT.PAGO_GUARANI) FROM PROVEEDORES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} and  AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_GS,
                              ( SELECT SUM(AT.PAGO_REAL) FROM PROVEEDORES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} and AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_RS
                    FROM PROVEEDORES C
                    LEFT JOIN COMPRAS V
                    ON C.COMPRA_ID = V.ID
                    LEFT JOIN SUB_GRUPOs SG
                    ON V.SUB_GRUPO_ID = SG.ID
                    WHERE C.UNIDADE_ID = #{current_unidade.id} and C.PERSONA_ID = #{@pago.persona_id} AND C.LIQUIDACAO = 0 AND (C.DIVIDA_GUARANI + C.DIVIDA_DOLAR ) > 0
                    ORDER BY 8,12
                              "        
            @proveedor  = Proveedore.find_by_sql(sql)





        @total_pago_dolar   = PagosDetalhe.sum(:pago_dolar, :conditions => ['pago_id = ?',params[:id]])
        @total_pago_guarani = PagosDetalhe.sum(:pago_guarani, :conditions => ['pago_id = ?',params[:id]])
        @count              = PagosDetalhe.count(:id, :conditions => ['pago_id = ?',params[:id]])

        respond_to do |format|
          format.html do
            render  :pdf                    => "gera_pdf_pagos",                
                    :layout                 => "layer_relatorios",
                    :margin => {:top        => '1.20in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},        
                    :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
        end
    end


    def cheque_terceiros
      @diferido = Financa.all( select: "saida_guarani,cod_proc,sigla_proc,data,diferido,titular,banco,persona_nome,conta_nome,cheque,entrada_dolar,entrada_guarani,id",:conditions => ["CONTA_ID = ? AND MOEDA = ? AND CHEQUE_STATUS IN (1,3)",params[:conta_id],params[:moeda]])
      render :layout => 'consulta'
    end

	def baixa_divida
      @pago = Pago.find(params[:id])

      @dividas = Proveedore.find(params[:pago]["dividas_ids"])      
        @dividas.each do |d|
            importo = Compra.find_by_id(d.compra_id)
            anterior_gs = Proveedore.sum(:pago_guarani, conditions: ["persona_id = #{d.persona_id} and cota = #{d.cota} and documento_numero_01 ='#{d.documento_numero_01}' and documento_numero_02 ='#{d.documento_numero_02}' and documento_numero ='#{d.documento_numero}' "])
            anterior_us = Proveedore.sum(:pago_dolar, conditions: ["persona_id = #{d.persona_id} and cota = #{d.cota} and documento_numero_01 ='#{d.documento_numero_01}' and documento_numero_02 ='#{d.documento_numero_02}' and documento_numero ='#{d.documento_numero}' "])
            anterior_rs = Proveedore.sum(:pago_real, conditions: ["persona_id = #{d.persona_id} and cota = #{d.cota} and documento_numero_01 ='#{d.documento_numero_01}' and documento_numero_02 ='#{d.documento_numero_02}' and documento_numero ='#{d.documento_numero}' "])
            if current_unidade.h_retencao == false 
              imp_us = 0
              rt_us  = 0
              imp_gs = 0
              rt_gs  = 0
            else
              if d.tabela = ''
                imp_us = ((d.divida_dolar.to_f - anterior_us.to_f) / 11)
                rt_us  = (((d.divida_dolar.to_f - anterior_us.to_f) / 11) * 0.30)
                imp_gs = ((d.divida_guarani.to_f - anterior_gs.to_f) / 11)
                rt_gs  = (((d.divida_guarani.to_f - anterior_gs.to_f) / 11) * 0.30)
              else
                imp_us = ((importo.imposto_05_dolar + importo.imposto_10_dolar))
                rt_us  = ((importo.imposto_05_dolar + importo.imposto_10_dolar) * 0.30)
                imp_gs = ((importo.imposto_05_guarani + importo.imposto_10_guarani))
                rt_gs  = ((importo.imposto_05_guarani + importo.imposto_10_guarani) * 0.30)
              end
            end
            PagosDetalhe.create(  pago_id:    @pago.id,
                                persona_id:  @pago.persona_id,
                                documento_numero_01: d.documento_numero_01,
                                documento_numero_02: d.documento_numero_02,
                                documento_numero:    d.documento_numero,
                                compra_id:           d.compra_id,
                                cota:                d.cota,
                                data:                @pago.data,
                                data_lanz:           d.data,
                                vencimento:          d.vencimento,
                                moeda:               @pago.moeda,
                                valor_dolar:         d.divida_dolar.to_f,
                                valor_guarani:       d.divida_guarani.to_f,
                                valor_real:          d.divida_real.to_f,
                                pago_dolar:          d.divida_dolar.to_f - anterior_us.to_f,
                                pago_guarani:        d.divida_guarani.to_f - anterior_gs.to_f,
                                pago_real:           d.divida_real.to_f - anterior_rs.to_f,
                                saldo_dolar:         d.divida_dolar.to_f  - anterior_us.to_f,
                                saldo_guarani:       d.divida_guarani.to_f - anterior_gs.to_f,
                                saldo_real:          d.divida_real.to_f - anterior_rs.to_f,
                                desconto_dolar:      0,
                                desconto_guarani:    0,
                                desconto_real:       0,
                                interes_dolar:       0,
                                interes_guarani:     0,
                                interes_real:        0,
                                imposto_us:          imp_us.to_f,
                                imposto_gs:          imp_gs.to_f,
                                retencao_us:         rt_us.to_f,
                                retencao_gs:         rt_gs.to_f,
                                estado:              1,
                                liquidacao:          1,
                                rubro_id:            d.rubro_id,
                                centro_custo_id:     d.centro_custo_id,
                                plano_de_conta_id:   d.plano_de_conta_id,
                                tot_cotas:           d.tot_cotas
                                )
        end

      redirect_to(pago_path(@pago))
    end
    def get_moeda                   #
        @moeda =  Moeda.find(:first, :select => 'dolar_venda',:conditions =>  ["data = ?", params[:key]]) 

        return render :text => "<script type='text/javascript'>
                                        document.getElementById('pago_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                                </script>"
    end

    def get_moeda_real            #
        @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('pago_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end


    def nova_cota                   #
        @pago = Pago.find(params[:id])
    
        @proveedor  = Proveedore.all(:conditions => ["persona_id = ? AND liquidacao = 0 AND  divida_dolar > 0 ",@pago.persona_id],:order => 'documento_numero,cota')

        respond_to do |format|
            format.html { render :layout => 'consulta'}
            format.xml  { render :xml => @pago }
        end
    end

    def filtro_dividas              #

        @pago       = Pago.find(params[:id])
        @proveedor  = Proveedore.find(params[:pagos_ids])

        @proveedor.each do |proveedor|
            anterior_dolar     = Proveedore.sum(:pago_dolar, :conditions   => ["documento_numero = ? AND cota = ?",proveedor.documento_numero,proveedor.cota])
            anterior_guarani   = Proveedore.sum(:pago_guarani, :conditions => ["documento_numero = ? AND cota = ?",proveedor.documento_numero,proveedor.cota])
            saldo_dolar        = proveedor.divida_dolar.to_f - anterior_dolar.to_f
            saldo_guarani      = proveedor.divida_guarani.to_f - anterior_guarani.to_f

            PagosDetalhe.create(  :pago_id              => @pago.id,
                :vencimento           => proveedor.vencimento,
                :data                 => proveedor.data,
                :persona_id           => proveedor.persona_id,
                :persona_nome         => proveedor.persona_nome,
                :documento_nome       => proveedor.documento_nome,
                :documento_numero_01  => proveedor.documento_numero_01,
                :documento_numero_02  => proveedor.documento_numero_02,
                :documento_numero     => proveedor.documento_numero,
                :compra_id            => proveedor.compra_id,
                :cota                 => proveedor.cota,
                :estado               => 1,
                :liquidacao           => 1,
                :valor_dolar          => proveedor.divida_dolar.to_f,
                :valor_guarani        => proveedor.divida_guarani.to_f,
                :anterior_dolar       => anterior_dolar.to_f,
                :anterior_guarani     => anterior_guarani.to_f,
                :saldo_dolar          => saldo_dolar.to_f,
                :saldo_guarani        => saldo_guarani.to_f,
                :pago_dolar           => saldo_dolar.to_f,
                :pago_guarani         => saldo_guarani.to_f

            )


        end

        respond_to do |format|
            format.html {redirect_to "/pagos/show/#{params[:id]}"}
            format.xml  { render :xml => @pagos }
        end



    end

    def get_cliente                 #
        @cliente =  Persona.find(:first, :conditions =>  [ "nome = ?", params[:persona_busca]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('pago_ruc').value                = '#{@cliente.ruc.to_s}';
                              document.getElementById('pago_persona_id').value         = '#{@cliente.id.to_s}';
                              document.getElementById('pago_persona_nome').value       = '#{@cliente.nome.to_s}';
                            </script>"
    end

    def pago_final                  #
        @pago    = Pago.find(params[:id])
      @cd          = PagosDetalhe.all(:conditions => ['pago_id = ?',params[:id]])
      @tot_pago_us = PagosDetalhe.sum( :pago_dolar,     :conditions => ['pago_id = ?',params[:id]])
      @tot_pago_gs = PagosDetalhe.sum( :pago_guarani,   :conditions => ['pago_id = ?',params[:id]])
      @tot_pago_rs = PagosDetalhe.sum( :pago_real,      :conditions => ['pago_id = ?',params[:id]])
      @tot_des_us   = PagosDetalhe.sum( :desconto_dolar,  :conditions => ['pago_id = ?',params[:id]])
      @tot_des_gs   = PagosDetalhe.sum( :desconto_guarani,:conditions => ['pago_id = ?',params[:id]])
      @tot_des_rs   = PagosDetalhe.sum( :desconto_real,   :conditions => ['pago_id = ?',params[:id]])
      @tot_int_us   = PagosDetalhe.sum( :interes_dolar,   :conditions => ['pago_id = ?',params[:id]])
      @tot_int_gs   = PagosDetalhe.sum( :interes_guarani, :conditions => ['pago_id = ?',params[:id]])
      @tot_int_rs   = PagosDetalhe.sum( :interes_real, :conditions => ['pago_id = ?',params[:id]])
      @tot_ade_us   = PagosAdelanto.sum( :valor_us,   :conditions => ['pago_id = ?',params[:id]])
      @tot_ade_gs   = PagosAdelanto.sum( :valor_gs, :conditions => ['pago_id = ?',params[:id]])
      @tot_ade_rs   = PagosAdelanto.sum( :valor_rs, :conditions => ['pago_id = ?',params[:id]])

      @fecha_result_us = ( ( @tot_pago_us.to_f + @tot_int_us.to_f ) - ( @tot_des_us.to_f + @tot_ade_us.to_f ) )
      @fecha_result_gs = ( ( @tot_pago_gs.to_f + @tot_int_gs.to_f ) - ( @tot_des_gs.to_f + @tot_ade_gs.to_f ) )
      @fecha_result_rs = ( ( @tot_pago_rs.to_f + @tot_int_rs.to_f ) - ( @tot_des_rs.to_f + @tot_ade_rs.to_f ) )

      @financ_cred_us = PagosFinanca.sum(:valor_dolar, :conditions => ["pago_id = #{@pago.id} and cred_deb = 0 "])
      @financ_cred_gs = PagosFinanca.sum(:valor_guarani, :conditions => ["pago_id = #{@pago.id} and cred_deb = 0 "])
      @financ_cred_rs = PagosFinanca.sum(:valor_real, :conditions => ["pago_id = #{@pago.id} and cred_deb = 0 "])

      @financ_deb_us = PagosFinanca.sum(:valor_dolar, :conditions => ["pago_id = #{@pago.id} and cred_deb = 1 "])
      @financ_deb_gs = PagosFinanca.sum(:valor_guarani, :conditions => ["pago_id = #{@pago.id} and cred_deb = 1 "])
      @financ_deb_rs = PagosFinanca.sum(:valor_real, :conditions => ["pago_id = #{@pago.id} and cred_deb = 1 "])

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
      @ncs = FormFiscal.where("status != 0 and sigla_proc = 'CB' AND cod_proc = #{@pago.id} and tipo_doc = 3").select("id, tot_gs, doc_01, doc_02, doc, status")
      @fts = FormFiscal.where("status != 0 and sigla_proc = 'CB' AND cod_proc = #{@pago.id} and tipo_doc = 1").select("id, tot_gs, doc_01, doc_02, doc, status")
      render layout: 'chart'
    end

    def index
      Pago.destroy_all("usuario_created = #{current_user.id} and op = false" )
    end

    def busca
        params[:unidade] = current_unidade.id
        @pagos = Pago.filtro(params)
        render :layout => false
    end

    def show                        #
        @pago       = Pago.find(params[:id])
sql = "SELECT C.ID,
                      C.PERSONA_ID,
                      C.PERSONA_NOME,
                      C.LIQUIDACAO,
                      C.MOEDA,
                      C.TIPO,
                      C.DATA,
                      C.VENCIMENTO,
                      C.COMPRA_ID,
                      C.DOCUMENTO_NOME,
                      C.DOCUMENTO_NUMERO,
                      C.COTA,
                      C.ORIGINAL,
                      C.DIVIDA_DOLAR,
                      C.DIVIDA_GUARANI,
                      C.DIVIDA_REAL,
                      C.PAGO_DOLAR,
                      C.PAGO_GUARANI,
                      C.PAGO_REAL,
                      C.DESCRICAO,
                      C.DOCUMENTO_NUMERO_01,
                      C.documento_numero_02,
                      SG.DESCRICAO AS MARCA,
                      C.CENTRO_CUSTO_ID,
                      C.TOT_COTAS,
                      C.PLANO_DE_CONTA_ID,
                      C.TABELA,
                      CC.NOME AS CENTRO_CUSTO_NOME,
                      R.DESCRICAO AS RUBRO_NOME,
                      V.COTACAO AS COTACAO_VENDA,
                      V.COTACAO_RS_US AS COTZ_RS_US,
                      (V.IMPOSTO_05_DOLAR + V.IMPOSTO_10_DOLAR) AS IMPOSTO_US,
                      (V.IMPOSTO_05_GUARANI + V.IMPOSTO_10_GUARANI) AS IMPOSTO_GS,
                      ((V.IMPOSTO_05_DOLAR + V.IMPOSTO_10_DOLAR)  * 0.3) AS RETENCAO_US,
                      ((V.IMPOSTO_05_GUARANI + V.IMPOSTO_10_GUARANI) * 0.3) AS RETENCAO_GS,

                      ( SELECT SUM(AT.PAGO_DOLAR) FROM PROVEEDORES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} and  AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_US,
                      ( SELECT SUM(AT.PAGO_GUARANI) FROM PROVEEDORES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} and  AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_GS,
                      ( SELECT SUM(AT.PAGO_REAL) FROM PROVEEDORES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} and AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_RS
            FROM PROVEEDORES C
            LEFT JOIN COMPRAS V
            ON C.COMPRA_ID = V.ID

            LEFT JOIN SUB_GRUPOs SG
            ON V.SUB_GRUPO_ID = SG.ID

            LEFT JOIN CENTRO_CUSTOS CC
            ON CC.ID = C.CENTRO_CUSTO_ID

            LEFT JOIN PLANO_DE_CONTAS R
            ON R.ID = C.PLANO_DE_CONTA_ID


            WHERE C.UNIDADE_ID = #{current_unidade.id} and C.PERSONA_ID = #{@pago.persona_id} AND C.LIQUIDACAO = 0 AND (C.DIVIDA_GUARANI + C.DIVIDA_DOLAR ) > 0
            ORDER BY 8,12
                      "        
            @proveedor  = Proveedore.find_by_sql(sql)





        @total_pago_dolar   = PagosDetalhe.sum(:pago_dolar, :conditions => ['pago_id = ?',params[:id]])
        @total_pago_guarani = PagosDetalhe.sum(:pago_guarani, :conditions => ['pago_id = ?',params[:id]])
        @count              = PagosDetalhe.count(:id, :conditions => ['pago_id = ?',params[:id]])
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @pago }
        end
    end

    def comprovante
        @pago = Pago.find(params[:id])
        @detalhes    = PagosDetalhe.all( :conditions => ['pago_id = ?',params[:id]])
        @financas    = PagosFinanca.all( :conditions => ['pago_id = ?',params[:id]])
        @cf_last     = PagosFinanca.last(:conditions => ['pago_id = ?',params[:id]])
        @tot_cobro_us = PagosDetalhe.sum( :pago_dolar,     :conditions => ['pago_id = ?',params[:id]])
        @tot_cobro_gs = PagosDetalhe.sum( :pago_guarani,   :conditions => ['pago_id = ?',params[:id]])
        @tot_cobro_rs = PagosDetalhe.sum( :pago_real,      :conditions => ['pago_id = ?',params[:id]])

        render  :layout => false
    end



    def pago_adelanto
        @pago       = Pago.find(params[:id])
        @proveedor  = Proveedore.all(:conditions => ["persona_id = ? AND  tabela = 'ADELANTO_COTAS' AND liquidacao = 0 AND  ( pago_dolar + pago_guarani + pago_real)  > 0 ", @pago.persona_id],:order => 'vencimento')
    end


    def new                         #
        @pago = Pago.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @pago }
        end
    end

    def edit                        #
        @pago = Pago.find(params[:id])
        session[:pagina] = '1'
    end

    def create                      #
        @pago = Pago.new(params[:pago])
        @pago.usuario_created = current_user.id
        @pago.unidade_created = current_unidade.id
        @pago.unidade_id = current_unidade.id.to_i


        respond_to do |format|
            if @pago.save
                flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
                if @pago.adelanto.to_i == 1
                    format.html { redirect_to("/pagos/#{@pago.id}/pago_adelanto") }
                else
                    format.html { redirect_to(@pago) }
                end
                format.xml  { render :xml => @pago, :status => :created, :location => @pago }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @pago.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update                      #
        @pago = Pago.find(params[:id])
        @pago.usuario_updated = current_user.id
        @pago.unidade_updated = current_unidade.id

        respond_to do |format|

            if @pago.update_attributes(params[:pago])
                if @pago.adelanto.to_i == 1
                    format.html { redirect_to("/pagos/#{@pago.id}/pago_adelanto") }
                else
                    format.html { redirect_to(@pago) }
                end
                format.json { head :no_content }
                format.js { head :no_content }

            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @pago.errors, :status => :unprocessable_entity }
                
            end

        end
    end

    def destroy                     #
        @pago = Pago.find(params[:id])
        @pago.destroy

        respond_to do |format|
            format.html { redirect_to(pagos_url) }
            format.xml  { head :ok }
        end
    end
end

	
