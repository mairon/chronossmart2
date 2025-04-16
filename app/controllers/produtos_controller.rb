 class ProdutosController < ApplicationController
	before_filter :authenticate

	def galeria

		@produto = Produto.find(params[:id])
		render layout: 'chart'
		
	end

	def gera_etiqueta
		render layout: 'chart'
	end

	def lista_grade_gerada

			@produto = Produto.find(params[:id])

			@lista_produtos = Produto.where(grade_produto_id: @produto)

		end

		def busca_referencia
			sql = "
							SELECT P.ID AS PRODUTO_ID,
										 P.NOME AS NOME,
										 P.COR,
										 P.TAMANHO,
										 P.CLASE_ID AS CLASE_ID,
										 P.GRUPO_ID AS GRUPO_ID,
										 P.SUB_GRUPO_ID AS SUB_GRUPO_ID,
										 P.FABRICANTE_COD,
										 P.BARRA,
										 P.COLECAO_ID
							FROM PRODUTOS P
							WHERE P.FABRICANTE_COD = '#{params[:cod]}'
							LIMIT 1"
							find_grade = Produto.find_by_sql(sql)

							grade = find_grade.last

					return render :json => { :produto => grade }
		end

		def statisticas
			@produto = Produto.find(params[:id])
			sql = "SELECT D.ID,
									 U.UNIDADE_NOME || ' - ' || D.NOME AS DEPOSITO_NOME
						FROM DEPOSITOS D
						INNER JOIN UNIDADES U
						ON U.ID = D.UNIDADE_ID
						ORDER BY 2"

			@depositos = Deposito.find_by_sql(sql)

			render layout: 'chart'
		end


		def update_multiple
				 Produto.update(params[:products].keys, params[:products].values)
				 redirect_to(:back)
					flash[:notice] = "Datos Actulizados!"
		end


		def resultado_busca_detalhada
			@produtos = Produto.busca_produto_multiplo(params)
		end

		def busca_detalhada
		end

		def atualizar_precos
				@produto = Produto.find(params[:id])
				@unidades_tabelas = ProdutosTabelaPreco.where('produto_id = ?', @produto.id).order('id')
			render :layout => 'consulta'
		end

		def update_individual_compra
			ProdutosTabelaPreco.update(params[:products].keys, params[:products].values)
			redirect_to atualizar_precos_produto_path(params[:id])
			flash[:notice] = "Preciso Actulizados! Pulse ESC para Salir"
		end

		def roteiro
				@produto = Produto.find(params[:id])
				render :layout => false
		end

		def cod_barra
				@produto = Produto.find(params[:id])
				@produto_barras = ProdutoBarra.where("produto_id = ?", @produto.id)
		end

		def atributs
				@produto = Produto.find(params[:id])
		end


		def tabelas_precos
				@produto = Produto.find(params[:id])
				@tabela = ProdutosTabelaPreco.where("produto_id = #{@produto.id}")
		end

		def composicao
				@produto = Produto.find(params[:id])
				sql = "SELECT PC.COMPONENTE_ID,
				              PC.ID,
								       PC.COMPONENTE_NOME,
								       PC.QUANTIDADE AS QUANTIDADE,
								       UM.NOME AS UNIDADE_MEDIDA_NOME,
								       COALESCE(P.PESO,1) AS VOLUME,
								       COALESCE((SELECT S.UNITARIO_GUARANI FROM STOCKS S WHERE S.STATUS = 0 AND S.ENTRADA > 0 AND S.PRODUTO_ID = PC.COMPONENTE_ID  ORDER BY S.DATA DESC, S.TABELA_ID DESC  LIMIT 1),0) AS CUSTO_GS

								FROM PRODUTO_COMPOSICAOS PC
								LEFT JOIN PRODUTOS P
								ON P.ID = PC.COMPONENTE_ID

								LEFT JOIN UNIDADE_MEDIDAS UM
								ON UM.ID = P.UNIDADE_MEDIDA_ID

								WHERE PC.PRODUTO_ID = #{@produto.id}"

				@composicao = ProdutoComposicao.find_by_sql(sql)
				render layout: 'chart'
		end

		def relatorio_detalhes_produto
				@pd = Produto.find(params[:id])

				@quantidade = Stock.sum("entrada - saida",:conditions => ["produto_id = ?",params[:id]])

				@cp = ProdutoComposicao.all(:conditions => ["produto_id = ?", @pd.id])

				@pr = ProdutosRoteiro.all(:conditions => ["produto_id = ?", @pd.id])

				pdf = render :layout => 'layer_relatorios'
				kit = PDFKit.new(pdf,:page_size     => 'A4',
						:print_media_type  => true,
						:header_font_name  => 'bold',
						:header_font_size  => "9" ,
						:header_spacing    => "0",
						:footer_font_size  => "7",
						:footer_right  => "Pagina [page] de [toPage]",
						:footer_left   => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
						:margin_top    => '0.20in',
						:margin_bottom => '0.25in',
						:margin_left   => '0.10in',
						:margin_right  => '0.10in')

				kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
				send_data(kit.to_pdf, :filename => "producto#{@pd.id}.pdf")
		end

		def get_componente                                #
				@produto =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:campo_produto]])
				return render :text => "<script type='text/javascript'>
										document.getElementById('produto_composicao_componente_nome').value                = '#{@produto.nome}';
										document.getElementById('produto_composicao_componente_id').value                = '#{@produto.id.to_i}';
										document.getElementById('produto_composicao_clase_id').value                = '#{@produto.clase_id.to_i}';
										document.getElementById('produto_composicao_grupo_id').value                = '#{@produto.grupo_id.to_i}';
														</script>"
		end


		def get_clase                              #
				@clase =  Clase.find(:first, :conditions =>  [ "id = ?", params[:campo_clase]])
				return render :text => "<script type='text/javascript'>
										document.getElementById('busca_clase').value                = '#{@clase.id.to_i}';
														</script>"
		end

		def get_grupo                              #
				@grupo =  Grupo.find(:first, :conditions =>  [ "id = ?", params[:campo_grupo]])
				return render :text => "<script type='text/javascript'>
										document.getElementById('busca_grupo').value                = '#{@grupo.id.to_i}';
														</script>"
		end

		def get_moeda                              #
				@moeda =  Moeda.find(:first, :conditions =>  [ "data = ?", params[:produto_data]])
				return render :text => "<script type='text/javascript'>
															document.getElementById('produto_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
															document.getElementById('produto_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
														</script>"
		end

		def dinamic_busca_compra_produto
        tipo = "P.NOME ILIKE '%#{params[:busca]}%'"            if params[:tipo] == "DESCRIPCION"
        tipo = "P.FABRICANTE_COD ILIKE '%#{params[:busca]}%'"  if params[:tipo] == "REFERENCIA"
        subg = "AND P.SUB_GRUPO_ID = #{params[:sub_grupo]}"     unless params[:sub_grupo].blank?
					sql = "
					SELECT P.ID AS PRODUTO_ID,
								 P.NOME AS NOME,
								 P.FABRICANTE_COD,
								 P.COR,
								 P.TAMANHO,
								 P.BARRA,
								 CL.DESCRICAO AS CLASE_NOME,
								 GP.DESCRICAO AS GRUPO_NOME,
								 SG.DESCRICAO AS SUB_GRUPO_NOME

					FROM PRODUTOS P
					LEFT JOIN SUB_GRUPOS SG
					ON SG.ID = P.SUB_GRUPO_ID

					LEFT JOIN CLASES CL
					ON CL.ID = P.CLASE_ID

					LEFT JOIN GRUPOS GP
					ON GP.ID = P.GRUPO_ID

					WHERE #{tipo} AND P.STATUS = TRUE
					#{subg}
					ORDER BY 2,3 LIMIT 300"
				@produtos = Produto.find_by_sql(sql)
				render :layout => false
		end

		def busca_compra_produto
				render :layout => 'consulta'
		end

	def dinamic_busca_pedido_compra_produto
				sql = "
				SELECT P.ID AS PRODUTO_ID,
							 P.NOME AS NOME,
							 P.CLASE_ID AS CLASE_ID,
							 P.GRUPO_ID AS GRUPO_ID,
							 P.SUB_GRUPO_ID AS SUB_GRUPO_ID,
							 P.FABRICANTE_COD,
							 P.CUSTO_BASE_US,
							 P.CUSTO_BASE_GS,
							 P.CUSTO_BASE_RS,
							 C.DESCRICAO AS MARCA,
							 P.PESO_BRUTO,
							 P.MULTIPLO_COMPRA,
							 P.COR,
							 P.TAMANHO,
							 (SELECT CP.UNITARIO_DOLAR FROM COMPRAS_PRODUTOS CP WHERE CP.PRODUTO_ID = P.ID ORDER BY DATA DESC LIMIT 1) ULTIMA_COMPRA_US,
							 (SELECT CP.UNITARIO_GUARANI FROM COMPRAS_PRODUTOS CP WHERE CP.PRODUTO_ID = P.ID ORDER BY DATA DESC LIMIT 1) ULTIMA_COMPRA_GS
				FROM PRODUTOS P
				LEFT JOIN CLASES C
				ON C.ID = P.CLASE_ID
				WHERE (P.NOME ILIKE '%#{params[:busca]}%' OR P.FABRICANTE_COD ILIKE '%#{params[:busca]}%')  AND P.STATUS = TRUE
				ORDER BY 2,3 LIMIT 50"
				@produtos = Produto.find_by_sql(sql)
				render :layout => false
		end


		def busca_pedido_compra_produto
				@produtos = Produto.find(:all, :order => 1)
				render :layout => 'consulta'
		end

		def busca_composicao_produto
				render :layout => 'consulta'
		end

		def dinamic_busca_composicao_produto
				tipo = "id"           if params[:tipo] == "CODIGO"

				tipo = "nome"            if params[:tipo] == "DESCRIPCION"

				tipo = "fabricante_cod"  if params[:tipo] == "COD FABRICANTE"

				if params[:tipo] == "CODIGO"
						cond  = " #{tipo} = #{params[:busca]} "
				else
						cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
				end

				@produtos = Produto.all( :select     => ' id,
																									nome,
																									clase_id,
																									grupo_id,
																									sub_grupo_id,
																									preco_venda_dolar,
																									preco_venda_guarani,
																									tipo,
																									locacao,
																									fabricante_cod,
																									cod_velho ',
						:conditions =>   cond,
						:order      => "nome,#{tipo}")

				render :layout => false
		end


		def busca_consumicao_interna_produto            #
				render :layout => 'consulta'
		end

		def dinamic_busca_consumicao_interna_produto    #
				tipo = "P.NOME"            if params[:tipo] == "DESCRIPCION"
				tipo = "P.FABRICANTE_COD"  if params[:tipo] == "REFERENCIA"
				tipo = "BARRA"             if params[:tipo] == "BARRA"
				sql = "

				SELECT PG.ID AS PRODUTOS_GRADE_ID,
							 P.ID AS PRODUTO_ID,
							 P.NOME AS NOME,
							 P.CLASE_ID AS CLASE_ID,
							 P.GRUPO_ID AS GRUPO_ID,
							 P.SUB_GRUPO_ID AS SUB_GRUPO_ID,
							 PG.COR_ID AS COR_ID,
							 C.NOME AS COR_NOME,
							 C.COD_COR AS COD_COR,
							 P.FABRICANTE_COD,
							 PG.TAMANHO_ID AS TAMANHO_ID,
							 T.NOME AS TAMANHO_NOME,
							 TB.PRECO_1_US,
							 TB.PRECO_1_GS,
							 TB.PRECO_1_RS,
							 TB.PRECO_2_US,
							 TB.PRECO_2_GS,
							 TB.PRECO_2_RS,
							 TB.PRECO_3_US,
							 TB.PRECO_3_GS,
							 TB.PRECO_3_RS,
							 TB.PRECO_4_US,
							 TB.PRECO_4_GS,
							 TB.PRECO_4_RS,
							 (SELECT SUM(entrada - saida) AS sum_id FROM stocks s WHERE ( s.deposito_id = #{params[:deposito_id]} and s.produto_id = P.ID and s.produtos_grade_id = PG.ID AND s.data <= '#{params[:data]}' ) ) AS STOCK
				FROM PRODUTOS_GRADES PG
				INNER JOIN PRODUTOS P
				ON PG.PRODUTO_ID = P.ID
				LEFT JOIN PRODUTOS_TABELA_PRECOS TB
				ON PG.PRODUTO_ID = TB.PRODUTO_ID
				LEFT JOIN CORS C
				ON PG.COR_ID = C.ID
				LEFT JOIN TAMANHOS T
				ON PG.TAMANHO_ID = T.ID
				WHERE TB.UNIDADE_ID = #{params[:unidade]} AND #{tipo} LIKE '%#{params[:busca]}%' AND P.STATUS = TRUE
				ORDER BY 10,3 LIMIT 50"
				@produtos = Produto.find_by_sql(sql)
				render :layout => false
		end


		def busca_producao_produto
				render :layout => 'consulta'
		end

		def dinamic_busca_producao_produto
				tipo = "id"           if params[:tipo] == "CODIGO"

				tipo = "nome"            if params[:tipo] == "DESCRIPCION"

				tipo = "fabricante_cod"  if params[:tipo] == "COD FABRICANTE"

				if params[:tipo] == "CODIGO"
						cond  = " #{tipo} = #{params[:busca]}  AND P.STATUS = true"
				else
						cond  = " #{tipo} LIKE '%#{params[:busca]}%'  AND P.STATUS = true"
				end

				@produtos = Produto.all( :select     => ' id,
																									nome,
																									clase_id,
																									grupo_id,
																									sub_grupo_id,
																									tipo,
																									locacao,
																									fabricante_cod,
																									cod_velho ',
						:conditions =>   cond,
						:order      => "nome,#{tipo}")

				render :layout => false
		end

		def busca_venda_produto
			render :layout => false
		end

		def dinamic_busca_venda_produtos_faturados
			tipo = "P.NOME"            if params[:tipo] == "DESCRIPCION"
			tipo = "P.FABRICANTE_COD"  if params[:tipo] == "REFERENCIA"
			tipo = "P.ID"             if params[:tipo] == "CODIGO"
			marca = "AND P.CLASE_ID = #{params[:marca]}" unless params[:marca].blank?
			params_search = "#{params[:busca].gsub(' ', '+')}:*" unless params[:busca].blank?

			busca_id = "" if params[:busca].to_i > 0
			sql = "
			SELECT P.ID AS PRODUTO_ID,
						 P.NOME AS NOME,
						 P.FABRICANTE_COD,
						 TB.PRECO_1_GS,
						 C.DESCRICAO AS MARCA_NOME

			FROM PRODUTOS P

			INNER JOIN PRODUTOS_TABELA_PRECOS TB
			ON P.ID = TB.PRODUTO_ID AND TB.TABELA_PRECO_ID = 1

			LEFT JOIN CLASES C
				ON P.CLASE_ID = C.ID

			WHERE to_tsvector(upper(P.NOME)) @@ to_tsquery(upper('#{params_search}')) OR P.FABRICANTE_COD ILIKE '%#{params[:busca]}%' #{busca_id} LIMIT 30"

			@produtos = Produto.find_by_sql(sql)
			render :layout => false
		end

    def dinamic_busca_venda_produto

      tipo = " (P.BARRA || P.FABRICANTE_COD || P.NOME) ILIKE '%#{params[:busca]}%'"            if params[:tipo] == "DESCRIPCION"
      tipo = "P.FABRICANTE_COD ILIKE '%#{params[:busca]}%'"  if params[:tipo] == "REFERENCIA"
      tipo = "CAST(P.ID AS VARCHAR) = '#{params[:busca]}'"             if params[:tipo] == "CODIGO"
      subg = "AND P.SUB_GRUPO_ID = #{params[:sub_grupo]}"     unless params[:sub_grupo].blank?
      sql = "

      SELECT DISTINCT( P.ID ) AS PRODUTO_ID,
             SIMILARITY('#{params[:busca].gsub(/\s/,'|')}', (upper( COALESCE(P.NOME,'') || ' ' || COALESCE(P.FABRICANTE_COD,'') || ' ' || COALESCE(P.BARRA,'') || ' ' || COALESCE(P.OBS,'') ) )),
             P.NOME AS NOME,
             P.BARRA,
             P.FABRICANTE_COD,
             TB.PRECO_1_US,
             TB.PRECO_1_GS,
             TB.PRECO_1_RS,
             (SELECT SUM(entrada - saida) AS sum_id FROM stocks s WHERE ( s.deposito_id = #{params[:deposito_id]} and s.produto_id = P.ID AND s.data <= '#{params[:data]}' ) ) AS STOCK
      FROM PRODUTOS P
      INNER JOIN PRODUTOS_TABELA_PRECOS TB
      ON P.ID = TB.PRODUTO_ID
      WHERE  P.STATUS = TRUE
      AND TB.TABELA_PRECO_ID = #{params[:tabela_preco_id]}
      AND TB.UNIDADE_ID = #{params[:unidade]}
      AND  to_tsvector(upper( COALESCE(P.NOME,'') || ' ' || COALESCE(P.FABRICANTE_COD,'') || ' ' || COALESCE(P.BARRA,'') || ' ' || COALESCE(P.OBS,'') ) ) @@ to_tsquery(upper('#{params[:busca].gsub(/\s/,'|')}'))
      ORDER BY 2 desc,3 LIMIT 50"

      @produtos = Produto.find_by_sql(sql)
      render :layout => false
    end

		def busca_os_produto
				render :layout => 'consulta'
		end

		def dinamic_os_produto

				tipo = "P.NOME"            if params[:tipo] == "DESCRIPCION"
				tipo = "P.FABRICANTE_COD"  if params[:tipo] == "REFERENCIA"
				tipo = "PB.BARRA"             if params[:tipo] == "CODIGO"
				sql = "
				SELECT P.ID AS PRODUTO_ID,
							 P.NOME AS NOME,
							 P.FABRICANTE_COD,
							 P.PROMEDIO_GUARANI,
							 P.PROMEDIO_DOLAR,
							 C.DESCRICAO AS MARCA_NOME,
							 TB.TABELA_PRECO_ID,
							 TB.PRECO_1_US,
							 TB.PRECO_1_GS,
							 TB.PRECO_1_RS,
							 P.PROMEDIO_GUARANI,
							 P.PROMEDIO_DOLAR,
							 (SELECT SUM(entrada - saida) AS sum_id FROM stocks s WHERE ( s.deposito_id = #{params[:deposito_id]} and s.produto_id = P.ID AND s.data <= '#{params[:data]}' ) ) AS STOCK
				FROM PRODUTOS P
				LEFT JOIN PRODUTOS_TABELA_PRECOS TB
				ON P.ID = TB.PRODUTO_ID
				LEFT JOIN PRODUTO_BARRAS PB
				ON PB.PRODUTO_ID = P.ID

				LEFT JOIN CLASES C
				ON P.CLASE_ID = C.ID

				WHERE #{tipo} ILIKE '%#{params[:busca]}%'  AND P.STATUS = true
				ORDER BY 2,3 LIMIT 50"

				@produtos = Produto.find_by_sql(sql)
				render :layout => false
		end

		def busca_empaque_produto
				render :layout => 'consulta'
		end


		def dinamic_busca_empaque_produto

				tipo = "VP.NOME"            if params[:tipo] == "DESCRIPCION"
				tipo = "VP.FABRICANTE_COD"  if params[:tipo] == "REFERENCIA"
				tipo = "BARRA"             if params[:tipo] == "BARRA"
				sql = " SELECT VP.PRODUTOS_GRADE_ID AS PRODUTOS_GRADE_ID,
																	MAX(VP.FABRICANTE_COD) AS FABRICANTE_COD,
																	MAX(VP.PRODUTO_NOME) AS NOME,
																	MAX(VP.TAMANHO_NOME) AS TAMANHO_NOME,
																	MAX(VP.COR_NOME) AS COR_NOME,
																	MAX(VP.PRODUTO_ID) AS PRODUTO_ID,
																	MAX(VP.COR_ID) AS COR_ID,
																	MAX(VP.TAMANHO_ID) AS TAMANHO_ID,
																	MAX(C.COD_COR) AS COD_COR,
																	SUM(VP.QUANTIDADE) AS QUANTIDADE,
																	COALESCE((SELECT SUM(EP.QUANTIDADE) FROM EMPAQUE_PRODUTOS EP WHERE EMPAQUE_ID = #{params[:empaque]} AND EP.PRODUTOS_GRADE_ID = VP.PRODUTOS_GRADE_ID),0) AS ADD
																FROM VENDAS_PRODUTOS VP
																LEFT JOIN PRODUTOS_GRADES PG
																ON VP.PRODUTOS_GRADE_ID = PG.ID
																LEFT JOIN CORS C
																ON PG.COR_ID = C.ID
																LEFT JOIN TAMANHOS T
																ON PG.TAMANHO_ID = T.ID
																WHERE VP.VENDA_ID = #{params[:venda_id]} AND #{tipo} LIKE '%#{params[:busca]}%'
																GROUP BY 1 LIMIT 150"

				@produtos = Produto.find_by_sql(sql)
				render :layout => false
		end

		def busca_condicional_produto
				render :layout => 'consulta'
		end


		def dinamic_busca_condicional_produto

				tipo = "P.NOME"            if params[:tipo] == "DESCRIPCION"
				tipo = "P.FABRICANTE_COD"  if params[:tipo] == "REFERENCIA"
				tipo = "BARRA"             if params[:tipo] == "BARRA"
				sql = "

				SELECT
							 P.ID AS PRODUTO_ID,
							 P.NOME AS NOME,
							 P.FABRICANTE_COD,
							 TB.PRECO_1_US,
							 TB.PRECO_1_GS,
							 TB.PRECO_1_RS,
							 (SELECT SUM(entrada - saida) AS sum_id FROM stocks s WHERE ( s.deposito_id = #{params[:deposito_id]} and s.produto_id = P.ID AND s.data <= '#{params[:data]}' ) ) AS STOCK
				FROM PRODUTOS P
				LEFT JOIN PRODUTOS_TABELA_PRECOS TB
				ON P.ID = TB.PRODUTO_ID
				WHERE TB.UNIDADE_ID = #{params[:unidade]} AND #{tipo} LIKE '%#{params[:busca]}%'
				ORDER BY 2,3 LIMIT 50"

				@produtos = Produto.find_by_sql(sql)
				render :layout => false
		end

		def busca_presupuesto_produto
				render :layout => 'consulta'
		end

		def dinamic_busca_presupuesto_produto
      tipo = " (P.BARRA || P.FABRICANTE_COD || P.NOME) ILIKE '%#{params[:busca]}%'"            if params[:tipo] == "DESCRIPCION"
      tipo = "P.FABRICANTE_COD ILIKE '%#{params[:busca]}%'"  if params[:tipo] == "REFERENCIA"
      tipo = "CAST(P.ID AS VARCHAR) = '#{params[:busca]}'"             if params[:tipo] == "CODIGO"
      subg = "AND P.SUB_GRUPO_ID = #{params[:sub_grupo]}"     unless params[:sub_grupo].blank?
      sql = "

      SELECT DISTINCT( P.ID ) AS PRODUTO_ID,
             P.NOME AS NOME,
             P.BARRA,
             P.FABRICANTE_COD,
             TB.PRECO_1_US,
             TB.PRECO_1_GS,
             TB.PRECO_1_RS,
             (SELECT SUM(entrada - saida) AS sum_id FROM stocks s WHERE ( s.deposito_id = #{params[:deposito_id]} and s.produto_id = P.ID AND s.data <= '#{params[:data]}' ) ) AS STOCK
      FROM PRODUTOS P
      INNER JOIN PRODUTOS_TABELA_PRECOS TB
      ON P.ID = TB.PRODUTO_ID
      WHERE  P.STATUS = TRUE
      AND TB.TABELA_PRECO_ID = #{params[:tabela_preco_id]}
      AND TB.UNIDADE_ID = #{params[:unidade]}
      AND to_tsvector(upper(COALESCE(P.NOME, '') || ' ' || COALESCE(P.CHASSI, '') || ' ' || COALESCE(P.REFERENCIA, '') || ' ' || COALESCE(P.COR, '') || ' ' ||  COALESCE(P.ANO, '') || ' ' ||  COALESCE(P.OBS, '') || ' ' || COALESCE(P.FABRICANTE_COD, '') || ' '  || ' ' || COALESCE(P.BARRA, '') || ' ' || COALESCE( CAST(P.ID AS CHARACTER VARYING ), '') )) @@ to_tsquery(upper('#{params[:busca].gsub(/\s/,'&')}:*'))
      ORDER BY 2,3 LIMIT 50"

      @produtos = Produto.find_by_sql(sql)
      render :layout => false
		end

		def busca_remicao_produto
				render :layout => 'consulta'
		end

		def dinamic_busca_remicao_produto

				tipo = "P.ID"           if params[:tipo] == "CODIGO"

				tipo = "P.NOME"            if params[:tipo] == "DESCRIPCION"

				if params[:tipo] == "CODIGO"
						cond  = " #{tipo} = #{params[:busca]} "
				else
						cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
				end

					sql = "SELECT
											 P.ID,
											 P.NOME,
											 P.CLASE_ID,
											 P.GRUPO_ID,
											 P.TIPO,
											 P.PRECO_VENDA_DOLAR AS PRECO_US,
											 P.PRECO_VENDA_GUARANI AS PRECO_GS,
											 P.PRECO_MAIORISTA_DOLAR,
											 P.PRECO_MAIORISTA_GUARANI,
											 P.PRECO_MINORISTA_DOLAR,
											 P.PRECO_MINORISTA_GUARANI,
											 P.CODIGO,
											 P.BARRA,
											 P.TAXA,
											 P.LOCACAO,
											 P.DESCONTO,
											 P.FABRICANTE_COD,
											 P.COD_VELHO,
											 (SELECT SUM(ENTRADA - SAIDA) FROM STOCKS WHERE PRODUTO_ID = P.ID) AS STOCK
								 FROM  PRODUTOS P
								 WHERE #{cond}
									 ORDER BY #{tipo}  LIMIT 50"

				@produtos = Produto.paginate_by_sql(sql, :page => params[:page], :per_page => 20)

				render :layout => false
		end

		def dinamic_busca_ordem_produto            #
				@produtos = Produto.find(:all, :conditions => ["fabricante_cod LIKE ? OR nome LIKE ? OR fabricante LIKE ?","%#{params[:busca]}%","%#{params[:busca]}%","%#{params[:busca]}%"])
				render :layout => false
		end

		def busca_ordem_produto                    #
				@produtos = Produto.find(:all, :order => 1)

				respond_to do |format|
						format.html # index.html.erb
						format.xml  { render :xml => @produtos }
				end
		end

		def historico_preco_produto
				@tabela = TabelaPrecoProduto.all(:conditions => ['produto_id = ?',params[:id]])
				render :layout => 'consulta'
		end

		def consulta_stock
				render :layout => 'consulta'
		end

		def dinamic_busca_consulta_stock

				sql = "

					SELECT P.ID AS PRODUTO_ID,
							 P.NOME AS NOME,
							 SIMILARITY('#{params[:busca]}', (upper( COALESCE(P.NOME,'') || ' ' || COALESCE(P.FABRICANTE_COD,'') || ' ' || COALESCE(P.BARRA,'') || ' ' || COALESCE(P.OBS,'') ) )),
							 P.FABRICANTE_COD,
							 P.BARRA,
							 P.LOCACAO,
							 P.OBS,
							 CL.DESCRICAO AS CLASE_NOME,
							 G.DESCRICAO AS GRUPO_NOME,
							 SG.DESCRICAO AS SUB_GRUPO_NOME,

							 (SELECT TB.PRECO_1_US FROM PRODUTOS_TABELA_PRECOS TB WHERE TB.PRODUTO_ID = P.ID AND TB.UNIDADE_ID = #{params[:unidade]} AND TB.TABELA_PRECO_ID = 1 LIMIT 1) AS TABELA_1_US,
							 (SELECT TB.PRECO_2_US FROM PRODUTOS_TABELA_PRECOS TB WHERE TB.PRODUTO_ID = P.ID AND TB.UNIDADE_ID = #{params[:unidade]} AND TB.TABELA_PRECO_ID = 1 LIMIT 1 ) AS TABELA_2_US,
							 (SELECT TB.PRECO_1_GS FROM PRODUTOS_TABELA_PRECOS TB WHERE TB.PRODUTO_ID = P.ID AND TB.UNIDADE_ID = #{params[:unidade]} AND TB.TABELA_PRECO_ID = 1 LIMIT 1 ) AS TABELA_1_GS,
							 (SELECT TB.PRECO_2_GS FROM PRODUTOS_TABELA_PRECOS TB WHERE TB.PRODUTO_ID = P.ID AND TB.UNIDADE_ID = #{params[:unidade]} AND TB.TABELA_PRECO_ID = 1 LIMIT 1 ) AS TABELA_2_GS,
							 (SELECT SUM(entrada - saida) FROM stocks s WHERE (s.produto_id = P.ID AND S.DEPOSITO_ID = #{params[:dp]["deposito"]}) ) AS STOCK
					FROM PRODUTOS P
					LEFT JOIN SUB_GRUPOS SG
					ON SG.ID = P.SUB_GRUPO_ID

					LEFT JOIN CLASES CL
					ON CL.ID = P.CLASE_ID

					LEFT JOIN GRUPOS G
					ON G.ID = P.GRUPO_ID
					WHERE to_tsvector(upper( COALESCE(P.NOME,'') || ' ' || COALESCE(P.FABRICANTE_COD,'') || ' ' || COALESCE(P.BARRA,'') || ' ' || COALESCE(P.OBS,'') ) ) @@ to_tsquery(upper('#{params[:busca].gsub(/\s/,'|')}'))

					ORDER BY 3 desc ,2,1
					LIMIT  50
				"
				@produtos = Produto.find_by_sql(sql)

				respond_to do |format|
						format.html {render :layout => false}
				end
		end

		def dinamic_busca

				@produtos = Produto.busca_produto(params)

				respond_to do |format|
						format.html {render :layout => false}
						format.json {render :json => {:pd => @produtos} }
				end
		end
		
		def index
			render layout: 'chart'
		end

	def grades

		@produto = Produto.new
    3.times do
    	produto_grades =  @produto.produtos_grades.build
    end

		render layout: 'chart'


	end

		def busca_grades
			params[:unidade] = current_unidade.id
			@produtos = Produto.busca_produto_grades(params)
		end


		def index_print

 head =
				"                                                      LISTADO DE CONFERENCIA                              "


			@produtos = Produto.busca_produto_listado(params)
			respond_to do |format|
		 	    if params[:modelo] == '1'
					format.html {
				      xls = render_to_string :action => "index_print", :layout => false
				      kit = PDFKit.new(xls,
				                       :encoding => 'UTF-8')
				      send_data(xls,:filename => "resultado_produtos.xls")
				    }
			  	else
					format.html do
						render  :pdf                    => "resultado_fechamento_caixa",
									:layout                 => "layer_relatorios",
									:margin => {:top        => '0.50in',
															:bottom     => '0.25in',
															:left       => '0.10in',
															:right      => '0.10in'},
									 :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:left       => head,
														:spacing    => 3},
									:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
															:font_size  => 7,
															:right      => "Pagina [page] de [toPage]",
															:left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
					end
				end
			end
		end

		def show
			@produto = Produto.find(params[:id])
			@unidades_tabelas = ProdutosTabelaPreco.where('produto_id = ? and unidade_id = ?', @produto.id, current_unidade.id).order('id')
			render layout: 'chart'
		end

		def historico
			@produto = Produto.find(params[:id])
			@saidas   = Stock.where(produto_id: params[:id], status: 1).order('data desc')
			@entradas = Stock.where(produto_id: params[:id], status: 0).order('data desc')
			render layout: false
		end

		def etiquetas

			if params[:modelo] == '1'

		    clase     = "AND P.clase_id = #{params[:clase]}" unless params[:clase].blank?
		    grupo     = "AND P.grupo_id = #{params[:grupo]}" unless params[:grupo].blank?
		    colecao     = "AND P.COLECAO_ID = #{params[:colecao]}" unless params[:colecao].blank?

		    tipo = "P.nome"            if params[:tipo] == "DESCRIPCION"
		    tipo = "P.id"              if params[:tipo] == "CODIGO"
		    tipo = "P.barra"           if params[:tipo] == "BARRA"
		    tipo = "P.fabricante_cod"  if params[:tipo] == "REFERENCIA"

		    if params[:tipo] == "CODIGO"
		      cond  = "AND #{tipo} = #{params[:busca]} "

		    elsif params[:tipo] == "BARRA"
		      cond  = "AND barra LIKE '#{params[:busca]}%'" unless params[:busca].blank?

		    elsif params[:tipo] == "REFERENCIA"
		      cond  = "AND fabricante_cod LIKE '%#{params[:busca]}%'" unless params[:busca].blank?

		    else
		      params_search = "#{params[:busca].gsub(' ', '+')}:*" unless params[:busca].blank?
		      cond  = "AND to_tsvector(upper(NOME)) @@ to_tsquery(upper('#{params_search}'))" unless params[:busca].blank?
		    end
		    sql = "SELECT P.ID,
		                  P.NOME,
		                  C.DESCRICAO AS CLASE_NOME,
		                  G.DESCRICAO AS GRUPO_NOME,
		                  CL.NOME AS COLECAO_NOME,
		                  P.FABRICANTE_COD,
		                  P.USUARIO_CREATED,
		                  P.BARRA,
		                  P.TAMANHO,
		                  P.COR,
		                  P.ite_PREVE1,
		                  P.ite_PREVE2,
		                  P.STOCK,
		                  P.CUSTO_INICIAL_GS,
		                  (SELECT U.NOME FROM UNIDADE_MEDIDAS U WHERE U.ID = P.UNIDADE_MEDIDA_ID) as UNIDADE_MEDIDA,
		                  (SELECT PT.PRECO_1_GS FROM PRODUTOS_TABELA_PRECOS PT WHERE PT.PRODUTO_ID = P.ID AND TABELA_PRECO_ID = 1 LIMIT 1) AS PRECO_1_GS
		            FROM PRODUTOS P
		            LEFT JOIN CLASES C
		            ON C.ID = P.CLASE_ID

		            LEFT JOIN GRUPOS G
		            ON G.ID = P.GRUPO_ID

		            LEFT JOIN COLECAOS CL
		            ON CL.ID = P.COLECAO_ID


		            WHERE P.ID > 0 #{cond} #{clase} #{grupo} #{colecao}
		            "
		    @produtos = Produto.find_by_sql(sql)

			else
				@produto = Produto.find(params[:id])
				@preco_tb_1 = ProdutosTabelaPreco.where(unidade_id: current_unidade.id, produto_id: @produto.id, tabela_preco_id: 1).last
				@unidade_medida = UnidadeMedida.where(id: @produto.unidade_medida_id).last

			end
				render layout: false
		end

		def add_cor
			@produto = Produto.find(params[:id])
			@cor = Cor.find(params[:produto]["cor_ids"])
				@cor.each do |c|
					CorsProduto.create(  :produto_id => params[:id],
															:cor_id      => c.id )
				end

			redirect_to(produto_path(@produto))
		end

		def add_tamanho
			@produto = Produto.find(params[:id])
			@tamanho = Tamanho.find(params[:produto]["tamanho_ids"])
				@tamanho.each do |c|
					ProdutosTamanho.create(  :produto_id => params[:id],
															:tamanho_id      => c.id )
				end

			redirect_to(produto_path(@produto))

		end
		def gerar_disponibilidades
			@produto = Produto.find(params[:id])
			sql= "select cp.produto_id as produto_id,
									 cp.cor_id as cor,
									 pt.tamanho_id as tamanho
						from cors_produtos cp
						inner join produtos_tamanhos pt
						on cp.produto_id = pt.produto_id
						where cp.produto_id = #{params[:id]}
						AND (SELECT COUNT(PG.ID) FROM PRODUTOS_GRADES PG WHERE PG.COR_ID = CP.COR_ID AND PG.TAMANHO_ID = PT.TAMANHO_ID AND PG.PRODUTO_ID = #{params[:id]}) = 0
						"
			dispo = Produto.find_by_sql(sql)
			dispo.each do |d|
					ProdutosGrade.create(  :produto_id    => params[:id],
																 :fabricante_id => @produto.fabricante_id,
																 :cor_id        => d.cor.to_i,
																 :tamanho_id    => d.tamanho.to_i)
			end
			redirect_to(produto_path(@produto))
		end

		def imagem
			@produto = Produto.find(params[:id])
			render :layout => 'consulta'
		end

		def new
			@produto = Produto.new

			unidades_tabelas = TabelaPreco.order('id')
			unidades = Unidade.where(id: current_unidade.id).order('id')
				
			unidades.each do |u|
				unidades_tabelas.each do |un|
					produtos_tabela_precos =  @produto.produtos_tabela_precos.build(tabela_preco_id: un.id, unidade_id: u.id)
				end
			end

			render layout: 'chart'
		end

		def edit
			@produto = Produto.find(params[:id])
			render layout: 'chart'
		end

		def create                       #
			@produto = Produto.new(params[:produto])
			@produto.usuario_created = current_user.id
			@produto.unidade_created = current_unidade.id

			respond_to do |format|
				if @produto.save
					if params[:proc] == 'grade'
						format.html { redirect_to  "/produtos/#{@produto.id}/lista_grade_gerada"  }
					else
						format.html { redirect_to(produto_path(@produto)) }
						format.xml  { render :xml => @produto, :status => :created, :location => @produto }
					end
				else
					format.html { render :action => "new" }
					format.xml  { render :xml => @produto.errors, :status => :unprocessable_entity }
				end
			end
		end


		def update_individual

			Produto.find(params[:id]).update_attributes(custo_base_gs: params[:custo_base_gs])
			ProdutosTabelaPreco.update(params[:products].keys, params[:products].values)
			redirect_to produto_path(params[:id])
		end

		def update                       #
			@produto = Produto.find(params[:id])
			respond_to do |format|
					if @produto.update_attributes(params[:produto])
							flash[:notice] = 'Actualizado con Sucesso'
							format.html { redirect_to(produto_path(@produto)) }
							format.xml  { head :ok }
					else
							format.html { render :action => "edit" }
							format.xml  { render :xml => @produto.errors, :status => :unprocessable_entity }
					end
			end
		end

		def destroy                      #
				@produto = Produto.find(params[:id])
				@produto.destroy

				respond_to do |format|
						format.html { redirect_to(produtos_url) }
						format.xml  { head :ok }
				end
		end

		def dynamic_colecao
			@sub_grupos = SubGrupo.find_all_by_id(params[:id])
			@personas = Colecao.find_all_by_sub_grupo_id(params[:id])
			respond_to do |format|
				format.js
			end
		end

end
