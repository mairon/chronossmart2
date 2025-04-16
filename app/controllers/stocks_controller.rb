class StocksController < ApplicationController

	def resultado_conferencia

    clase     = "AND P.clase_id = #{params[:busca]["clase"]}" unless params[:busca]["clase"].blank?
    grupo     = "AND P.grupo_id = #{params[:busca]["grupo"]}" unless params[:busca]["grupo"].blank?
    sub_grupo = "AND P.sub_grupo_id = #{params[:busca]["sub_grupo"]}" unless params[:busca]["sub_grupo"].blank?

    sql = "SELECT
                  G.DESCRICAO AS GRUPO_NOME,
                  SG.DESCRICAO AS SUB_GRUPO_NOME,
                  P.ID,
                  P.NOME,
                  P.CLASE_ID,
                  P.GRUPO_ID,
                  P.BARRA,
                  P.FABRICANTE_COD,
                  P.USUARIO_CREATED,
                  P.OBS,
                  (SELECT SUM(ENTRADA - SAIDA) AS SUM_ID FROM STOCKS S WHERE S.PRODUTO_ID = P.ID AND S.DEPOSITO_ID = #{params[:busca]["deposito"]} AND S.DATA <= '#{params[:final].split("/").reverse.join("-")}') AS STOCK
                  FROM PRODUTOS P
                  LEFT JOIN GRUPOS G
                  ON G.ID = P.GRUPO_ID
                  LEFT JOIN SUB_GRUPOS SG
                  ON SG.ID = P.SUB_GRUPO_ID
                  WHERE P.STATUS = TRUE #{clase} #{grupo} #{sub_grupo}
                  AND (SELECT COUNT(PTB.ID) FROM PRODUTOS_TABELA_PRECOS PTB WHERE PTB.PRODUTO_ID = P.ID AND PTB.UNIDADE_ID = #{current_unidade.unidade_tabela_preco_id} AND PTB.PRECO_1_GS > 0 ) > 0
                  ORDER BY 1,2,4
                  "
    @produtos = Produto.find_by_sql(sql)

    render layout: false
	end

	def resultado_registro_consumo
		@consumos = Stock.resultado_registro_consumo(params)
		@consumo_group = Stock.resultado_registro_consumo_agrupado(params)
		@consumo_group_preco = Stock.resultado_registro_consumo_agrupado_preco(params)


				head =
				"                                                             #{current_unidade.nome_sys}
																															                              REGISTRO CONSUMO
- Periodo..: #{params[:inicio]} Hasta #{params[:final]}
-----------------------------------------------------------------------------------------------------------------------------------------
  Fecha   Cliente                                       Producto                              Ctd          Total
-----------------------------------------------------------------------------------------------------------------------------------------
				"

		respond_to do |format|
      if params["tipo"] == '1'
            format.html {
              xls = render_to_string :action => "resultado_registro_consumo", :layout => false
              kit = PDFKit.new(xls, :encoding => 'UTF-8')
              send_data(xls,:filename => "registro-consumo-#{params[:inicio]}-#{params[:final]}.xls")
            }
          else
				format.html do
					render  :pdf                    => "resultado_registro_consumo",
									:layout                 => "layer_relatorios",
									:margin => {:top        => '1.05in',
															:bottom     => '0.25in',
															:left       => '0.10in',
															:right      => '0.10in'},
									:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:left       => head,
															:spacing    => 23},
									:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:right      => "Pagina [page] de [toPage]",
															:left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
		end
	end

	def resultado_curva_abc
		params[:unidade] = current_unidade.id
		if params[:orden].to_s == "0"
			order  = 'Producto'
		elsif params[:orden].to_s == "1"
			order  = 'Cantidad'
		elsif params[:orden].to_s == "2"
			order  = 'Valor'
		end

		if params[:busca]["clase"].blank?
			clase = 'Todos..'
		else
			clase   = params[:busca]["clase"]
			cl_c = Clase.find_by_id(params[:busca]["clase"])
			cl_desc = ' - ' << cl_c.descricao

		end
		#VERIFICA SE  TEM GRUPO E IMPRIME
		if params[:busca]["grupo"].blank?
				grupo = 'Todos..'
		else
				grupo = params[:busca]["grupo"]
				gp_c  = Grupo.find_by_id(params[:busca]["grupo"])
				gp_desc = ' - ' << gp_c.descricao
		end

		#VERIFICA SE  TEM SUB_GRUPO E IMPRIME
		if params[:busca]["sub_grupo"].blank?
				sgrupo = 'Todos..'
		else
				sgrupo = params[:busca]["sub_grupo"]
				sgp_c  = SubGrupo.find_by_id(params[:busca]["sub_grupo"])
				sgp_desc = ' - ' << sgp_c.descricao
		end
		@vendas = Stock.resultado_curva_abc(params)
				head =
				"                                                             #{current_unidade.nome_sys}
																															                              CURVA ABC
- Periodo..: #{params[:inicio]} Hasta #{params[:final]}
- Grupo....: #{ grupo.to_s.rjust(6,'0') } #{ gp_desc }
- Ordenado por: #{order}
- Parametros curva A: #{params[:a]}% B: #{params[:b]}% C: #{params[:c]}%
-----------------------------------------------------------------------------------------------------------------------------------------
Producto                                            Ctd        Margen          Total    Percentual%    Acumulado%
-----------------------------------------------------------------------------------------------------------------------------------------
				"

		respond_to do |format|
      if params["tipo"] == '1'
            format.html {
              xls = render_to_string :action => "result_vendas_produtos", :layout => false
              kit = PDFKit.new(xls, :encoding => 'UTF-8')
              send_data(xls,:filename => "curva-abc-#{params[:inicio]}-#{params[:final]}.xls")
            }
          else
				format.html do
					render  :pdf                    => "resul_vendas_produto",
									:layout                 => "layer_relatorios",
									:margin => {:top        => '1.05in',
															:bottom     => '0.25in',
															:left       => '0.10in',
															:right      => '0.10in'},
									:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:left       => head,
															:spacing    => 23},
									:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:right      => "Pagina [page] de [toPage]",
															:left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
				end
			end
		end
	end

  def resultado_cmv
    #VERIFICA SE  TEM GRUPO E IMPRIME
    if params[:busca]["grupo"].blank?
        grupo = 'Todos..'
    else
        grupo = params[:busca]["grupo"]
        gp_c  = Grupo.find_by_id(params[:busca]["grupo"])
        gp_desc = ' - ' << gp_c.descricao
    end

    #VERIFICA SE  TEM SUB_GRUPO E IMPRIME
    if params[:busca]["sub_grupo"].blank?
        sgrupo = 'Todos..'
    else
        sgrupo = params[:busca]["sub_grupo"]
        sgp_c  = SubGrupo.find_by_id(params[:busca]["sub_grupo"])
        sgp_desc = ' - ' << sgp_c.descricao
    end


    #VERIFICA SE  TEM PRODUTO E IMPRIME
    if params[:busca]["produto"].blank?
        produto = 'Todos..'
    else
        produto = params[:busca]["produto"]
        pd_c    = Produto.find_by_id(params[:busca]["produto"])
        pd_desc = ' - ' << pd_c.nome

    end

    @cmvs = Stock.resumo_cmv(params)

        head =
        "                                                               #{$empresa_nome}
                                                         LISTADO ANALITICO CMV
Periodo #{params[:inicio]} Hasta #{params[:final]}
Grupo......: #{ grupo.to_s.rjust(6,'0') } #{ gp_desc }
Sub-Grupo..: #{ sgrupo.to_s.rjust(6,'0') } #{ sgp_desc }
Produto....: #{ produto.to_s.rjust(6,'0') }
-----------------------------------------------------------------------------------------------------------------------------------------
  Codigo  Fecha   Cliente                     Producto                               Ctd     CMV Unit     CMV Tot   Venta Unit       Tot
-----------------------------------------------------------------------------------------------------------------------------------------

        "
        respond_to do |format|
          if params["tipo"] == '1'
            format.html {
              xls = render_to_string :action => "resultado_cmv", :layout => false
              kit = PDFKit.new(xls, :encoding => 'UTF-8')
              send_data(xls,:filename => "CMV-#{params[:inicio]}-#{params[:final]}.xls")
            }
          else
            format.html do
            render  :pdf                    => "resultado_cmv",
                    :layout                 => "layer_relatorios",
                    :margin => {:top        => '1.00in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},
                    :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :left       => head,
                                :spacing    => 22},
                    :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :right      => "Pagina [page] de [toPage]",
                                :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
          end
        end
      end
    end



		def resultado_resumo_deposito

				#VERIFICA SE  TEM DEPOSITO E IMPRIME
				if params[:busca]["deposito"].blank?
						deposito = 'Todos..'
				else
						deposito = params[:busca]["deposito"]
				end

				@stocks = Stock.resumo_deposito(params)

				head =
				"                                                               #{$empresa_nome}
																												LISTADO DE RESUMEN DE DEPOSITO
Periodo Hasta..: #{params[:final]}
Deposito.......: #{ deposito }
-----------------------------------------------------------------------------------------------------------------------------------------
 Cod.       Deposito                            Producto                                         Cantidad
-----------------------------------------------------------------------------------------------------------------------------------------

				"


				respond_to do |format|
						format.xls
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
																:spacing    => 18},
										:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
																:font_size  => 7,
																:right      => "Pagina [page] de [toPage]",
																:left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
					end
				end
		end


		def resumo_deposito
				sql = "SELECT
										 U.UNIDADE_NOME || ' - ' ||D.NOME AS NOME,
										 D.ID,
										 D.UNIDADE_ID
							FROM DEPOSITOS D
							LEFT JOIN UNIDADES U
							ON D.UNIDADE_ID = U.ID
							WHERE D.SETA_PRODUTO = 1
							ORDER BY 3"
				@depositos =  Deposito.find_by_sql(sql)
		end

		def get_produto_inicial
				@produto =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:cod]])
				cotacao =  Moeda.last
				stock = Stock.sum( 'entrada - saida',:conditions => ["produto_id = ?  AND data <= '#{cotacao.data}' ",@produto.id] )
				suma_entrada       = Stock.sum(:entrada, :conditions => ["produto_id = #{@produto.id} AND data <= '#{cotacao.data}'"])
				suma_custo_dolar   = Stock.sum('( entrada * unitario_dolar)',   :conditions => ["produto_id = #{@produto.id} AND STATUS = 0 AND data <= '#{cotacao.data}'"])
				suma_custo_guarani = Stock.sum('( entrada * unitario_guarani )', :conditions => ["produto_id = #{@produto.id} AND STATUS = 0 AND data <= '#{cotacao.data}'"])
				stock_custo_dolar   = ( suma_custo_dolar.to_f / suma_entrada.to_f )
				stock_custo_guarani = ( suma_custo_guarani.to_f / suma_entrada.to_f )
				return render :text => "<script type='text/javascript'>
																document.getElementById('stock_produto_id').value             = '#{@produto.id.to_i}';
																document.getElementById('stock_taxa').value                   = '#{@produto.taxa.to_i}';
																document.getElementById('saldo').value                   = '#{stock.to_f}';
																document.getElementById('stock_unitario_dolar').value         = '#{format("%.2f",stock_custo_dolar.to_f)}';
																document.getElementById('stock_unitario_guarani').value       = '#{stock_custo_guarani.to_i}';

														</script>"
		end

		def relatorio_consumo_bomba

				respond_to do |format|
						format.html # show.html.erb
				end
		end

		def resultado_relatorio_consumo_bomba
				cond = "data >= '#{params[:inicio]}' AND data <= '#{params[:final]}' AND tipo = 1"
				cond = cond + " AND turno_created = #{params[:busca]["turno"]}" if params[:busca]["turno"].to_s != ""
				cond = cond + " AND produto_id = #{params[:busca]["bomba"]}" if params[:busca]["bomba"].to_s != ""
				@stocks = Stock.all(:conditions => cond, :order => 'status,data')
				respond_to do |format|
						format.html # show.html.erb
						format.xls  { render :action => "resultado_relatorio_consumo_bomba", :layout => false }
						format.pdf  { render :action => "resultado_relatorio_consumo_bomba", :layout => false }
				end

		end

		def index

				respond_to do |format|
						format.html # show.html.erb
				end
		end

    def stock_inicial                              #

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @diarios }
        end
    end

    def dinamic_busca_stock_inicial
    	params[:unidade] = current_unidade.id
      @stocks = Stock.resultaro_stock_inicial(params)
      render :layout => false
    end

		def relatorio_stock
				params[:deposito] = params[:busca]["deposito"]
				#Recalculo.gera_recalculo_listado(params)

				#VERIFICA SE  TEM DEPOSITO E IMPRIME
				if params[:busca]["deposito"].blank?
						deposito = 'Todos'
				else
						deposito = params[:busca]["deposito"]
				end
				if params[:filtro] == '0'
						f = 'SOLO ENTRADAS'
				elsif params[:filtro] == '1'
						f = 'SOLO SALIDAS'
				else
						f = 'ENTRADA Y SALIDAS'
				end


				#VERIFICA SE  TEM CLASE E IMPRIME
				if params[:busca]["clase"].blank?
					clase = 'Todos..'
				else
					clase   = params[:busca]["clase"]
					cl_c = Clase.find_by_id(params[:busca]["clase"])
					cl_desc = ' - ' << cl_c.descricao
				end

				#VERIFICA SE  TEM GRUPO E IMPRIME
				if params[:busca]["grupo"].blank?
						grupo = 'Todos..'
				else
						grupo = params[:busca]["grupo"]
						gp_c  = Grupo.find_by_id(params[:busca]["grupo"])
						gp_desc = ' - ' << gp_c.descricao
				end

				#VERIFICA SE  TEM SUB_GRUPO E IMPRIME
				if params[:busca]["sub_grupo"].blank?
						sgrupo = 'Todos..'
				else
						sgrupo = params[:busca]["sub_grupo"]
						sgp_c  = SubGrupo.find_by_id(params[:busca]["sub_grupo"])
						sgp_desc = ' - ' << sgp_c.descricao
				end


				#VERIFICA SE  TEM PRODUTO E IMPRIME
				if params[:busca]["produto"].blank?
						produto = 'Todos..'
				else
						produto = params[:busca]["produto"]
						pd_c    = Produto.find_by_id(params[:busca]["produto"])
						pd_desc = ' - ' << pd_c.nome

				end

				#VERIFICA SE  TEM DEPOSITO E IMPRIME
				if params[:busca]["deposito"].blank?
						deposito = 'Todos..'
				else
						deposito = params[:busca]["deposito"]
				end

				if params[:status].to_s == '0'
						@stocks = Stock.ficha_stock_resumido(params)
						@saldo_anterior = Stock.relatorio_ficha_stock_saldo_anterio( params )

						head =
"                                                       #{$empresa_nome}
																													 FICHA STOCK FISICO
 Fecha....: #{params[:inicio]} hasta #{params[:final]}
 Clase....: #{clase}
 Grupo....: #{grupo}
 Produto..: #{produto}
 Deposito.: #{deposito}
 Filtro...: #{f}
-------------------------------------------------------------------------------------|-------Valores------|---------Cantidades-----------|
 Lanz.     Fecha  Ref     Persona          Producto                                   Unit         Tot.     Entrada      Salida      Saldo
------------------------------------------------------------------------------------------------------------------------------------------
						"

				else
						@stocks = Stock.relatorio_ficha_stock(params)
						@saldo_anterior = Stock.relatorio_ficha_stock_saldo_anterio( params )
		 head =
"                                                       #{$empresa_nome}
																													 FICHA STOCK FINANCIERO
 Fecha....: #{params[:inicio]} hasta #{params[:final]}
 Sector...: #{ clase.to_s.rjust(6,'0') } #{cl_desc }
 Grupo....: #{ grupo.to_s.rjust(6,'0') } #{ gp_desc }
 Sub-Grupo: #{ sgrupo.to_s.rjust(6,'0') } #{ sgp_desc }
 Produto..: #{ produto.to_s.rjust(6,'0') } #{ pd_desc }
 Deposito.: #{ deposito.to_s.rjust(6,'0') }
-----------------------|-----------Entradas-----------|-|-------------Salida-------------|-|-------------Saldo-------------|--------------
	Lanz.  Fecha   Dep.   Cantidad       Unit      Total   Cantidad        Unit.      Total   Cantidad       Unit.      Total
------------------------------------------------------------------------------------------------------------------------------------------
"

				end

				respond_to do |format|
					if params["tipo"] == '1'
						 format.html {
		          render :xlsx => "relatorio_stock",
		          filename: "FichaStock-#{params[:inicio]}-#{params[:final]}"
		        }
		      else

						format.html do
						render  :pdf                    => "resultado_fechamento_caixa",
										:layout                 => "layer_relatorios",
										:margin => {:top        => '1.20in',
																:bottom     => '0.25in',
																:left       => '0.10in',
																:right      => '0.10in'},
										:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
																:font_size  => 7,
																:left       => head,
																:spacing    => 28},
										:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
																:font_size  => 7,
																:right      => "Pagina [page] de [toPage]",
																:left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
						end
					end
				end
		end

		def resultado_iventario
			#VERIFICA SE  TEM CLASE E IMPRIME
			if params[:busca]["clase"].blank?
				clase = 'Todos..'
			else
				clase   = params[:busca]["clase"]
				cl_c = Clase.find_by_id(params[:busca]["clase"])
				cl_desc = ' - ' << cl_c.descricao

			end
			#VERIFICA SE  TEM GRUPO E IMPRIME
			if params[:busca]["grupo"].blank?
					grupo = 'Todos..'
			else
					grupo = params[:busca]["grupo"]
					gp_c  = Grupo.find_by_id(params[:busca]["grupo"])
					gp_desc = ' - ' << gp_c.descricao
			end

			#VERIFICA SE  TEM SUB_GRUPO E IMPRIME
			if params[:busca]["sub_grupo"].blank?
					sgrupo = 'Todos..'
			else
					sgrupo = params[:busca]["sub_grupo"]
					sgp_c  = SubGrupo.find_by_id(params[:busca]["sub_grupo"])
					sgp_desc = ' - ' << sgp_c.descricao
			end


			#VERIFICA SE  TEM PRODUTO E IMPRIME
			if params[:busca]["produto"].blank?
					produto = 'Todos..'
			else
					produto = params[:busca]["produto"]
					pd_c    = Produto.find_by_id(params[:busca]["produto"])
					pd_desc = ' - ' << pd_c.nome

			end

			#VERIFICA SE  TEM DEPOSITO E IMPRIME
			if params[:busca]["deposito"].blank?
					deposito = 'Todos..'
			else
							deposito = params[:busca]["deposito"]
							dp_c     = Deposito.find_by_id(params[:busca]["deposito"])
							dp_desc  = ' - ' << dp_c.nome
			end
			@stocks = Stock.resultado_iventario( params )

			head =
			"                                                            #{current_unidade.nome_sys}
																													                            LISTADO DE IVENTARIO
Periodo Hasta.: #{params[:final]}
Sector........: #{ clase.to_s.rjust(6,'0') } #{cl_desc }
Grupo.........: #{ grupo.to_s.rjust(6,'0') } #{ gp_desc }
Sub-Grupo.....: #{ sgrupo.to_s.rjust(6,'0') } #{ sgp_desc }
Produto.......: #{ produto.to_s.rjust(6,'0') } #{ pd_desc }
Deposito......: #{ deposito.to_s.rjust(6,'0') } #{ dp_desc }
-----------------------------------------------------------------------------------------------------------------------------------------
Codigo   Grupo               Sub-Grupo          Ref        Producto                                Cantidad        Costo           Total
-----------------------------------------------------------------------------------------------------------------------------------------

			"

				respond_to do |format|
					if params["tipo"] == '1'
 format.html {
		          render :xlsx => "resultado_pagamentos",
		          filename: "pagamentos-#{params[:inicio]}-#{params[:final]}"
		        }					else
					format.html do
						render  :pdf                    => "resultado_fechamento_caixa",
										:layout                 => "layer_relatorios",
										:margin => {:top        => '1.55in',
																:bottom     => '0.25in',
																:left       => '0.10in',
																:right      => '0.10in'},
										:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
																:font_size  => 7,
																:left       => head,
																:spacing    => 33},
										:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
																:font_size  => 7,
																:right      => "Pagina [page] de [toPage]",
																:left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
					end
				end
			end
		end



		def resultado_STOCK_POR_MARCA

			#VERIFICA SE  TEM CLASE E IMPRIME
			if params[:busca]["clase"].blank?
				clase = 'Todos..'
			else
				clase   = params[:busca]["clase"]
				cl_c = Clase.find_by_id(params[:busca]["clase"])
				cl_desc = ' - ' << cl_c.descricao
			end

			#VERIFICA SE  TEM GRUPO E IMPRIME
			if params[:busca]["grupo"].blank?
					grupo = 'Todos..'
			else
					grupo = params[:busca]["grupo"]
					gp_c  = Grupo.find_by_id(params[:busca]["grupo"])
					gp_desc = ' - ' << gp_c.descricao
			end

			#VERIFICA SE  TEM SUB_GRUPO E IMPRIME
			if params[:busca]["sub_grupo"].blank?
					sgrupo = 'Todos..'
			else
					sgrupo = params[:busca]["sub_grupo"]
					sgp_c  = SubGrupo.find_by_id(params[:busca]["sub_grupo"])
					sgp_desc = ' - ' << sgp_c.descricao
			end


			#VERIFICA SE  TEM PRODUTO E IMPRIME
			if params[:busca]["produto"].blank?
					produto = 'Todos..'
			else
					produto = params[:busca]["produto"]
					pd_c    = Produto.find_by_id(params[:busca]["produto"])
					pd_desc = ' - ' << pd_c.nome

			end

			#VERIFICA SE  TEM DEPOSITO E IMPRIME
			if params[:busca]["deposito"].blank?
					deposito = 'Todos..'
			else
							deposito = params[:busca]["deposito"]
							dp_c     = Deposito.find_by_id(params[:busca]["deposito"])
							dp_desc  = ' - ' << dp_c.nome
			end

			@stocks = Stock.resultado_STOCK_POR_MARCA(params)

			head =
			"                                                               #{$empresa_nome}
																													LISTADO DE IVENTARIO
Periodo Hasta.: #{params[:final]}
Sector........: #{ clase.to_s.rjust(6,'0') } #{cl_desc }
Grupo.........: #{ grupo.to_s.rjust(6,'0') } #{ gp_desc }
Sub-Grupo.....: #{ sgrupo.to_s.rjust(6,'0') } #{ sgp_desc }
Produto.......: #{ produto.to_s.rjust(6,'0') } #{ pd_desc }
Deposito......: #{ deposito.to_s.rjust(6,'0') } #{ dp_desc }
-----------------------------------------------------------------------------------------------------------------------------------------
Cod.     Producto                                                                                 Cantidad       Unitario          Total
-----------------------------------------------------------------------------------------------------------------------------------------

			"

				respond_to do |format|
					if params["tipo"] == '1'
							format.html {
								xls = render_to_string :action => "resultado_iventario", :layout => false
								kit = PDFKit.new(xls, :encoding => 'UTF-8')
								send_data(xls,:filename => "Iventario-#{params[:final]}.xls")
							}
					else
					format.html do
						render  :pdf                    => "resultado_fechamento_caixa",
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
																:left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
					end
				end
			end
		end



	def resultado_rentabilidade
		params[:unidade] = current_unidade.id
		#VERIFICA SE  TEM SUBGRUPO E IMPRIME
		if params[:busca]["vendedor"].blank?
				vendedor = 'Todos..'
		else
				vendedor = params[:busca]["vendedor"].to_s.rjust(6,'0')
				sb_s = Persona.find_by_id(params[:busca]["vendedor"])
				sb_desc = ' - ' << sb_s.nome
		end

		@cmvs = Stock.rentabilidade(params)


	  if params[:tipo] == '1'
      render :xlsx => "resultado_rentabilidade",
      filename: "Rentabilidad-#{params[:inicio]}-#{params[:final]}"
	  else
	  	render :layout => 'relatorio_view'
	  end


	end

def resultado_projecao_compras

		@stocks = Stock.projecao_compras(params)
		respond_to do |format|
			format.html do
				render  :pdf                    => "resultado_fechamento_caixa",
								:layout                 => "layer_relatorios",
								:margin => {:top        => '1.55in',
														:bottom     => '0.25in',
														:left       => '0.10in',
														:right      => '0.10in'},
								:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:html => { :template => 'stocks/headers/projecao_compras.html',
														:layout     => "layer_relatorios" },
														:spacing    => 0},
								:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:right      => "Pagina [page] de [toPage]",
														:left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end

		end


def resultado_disponibilidade_stock

		@stocks = Stock.disponibilidade_stock(params)
		respond_to do |format|
			format.html do
				render  :pdf                    => "resultado_fechamento_caixa",
								:layout                 => "layer_relatorios",
								:margin => {:top        => '1.55in',
														:bottom     => '0.25in',
														:left       => '0.10in',
														:right      => '0.10in'},
								:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:html => { :template => 'stocks/headers/disponibilidade_stock.html',
														:layout     => "layer_relatorios" },
														:spacing    => 0},
								:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:right      => "Pagina [page] de [toPage]",
														:left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end

		end

	def resultado_stock_minimo
		@stocks = Stock.stock_minimo(params)
		respond_to do |format|
			format.html do
				render  :pdf                    => "resultado_fechamento_caixa",
								:layout                 => "layer_relatorios",
								:margin => {:top        => '1.75in',
														:bottom     => '0.25in',
														:left       => '0.10in',
														:right      => '0.10in'},
								:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:html => { :template => 'stocks/headers/stock_min_max.html',
														:layout     => "layer_relatorios" },
														:spacing    => 0},
								:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:right      => "Pagina [page] de [toPage]",
														:left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end
	end


	def relatorio_stock_print                      #
		cond = "data >= '#{params[:inicio]}' AND data <= '#{params[:final]}'"
		cond = cond + " AND produto_id = #{params[:busca]["produto"]}" if params[:busca]["produto"].to_s != ""
		cond = cond + " AND produto_id = #{params[:busca]["clase"]}" if params[:busca]["clase"].to_s != ""
		cond = cond + " AND produto_id = #{params[:busca]["grupo"]}" if params[:busca]["grupo"].to_s != ""
		@stocks = Stock.all(:conditions => cond, :order => 'status,data')
		render :layout => false
	end

	def show                                       #
			@stock = Stock.find(params[:id])

			respond_to do |format|
					format.html # show.html.erb
					format.xml  { render :xml => @stock }
			end
	end

	def new                                        #
		@stock = Stock.new

		respond_to do |format|
				format.html # new.html.erb
				format.xml  { render :xml => @stock }
		end
	end

	def edit                                       #
		@stock = Stock.find(params[:id])
	end

	def create
		@stock = Stock.new(params[:stock])

		#USUARIO UNIDADE
		@stock.usuario_created = current_user.id
		@stock.unidade_created = current_unidade.id
		@stock.unidade_id = current_unidade.id

		respond_to do |format|
				if @stock.save
						flash[:notice] = 'Grabado con Sucesso'
						format.html { redirect_to('/stocks/new') }
						format.xml  { render :xml => @stock, :status => :created, :location => @stock }
				else
						format.html { render :action => "new" }
						format.xml  { render :xml => @stock.errors, :status => :unprocessable_entity }
				end
		end
	end

	def update                                     #
		@stock = Stock.find(params[:id])

		#USUARIO UNIDADE
		@stock.usuario_updated = current_user.id
		@stock.unidade_updated = current_unidade.id

		respond_to do |format|
				if @stock.update_attributes(params[:stock])
						flash[:notice] = 'Actulizado con Sucesso'
						format.html { redirect_to('/stocks/stock_inicial') }
						format.xml  { head :ok }
				else
						format.html { render :action => "edit" }
						format.xml  { render :xml => @stock.errors, :status => :unprocessable_entity }
				end
		end
	end

	def destroy                                    #
		@stock = Stock.find(params[:id])
		@stock.destroy

		respond_to do |format|
				format.html { redirect_to('/stocks/stock_inicial') }
				format.xml  { head :ok }
		end
	end

	def dynamic_dispo_stock
		@marcas = Colecao.find_all_by_sub_grupo_id(params[:id])
		respond_to do |format|
			format.js
		end
	end

end
