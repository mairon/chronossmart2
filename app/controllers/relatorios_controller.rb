class RelatoriosController < ApplicationController

  def resultado_controle_km
    params[:unidade] = current_unidade.id
    @controle_kms = Relatorios.controle_km(params)
    render :layout => 'relatorio_view'
  end

  def resultado_rodados

      respond_to do |format|
        format.html do
          render  :pdf                    => "resultado_rodados",
                  :layout                 => "layer_relatorios",
                  :margin => {:top        => '0.90in',
                              :bottom     => '0.25in',
                              :left       => '0.10in',
                              :right      => '0.10in'},
                  :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                              :font_size  => 7,
                              :right      => "Pagina [page] de [toPage]",
                              :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
        end
      end
  end


  def resultado_entrada_modal
        respond_to do |format|
          if params["tipo"] == '1'
            format.html {
              xls = render_to_string :action => "resultado_entrada_modal", :layout => false
              kit = PDFKit.new(xls,
                               :encoding => 'UTF-8')
              send_data(xls,:filename => "resultado_entrada_modal-#{params[:mes]}-#{params[:ano]}.xls")
            }
          else

          format.html do
            render  :pdf                    => "resultado_abastecida_vendedor",
                    :layout                 => "layer_relatorios",
                    :orientation                    => 'Landscape',
                    :margin => {:top        => '0.95in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},
                    :header => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                                :font_size  => 7,
                                :spacing    => 20},
                    :footer => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
        end
      end
  end

  def resultado_fechamento_caixa
    render :layout => 'relatorio_view'
  end

	def resultado_ferias
        respond_to do |format|
          if params["tipo"] == '1'
            format.html {
              xls = render_to_string :action => "resultado_ponto_funciario", :layout => false
              kit = PDFKit.new(xls,
                               :encoding => 'UTF-8')
              send_data(xls,:filename => "resultado_ponto_funciario-#{params[:mes]}-#{params[:ano]}.xls")
            }
          else

          format.html do
            render  :pdf                    => "resultado_abastecida_vendedor",
                    :layout                 => "layer_relatorios",
                    :margin => {:top        => '0.95in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},
                    :header => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                                :font_size  => 7,
                                :spacing    => 20},
                    :footer => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
        end
      end
	end

    def resultado_ponto_funciario

    if params[:tipo_listado] == '1'
      unid = "AND P.UNIDADE_ID = #{params[:busca]["unidade"]}" unless params[:busca]["unidade"].blank?
      per  = "AND CP.USUARIO_ID = #{params[:busca]["empregado"]}" unless params[:busca]["empregado"].blank?
      sql = "

      SELECT DISTINCT CP.CREATED_AT AS DATETIME,
      CP.CREATED_AT,
              CP.CHECK_POINT_TYPE,
              CP.ID,
              P.NOME AS PERSONA_NOME
      FROM CHECK_POINTS CP

      INNER JOIN PERSONAS P
      ON P.ID = CP.PERSONA_ID

      WHERE CP.CREATED_AT::date BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
      #{unid} #{per}
      ORDER BY 5,1,2


      "

      @dias_trabalhos = Persona.find_by_sql(sql)
    end




    unless params[:busca]["empregado"].blank?
        uni = Persona.find_by_id(params[:busca]["empregado"], :select => 'id,nome')
        per = uni.nome
    else
        per = 'TODOS'
    end

    unless params[:busca]["unidade"].blank?
        uni = Unidade.find_by_id(params[:busca]["unidade"], :select => 'id,unidade_nome')
        un = uni.unidade_nome
    else
        un = 'TODOS'
    end

if params[:tipo_listado] == '3'
        head =
        "                                                                                                                                     #{current_unidade.nome_sys}
                                                                                                                     PUNTO DE EMPLEADO POR UNIDAD
- Periodo..: #{params[:inicio]} Hasta #{params[:final]}
- Empleado.: #{per}
- Unidad...: #{un}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                       Empleado                                                                                   Cargo                                             Dias        CH Reg.      CH Pontual      CH Comer.    Dif.Reg    Dif Pontual
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        "
elsif params[:tipo_listado] == '4'
        head =
        "                                                                                                                                     #{current_unidade.nome_sys}
                                                                                                                     PUNTO DE EMPLEADO POR UNIDAD
- Periodo..: #{params[:inicio]} Hasta #{params[:final]}
- Empleado.: #{per}
- Unidad...: #{un}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                       Empleado                                                                                     Cargo                                                         Dias        CH Reg.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        "



else
        head =
        "                                                                                                                                     #{current_unidade.nome_sys}
                                                                                                                     PUNTO DE EMPLEADO
- Periodo..: #{params[:inicio]} Hasta #{params[:final]}
- Empleado.: #{per}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   Fecha         Dia Semana      Entrada          Salida           Entrada         Salida    Hrs Reg.   Hrs Comer.   Obs.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        "

end

        respond_to do |format|
          if params["tipo"] == '1'
            format.html {
              xls = render_to_string :action => "resultado_ponto_funciario", :layout => false
              kit = PDFKit.new(xls,
                               :encoding => 'UTF-8')
              send_data(xls,:filename => "resultado_ponto_funciario-#{params[:mes]}-#{params[:ano]}.xls")
            }
          else

          format.html do
            render  :pdf                    => "resultado_abastecida_vendedor",
                    :layout                 => "layer_relatorios",
                    :margin => {:top        => '0.95in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},
                    :header => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                                :font_size  => 7,
                                :left       => head,
                                :spacing    => 20},
                    :footer => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
        end
      end
  end



    def resultado_sueldo
        @sueldo_detalhes = Relatorios.detalhe_sueldo(params)


        head =
        "                                                      #{$empresa_nome}
                                                SUELDO Y JORNALES DETALLADO

- Fecha : #{params[:inicio]} Hasta #{params[:final]}
-----------------------------------------------------------------------------------------------------------------------------------------
 Lanz.  Fecha    Tipo               Concepto                                                       Debito      Credito
-----------------------------------------------------------------------------------------------------------------------------------------

        "

        respond_to do |format|
          format.html do
            render  :pdf                    => "resultado_sueldo",
                    :layout                 => "layer_relatorios",
                    :margin => {:top        => '0.90in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},
                    :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :left       => head,
                                :spacing    => 18},
                    :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
        end
    end

def resultado_demonstrativo_resultados
      unless params[:busca]["cc"].blank?
        cc_desc = CentroCusto.find_by_id(params[:busca]["cc"])
        cc_desc_title =  '- ' << cc_desc.nome
      else
        cc_desc_title = 'TODOS...'
      end

			head =
				"                                                         #{current_unidade.nome_sys}
																												                    Demonstrativo de Resultado - DRE

#{t('DATE')}.........: #{params[:inicio]}  #{t('TO')} #{params[:final]}
Centro de Costo: #{cc_desc_title}
				"

	respond_to do |format|
	  if params[:tipo] == '1'
	    format.html {
	      xls = render_to_string :action => "resultado_demonstrativo_resultados", :layout => false
	      kit = PDFKit.new(xls,
	                       :encoding => 'UTF-8')
	      send_data(xls,:filename => "resultado_demonstrativo_resultados.xls")
	    }
	  else
				format.html do
					render  :pdf                    => "resultado_demonstrativo_resultados",
									:layout                 => "layer_relatorios",
									:margin => {:top        => '1.00in',
															:bottom     => '0.25in',
															:left       => '0.10in',
															:right      => '0.10in'},
									:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:left       => head,
															:spacing    => 18},
									:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:right      => "Pagina [page] de [toPage]",
															:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
		end
end

def resultado_evolucao_faturamento

			head =
				"									                                                                               #{current_unidade.nome_sys}
																												                      									                       Evolução de Faturamento

-ANO: #{params[:ano]}
				"

	respond_to do |format|
	  if params[:tipo] == '1'
	    format.html {
	      xls = render_to_string :action => "resultado_demonstrativo_resultados", :layout => false
	      kit = PDFKit.new(xls,
	                       :encoding => 'UTF-8')
	      send_data(xls,:filename => "resultado_demonstrativo_resultados.xls")
	    }
	  else
				format.html do
					render  :pdf                    => "resultado_demonstrativo_resultados",
									:layout                 => "layer_relatorios",
									:orientation            => 'Landscape',
									:margin => {:top        => '1.00in',
															:bottom     => '0.25in',
															:left       => '0.10in',
															:right      => '0.10in'},
									:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:left       => head,
															:spacing    => 18},
									:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:right      => "Pagina [page] de [toPage]",
															:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
		end
end


	def resultado_contratos
		@contratos = Relatorios.resultado_contratos(params)
		unless params[:busca]["centro_custo"].blank?
			cc_desc = CentroCusto.find_by_id(params[:busca]["centro_custo"])
			cc_desc_title =  '- ' << cc_desc.nome
		else
			cc_desc_title = 'TODOS...'
		end



			if params[:detalhe] == '0'
			head =
				"                                                         #{current_unidade.nome_sys}
																												                           #{t('LISTING').upcase} DE CONTRATOS

#{t('DATE')}..: #{params[:inicio]}  #{t('TO')} #{params[:final]}
CC....: #{cc_desc_title}
------------------------------------------------------------------------------------------------------------------------------------------
 Cod   Doc      Status   #{t('DATE')}   Final  CC                     Cliente               Tipo     Venc. Comp Obs                        Valor
------------------------------------------------------------------------------------------------------------------------------------------
				"

			elsif params[:detalhe] == '1'
			head =
				"                                                         #{current_unidade.nome_sys}
																												                           #{t('LISTING').upcase} DE CONTRATOS

#{t('DATE')}..: #{params[:inicio]}  #{t('TO')} #{params[:final]}
CC....: #{cc_desc_title}
------------------------------------------------------------------------------------------------------------------------------------------
 Cod   Doc      Status  #{t('DATE')}    Final   CC                 Cliente             Tipo    Prod/Serv.                 Qtd.    Unit.    Total
------------------------------------------------------------------------------------------------------------------------------------------
				"

			end

	respond_to do |format|

				format.html do
					render  :pdf                    => "resultado_contratos",
									:layout                 => "layer_relatorios",
									:margin => {:top        => '1.20in',
															:bottom     => '0.25in',
															:left       => '0.10in',
															:right      => '0.10in'},
									:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:left       => head,
															:spacing    => 21},
									:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:right      => "Pagina [page] de [toPage]",
															:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
				format.xls
		end
	end

		def resultado_nota_creditos
			@nota_creditos = Relatorios.nota_creditos(params)
			head =
				"                                                                         #{current_unidade.nome_sys}
																												                           #{t('LISTING').upcase} DE NOTA DE CREDITOS

#{t('DATE')}.........: #{params[:inicio]}  #{t('TO')} #{params[:final]}
------------------------------------------------------------------------------------------------------------------------------------------
	  Codigo       #{t('DATE')}     Cliente                                                Operacion                  Valor
------------------------------------------------------------------------------------------------------------------------------------------
				"

	respond_to do |format|
	  if params[:tipo] == '1'
	    format.html {
	      xls = render_to_string :action => "resultado_nota_creditos", :layout => false
	      kit = PDFKit.new(xls,
	                       :encoding => 'UTF-8')
	      send_data(xls,:filename => "resultado_nota_creditos.xls")
	    }
	  else
				format.html do
					render  :pdf                    => "resultado_nota_creditos",
									:layout                 => "layer_relatorios",
									:margin => {:top        => '1.20in',
															:bottom     => '0.25in',
															:left       => '0.10in',
															:right      => '0.10in'},
									:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:left       => head,
															:spacing    => 21},
									:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:right      => "Pagina [page] de [toPage]",
															:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
		end
	end
		def resultado_antecipo_empleado
			params[:unidade] = current_unidade.id
			@adelantos = Relatorios.antecipo_empleado(params)

			if params[:liquidacao] == '0'
				l = "EN ABERTAS"
			elsif params[:liquidacao] == '1'
				l = "CANCELADAS"
			else
				l = "TODOS"
			end

			head =
				"                                                                                #{current_unidade.nome_sys}
																												                           #{t('LISTING').upcase} DE ANTECIPO DE EMPLEADO
#{t('DATE')}.........: #{params[:inicio]}  #{t('TO')} #{params[:final]}
- Liquidacion...: #{l}
------------------------------------------------------------------------------------------------------------------------------------------
	Laz.   #{t('DATE')}    Venc.   Empleado                                           Doc.           Cuota       Valor           Pago         Saldo
------------------------------------------------------------------------------------------------------------------------------------------
				"

	respond_to do |format|
	  if params[:tipo] == '1'
	    format.html {
	      xls = render_to_string :action => "resultado_antecipo_empleado", :layout => false
	      kit = PDFKit.new(xls,
	                       :encoding => 'UTF-8')
	      send_data(xls,:filename => "rresultado_antecipo_empleado.xls")
	    }
	  else
				format.html do
					render  :pdf                    => "resultado_antecipo_empleado",
									:layout                 => "layer_relatorios",
									:margin => {:top        => '1.20in',
															:bottom     => '0.25in',
															:left       => '0.10in',
															:right      => '0.10in'},
									:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                              :font_size  => 7,
                              :left       => head,
                              :spacing    => 21},
                  :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                              :font_size  => 7,
                              :right      => "Pagina [page] de [toPage]",
                              :left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
		end
	end





	def fluxo_caixa_dt
		if params[:formato] == '2'
			if params[:mov] == '0'
				@entradas = Cliente.where( vencimento: params[:data], liquidacao: 0 )
			else
				@saidas = Proveedore.where( vencimento: params[:data], liquidacao: 0 )
			end

		else
			if params[:mov] == '0'
				@entradas = Cliente.where(moeda: params[:moeda], vencimento: params[:data], liquidacao: 0 )
			else
				@saidas = Proveedore.where(moeda: params[:moeda], vencimento: params[:data], liquidacao: 0 )
			end

		end

		render layout: 'consulta'

	end

    def fluxo_caixa
    @ctz = Moeda.order('data').last
    @unidade = Unidade.last

        render layout: 'chart'
    end

    def fluxo_caixa_realizado
        render layout: 'chart'
    end

    def fluxo_caixa_previsto_realizado
    @ctz = Moeda.order('data').last
    @unidade = Unidade.last

        render layout: 'chart'
    end

    def resultado_fluxo_caixa

    @ctz = Moeda.order('data').last
    @saldo_us = Financa.where("moeda = 0").sum("entrada_dolar - saida_dolar")
    @saldo_gs = Financa.where("moeda = 1").sum("entrada_guarani - saida_guarani")
    @saldo_rs = Financa.where("moeda = 2").sum("entrada_real - saida_real")

        if params[:visao] == '0'

        sql_cl = "SELECT DATA, SUM(DIVIDA_GS) AS DIVIDA_GS, SUM(DIVIDA_US) AS DIVIDA_US, SUM(DIVIDA_RS) AS DIVIDA_RS FROM (
                    SELECT DAY::DATE AS DATA,
                       0 AS DIVIDA_GS,
                       0 AS DIVIDA_US,
                       0 AS DIVIDA_RS
                    FROM   GENERATE_SERIES(TIMESTAMP '#{Time.now.to_date}', '#{params[:final].split("/").reverse.join("-")}', '1 DAY') DAY
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(0) AS DIVIDA_GS,
                      SUM(C.DIVIDA_DOLAR) AS DIVIDA_US,
                      SUM(0) AS DIVIDA_RS
                    FROM CLIENTES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                    WHERE CT.TESOURARIA = FALSE
                    AND C.LIQUIDACAO = 0
                    AND C.MOEDA = 0
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(C.DIVIDA_GUARANI) AS DIVIDA_GS,
                      SUM(0) AS DIVIDA_US,
                      SUM(0) AS DIVIDA_RS
                    FROM CLIENTES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                    WHERE CT.TESOURARIA = FALSE
                    AND C.LIQUIDACAO = 0
                    AND C.MOEDA = 1
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(0) AS DIVIDA_GS,
                      SUM(0) AS DIVIDA_US,
                      SUM(C.DIVIDA_REAL) AS DIVIDA_RS
                    FROM CLIENTES C
                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                    WHERE CT.TESOURARIA = FALSE
                    AND C.LIQUIDACAO = 0
                    AND C.MOEDA = 2
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                      ) AS FOO
                    GROUP BY 1
                    ORDER BY 1"

        sql_prov = "
        SELECT DATA, SUM(DIVIDA_GS) AS DIVIDA_GS, SUM(DIVIDA_US) AS DIVIDA_US, SUM(DIVIDA_RS) AS DIVIDA_RS FROM (
                    SELECT DAY::DATE AS DATA,
                       0 AS DIVIDA_GS,
                       0 AS DIVIDA_US,
                       0 AS DIVIDA_RS
                    FROM   GENERATE_SERIES(TIMESTAMP '#{Time.now.to_date}', '#{params[:final].split("/").reverse.join("-")}', '1 DAY') DAY
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(0) AS DIVIDA_GS,
                      SUM(C.DIVIDA_DOLAR) AS DIVIDA_US,
                      SUM(0) AS DIVIDA_RS
                    FROM PROVEEDORES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                    AND C.MOEDA = 0
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(C.DIVIDA_GUARANI) AS DIVIDA_GS,
                      SUM(0) AS DIVIDA_US,
                      SUM(0) AS DIVIDA_RS
                    FROM PROVEEDORES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                    AND C.MOEDA = 1
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(0) AS DIVIDA_GS,
                      SUM(0) AS DIVIDA_US,
                      SUM(C.DIVIDA_REAL) AS DIVIDA_RS
                    FROM PROVEEDORES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                    AND C.MOEDA = 2
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                      ) AS FOO
                    GROUP BY 1
                    ORDER BY 1"


        sql_saldo = "
        SELECT DATA, SUM(DIVIDA_GS) AS DIVIDA_GS, SUM(DIVIDA_US) AS DIVIDA_US, SUM(DIVIDA_RS) AS DIVIDA_RS FROM (
                    SELECT DAY::DATE AS DATA,
                       0 AS DIVIDA_GS,
                       0 AS DIVIDA_US,
                       0 AS DIVIDA_RS
                    FROM   GENERATE_SERIES(TIMESTAMP '#{Time.now.to_date}', '#{params[:final].split("/").reverse.join("-")}', '1 DAY') DAY
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(0) AS DIVIDA_GS,
                      SUM(C.DIVIDA_DOLAR * -1) AS DIVIDA_US,
                      SUM(0) AS DIVIDA_RS
                    FROM PROVEEDORES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                    AND C.MOEDA = 0
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(C.DIVIDA_GUARANI * -1) AS DIVIDA_GS,
                      SUM(0) AS DIVIDA_US,
                      SUM(0) AS DIVIDA_RS
                    FROM PROVEEDORES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                    AND C.MOEDA = 1
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(0) AS DIVIDA_GS,
                      SUM(0) AS DIVIDA_US,
                      SUM(C.DIVIDA_REAL * -1) AS DIVIDA_RS
                    FROM PROVEEDORES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                    AND C.MOEDA = 2
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(0) AS DIVIDA_GS,
                      SUM(C.DIVIDA_DOLAR) AS DIVIDA_US,
                      SUM(0) AS DIVIDA_RS
                    FROM CLIENTES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                    AND C.MOEDA = 0
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(C.DIVIDA_GUARANI) AS DIVIDA_GS,
                      SUM(0) AS DIVIDA_US,
                      SUM(0) AS DIVIDA_RS
                    FROM CLIENTES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                    AND C.MOEDA = 1
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                    UNION ALL

                    SELECT C.VENCIMENTO AS DATA,
                      SUM(0) AS DIVIDA_GS,
                      SUM(0) AS DIVIDA_US,
                      SUM(C.DIVIDA_REAL) AS DIVIDA_RS
                    FROM CLIENTES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                    AND C.MOEDA = 2
                    AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                    GROUP BY 1

                      ) AS FOO
                    GROUP BY 1
                    ORDER BY 1"
    else

      sql_cl = "SELECT DATA, SUM(DIVIDA_GS) AS DIVIDA_GS, SUM(DIVIDA_US) AS DIVIDA_US, SUM(DIVIDA_RS) AS DIVIDA_RS FROM (
                  SELECT date_trunc('month',DAY::DATE) AS DATA,
                     0 AS DIVIDA_GS,
                     0 AS DIVIDA_US,
                     0 AS DIVIDA_RS
                  FROM   GENERATE_SERIES(TIMESTAMP '#{Time.now.to_date}', '#{params[:final].split("/").reverse.join("-")}', '1 DAY') DAY
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(0) AS DIVIDA_GS,
                    SUM(C.DIVIDA_DOLAR) AS DIVIDA_US,
                    SUM(0) AS DIVIDA_RS
                  FROM CLIENTES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 0
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(C.DIVIDA_GUARANI) AS DIVIDA_GS,
                    SUM(0) AS DIVIDA_US,
                    SUM(0) AS DIVIDA_RS
                  FROM CLIENTES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 1
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(0) AS DIVIDA_GS,
                    SUM(0) AS DIVIDA_US,
                    SUM(C.DIVIDA_REAL) AS DIVIDA_RS
                  FROM CLIENTES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 2
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                    ) AS FOO
                  GROUP BY 1
                  ORDER BY 1"

      sql_prov = "
      SELECT DATA, SUM(DIVIDA_GS) AS DIVIDA_GS, SUM(DIVIDA_US) AS DIVIDA_US, SUM(DIVIDA_RS) AS DIVIDA_RS FROM (
                  SELECT date_trunc('month', DAY::DATE) AS DATA,
                     0 AS DIVIDA_GS,
                     0 AS DIVIDA_US,
                     0 AS DIVIDA_RS
                  FROM   GENERATE_SERIES(TIMESTAMP '#{Time.now.to_date}', '#{params[:final].split("/").reverse.join("-")}', '1 DAY') DAY
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(0) AS DIVIDA_GS,
                    SUM(C.DIVIDA_DOLAR) AS DIVIDA_US,
                    SUM(0) AS DIVIDA_RS
                  FROM PROVEEDORES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 0
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(C.DIVIDA_GUARANI) AS DIVIDA_GS,
                    SUM(0) AS DIVIDA_US,
                    SUM(0) AS DIVIDA_RS
                  FROM PROVEEDORES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 1
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(0) AS DIVIDA_GS,
                    SUM(0) AS DIVIDA_US,
                    SUM(C.DIVIDA_REAL) AS DIVIDA_RS
                  FROM PROVEEDORES C
                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 2
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                    ) AS FOO
                  GROUP BY 1
                  ORDER BY 1"


      sql_saldo = "
      SELECT DATA, SUM(DIVIDA_GS) AS DIVIDA_GS, SUM(DIVIDA_US) AS DIVIDA_US, SUM(DIVIDA_RS) AS DIVIDA_RS FROM (
                  SELECT date_trunc('month', DAY::DATE) AS DATA,
                     0 AS DIVIDA_GS,
                     0 AS DIVIDA_US,
                     0 AS DIVIDA_RS
                  FROM   GENERATE_SERIES(TIMESTAMP '#{Time.now.to_date}', '#{params[:final].split("/").reverse.join("-")}', '1 DAY') DAY
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(0) AS DIVIDA_GS,
                    SUM(C.DIVIDA_DOLAR * -1) AS DIVIDA_US,
                    SUM(0) AS DIVIDA_RS
                  FROM PROVEEDORES C

                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 0
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(C.DIVIDA_GUARANI * -1) AS DIVIDA_GS,
                    SUM(0) AS DIVIDA_US,
                    SUM(0) AS DIVIDA_RS
                  FROM PROVEEDORES C
                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 1
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(0) AS DIVIDA_GS,
                    SUM(0) AS DIVIDA_US,
                    SUM(C.DIVIDA_REAL * -1) AS DIVIDA_RS
                  FROM PROVEEDORES C
                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 2
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(0) AS DIVIDA_GS,
                    SUM(C.DIVIDA_DOLAR) AS DIVIDA_US,
                    SUM(0) AS DIVIDA_RS
                  FROM CLIENTES C
                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 0
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(C.DIVIDA_GUARANI) AS DIVIDA_GS,
                    SUM(0) AS DIVIDA_US,
                    SUM(0) AS DIVIDA_RS
                  FROM CLIENTES C
                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 1
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                  UNION ALL

                  SELECT date_trunc('month',C.VENCIMENTO) AS DATA,
                    SUM(0) AS DIVIDA_GS,
                    SUM(0) AS DIVIDA_US,
                    SUM(C.DIVIDA_REAL) AS DIVIDA_RS
                  FROM CLIENTES C
                    LEFT JOIN CONTAS CT
                    ON CT.ID = C.CONTA_ID

                  WHERE C.LIQUIDACAO = 0
                  AND C.MOEDA = 2
                  AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{params[:final].split("/").reverse.join("-")}'
                  GROUP BY 1

                    ) AS FOO
                  GROUP BY 1
                  ORDER BY 1"

    end
        @fluxo_caixa_cl = Cliente.find_by_sql(sql_cl)

        @fluxo_caixa_prov = Cliente.find_by_sql(sql_prov)

        @fluxo_caixa_saldo = Cliente.find_by_sql(sql_saldo)

        render layout: false
    end


	def resultado_fluxo_caixa_realizado

		ct = "AND F.CONTA_ID IN (?) " unless  params[:busca_conta].blank?
		sql_saldo_cx = "SELECT C.NOME AS CONTA_NOME,
										      SUM(F.ENTRADA_REAL - F.SAIDA_REAL) AS SALDO_RS
										FROM FINANCAS F

										INNER JOIN CONTAS C
										ON C.ID = F.CONTA_ID
										WHERE C.TIPO = 0 AND C.MOEDA = #{params[:moeda]} AND DATA < '#{params[:inicio].split("/").reverse.join("-")}'
										#{ct}
										GROUP BY 1"

	@saldo_cx = Financa.find_by_sql([sql_saldo_cx,params[:busca_conta]])


	sql_saldo_bc = "SELECT C.NOME AS CONTA_NOME,
										      SUM(F.ENTRADA_REAL - F.SAIDA_REAL) AS SALDO_RS
										FROM FINANCAS F

										INNER JOIN CONTAS C
										ON C.ID = F.CONTA_ID
										WHERE C.TIPO = 1 AND F.CONCILIACAO = TRUE AND C.MOEDA = #{params[:moeda]} AND F.DATA < '#{params[:inicio].split("/").reverse.join("-")}' #{ct}
										GROUP BY 1"
	@saldo_bc = Financa.find_by_sql([sql_saldo_bc, params[:busca_conta]])


	sql_mov_fc = "SELECT F.DATA AS VENCIMENTO,
						     COALESCE(F.PERSONA_NOME, 'OP. FINANCEIRO') AS PERSONA_NOME,
							   F.CONCEPTO AS DESCRICAO,
							   COALESCE(CC.NOME, 'OP. FINANCEIRA') AS CENTRO_CUSTO_NOME,
							   COALESCE(R.DESCRICAO, 'OP. FINANCEIRA') AS RUBRO_NOME,
							   '' AS DOCUMENTO_NUMERO_01,
							   '' AS DOCUMENTO_NUMERO_02,
							   '' AS DOCUMENTO_NUMERO,
							   '' AS COTA,
							   C.NOME AS CONTA_NOME,
							   F.ENTRADA_REAL,
							   F.SAIDA_REAL
						FROM FINANCAS F
						INNER JOIN CONTAS C
						ON C.ID = F.CONTA_ID
						LEFT JOIN CENTRO_CUSTOS CC
						ON CC.ID = F.CENTRO_CUSTO_ID
						LEFT JOIN RUBROS R
						ON R.ID = F.RUBRO_ID
						WHERE F.MOEDA = #{params[:moeda]}
						AND F.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{ct}


						ORDER BY 1"

	@mov_fc = Financa.find_by_sql([sql_mov_fc, params[:busca_conta] ])


				head =
				"                                                                 #{current_unidade.nome_sys}
																														                   FLUXO DE CAIXA - REALIZADO


#{t('DATE')} : #{params[:inicio]} #{t('TO')} #{params[:final]}
-----------------------------------------------------------------------------------------------------------------------------------------
 Favorecido                 CC                #{t('CLASSIFICATION')}     Descrição                       Doc.          Entrada   Saida     Saldo
-----------------------------------------------------------------------------------------------------------------------------------------

				"

		respond_to do |format|
			format.html do
				render  :pdf                    => "resultado_fluxo_caixa",
								:layout                 => "layer_relatorios",
								:margin => {:top        => '0.80in',
														:bottom     => '0.25in',
														:left       => '0.10in',
														:right      => '0.10in'},
								:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:left       => head,
														:spacing    => 15},
								:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:right      => "Pagina [page] de [toPage]",
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
			format.xls
		end
	end



	def resultado_detalhe_atraso_receber
		sql = "	SELECT  persona_nome, vencimento, divida_guarani - cobro_guarani AS divida_valor
									FROM clientes
									WHERE vencimento < '#{params[:dtAtrasoReceber]}' AND liquidacao = 0"

		@acumulado_receber = Cliente.find_by_sql(sql)
	end


	def resultado_detalhe_atraso_pagar
		sql = " 	SELECT documento_nome, persona_nome AS compra, divida_guarani - pago_guarani AS divida_valor, data
									FROM proveedores
									WHERE vencimento < '#{params[:dtAtrasoPagar]}' AND liquidacao = 0"

		@acumulado_pagar = Cliente.find_by_sql(sql)
	end


	def resultado_detalhe_efetivo
		sqlCaixas = "	SELECT 	c.nome,
							  		CASE WHEN #{params[:moeda]} = 1 THEN
										sum(entrada_guarani - saida_guarani)
									ELSE
										sum(entrada_dolar - saida_dolar)
									END AS valor
						FROM financas f
						LEFT OUTER JOIN contas c ON c.id = f.conta_id
						WHERE f.tipo = 0 AND f.data < '#{params[:dtEfetivo]}'
						GROUP BY c.id"

		sqlBancos = "	SELECT 	c.nome,
									CASE WHEN #{params[:moeda]} = 1 THEN
										sum(entrada_guarani - saida_guarani)
									ELSE
										sum(entrada_dolar - saida_dolar)
									END AS valor
						FROM financas f
						LEFT OUTER JOIN contas c ON c.id = f.conta_id
						WHERE f.tipo = 1 AND f.data < '#{params[:dtEfetivo]}'
						GROUP BY c.id"

		@caixas = Financa.find_by_sql(sqlCaixas)
		@bancos = Financa.find_by_sql(sqlBancos)
	end


	def resultado_detalhe_a_receber
		sql = "	SELECT  personas.nome,
					      CASE WHEN #{params[:moeda]} = 1 THEN
							sum(divida_guarani)
						ELSE
							sum(divida_dolar)
						END
						AS divida_valor
				FROM clientes
				LEFT OUTER JOIN personas ON personas.id = clientes.persona_id
				WHERE vencimento = '#{params[:dtContaReceber]}' AND liquidacao = 0
				GROUP BY personas.id"

		@contas = Cliente.find_by_sql(sql)
	end


	def resultado_detalhe_a_pagar
		sql = " 	SELECT personas.nome,
						CASE WHEN #{params[:moeda]} = 1 THEN
							sum(divida_guarani)
						ELSE
							sum(divida_dolar)
						END
						AS divida_valor
				FROM proveedores
				LEFT OUTER JOIN personas ON personas.id = proveedores.persona_id
				WHERE vencimento = '#{params[:dtContaPagar]}' AND liquidacao = 0
				GROUP BY personas.id "

		@contas = Financa.find_by_sql(sql)
	end


	def resultado_detalhe_cheques_diferidos
		sql = "	SELECT  	c.id,
							c.nome AS conta_nome,
							p.nome AS persona_nome,
							CASE WHEN #{params[:moeda]} = 1 THEN
								sum(entrada_guarani - saida_guarani)
							ELSE
								sum(entrada_dolar - saida_dolar)
							END AS valor
				FROM financas f
				LEFT OUTER JOIN contas c ON c.id = f.conta_id
				LEFT OUTER JOIN personas p ON p.id = f.persona_id
				WHERE cheque_status = 1 AND f.diferido = '#{params[:dtChequeDiferido]}'
									   		AND f.data <> '#{params[:dtChequeDiferido]}'
				GROUP BY c.id, p.id, f.id"

		@cheques = Financa.find_by_sql(sql)
	end


	def resultado_detalhe_cheques_emitidos
		sql = "	SELECT 	c.id,
						c.nome AS conta_nome,
						p.nome AS persona_nome,
						CASE WHEN #{params[:moeda]} = 1 THEN
							saida_guarani
						ELSE
							saida_dolar
						END AS valor
				FROM financas f
				LEFT OUTER JOIN contas c ON c.id = f.conta_id
				LEFT OUTER JOIN personas p ON p.id = f.persona_id
				WHERE cheque_status = 0 AND f.diferido = '#{params[:dtChequeEmitido]}'
									   		AND f.data <> '#{params[:dtChequeEmitido]}'
				GROUP BY c.id, p.id, f.id"

		@cheques = Financa.find_by_sql(sql)
	end

	def resultado_pago_antecipado
				@pagos = Relatorios.pago_antecipado(params)


				head =
				"                                                   #{current_unidade.nome_sys}
																														PAGOS ANTECIPADOS
#{t('DATE')} : #{params[:inicio]}
-----------------------------------------------------------------------------------------------------------------------------------------
 #{t('DATE')}   Diferido  Cheque           Doc.               Concepto                                      Haber           Debe         Saldo
-----------------------------------------------------------------------------------------------------------------------------------------

				"

				respond_to do |format|
					format.html do
						render  :pdf                    => "resultado_pago_antecipado",
										:layout                 => "layer_relatorios",
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
																:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
					end
				end
		end

	def result_vendas_produtos

		params[:unidade] = current_unidade.id

		@vendas = Relatorios.vendas_produto(params)

	  if params[:tipo] == '1'
      respond_to do |format|
  	    format.html {
  	      xls = render_to_string :action => "result_vendas_produtos", :layout => false
  	      kit = PDFKit.new(xls,
  	                       :encoding => 'UTF-8')
  	      send_data(xls,:filename => "result_vendas_produtos.xls")
  	    }
      end
	  else
			render :layout => 'relatorio_view'
    end
	end

	def resultado_fopag
		unless params[:busca]["cc"].blank?
			cc = "AND CC.CENTRO_CUSTO_ID = '#{params[:busca]["cc"]}'" unless params[:busca]["cc"].blank?
			cc_fat = "AND V.UNIDADE_ID = '#{params[:busca]["cc"]}'" unless params[:busca]["cc"].blank?
			cc_desc = CentroCusto.find_by_id(params[:busca]["cc"])
			cc_desc_title =  '- ' << cc_desc.nome
		else
			cc_desc_title = 'TODOS...'
		end
		ordem = "Nombre" if params["order"] == '0'
		ordem = "Tiempo en la empresa" if params["order"] == '1'
		ordem = "Departamento" if params["order"] == '2'

		@fopags = Relatorios.fopag(params)


				head =
				"                                                   #{current_unidade.nome_sys}
																																	FOPAG
- Mes Referente : #{params[:mes]} #{params[:ano]}
- CC....: #{params[:busca]["cc"]} #{cc_desc_title}
- Ordenado por: #{ordem}
_________________________________________________________________________________________________________________________________________
				"

		respond_to do |format|
			if params[:tipo] == '1'
				format.xls { send_data @fopags.to_xls }
			 else
				format.html do
					render  :pdf                    => "resultado_fopag",
									:layout                 => "layer_relatorios",
									:margin => {:top        => '0.90in',
															:bottom     => '0.25in',
															:left       => '0.10in',
															:right      => '0.10in'},
									:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:left       => head,
															:spacing    => 15},
									:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:right      => "Pagina [page] de [toPage]",
															:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
		end
	end

		def resultado_planilha_custos
				params[:unidade] = current_unidade.id
				unless params[:busca]["cc"].blank?
					cc = "AND CC.UNIDADE_ID = '#{params[:busca]["cc"]}'" unless params[:busca]["cc"].blank?
					cc_fat = "AND V.UNIDADE_ID = '#{params[:busca]["cc"]}'" unless params[:busca]["cc"].blank?
					cc_desc = Unidade.find_by_id(params[:busca]["cc"])
					cc_desc_title =  '- ' << cc_desc.unidade_nome
				else
					cc_desc_title = 'TODOS...'
				end
				sql_f = "
								SELECT RUBRO_ID,MAX(R.CODIGO) AS COD, MAX(GRUPO_CUSTO_NOME) AS GRUPO_CUSTO_NOME, MAX(R.DESCRICAO) AS DESC, SUM(VALOR_US) AS VALOR_US, SUM(VALOR_GS) AS VALOR_GS, SUM(VALOR_RS) AS VALOR_RS
								FROM (
											SELECT
															CC.RUBRO_ID,
															MAX(R.CODIGO) AS COD,
															MAX(PC.DESCRICAO) AS GRUPO_CUSTO_NOME,
															MAX(R.DESCRICAO) AS DESC,
															SUM(CC.VALOR_US) AS VALOR_US,
															SUM(CC.VALOR_GS) AS VALOR_GS,
															SUM(CC.VALOR_RS) AS VALOR_RS
											 FROM COMPRAS_CUSTOS CC
											 INNER JOIN RUBROS R
											 ON R.ID = CC.RUBRO_ID

											 LEFT JOIN PLANO_DE_CONTAS PC
											 ON PC.CODIGO = SUBSTR(R.CODIGO, 0, 9)

											 INNER JOIN CENTRO_CUSTOS CTC
											 ON CTC.ID = CC.CENTRO_CUSTO_ID
											 WHERE R.CODIGO LIKE '1.%' #{cc}
											 AND  CC.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}'
											 GROUP BY 1



								 ) T
								 INNER JOIN RUBROS R
								 ON R.ID = T.RUBRO_ID
								 GROUP BY 1
								 ORDER BY 2, 5 DESC
								"

				sql_v = "
								SELECT RUBRO_ID,MAX(R.CODIGO) AS COD, MAX(GRUPO_CUSTO_NOME) AS GRUPO_CUSTO_NOME, MAX(R.DESCRICAO) AS DESC, SUM(VALOR_US) AS VALOR_US, SUM(VALOR_GS) AS VALOR_GS, SUM(VALOR_RS) AS VALOR_RS
								FROM (
											SELECT
															CC.RUBRO_ID,
															MAX(R.CODIGO) AS COD,
															MAX(PC.DESCRICAO) AS GRUPO_CUSTO_NOME,
															MAX(R.DESCRICAO) AS DESC,
															SUM(CC.VALOR_US) AS VALOR_US,
															SUM(CC.VALOR_GS) AS VALOR_GS,
															SUM(CC.VALOR_RS) AS VALOR_RS
											 FROM COMPRAS_CUSTOS CC
											 INNER JOIN COMPRAS C
											 ON C.ID = CC.COMPRA_ID

											 INNER JOIN RUBROS R
											 ON R.ID = CC.RUBRO_ID
											 LEFT JOIN PLANO_DE_CONTAS PC
											 ON PC.CODIGO = SUBSTR(R.CODIGO, 0, 9)

											 INNER JOIN CENTRO_CUSTOS CTC
											 ON CTC.ID = CC.CENTRO_CUSTO_ID

											 WHERE R.CODIGO LIKE '2.%' #{cc}
											 AND  CTC.ACTIVE = TRUE AND CC.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}'
											 GROUP BY 1

								 ) T
								 INNER JOIN RUBROS R
								 ON R.ID = T.RUBRO_ID
								 GROUP BY 1
								 ORDER BY 2,5 DESC
								"


				sql_fat = "SELECT SUM(VF.QUANTIDADE * VF.UNITARIO_DOLAR) AS FAT_US,
													SUM(VF.QUANTIDADE * VF.UNITARIO_GUARANI) AS FAT_GS,
													SUM(VF.QUANTIDADE * VF.UNITARIO_REAL) AS FAT_RS
										FROM VENDAS_PRODUTOS VF
										INNER JOIN VENDAS V
										ON V.ID = VF.VENDA_ID
										WHERE V.OP = TRUE AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}' #{cc_fat}"



		    sql_cmv = "SELECT
		    							P.TIPO_PRODUTO,
		                  SUM( VP.QUANTIDADE * COALESCE((SELECT SS.UNITARIO_GUARANI FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.PRODUTO_ID = VP.PRODUTO_ID  ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1),0)) CUSTO_MEDIO_GS,
                  		SUM( VP.QUANTIDADE * COALESCE((SELECT SS.UNITARIO_DOLAR FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.PRODUTO_ID = VP.PRODUTO_ID  ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1),0)) CUSTO_MEDIO_US

		            FROM VENDAS_PRODUTOS VP
		            INNER JOIN VENDAS  V
		            ON V.ID = VP.VENDA_ID
		            INNER JOIN PRODUTOS  P
		            ON P.ID = VP.PRODUTO_ID

		            WHERE  V.OP = TRUE AND P.TIPO_PRODUTO = 0
		            AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}' #{cc_fat}
		            GROUP BY 1"

		    sql_cmv_composto = "SELECT
		    						P.TIPO_PRODUTO,
                 		SUM(VP.QUANTIDADE * P.custo_base_gs ) AS CUSTO_MEDIO_GS,
                    SUM(VP.QUANTIDADE * P.custo_base_Us) AS CUSTO_MEDIO_US
		            FROM VENDAS_PRODUTOS VP
		            INNER JOIN VENDAS  V
		            ON V.ID = VP.VENDA_ID
		            INNER JOIN PRODUTOS  P
		            ON P.ID = VP.PRODUTO_ID

		            WHERE V.OP = TRUE AND P.TIPO_PRODUTO = 2
		            AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
		            #{cc_fat}
		            group by 1
		            "

		    sql_cmv_serv = "SELECT
				    						P.TIPO_PRODUTO,
		                 		SUM(VP.QUANTIDADE * P.custo_base_gs ) AS CUSTO_MEDIO_GS,
		                    SUM(VP.QUANTIDADE * P.custo_base_Us) AS CUSTO_MEDIO_US
		            FROM VENDAS_PRODUTOS VP
		            INNER JOIN VENDAS  V
		            ON V.ID = VP.VENDA_ID
		            INNER JOIN PRODUTOS  P
		            ON P.ID = VP.PRODUTO_ID

		            WHERE V.OP = TRUE AND P.TIPO_PRODUTO = 1
		            AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
		            #{cc_fat}
		            group by 1
		            "




					#CONTRATOS RECORRENTES

					sql = "SELECT CC.NOME AS CENTRO_CUSTO_NOME,
										       SUM(C.DIVIDA_DOLAR) AS DIVIDA_DOLAR,
											     SUM(C.DIVIDA_GUARANI) AS DIVIDA_GUARANI,
											     SUM(C.DIVIDA_REAL) AS DIVIDA_REAL
										FROM CLIENTES C
										INNER JOIN  CONTRATOS CT
										ON CT.ID = C.TABELA_ID AND C.TABELA = 'CONTRATOS'

										INNER JOIN CENTRO_CUSTOS CC
										ON CC.ID = CT.CENTRO_CUSTO_ID

										WHERE C.TABELA = 'CONTRATOS' AND CC.ACTIVE = TRUE
										AND CT.TIPO = 0 AND C.VENCIMENTO BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
										GROUP BY 1
										ORDER BY 1
										"

						@contratos_recorrentes = Contrato.find_by_sql(sql)

					#CONTRATOS POR PG

					sqlpg = "SELECT CC.NOME AS CENTRO_CUSTO_NOME,
										       SUM(C.COBRO_DOLAR) AS DIVIDA_DOLAR,
											     SUM(C.COBRO_GUARANI) AS DIVIDA_GUARANI,
											     SUM(C.COBRO_REAL) AS DIVIDA_REAL

										FROM CLIENTES C

										INNER JOIN CENTRO_CUSTOS CC
										ON CC.ID = C.CENTRO_CUSTO_ID

										WHERE CC.ACTIVE = TRUE
										AND C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
										GROUP BY 1
										ORDER BY 1
										"

						@contratos_recorrentes_pg = Cliente.find_by_sql(sqlpg)


					#CONTRATOS FIXOS

					sqlf = "SELECT CC.NOME AS CENTRO_CUSTO_NOME,
										       SUM(C.VALOR_US) AS VALOR_US,
											     SUM(C.VALOR_GS) AS VALOR_GS,
											     SUM(C.VALOR_RS) AS VALOR_RS

										FROM CONTRATOS C
										INNER JOIN CENTRO_CUSTOS CC
										ON CC.ID = C.CENTRO_CUSTO_ID

										WHERE CC.ACTIVE = TRUE
										AND C.TIPO = 1 AND C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
										GROUP BY 1
										ORDER BY 1
					"

				@contratos_fixos = Contrato.find_by_sql(sqlf)
				@fixos       = Rubro.find_by_sql(sql_f)
				@variaveis   = Rubro.find_by_sql(sql_v)
				@faturamento = Venda.find_by_sql(sql_fat)
				@uso_e_consumo_us_fixo = ConsumicaoInternaProduto.joins(:consumicao_interna).where("consumicao_internas.tipo_economico = 1 AND consumicao_internas.data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'").sum('consumicao_interna_produtos.total_dolar')
				@uso_e_consumo_gs_fixo = ConsumicaoInternaProduto.joins(:consumicao_interna).where("consumicao_internas.tipo_economico = 1 AND consumicao_internas.data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'").sum('consumicao_interna_produtos.total_guarani')

				@uso_e_consumo_us_variavel = ConsumicaoInternaProduto.joins(:consumicao_interna).where("consumicao_internas.tipo_economico = 2 AND consumicao_internas.data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'").sum('consumicao_interna_produtos.total_dolar')
				@uso_e_consumo_gs_variavel = ConsumicaoInternaProduto.joins(:consumicao_interna).where("consumicao_internas.tipo_economico = 2 AND consumicao_internas.data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'").sum('consumicao_interna_produtos.total_guarani')
 				@comissao_us = SueldosDetalhe.where("tipo = 'COMISION' and data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'").sum(:credito_us)
				@comissao_gs = SueldosDetalhe.where("tipo = 'COMISION' and data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'").sum(:credito_gs)
				@bonificacao_us = SueldosDetalhe.where("tipo = 'BONIFICACION' and data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'").sum(:credito_us)
				@bonificacao_gs = SueldosDetalhe.where("tipo = 'BONIFICACION' and data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'").sum(:credito_gs)
				@extra_us = SueldosDetalhe.where("tipo = 'EXTRA' and data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'").sum(:credito_us)
				@extra_gs = SueldosDetalhe.where("tipo = 'EXTRA' and data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'").sum(:credito_gs)


				cmv_mercad        = VendasProduto.find_by_sql(sql_cmv)
				cmv_proc_composto = VendasProduto.find_by_sql(sql_cmv_composto)
				cmv_serv          = VendasProduto.find_by_sql(sql_cmv_composto)


				cmv_find_mercad_us = cmv_mercad.last ? cmv_mercad.last.custo_medio_us.to_f : 0
				cmv_find_mercad_gs = cmv_mercad.last ? cmv_mercad.last.custo_medio_gs.to_f : 0

				cmv_find_proc_composto_us = cmv_proc_composto.last ? cmv_proc_composto.last.custo_medio_us.to_f : 0
				cmv_find_proc_composto_gs = cmv_proc_composto.last ? cmv_proc_composto.last.custo_medio_gs.to_f : 0

				cmv_find_cmv_serv_us = cmv_serv.last ? cmv_serv.last.custo_medio_us.to_f : 0
				cmv_find_cmv_serv_gs = cmv_serv.last ? cmv_serv.last.custo_medio_gs.to_f : 0

				@cmv_us = (cmv_find_mercad_us.to_f + cmv_find_proc_composto_us.to_f + cmv_find_cmv_serv_us.to_f)
				@cmv_gs = (cmv_find_mercad_gs.to_f + cmv_find_proc_composto_gs.to_f + cmv_find_cmv_serv_gs.to_f)
				@cmv_rs = 0

				head =
				"                                                   #{current_unidade.nome_sys}
																														Planilha de Custo
#{t('DATE')} : #{params[:inicio]}  #{t('TO')} #{params[:final]}
- CC....: #{params[:busca]["cc"]} #{cc_desc_title}
_________________________________________________________________________________________________________________________________________
				"

				respond_to do |format|
					format.html do
						render  :pdf                    => "resultado_planilha_custos",
										:layout                 => "layer_relatorios",
										:margin => {:top        => '0.90in',
																:bottom     => '0.25in',
																:left       => '0.10in',
																:right      => '0.10in'},
										:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
																:font_size  => 7,
																:left       => head,
																:spacing    => 15},
										:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
																:font_size  => 7,
																:right      => "Pagina [page] de [toPage]",
																:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
					end
					format.xls
				end
		end

	def resultado_#{t('DATE')}mento_caixa

				head =
				"                                       #{current_unidade.nome_sys}
																								CIERRE DE CAJA
				"

				respond_to do |format|
					if params[:tipo] == '1'
						format.xls { send_data @condicinais.to_xls }
					 else
						format.html do
							render  :pdf                    => "resultado_#{t('DATE')}mento_caixa",
											:layout                 => "layer_relatorios",
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
																	:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
						end
					end
				end
		end

		def resultado_vendas
			params[:unidade] = current_unidade.id
			if params[:lancamento].to_s != "1"
				if params[:moeda] == "0"
					moeda = "#{t('ONLY').upcase} #{t('RELEASE').upcase}s #{t('EM').upcase} U$"
				elsif params[:moeda] == "1"
					moeda = "#{t('ONLY').upcase} #{t('RELEASE').upcase}s #{t('EM').upcase} G$"
				else
					moeda = "#{t('ONLY').upcase} #{t('RELEASE').upcase}s #{t('EM').upcase} R$"
				end
			else
				if params[:moeda] == "0"
					moeda = "#{t('ALL_RELEASES').upcase} #{t('EM').upcase} U$"
				elsif params[:moeda] == "1"
					moeda = "#{t('ALL_RELEASES').upcase} #{t('EM').upcase} G$"
				else
					moeda = "#{t('ALL_RELEASES').upcase} #{t('EM').upcase} R$"
				end
			end
			unless params[:busca]["persona"].blank?
					per = Persona.find_by_id(params[:busca]["persona"], :select => 'id,nome')
					per = per.nome
			else
					per = 'TODOS'
			end

			if params[:detalhe].to_s == '0'
				detalhe = "RESUMEN"
			elsif params[:detalhe].to_s == '1'
				detalhe = "DETALLADO"
			elsif params[:detalhe].to_s == '2'
				detalhe = "POR PRODUCTO"
			end
			if params[:detalhe].to_s == '2'
				@vendas = Relatorios.venda_por_produto(params)
				head =
				"                                                  #{current_unidade.nome_sys}
																													 #{t('LISTING').upcase} DE VENTAS
 #{t('DATE')}...: #{params[:inicio]}  #{t('TO')} #{params[:final]}
 - Moneda..: #{moeda}
 - Cliente.: #{per}
 - Tipo....: #{detalhe}
-----------------------------------------------------------------------------------------------------------------------------------------
 Turno             OP                  Producto                                                  Cantidad     Valor
-----------------------------------------------------------------------------------------------------------------------------------------
				"

			elsif params[:detalhe].to_s == '3'
				@vendas = Relatorios.vendas(params)
				head =
				"                                                  #{current_unidade.nome_sys}
																													 #{t('LISTING').upcase} DE VENTAS POR BICOS
 #{t('DATE')}...: #{params[:inicio]}  #{t('TO')} #{params[:final]}
 - Moneda..: #{moeda}
 - Cliente.: #{per}
 - Tipo....: #{detalhe}
-----------------------------------------------------------------------------------------------------------------------------------------
 BICO    CAJA  			                        						     CANTIDAD         VALOR
-----------------------------------------------------------------------------------------------------------------------------------------
				"

			elsif params[:detalhe].to_s == '5'
				@vendas = Relatorios.vendas(params)
				head =
				"                                                  #{current_unidade.nome_sys}
																													 #{t('LISTING').upcase} DE VENTAS POR VENDEDOR
 #{t('DATE')}...: #{params[:inicio]}  #{t('TO')} #{params[:final]}
 - Moneda..: #{moeda}
 - Cliente.: #{per}
 - Tipo....: #{detalhe}
-----------------------------------------------------------------------------------------------------------------------------------------
 Vendedor                                            Ctd Prod Vend. Monto Vendido   Desc. Venta    NC Ctd Prod    Monto NC         Total
-----------------------------------------------------------------------------------------------------------------------------------------
				"

			else
				@vendas = Relatorios.vendas(params)
				head =
				"                                                              #{current_unidade.nome_sys}
                                                               #{t('LISTING').upcase} DE VENTAS
 #{t('DATE')}...: #{params[:inicio]}  #{t('TO')} #{params[:final]}
 - Moneda..: #{moeda}
 - Cliente.: #{per}
 - Tipo....: #{detalhe}
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Lanz   #{t('DATE')}   Vendedor         Setor          Cliente/Producto                               Doc.        Tipo    Ctd       Monto        Desc.      Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				"

			end


		respond_to do |format|
		  if params[:tipo] == '1'
		    format.html {
		      xls = render_to_string :action => "resultado_vendas", :layout => false
		      kit = PDFKit.new(xls,
		                       :encoding => 'UTF-8')
		      send_data(xls,:filename => "resultado_vendas.xls")
		    }
		  else

			format.html do
				render  :pdf                    => "resultado_#{t('DATE')}mento_caixa",
								:layout                 => "layer_relatorios",
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
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
		end
	end
		def resultado_historico_precos                  #


				@historico_preco          = Relatorios.historico_precos(params)

				head =
				"                                                                                       #{current_unidade.nome_sys}
																																											Historico de Precios
		#{t('DATE')} : #{params[:inicio]}  #{t('TO')} #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			#{t('DATE')}                 Cod.                                     Produto                                                                       Precio Gs.          Precio U$.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				"

				respond_to do |format|
			format.html do
				render  :pdf                    => "resultado_#{t('DATE')}mento_caixa",
								:layout                 => "layer_relatorios",
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
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end

		end

		def resultado_tabela_preco
			params[:unidade] = current_unidade.id
			@tabela_preco          = Relatorios.tabela_preco(params)

						head =
"                                                              #{session[:empresa_nome]}
																							                                    TABLA DE PRECIOS
TABLA......: #{params[:busca]["tabela"]}
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Cod.          Descripcion                                                              Stock         Costo         Precio
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						"


		respond_to do |format|
			if params["tipo"] == '1'
				format.html {
					xls = render_to_string :action => "resultado_tabela_preco", :layout => false
					kit = PDFKit.new(xls, :encoding => 'UTF-8')
					send_data(xls,:filename => "Tabla-Precio.xls")
				}
			else

				format.html do
					render  :pdf                    => "resultado_vendas_turno",
									:layout                 => "layer_relatorios",
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
															:left       => "CHRONOS SOFTWARE #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
		end
	end

	def resultado_compras
		params[:unidade] = current_unidade.id
		@compras = Relatorios.compras(params)

		respond_to do |format|
		  if params[:tipo] == '1'
		    format.html {
		      xls = render_to_string :action => "resultado_compras", :layout => false
		      kit = PDFKit.new(xls,
		                       :encoding => 'UTF-8')
		      send_data(xls,:filename => "resultado_compras.xls")
		    }
		  else
				format.html do
					render  :pdf                    => "resultado_#{t('DATE')}mento_caixa",
								:layout                 => "layer_relatorios",
								:margin => {:top        => '1.20in',
														:bottom     => '0.25in',
														:left       => '0.10in',
														:right      => '0.10in'},
								:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:html => { :template => 'relatorios/headers/compras.html',
														:layout     => "layer_relatorios" },
														:spacing    => 0},

								:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:right      => "Pagina [page] de [toPage]",
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end
	end
	end


def resultado_control_obra
    @obra = Relatorios.resultado_control_obra(params)

    head =
        "                                                   #{current_unidade.nome_sys}
                                                        #{t('LISTING').upcase} de Visitas
#{t('DATE')}....: #{params[:inicio]}  #{t('TO')} #{params[:final]}

-----------------------------------------------------------------------------------------------------------------------------------------
    #{t('DATE')}     Prox. Visi.    Dias     Consultor                     Cliente                     Servicio                           NC
-----------------------------------------------------------------------------------------------------------------------------------------
"

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_#{t('DATE')}mento_caixa",
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.55in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :html => { :template => 'relatorios/headers/control_obra.html',
                            :layout     => "layer_relatorios" },
                            :spacing    => 0},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "CHRONOS SOFTWARE #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
        end
    end
end


		def resultado_cobros
			params[:unidade] = current_unidade.id
			if params[:lancamento].to_s != "1"
				if params[:moeda] == "0"
					moeda = "#{t('ONLY').upcase} #{t('RELEASE').upcase}s #{t('EM').upcase} U$"
				elsif params[:moeda] == "1"
					moeda = "#{t('ONLY').upcase} #{t('RELEASE').upcase}s #{t('EM').upcase} G$"
				else
					moeda = "#{t('ONLY').upcase} #{t('RELEASE').upcase}s #{t('EM').upcase} R$"
				end
			else
				if params[:moeda] == "0"
					moeda = "#{t('ALL_RELEASES').upcase} #{t('EM').upcase} U$"
				elsif params[:moeda] == "1"
					moeda = "#{t('ALL_RELEASES').upcase} #{t('EM').upcase} G$"
				else
					moeda = "#{t('ALL_RELEASES').upcase} #{t('EM').upcase} R$"
				end
			end
			unless params[:busca]["persona"].blank?
					per = Persona.find_by_id(params[:busca]["persona"], :select => 'id,nome')
					per = per.nome
			else
					per = 'TODOS'
			end

			if params[:detalhe].to_s == '0'
				detalhe = "RESUMEN"
			else
				detalhe = "DETALLADO"
			end
			@cobros = Relatorios.cobros(params)



				if params[:detalhe] == '2'

				head =
				"                                                                          #{current_unidade.nome_sys}
																														                        #{t('LISTING').upcase} DE #{t('CHARGE').upcase} - POR FORMA DE PAGAMENTO
 #{t('DATE')}...: #{params[:inicio]} #{t('TO')} #{params[:final]}
 - Moneda..: #{moeda}
 - Cliente.: #{per}
 - Tipo....: #{detalhe}
-----------------------------------------------------------------------------------------------------------------------------------------
 Reg.    Venc.   #{t('DATE')} PG Cliente                        Doc.    CC              Descr.                       #{t('QUOTA')}     Valor   #{t('ACCOUNT')}
-----------------------------------------------------------------------------------------------------------------------------------------
				"

			elsif params[:detalhe].to_s == '0'
head =
				"                                                  #{current_unidade.nome_sys}
																											#{t('LISTING').upcase} DE #{t('CHARGE').upcase}S
 - #{t('DATE')}...: #{params[:inicio]} #{t('TO')} #{params[:final]}
 - Moneda..: #{moeda}
 - Cliente.: #{per}
 - Tipo....: #{detalhe}
------------------------------------------------------------------------------------------------------------------------------------------
 Lanz.    #{t('DATE')}  Sector Recibo     Doc               Nombre                                  Cuota        Valor    Cancelado
------------------------------------------------------------------------------------------------------------------------------------------
				"

      elsif params[:detalhe].to_s == '3'
head =
        "                                                        #{current_unidade.nome_sys}
                                                      RENDICION COBRANZAS DE DOCUMENTOS
 - #{t('DATE')}...: #{params[:inicio]}



-----------------------------------------------------------------------------------------------------------------------------------------------------
 Fecha   Cliente                           Cuota   Vto.    Moneda  Monto Pag. Interes USD Importe USD Monto Pag. Interes Gs. Importe Gs.    Recibo
-----------------------------------------------------------------------------------------------------------------------------------------------------
        "


			else

head =
				"                                                  #{current_unidade.nome_sys}
																											#{t('LISTING').upcase} DE #{t('CHARGE').upcase}S
 - #{t('DATE')}...: #{params[:inicio]} #{t('TO')} #{params[:final]}
 - Moneda..: #{moeda}
 - Cliente.: #{per}
 - Tipo....: #{detalhe}
------------------------------------------------------------------------------------------------------------------------------------------
	Lanz.     #{t('DATE')}   Vend                                      Total
------------------------------------------------------------------------------------------------------------------------------------------
				"
			end


	respond_to do |format|
		format.html do
			render  :pdf                    => "resultado",
							:layout                 => "layer_relatorios",
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
													:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
			format.xls
		end
	end



		def resultado_pagos
			params[:unidade] = current_unidade.id
			if params[:lancamento].to_s != "1"
				if params[:moeda] == "0"
					moeda = "SOMENTE REGISTROS U$"
				elsif params[:moeda] == "1"
					moeda = "SOMENTE REGISTROS G$"
				else
					moeda = "SOMENTE REGISTROS R$"
				end
			else
				if params[:moeda] == "0"
					moeda = "TODOS REGISTROS U$"
				elsif params[:moeda] == "1"
					moeda = "TODOS REGISTROS G$"
				else
					moeda = "TODOS REGISTROS R$"
				end
			end
			unless params[:busca]["persona"].blank?
					per = Persona.find_by_id(params[:busca]["persona"], :select => 'id,nome')
					per = per.nome
			else
					per = 'TODOS'
			end

	    #VERIFICA SE  TEM CC E IMPRIME
	    if params[:busca]["cc"].blank?
	        cc = 'TODOS...'
	    else
	        busca_cc = CentroCusto.find_by_id(params[:busca]["cc"], :select => 'nome')
	        cc = "#{params[:busca]["cc"]} - #{busca_cc.nome}"
	    end

	    #VERIFICA SE  TEM CC E IMPRIME
	    if params[:compras_custo]["rubro_id"].blank?
	        rb = 'TODOS...'
	    else
	        busca_rb = Rubro.find_by_id(params[:compras_custo]["rubro_id"], :select => 'descricao')
	        rb = "#{params[:compras_custo]["rubro_id"]} - #{busca_rb.descricao}"
	    end

				@cobros = Relatorios.pagos(params)


				if params[:detalhe] == '2'

				head =
				"                                                             #{current_unidade.nome_sys}
																											              #{t('LISTING').upcase} DE #{ t('PAYMENTS').upcase } - POR FORMA DE #{ t('PAYMENTS').upcase }
 - #{t('DATE')}...: #{params[:inicio]} #{t('TO')} #{params[:final]}
 - #{t('COIN')}..: #{moeda}
 - Cliente.: #{per}
 - CC......: #{cc}
 - #{t('CLASSIFICATION')}: #{rb}
-----------------------------------------------------------------------------------------------------------------------------------------
 Reg.   #{t('DATE')} PG #{t('PROVIDER')}                      #{t('CLASSIFICATION')}               Obs.                           #{t('QUOTA')}      Valor     #{t('ACCOUNT')}
-----------------------------------------------------------------------------------------------------------------------------------------
				"
				else

head =
				"                                                  #{current_unidade.nome_sys}
																														#{t('LISTING').upcase} DE PAGOS
 #{t('DATE')}...: #{params[:inicio]} #{t('TO')} #{params[:final]}
 - Moneda..: #{moeda}
 - Cliente.: #{per}
 - Tipo....: #{detalhe}
-----------------------------------------------------------------------------------------------------------------------------------------
 Cod.     #{t('DATE')}    Recibo  Nombre                                        Desc.           Interes               Valor              Total
-----------------------------------------------------------------------------------------------------------------------------------------
				"


				end




	 	respond_to do |format|
			format.html do
				render  :pdf                    => "resultado_#{t('DATE')}mento_caixa",
								:layout                 => "layer_relatorios",
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
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
			format.xls
		end
	end



		def resultado_resumo_mes                            #
				head =
				"                                                                                          #{current_unidade.nome_sys}
																																									Resumen Del Mes
	- Mes : #{params[:mes]} de #{params[:ano]}




				"

				respond_to do |format|
					format.html do
						render  :pdf                    => "resultado",
										:layout                 => "layer_relatorios",
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
																:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
					end
				end
		end

	def resultado_consumicao_interna


    if params[:detalhe] == '0'
      params[:unidade] = current_unidade.id
      @consumicao_interna = Relatorios.consumicao_interna(params)

    else

			if params[:moeda].to_s == '0'
					moeda = 'AND MOEDA = 0'
					md = 'Dolar'
			else
				moeda = 'AND MOEDA = 1'
				md = 'Guaranies'
			end

			@consumicao = ConsumicaoInterna.all(:conditions => ["DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{moeda}"])

    end

				head =
"                                                        #{current_unidade.nome_sys}
																													Consumicion Interna
#{t('DATE')}.........: #{params[:inicio]}  #{t('TO')} #{params[:final]}
- Moneda........: #{md}

-----------------------------------------------------------------------------------------------------------------------------------------
 Cod.    #{t('DATE')}      Producto                                                                                                     Total
-----------------------------------------------------------------------------------------------------------------------------------------
				"
		respond_to do |format|
		  if params[:tipo] == '1'
        format.html {
          render :xlsx => "resultado_consumicao_interna",
          filename: "Consumicion-Interna-#{params[:inicio]}-#{params[:final]}"
        }
		  else

			format.html do
				render  :pdf                    => "resultado_#{t('DATE')}mento_caixa",
								:layout                 => "layer_relatorios",
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
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
			end
	end




	def resultado_comissoes
		params[:unidade] = current_unidade.id
    @comissaos = Relatorios.comissao(params)

    if params[:tipo] == '1'
      render :xlsx => "resultado_rentabilidade",
      filename: "Rentabilidad-#{params[:inicio]}-#{params[:final]}"
    else
      render :layout => 'relatorio_view'
    end

  end

	def resultado_folha_de_pagamento
		@sueldo = Relatorios.sueldo(params)
		if params[:busca]["unidade"].blank?
				unidade = 'Todos..'
		else
				unidade = params[:busca]["unidade"]
				gp_c  = Unidade.find_by_id(params[:busca]["unidade"])
				gp_desc = ' - ' << gp_c.unidade_nome
		end
		head =
"                                                         #{current_unidade.nome_sys}
																												                           		Hoja de Pago
	- Unidad....: #{ unidade.to_s.rjust(6,'0') } #{ gp_desc }
	- Periodo...: #{params[:mes]}  #{t('TO')} #{params[:ano]}


"

		respond_to do |format|
		  if params[:tipo] == '1'
		    format.html {
		      xls = render_to_string :action => "resultado_folha_de_pagamento", :layout => false
		      kit = PDFKit.new(xls,
		                       :encoding => 'UTF-8')
		      send_data(xls,:filename => "resultado_folha_de_pagamento.xls")
		    }
		  else

			format.html do
				render  :pdf                    => "resultado_folha_de_pagamento",
								:layout                 => "layer_relatorios",
								:orientation            => 'Landscape',
								:margin => {:top        => '1.20in',
														:bottom     => '0.25in',
														:left       => '0.10in',
														:right      => '0.10in'},
								:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:left       => head,
														:spacing    => 20},
								:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:right      => "Pagina [page] de [toPage]",
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
					end
				end
			end
		end


  def resultado_cheque_diferido
      params[:unidade] = current_unidade.id

        @cheque_diferido             = Relatorios.cheque_diferido(params)
        if params[:cheque].to_s == '1'
            cheque = 'A Depositar'
        elsif params[:cheque].to_s == '2'
            cheque = 'Depositado'
        else
            cheque = 'Todos'
        end

        if params[:moeda].to_s == '0'
            moeda = 'Dolar'
        else
            moeda = 'Guaranies'
        end
        conta = Conta.find_by_id(params[:busca]["conta"])
        if params[:busca]["conta"] != ''
            c = conta.nome
        else
            c = 'TODOS..'
        end
        head =
"                                                       #{current_unidade.nome_sys}
                                                        #{t('LISTING').upcase} DE CHEQUES
#{t('DATE')}...: #{params[:inicio]}  #{t('TO')} #{params[:final]}
- Cheque..: #{cheque}
- Moneda..: #{moeda}
- Cuenta..: #{c}
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Emicion Difer.  CP   SP Nombre                             Cuenta             Titula                Banco                Cheque Concepto                                       Entrada    Salida
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

        respond_to do |format|
		      if params[:tipo] == '1'
		        format.html {
		          xls = render_to_string :action => "resultado_cheque_diferido", :layout => false
		          kit = PDFKit.new(xls,
		                           :encoding => 'UTF-8')
		          send_data(xls,:filename => "cheques-#{params[:inicio]}.xls")
		        }
           else
            format.html do
              render  :pdf                    => "resultado_cheque_diferido",
                      :orientation            => 'Landscape',
                      :layout                 => "layer_relatorios",
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
                                  :left       => "CHRONOS SOFTWARE #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
              end
            end
        end
    end
		def resultado_adelantos
			params[:unidade] = current_unidade.id

			@adelantos = Relatorios.adelantos(params)
			if params[:status] == '0'
				if params[:tipo_adelanto] == '0'
					ta = "CONCEDIDO"
				else
					ta = "RECEBIDO"
				end
			if params[:liquidacao] == '0'
				l = "EN ABERTAS"
			elsif params[:liquidacao] == '1'
				l = "CANCELADAS"
			else
				l = "TODOS"
			end

			head =
				"                                                             #{current_unidade.nome_sys}
																												#{t('LISTING').upcase} DE ADELANTOS
#{t('DATE')}.........: #{params[:inicio]}  #{t('TO')} #{params[:final]}
- Tipo Adelanto.: #{ta}
- Liquidacion...: #{l}
------------------------------------------------------------------------------------------------------------------------------------------
	Laz.  #{t('DATE')}    Venc. Persona                             Cuota   Doc.                            Valor         Pago         Saldo
------------------------------------------------------------------------------------------------------------------------------------------
				"
else

				head =
				"                                                                 #{current_unidade.nome_sys}
																															                       #{t('LISTING').upcase} DE ADELANTOS
	#{t('DATE')} : #{params[:inicio]}  #{t('TO')} #{params[:final]}


------------------------------------------------------------------------------------------------------------------------------------------
	Laz.     #{t('DATE')}        Doc.            Persona                     Concepto                        Adelanto     Aplicdo       Saldo
------------------------------------------------------------------------------------------------------------------------------------------
				"
end
respond_to do |format|
			format.html do
				render  :pdf                    => "resultado_adelantos",
								:layout                 => "layer_relatorios",
								:margin => {:top        => '0.95in',
														:bottom     => '0.25in',
														:left       => '0.10in',
														:right      => '0.10in'},
								:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:left       => head,
														:spacing    => 20},
								:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:right      => "Pagina [page] de [toPage]",
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end
		end

		def resultado_pedidos_vendas                  #
		 if params[:moeda].to_s == '0'
			moeda = 'DOLAR'
		 elsif params[:moeda].to_s == '1'
			moeda = 'GUARANI'
		else
			moeda = 'REAIS'
		 end

		 if params[:status].to_s == '0'
			filtro = 'Solo En Abertas'
		 elsif params[:status].to_s == '1'
			filtro = 'Solo Facturados'
		 elsif params[:status].to_s == '3'
			filtro = 'Solo Aceitas'

		 elsif params[:status].to_s == '2'
			filtro = 'Solo Cancelados'
		 else
			filtro = 'Todos'
		 end

		#VERIFICA SE  TEM SUBGRUPO E IMPRIME
		if params[:busca]["sub_grupo"].blank?
				grupo = 'Todos..'
		else
				sub_grupo = params[:busca]["sub_grupo"].to_s.rjust(6,'0')
				sb_s = SubGrupo.find_by_id(params[:busca]["sub_grupo"])
				sb_desc = ' - ' << sb_s.descricao
		end


		#VERIFICA SE  TEM COLECAO E IMPRIME
		if params[:busca]["colecao"].blank?
				colecao = 'Todos..'
		else
				colecao = params[:busca]["colecao"].to_s.rjust(6,'0')
				c_s = Colecao.find_by_id(params[:busca]["colecao"])
				c_desc = ' - ' << c_s.nome
		end

		if params[:detalhe].to_s == '2'
			@pedidos_vendas = Relatorios.pedido_venda_agrupado_cliente(params)
			head =
					"                                             #{current_unidade.nome_sys}
																									#{t('LISTING').upcase} Pedido de Ventas por cliente
- #{t('DATE')}........: #{params[:inicio]}  #{t('TO')} #{params[:final]}
- Filtro.......: #{filtro}
- Moneda.......: #{moeda}
- Marca........: #{ sub_grupo } #{ sb_desc }
- Coleccion....: #{ colecao } #{ c_desc }
-----------------------------------------------------------------|---------Cantidad-------------|------|-------------Valores-------------|
Cliente                                                           Pedido      Factura      Saldo        Pedido        Factura        Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
	"
		else
			@pedidos_vendas = Relatorios.pedidos_vendas(params)
			head =
					"                                                   #{current_unidade.nome_sys}
																											#{t('LISTING').upcase} Pedido de Ventas
	- #{t('DATE')}....: #{params[:inicio]}  #{t('TO')} #{params[:final]}
	- Filtro...: #{filtro}
	- Moneda...: #{moeda}
	-----------------------------------------------------------------------------------------------------------------------------------------
		Lanz.  Doc.   #{t('DATE')}  Prazo Entr.  Vend.    Cliente                     Marca                Coleccion             Cantidad        Total
	-----------------------------------------------------------------------------------------------------------------------------------------
	"
		end

				respond_to do |format|
			if params[:tipo] == '1'
				format.xls
				else
					format.html do
					render  :pdf                    => "resultado_#{t('DATE')}mento_caixa",
									:layout                 => "layer_relatorios",
									:margin => {:top        => '1.22in',
															:bottom     => '0.25in',
															:left       => '0.10in',
															:right      => '0.10in'},
									:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:left       => head,
															:spacing    => 27},
									:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:right      => "Pagina [page] de [toPage]",
															:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
		end
		end


		def resultado_egressos                  #
			@egressos = Relatorios.egressos(params)
		 if params[:moeda].to_s == '0'
			moeda = 'DOLAR'
		 elsif params[:moeda].to_s == '1'
			moeda = 'GUARANI'
		else
			moeda = 'REAIS'
		 end

		head =
				"                                                   #{current_unidade.nome_sys}
																												#{t('LISTING').upcase} de Egressos
#{t('DATE')}....: #{params[:inicio]}  #{t('TO')} #{params[:final]}
- Moneda...: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
 Lanz.  #{t('DATE')}  Sect.Cuenta                    Rubro                         Concepto                                                Total
-----------------------------------------------------------------------------------------------------------------------------------------
"

				respond_to do |format|
			format.html do
				render  :pdf                    => "resultado_#{t('DATE')}mento_caixa",
								:layout                 => "layer_relatorios",
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
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end
		end

		def resultado_ingressos
			@ingressos = Relatorios.ingressos(params)
		 if params[:moeda].to_s == '0'
			moeda = 'DOLAR'
		 elsif params[:moeda].to_s == '1'
			moeda = 'GUARANI'
		else
			moeda = 'REAIS'
		 end

		head =
				"                                                   #{current_unidade.nome_sys}
																												#{t('LISTING').upcase} de Ingressos
#{t('DATE')}....: #{params[:inicio]}  #{t('TO')} #{params[:final]}
- Moneda...: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
 Lanz.  #{t('DATE')}  Sect.Cuenta                    Rubro                         Concepto                                                Total
-----------------------------------------------------------------------------------------------------------------------------------------
"

				respond_to do |format|
			format.html do
				render  :pdf                    => "resultado_#{t('DATE')}mento_caixa",
								:layout                 => "layer_relatorios",
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
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
		end

		def resultado_gastos
				params[:unidade] = current_unidade.id

				if params[:moeda] == '0'
					 moeda  = 'DOLAR'
				elsif params[:moeda] == '2'
					 moeda  = 'REAL'
				else
					 moeda  = 'GUARANIES'
				end


				unless params[:busca]["rodado"].blank?
					 rd = Rodado.last(:conditions => ["id = #{params[:busca]["rodado"]}"])
				end

				@gastos = Relatorios.gastos(params)
				if params[:tp] == "0"
						@gastos = Relatorios.gastos(params)
				head =

				"                                                                   #{current_unidade.nome_sys}
																																				                        #{t('LISTING').upcase} DE GASTOS - ANALITICO
- #{t('DATE')}...: #{params[:inicio]}  #{t('TO')} #{params[:final]}
- #{t('COIN')}..: #{moeda}
- Rodado..: #{rd.placa unless params[:busca]["rodados"].blank? }
---------------------------------------------------------------------------------------------------------------------------------------------------------------
	Cod.     #{t('DATE')}     Doc.              Centro Costo            #{t('PROVIDER')}               #{t('CLASSIFICATION')}                                     Rodado       Valor
---------------------------------------------------------------------------------------------------------------------------------------------------------------
				"

        pg = "Portrait"

      elsif params[:tp] == "1"

        head =
        "                                                                   #{current_unidade.nome_sys}
                                                          #{t('LISTING').upcase} DE COSTOS - ANALITICO
- #{t('DATE')}...: #{params[:inicio]}  #{t('TO')} #{params[:final]}
- #{t('COIN')}..: #{moeda}
- Rodado..: #{rd.placa unless params[:busca]["rodados"].blank? }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Cod. Fecha Op Compt. Persona                         Rodado   Empleado                 Centro de Costo           Grupo Costo                      Clasificacion                                         Valor
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

        pg = "Landscape"
			elsif params[:tp] == "3"

        head =
        "                                                                   #{current_unidade.nome_sys}
                                                          #{t('LISTING').upcase} DE GASTOS - ANALITICO
- #{t('DATE')}...: #{params[:inicio]}  #{t('TO')} #{params[:final]}
- #{t('COIN')}..: #{moeda}
- Rodado..: #{rd.placa unless params[:busca]["rodados"].blank? }
--------------------------------------------------------------------------------------
#{t('CLASSIFICATION')}                                                                     Valor
--------------------------------------------------------------------------------------
				"
        pg = "Portrait"

	end

		respond_to do |format|
      if params[:tipo] == '1'
        format.html {
          render :xlsx => "resultado_gastos",
          filename: "gastos-#{params[:inicio]}-#{params[:final]}"
        }
      else

  			format.html do
  				render  :pdf                    => "resultado_#{t('DATE')}",
  								:layout                 => "layer_relatorios",
                  :orientation            =>  pg,
  								:margin => {:top        => '1.00in',
  														:bottom     => '0.25in',
  														:left       => '0.10in',
  														:right      => '0.10in'},
  								:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
  														:font_size  => 7,
  														:left       => head,
  														:spacing    => 18},
  								:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
  														:font_size  => 7,
  														:right      => "Pagina [page] de [toPage]",
  														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
  			end
      end
		end
	end

	def dynamic_terminal
		@terminals = Terminal.find_all_by_unidade_id(params[:id])
		respond_to do |format|
			format.js
		end
	end


	def dynamic_marca
		@marcas = SubGrupo.find_all_by_persona_id(params[:id])
		respond_to do |format|
			format.js
		end
	end

end
