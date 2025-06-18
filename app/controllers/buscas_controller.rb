class BuscasController < ApplicationController

	def busca_custo
		last_custo = Stock.where(produto_id: params[:produto_id], status: 0 ).order(:data).last
		return render :json => { :custo => last_custo }
	end

	def busca_viaticos
		sql = "SELECT V.ID,
    							(lpad(cast(V.ID as varchar),6,'0') || ' - ' || cast( (V.VALOR_GS - COALESCE((SELECT SUM(CP.TOTAL_GUARANI) FROM COMPRAS CP WHERE CP.VIATICO_ID = V.ID ),0) ) as money) ) AS VALUE
					FROM VIATICOS V
					WHERE V.PERSONA_ID = #{params[:funcionario_id]}"
			viats =  Viatico.find_by_sql(sql)

			respond_to do |format|
			format.json  { list = viats.map {|u| Hash[ id: u.id, label: u.value]}
				render json: list }
		end
	end

	def busca_default_produto
		if params[:tipo] == 'id'
			cond = "P.ID = #{params[:id]}"
		else
			cond = "(P.FABRICANTE_COD || ' ' || P.NOME) ILIKE '%#{params[:busca]}%'"
		end
		sql = "SELECT
									P.ID,
									P.NOME AS NOME,
									(P.FABRICANTE_COD || ' ' || P.NOME) AS NOME_FABRICANTE

						FROM PRODUTOS P

						WHERE #{cond}
						LIMIT 15"
		produtos = Produto.find_by_sql(sql)
		respond_to do |format|
		if params[:tipo] == 'id'
			format.json  { render json: {:produto => produtos.first} }
		else
			format.json  { list = produtos.map {|u| Hash[ id: u.id, label: u.nome_fabricante, label_fabr: u.nome_fabricante]}
				render json: list }
		end
		end
	end

	def busca_ruc
    url = URI("https://api.facturasend.com.py/chronos_3224/ruc/#{params[:ruc][0...-2]}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["authorization"] = 'Bearer api_key_13D8ABE4-0C22-4CDB-975E-C58D0A767CC0'
    request["content-type"] = 'application/json'
    # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
		response = http.request(request)
    puts get_resp = JSON.parse(response.body)

    return render :json => { :fe => get_resp }
	end

	def busca_cartao
		find_cartao = Cartao.where(unidade_id: params[:unidade_id], nome: params[:cod], status_op: 0 ).first
		return render :json => { :cartao => find_cartao }
	end

  def autoriza_acao_venda
    persona =  Usuario.find_by_senha_autoriza_venda(params[:cod])

    return render :json => { :us => persona, :errors => persona.errors }
  end

	def busca_tipo_contas
		if current_unidade.conta_multi_unidades == true
			un = ""
		else
			un = "unidade_id = #{params[:unidade_id]} and "
		end

		@contas = Conta.where("#{un} tipo = #{params[:tipo]} and status = true").select('nome,id').order('nome')
		respond_to do |format|
			format.js
		end
	end

	def busca_pedido_traslado

		@pedido = PedidoTraslado.where("persona_id = #{params[:persona_id]}").select('cod_ext,id').order('id desc')
		respond_to do |format|
			format.js
		end
	end

	def proveedor_pagar
		dados_prov = Proveedore.where(id: params[:prev_gasto]).first
		return render :json => { :prov => dados_prov }
	end

	def get_moeda_conta
		conta =  Conta.find_by_id(params[:conta], :select => 'id,moeda')
		return render :text => conta.moeda
	end


	def get_produtos_precos
		produto = ProdutosTabelaPreco.where(produto_id: params[:produto_id], tabela_preco_id: params[:tabela_preco_id]).first
		return render :json => { :produto => produto }
	end

	def busca_sigle_produto
		produto = Produto.where(id: params[:busca]).select('id,nome').first
		return render :json => { :busca => produto }
	end

	def busca_preco_produto
		produto = ProdutosTabelaPreco.where(produto_id: params[:busca], tabela_preco_id: 1).select('preco_1_gs').first
		return render :json => { :busca => produto }
	end

	def busca_embalagem
		sql = "SELECT E.COD_EMBALAGEM,
									E.CAPACIDADE,
									P.ITE_PREVE2
					 FROM EMBALAGENS E
					 LEFT JOIN PRODUTOS P
					 ON P.ID = E.PRODUTO_ID
					 WHERE E.COD_EMBALAGEM = #{params[:data]}
					 LIMIT 1"

		embalagem =  Embalagem.find_by_sql(sql).last
		return render :json => embalagem
	end

	def busca_timbrado_vecimento
		compra =  Coompra.last(conditions: ["persona_id = #{params[:data]}"], select: 'documento_timbrado,venc_timbrado')
		return render :json => { :persona => compra }
	end

	def compra_documento
		doc =  Documento.find_by_id(params[:data])
		return render :text => doc.fiscal.to_i
	end

	def get_unidade
		unidade =  Unidade.find_by_id(params[:unidade], :select => 'id')
		return render :text => unidade.id
	end

	def get_usuario
		usuario =  Usuario.find_by_id(params[:usuario], :select => 'id')
		return render :text => usuario.id
	end

	def cotz_us_compra
		moeda =  Moeda.last(:select => 'dolar_compra')
		return render :text => moeda.dolar_compra.to_f
	end

	def cotz_us_venda
		moeda =  Moeda.last(:select => 'dolar_venda')
		return render :text => moeda.dolar_venda.to_i
	end

	def cotz_rs_compra
		moeda =  Moeda.last(:select => 'real_compra')
		return render :text => moeda.real_compra.to_i
	end

	def cotz_rs_venda
		moeda =  Moeda.last(:select => 'real_venda')
		return render :text => moeda.real_venda.to_i
	end

	def cotz_rs_us_venda
		moeda =  Moeda.last(:select => 'rs_us_venda')
		return render :text => moeda.rs_us_venda.to_f
	end

	def cotz_rs_us_compra
		moeda =  Moeda.last(:select => 'rs_us_compra')
		return render :text => moeda.rs_us_compra.to_f
	end

	def cotz_ps_venda
		moeda =  Moeda.last(:select => 'ps_gs_venda')
		return render :text => moeda.ps_gs_venda.to_i
	end
	def cotz_ps_compra
		moeda =  Moeda.last(:select => 'ps_gs_compra')
		return render :text => moeda.ps_gs_compra.to_i
	end


	def search_all_produtos
		@produtos = Produto.select("id,nome,peso_bruto,fabricante_cod,multiplo_compra, SIMILARITY('#{params[:busca]}', NOME)").where("status = true and NOME ILIKE ?","%#{params[:busca]}%").order('5 desc, 2').limit(20)
		respond_to do |format|
			format.json  { list = @produtos.map {|u| Hash[ id: u.id, label: "#{u.fabricante_cod} #{u.nome}", name: u.nome, peso_bruto: u.peso_bruto]}
							render json: list }

		end

	end

	def busca_produto
		prod   = Produto.find_by_fabricante_cod(params[:cod])    if params[:tipo_cod] == "CODIGO"
		prod   = Produto.find_by_barra(params[:cod]) if params[:tipo_cod] == "BARRA"

		stock  = Stock.sum('entrada - saida', :conditions => ["produto_id = ? and deposito_id = ? and data <= ?",prod.id, params[:deposito_id], params[:data]] )
		return render :json => {:produto => prod, :sum_stock => stock}
	end

	def get_pedido
		pedido =  Presupuesto.find(:first, :conditions =>  [ "id = ?", params[:pedido]])
		return render :json => { :p => pedido}

	end

	def get_produto
		prod =  Produto.find_by_barra( params[:cod], :select => 'id,nome')
		return render :json => { :prod => prod}
	end

	def get_clase
		cl = Clase.find_by_id( params[:cod], :select => 'id')
		return render :text => cl.id.to_i
	end

	def get_grupo
		g =  Grupo.find_by_id( params[:cod], :select => 'id')
		return render :text => g.id.to_i
	end

	def get_subgrupo
		sg =  SubGrupo.find_by_id( params[:cod], :select => 'id')
		return render :text => sg.id.to_i
	end

	def get_tara_cadinho
		ts =  TaraCadinho.find_by_tara( params[:data], :select => 'peso')
		return render :text => ts.peso.to_f
	end

	def get_fabricante_cod
		p =  Produto.find_by_fabricante_cod( params[:fabricante], :select => 'nome')
		return render :text => p.nome.to_s
	end

	def get_referencia
		p =  Produto.find_by_fabricante_cod( params[:fabricante], :select => 'id')
		return render :text => p.id.to_i
	end

	def get_compra_empaque_referencia_grade
		p = ComprasProduto.find_by_fabricante_cod( params[:fabricante], :select => 'id')
		return render :text => p.produtos_grade_id.to_i
	end


	def get_cliente
		g =  Persona.find_by_id( params[:cod_cliente], :select => 'id,nome', conditions: ["tipo_cliente = 1"])
		return render :json => { :persona => g }
	end

	def get_funcionario
		g =  Persona.find_by_id( params[:cod])
		return render :json => { :persona => g }
	end


	def get_vendedor
		g =  Persona.find_by_id( params[:cod_vendedor], :select => 'id,nome', conditions: ["tipo_vendedor = 1"])

		if g.nil?
			return render :json => { :persona => 'null' }
		else
			return render :json => { :persona => g }
		end
	end

	def get_plano
		g =  Plano.find_by_id( params[:cod_plano], :select => 'id,condicao')
		return render :text => g.id.to_i
	end

	def busca_compra_produto

			if params[:cod][0..0].to_s == '2'
				puts prod_id =  params[:cod][1..6].to_i
				puts kg      =  params[:cod][7..8]
				puts grms    =  params[:cod][9..11]

				peso = "#{kg}.#{grms}"

					sql = "
					SELECT
							P.ID AS PRODUTO_ID,
							 P.NOME AS NOME,
							 P.CLASE_ID AS CLASE_ID,
							 P.GRUPO_ID AS GRUPO_ID,
							 P.FABRICANTE_COD,
							 P.CUSTO_BASE_US,
							 P.CUSTO_BASE_GS,
							 P.CUSTO_BASE_RS,
							 P.MULTIPLO_COMPRA,
						 	 '#{peso}' AS QTD
					FROM PRODUTOS P
					WHERE P.FABRICANTE_COD = '#{prod_id}'
					LIMIT 1"

			else

				sql = "
				SELECT P.ID AS PRODUTO_ID,
							 P.NOME AS NOME,
							 P.CLASE_ID AS CLASE_ID,
							 P.GRUPO_ID AS GRUPO_ID,
							 P.FABRICANTE_COD,
							 P.CUSTO_BASE_US,
							 P.CUSTO_BASE_GS,
							 P.CUSTO_BASE_RS,
							 P.MULTIPLO_COMPRA
				FROM PRODUTOS P
				LEFT JOIN PRODUTO_BARRAS PB
				ON PB.PRODUTO_ID = P.ID
				WHERE PB.BARRA = '#{params[:cod]}'
				LIMIT 1"
			end

				find_grade = Produto.find_by_sql(sql)

				grade = find_grade.first

		return render :json => { :produto => grade }
	end

	def busca_venda_produto

			#2 000018 11 805 4
			#2 000008 00 375 9
			if params[:barra_balanca] == 'true' and params[:cod][0..0].to_s == '2'
				puts prod_id =  params[:cod][1..6].to_i
				puts kg      =  params[:cod][7..8]
				puts grms    =  params[:cod][9..11]

				if params[:cod][7..11] == '00001'
					peso = "1"
				else
					peso = "#{kg}.#{grms}"
				end


					sql = "
					SELECT
						 P.ID AS PRODUTO_ID,
						 P.NOME AS NOME,
						 P.CLASE_ID AS CLASE_ID,
						 P.GRUPO_ID AS GRUPO_ID,
						 P.SUB_GRUPO_ID AS SUB_GRUPO_ID,
						 P.FABRICANTE_COD,
						 TB.PRECO_1_US,
						 TB.PRECO_1_GS,
						 TB.PRECO_1_RS,
						 #{peso} AS QTD,
						 (SELECT SUM(entrada - saida) AS sum_id FROM stocks s WHERE ( s.deposito_id = #{params[:deposito]} AND s.produto_id = P.ID AND s.data <= '#{params[:data].split("/").reverse.join("-")}' ) ) AS STOCK
					FROM PRODUTOS P
					LEFT JOIN PRODUTOS_TABELA_PRECOS TB
					ON P.ID = TB.PRODUTO_ID
					WHERE P.FABRICANTE_COD = '#{prod_id}'
					AND P.STATUS = TRUE
					AND TB.TABELA_PRECO_ID = #{params[:tabela_preco]}
					AND TB.UNIDADE_ID = #{params[:unidade]}
					LIMIT 1"

			else
					if params[:tipo_busca] == 'ID'
						filtro_prod = "P.ID = #{params[:cod]}"
					else
						filtro_prod = "PB.BARRA = '#{params[:cod]}'"
					end
						sql = "
						SELECT
							 P.ID AS PRODUTO_ID,
							 P.NOME AS NOME,
							 P.CLASE_ID AS CLASE_ID,
							 P.GRUPO_ID AS GRUPO_ID,
							 P.SUB_GRUPO_ID AS SUB_GRUPO_ID,
							 P.FABRICANTE_COD,
							 TB.PRECO_1_US,
							 TB.PRECO_1_GS,
							 TB.PRECO_1_RS,
							 1 AS QTD,
							 (SELECT SUM(entrada - saida) AS sum_id FROM stocks s WHERE ( s.deposito_id = #{params[:deposito]} AND s.produto_id = P.ID AND s.data <= '#{params[:data].split("/").reverse.join("-")}' ) ) AS STOCK
						FROM PRODUTOS P

						LEFT JOIN PRODUTOS_TABELA_PRECOS TB
						ON P.ID = TB.PRODUTO_ID

						LEFT JOIN PRODUTO_BARRAS PB
						ON P.ID = PB.PRODUTO_ID

						WHERE #{filtro_prod}
						AND TB.TABELA_PRECO_ID = #{params[:tabela_preco]}
						AND P.STATUS = TRUE
						AND TB.UNIDADE_ID = #{params[:unidade]}
						LIMIT 1"
			end

			find_grade = ProdutosGrade.find_by_sql(sql)
			grade = find_grade.first

			return render :json => { :produto => grade }
	end


	def busca_conferencia_produto
		if params[:filtro] == 'descr'
			prod    = "P.ID = #{params[:cod]}"
		else
			barra   = Produto.find_by_barra(params[:cod])
			prod    = "P.ID = #{barra.id}"
		end

		 sql = " SELECT P.ID AS PRODUTO_ID,
					P.NOME AS PRODUTO_NOME,
					COALESCE((SELECT SUM(COALESCE(S.ENTRADA,0) - COALESCE(S.SAIDA,0)) FROM STOCKS S WHERE S.PRODUTO_ID = P.ID AND S.DATA <= '#{params[:dt].split("/").reverse.join("-")}' AND S.DEPOSITO_ID = #{params[:deposito_id]}),0) AS SALDO_ATUAL,
					COALESCE((SELECT S.UNITARIO_GUARANI FROM STOCKS S WHERE S.STATUS = 0 AND S.PRODUTO_ID = P.ID AND S.DATA <= '#{params[:dt].split("/").reverse.join("-")}' AND S.DEPOSITO_ID = #{params[:deposito_id]} ORDER BY ID DESC LIMIT 1),0) AS CUSTO_PRODUTO_GUARANI
				FROM PRODUTOS P
				WHERE #{prod}
				ORDER BY 2"

		find_grade = Stock.find_by_sql(sql)

		grade = find_grade.first

		return render :json => { :produto => grade }
	end


	def busca_empaque_produto
		barra   = ProdutoBarra.find_by_barra(params[:cod])
				sql = "
				SELECT PG.ID AS PRODUTOS_GRADE_ID,
							 P.ID AS PRODUTO_ID,
							 P.NOME AS NOME,
							 P.SUB_GRUPO_ID AS SUB_GRUPO_ID,
							 PG.COR_ID AS COR_ID,
							 C.NOME AS COR_NOME,
							 P.FABRICANTE_COD,
							 PG.TAMANHO_ID AS TAMANHO_ID,
							 T.NOME AS TAMANHO_NOME
				FROM PRODUTOS_GRADES PG
				LEFT JOIN PRODUTOS P
				ON PG.PRODUTO_ID = P.ID
				LEFT JOIN CORS C
				ON PG.COR_ID = C.ID
				LEFT JOIN TAMANHOS T
				ON PG.TAMANHO_ID = T.ID
				INNER JOIN VENDAS_PRODUTOS VP
				ON VP.PRODUTOS_GRADE_ID = PG.ID
				WHERE  VP.VENDA_ID = #{params[:venda_id]} AND PG.ID = #{barra.produtos_grade_id}
				LIMIT 1"
				find_grade = ProdutosGrade.find_by_sql(sql)

				grade = find_grade.first

				return render :json => { :produto => grade }
	end

	def busca_bico

		bico = Bico.find_by_id(params[:cod])

		sql = "SELECT P.ID AS PRODUTO_ID,
									 P.NOME AS PRODUTO_NOME,
									 B.DEPOSITO_ID,
									 B.PRECO_US,
									 B.PRECO_GS,
									 B.PRECO_RS,
									 B.PRECO_02_US,
									 B.PRECO_02_GS,
									 B.PRECO_02_RS
						FROM BICOS B
						INNER JOIN DEPOSITOS D
						ON D.ID = B.DEPOSITO_ID

						LEFT JOIN PRODUTOS P
						ON D.PRODUTO_ID = P.ID

						WHERE B.ID = #{params[:cod]}"
			find_grade = Produto.find_by_sql(sql)
			grade = find_grade.first

			return render :json => { :produto => grade }
	end

	def busca_produto_por_tabela_preco

		sql = "SELECT
									P.ID,
									P.NOME,
									P.TAXA,
									PT.TABELA_PRECO_ID,
									PT.PRECO_1_US ,
									PT.PRECO_1_GS,
									PT.PRECO_1_RS,
									COALESCE((SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.DEPOSITO_ID = #{params[:deposito]} AND S.PRODUTO_ID = PT.PRODUTO_ID AND DATA <= '#{params[:data]}' ),0) AS STOCK
						FROM PRODUTOS_TABELA_PRECOS PT
						LEFT JOIN PRODUTOS P
						ON P.ID = PT.PRODUTO_ID
						WHERE PT.UNIDADE_ID = #{params[:unidade]} AND PT.TABELA_PRECO_ID = #{params[:tabela_preco]}
						AND P.NOME ILIKE '%#{params[:busca]}%'"
		produtos = Produto.find_by_sql(sql)
		respond_to do |format|
			format.json  { list = produtos.map {|u| Hash[ id: u.id, label: u.nome, taxa: u.taxa, preco_1_us: u.preco_1_us, preco_1_gs: u.preco_1_gs, preco_1_rs: u.preco_1_rs, stock: u.stock]}
				render json: list }
		end
	end
end
