class ComprasController < ApplicationController
	before_filter :authenticate

	def add_produtos_cadastro
		@compra = Compra.find(params[:id])
		prods = Produto.where(doc: @compra.documento_numero )
		prods.each do |pp|
			ComprasProduto.create(  compra_id:                 @compra.id,
															data:                      @compra.data,
															moeda:                     @compra.moeda,
															tipo_compra:               0,
															deposito_id:               1,
															produto_id:                pp.id,
															produto_nome:              pp.nome,
															persona_id:                @compra.persona_id,
															persona_nome:              @compra.persona_nome,
															quantidade:                1,
															custo_guarani:             pp.custo_base_gs.to_f,
															promedio_guarani:          pp.custo_base_gs.to_f,
															unitario_guarani:          pp.custo_base_gs.to_f,
															total_guarani:             pp.custo_base_gs.to_f,
													)
			end

			redirect_to("/compras/" << params[:id].to_s)
	end

	def add_prod_import
		@compra = Compra.find(params[:compra_id])
		compra_import = FaturaImportProduto.where(fatura_import_id: params[:busca]["impor"])
		compra_import.each do |pp|

			pd = Produto.where("fabricante_cod = '#{pp.dcodint}' and nome = '#{pp.ddesproser} TM #{pp.tamanho}'").last
			ComprasProduto.create(  compra_id:                 @compra.id,
															data:                      @compra.data,
															moeda:                     @compra.moeda,
															tipo_compra:               0,
															deposito_id:               1,
															produto_id:                pd.id,
															produto_nome:              pd.nome,
															persona_id:                @compra.persona_id,
															persona_nome:              @compra.persona_nome,
															quantidade:                pp.dcantproser.to_f,
															custo_guarani:             pp.dtotopeitem.to_f,
															promedio_guarani:          pp.dtotopeitem.to_f,
															unitario_guarani:          pp.dtotopeitem.to_f,
															total_guarani:             pp.dtotopeitem.to_f * pp.dcantproser.to_f,
													)
			end

			redirect_to("/compras/" << params[:compra_id].to_s)
	end

	def lista_viaticos

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

            WHERE C.UNIDADE_ID = #{current_unidade.id} AND C.PERSONA_ID = #{params[:persona_id]} AND C.LIQUIDACAO = 0 AND (C.DIVIDA_GUARANI + C.DIVIDA_DOLAR + C.DIVIDA_REAL ) > 0
            ORDER BY 12,16
                      "

		@viaticos = Cliente.find_by_sql(sql)
		render layout: false
	end

	def valida_processo

		@compra = Compra.find(params[:id])
		@compra.update_attributes(op: true)

		if  @compra.tipo_compra == 1
			redirect_to "/compras/index_gasto"
		elsif  @compra.tipo_compra == 3
			redirect_to "/compras/index_bens"
		else
			redirect_to(compras_url)
		end
	end

	def etiquetas
		@compra = Compra.find(params[:id])
		@compras_produtos = ComprasEmpaque.where("compra_id = #{params[:id]}").order('id')
		render layout: false
	end

	def adicionar_codigo
		@compra = Compra.find(params[:id])
	end

		def agregar_produtos
			ComprasProduto.destroy_all("compra_id = #{params[:compra_id]}" )
			cod = params[:codigo].to_s.gsub('#{params[:compra_id]}', params[:compra_id]).gsub('#{params[:deposito_id]}', params[:deposito_id]).gsub('#{params[:data]}', params[:data]).gsub('#{params[:cotacao]}', params[:cotacao]).gsub('#{params[:moeda]}', params[:moeda])
			conn = ActiveRecord::Base.connection
			conn.execute "#{cod}"

			cp = ComprasProduto.where("compra_id = #{params[:compra_id]}" )
			cp.each do |c|
				c.update_attribute :unidade_id, current_unidade.id
			end

			redirect_to("/compras/"<< params[:compra_id].to_s)
		end

	def pedidos
			@compra = Compra.find(params[:id])
			sql = "SELECT PC.ID,
										PC.DATA,
										PC.SUB_GRUPO_ID,
										PC.MOEDA
							FROM PEDIDO_COMPRAS PC
							WHERE (SELECT COUNT(CP.ID) FROM COMPRAS_PEDIDOS CP WHERE CP.PEDIDO_COMPRA_ID = PC.ID AND CP.COMPRA_ID = #{@compra.id}) = 0
							AND PC.PERSONA_ID = #{@compra.persona_id}
							ORDER BY 2 DESC
										"
			@pedidos_pendentes = PedidoCompra.find_by_sql(sql)
			@pedidos_faturas   = ComprasPedido.where("compra_id = #{@compra.id}")
	end



	def add_pedidos
			@compra = Compra.find(params[:id])

			@insert_lanz = PedidoCompra.find(params[:lanz_ids])

			@insert_lanz.each do |il|
			 @cp = ComprasPedido.create(  :compra_id         => @compra.id,
															:pedido_compra_id => il.id
														)
			end

			#add produtos do pedido na compra
			@pedido_produtos   = PedidoCompraProduto.where("pedido_compra_id in (#{@insert_lanz.map  { |t| t.id }.join(',')})").order('id')
			@pedido_produtos.each do |pp|
				ComprasProduto.create(  compra_id:                 @compra.id,
																data:                      @compra.data,
																moeda:                     @compra.moeda,
																pedido_compra_id:          pp.pedido_compra_id,
																compras_pedido_id:          @cp.id,
																pedido_compra_produto_id:  pp.id,
																deposito_id:               params[:busca]["deposito"],
																produto_id:                pp.produto_id,
																peso_bruto:                pp.produto.peso_bruto,
																quantidade:                pp.quantidade.to_f,
																custo_dolar:               pp.unitario_dolar.to_f,
																custo_guarani:             pp.unitario_guarani.to_f,
																custo_real:                pp.unitario_real.to_f,
																unitario_dolar:            pp.unitario_dolar.to_f,
																unitario_guarani:          pp.unitario_guarani.to_f,
																unitario_real:             pp.unitario_real.to_f,
																total_dolar:               pp.total_dolar.to_f,
																total_guarani:             pp.total_guarani.to_f,
																total_real:                pp.total_real.to_f
														)
			end

			redirect_to("/compras/#{@compra.id}")
	end

	def compras_produto

			@compra  = Compra.find(params[:id])
			@produto = ComprasProduto.find(:all,:conditions => ['compra_id = ?',params[:id]] )
			@produto_count       = ComprasProduto.count(:all,:conditions => ['compra_id = ?',params[:id]] )
			@produto_sum_dolar   = ComprasProduto.sum(:total_dolar,:conditions => ['compra_id = ?',params[:id]] )
			@produto_sum_guarani = ComprasProduto.sum(:total_guarani,:conditions => ['compra_id = ?',params[:id]] )

			render :layout=>false


	end

	def prorateo
		@compra          = Compra.find(params[:id])
		@compras_produto = ComprasProduto.all(:conditions => ['compra_id  =  ?',params[:id] ],:order => 1 )

		@compras_documento = ComprasDocumento.all( :conditions => ["compra_id  =  ?",params[:id] ] )

		respond_to do |format|
				format.html # show.html.erb
		end
	end

	def compras_financa
		@compra = Compra.find(params[:id])
		@prov_produtos  = ComprasFinanca.where(compra_id: @compra.id).order('cota')
		@fts = FormFiscal.where("sigla_proc = 'CP' AND cod_proc = #{@compra.id} AND STATUS != 0").select("cdc, tipo_emissao, ruc, persona_nome, id,impressao, cod_proc, tot_gs, doc_01, doc_02, doc, status, autorizacao").order('id desc ')
		if @compra.tipo_rateio == 0
			@sum_dolar   = ( ( @compra.total_dolar.to_f - @compra.retencao_us.to_f) - @compra.desconto_dolar.to_f) - ComprasFinanca.sum(:valor_dolar, :conditions => ['compra_id = ?',params[:id]] ).to_f
			@sum_guarani = ( ( @compra.total_guarani.to_f - @compra.retencao_gs.to_f) - @compra.desconto_guarani.to_f) - ComprasFinanca.sum(:valor_guarani, :conditions => ['compra_id = ?',params[:id]] )
			@sum_real    = ( ( @compra.total_real.to_f) - @compra.desconto_real.to_f) - ComprasFinanca.sum(:valor_real, :conditions => ['compra_id = ?',params[:id]] ).to_f
			@sum_euro    = (@compra.total_euro.to_f) - ComprasFinanca.sum(:valor_euro, :conditions => ['compra_id = ?',params[:id]] ).to_f
		else
			@sum_dolar   = ( (( @compra.total_dolar.to_f - @compra.retencao_us.to_f) + @compra.frete_dolar.to_f + @compra.outros_dolar.to_f) - @compra.desconto_dolar.to_f) - ComprasFinanca.sum(:valor_dolar, :conditions => ['compra_id = ?',params[:id]] ).to_f
			@sum_guarani = ( (( @compra.total_guarani.to_f - @compra.retencao_gs.to_f) + @compra.frete_guarani.to_f + @compra.outros_guarani.to_f) - @compra.desconto_guarani.to_f) - ComprasFinanca.sum(:valor_guarani, :conditions => ['compra_id = ?',params[:id]] )
			@sum_real    = ( (( @compra.total_real.to_f) - @compra.desconto_real.to_f) + @compra.frete_real.to_f + @compra.outros_real.to_f ) - ComprasFinanca.sum(:valor_real, :conditions => ['compra_id = ?',params[:id]] ).to_f
			@sum_euro    = (@compra.total_euro.to_f) - ComprasFinanca.sum(:valor_euro, :conditions => ['compra_id = ?',params[:id]] ).to_f
		end

		if session[:modal] == 'true'
			render layout: 'modal'
		end

		render layout: 'chart'

	end

	def compras_custos
		@compra = Compra.find(params[:id])
		@compra_custos = ComprasCusto.where(compra_id: @compra.id)
		@saldo_us = ( ( ( @compra.total_dolar.to_f) - @compra.desconto_dolar.to_f) - @compra.compras_custos.sum(:valor_us).to_f )
		@saldo_gs = ( ( ( @compra.total_guarani.to_f) - @compra.desconto_guarani.to_f) - @compra.compras_custos.sum(:valor_gs).to_f )
		@saldo_rs = ( ( ( @compra.total_real.to_f)) - @compra.compras_custos.sum(:valor_rs).to_f )
		if session[:modal] == 'true'
			render layout: 'modal'
		end

	end

	def compras_documento
		@compra = Compra.find(params[:id])
		@count_produtos               = ComprasProduto.count( :id, :conditions => ['compra_id = ?', params[:id]])
		@sum_produtos_dolar           = ComprasProduto.sum( :total_dolar, :conditions => ['compra_id = ?', params[:id]])
		@sum_produtos_guarani         = ComprasProduto.sum( :total_guarani, :conditions => ['compra_id = ?', params[:id]])
		@sum_desconto_dolar           = ComprasProduto.sum( :desconto_dolar, :conditions => ['compra_id = ?', params[:id]])
		@sum_desconto_guarani         = ComprasProduto.sum( :desconto_guarani, :conditions => ['compra_id = ?', params[:id]])

		@total_dolar                  = @sum_produtos_dolar - @sum_desconto_dolar
		@total_guarani                = @sum_produtos_guarani - @sum_desconto_guarani
	end

	def compras_gasto
			@compra = Compra.find(params[:id])
			@count_produtos               = ComprasProduto.count( :id, :conditions => ['compra_id = ?', params[:id]])
			@sum_produtos_dolar           = ComprasProduto.sum( :total_dolar, :conditions => ['compra_id = ?', params[:id]])
			@sum_produtos_guarani         = ComprasProduto.sum( :total_guarani, :conditions => ['compra_id = ?', params[:id]])
			@sum_desconto_dolar           = ComprasProduto.sum( :desconto_dolar, :conditions => ['compra_id = ?', params[:id]])
			@sum_desconto_guarani         = ComprasProduto.sum( :desconto_guarani, :conditions => ['compra_id = ?', params[:id]])

			@total_dolar                  = @sum_produtos_dolar - @sum_desconto_dolar
			@total_guarani                = @sum_produtos_guarani - @sum_desconto_guarani

	end

	def novo_produto
			@compra = Compra.find(params[:id])
	end

	def novo_financa
			@compra = Compra.find(params[:id])
			@cota_count          = ComprasFinanca.count(:id,:conditions => ['compra_id = ?',params[:id]] )
			@cota_total          = @cota_count +1
			@compras_documento   = ComprasDocumento.find_by_compra_id(params[:id])
			@produto_count       = ComprasProduto.sum(:quantidade,:conditions => ['compra_id = ?',params[:id]] )
			@cp_sum_dolar   = Compra.sum(:total_dolar,:conditions => ['id = ?',params[:id]] )
			@cp_sum_guarani = Compra.sum(:total_guarani,:conditions => ['id = ?',params[:id]] )
			@cp_sum_real    = Compra.sum(:total_real,:conditions => ['id = ?',params[:id]] )
	end

	def gerar_cotas_credito
			@compra = Compra.find(params[:id])
			Compra.gerador_cotas(params)
			redirect_to("/compras/"<< @compra.id.to_s<< '/compras_financa')
	end

    def cheque_terceiros
      @diferido = Financa.all( select: "saida_guarani,cod_proc,sigla_proc,data,diferido,titular,banco,persona_nome,conta_nome,cheque,entrada_dolar,entrada_guarani,id",:conditions => ["CONTA_ID = ? AND MOEDA = ? AND CHEQUE_STATUS IN (1,3)",params[:conta_id],params[:moeda]])
      render :layout => 'consulta'
    end

    def pago_antecipado
    	@compra = Compra.find(params[:id])
    	@pagos = Financa.find_by_sql("SELECT C.DOCUMENTO_NUMERO_01,
					                        C.DOCUMENTO_NUMERO_02,
					                        C.DOCUMENTO_NUMERO,
					                        C.COTA,
					                        SUM(C.DIVIDA_GUARANI) AS DIVIDA_GUARANI,
					                        SUM(C.PAGO_GUARANI) AS PAGO_GUARANI,
					                        SUM(C.DIVIDA_DOLAR) AS DIVIDA_DOLAR,
					                        SUM(C.PAGO_DOLAR) AS PAGO_DOLAR
					                  FROM PROVEEDORES C

					                  WHERE C.LIQUIDACAO = 0
					                  AND FORMA_PAGO_ID = 12
					                  AND C.PERSONA_ID = #{params[:persona_id]}

					                  GROUP BY 1, 2, 3, 4")
	      render :layout => 'consulta'
    end

	def novo_gasto           #
			@compra = Compra.find(params[:id])
			@cota_count          = ComprasFinanca.count(:id,:conditions => ['compra_id = ?',params[:id]] )
			@cota_total          = @cota_count +1
			@compras_documento   = ComprasDocumento.find_by_compra_id(params[:id])
			@produto_count       = ComprasProduto.sum(:quantidade,:conditions => ['compra_id = ?',params[:id]] )
			@produto_sum_dolar   = ComprasProduto.sum(:total_dolar,:conditions => ['compra_id = ?',params[:id]] )
			@produto_sum_guarani = ComprasProduto.sum(:total_guarani,:conditions => ['compra_id = ?',params[:id]] )
	end

	def novo_documento
			@compra = Compra.find(params[:id])
			@produto_sum_dolar   = ComprasProduto.sum(:total_dolar,:conditions => ['compra_id = ?',params[:id]] )
			@produto_sum_guarani = ComprasProduto.sum(:total_guarani,:conditions => ['compra_id = ?',params[:id]] )



	end

	def total_documento
			@compra = Compra.find(params[:id])

			@produto_sum_dolar       = ComprasProduto.sum( :total_dolar,           :conditions => ['compra_id = ?',params[:id]] )
			@produto_sum_guarani     = ComprasProduto.sum( :total_guarani,         :conditions => ['compra_id = ?',params[:id]] )
			@total_dolar_documento   = ComprasDocumento.sum( :total_dolar,         :conditions => ["compra_id = ? AND tipo_documento = 'DESPACHO'",params[:id]] )
			@total_guarani_documento = ComprasDocumento.sum( :total_guarani,       :conditions => ["compra_id = ? AND tipo_documento = 'DESPACHO'",params[:id]] )
			@total_iva_dolar         = ComprasDocumento.sum( :imposto_10_dolar,    :conditions => ["compra_id = ?",params[:id]] )
			@total_iva_guarani       = ComprasDocumento.sum( :imposto_10_guarani,  :conditions => ["compra_id = ?",params[:id]] )
			@total_frete_dolar       = ComprasDocumento.sum( :total_dolar,         :conditions => ["compra_id = ? AND tipo_documento = 'FLETES' ",params[:id]] )
			@total_frete_guarani     = ComprasDocumento.sum( :total_guarani,       :conditions => ["compra_id = ? AND tipo_documento = 'FLETES' ",params[:id]] )
			@total_seguro_dolar      = ComprasDocumento.sum( :total_dolar,         :conditions => ["compra_id = ? AND tipo_documento = 'SEGUROS' ",params[:id]] )
			@total_seguro_guarani    = ComprasDocumento.sum( :total_guarani,       :conditions => ["compra_id = ? AND tipo_documento = 'SEGUROS' ",params[:id]] )
			@total_outros_dolar      = ComprasDocumento.sum( :total_dolar,         :conditions => ["compra_id = ? AND tipo_documento = 'OUTROS' ",params[:id]] )
			@total_outros_guarani    = ComprasDocumento.sum( :total_guarani,       :conditions => ["compra_id = ? AND tipo_documento = 'OUTROS' ",params[:id]] )

			@total_invoice_dolar     = ComprasDocumento.sum( :total_dolar,         :conditions => ["compra_id = ? AND tipo_documento = 'MERCADERIAS' ",params[:id]] )
			@total_invoice_guarani   = ComprasDocumento.sum( :total_guarani,       :conditions => ["compra_id = ? AND tipo_documento = 'MERCADERIAS' ",params[:id]] )
			@total_despacho_us          = ComprasDocumento.sum( :total_dolar,         :conditions => ["compra_id = ? AND tipo_documento = 'DESPACHO' ",params[:id]] )
			@total_despacho_gs          = ComprasDocumento.sum( :total_guarani,       :conditions => ["compra_id = ? AND tipo_documento = 'DESPACHO' ",params[:id]] )

			session[:proraterio] = "PRORATEIO"

	end


	def comprovante
			@compra                       = Compra.find(params[:id])
			@produtos                     = ComprasProduto.all(:conditions => ['compra_id = ?', params[:id]], :order => "fabricante_cod")
			@count_produtos               = ComprasProduto.count( :quantidade, :conditions => ['compra_id = ?', params[:id]])
			@sum_produtos_dolar           = ComprasProduto.sum( :total_dolar, :conditions => ['compra_id = ?', params[:id]])
			@sum_produtos_guarani         = ComprasProduto.sum( :total_guarani, :conditions => ['compra_id = ?', params[:id]])
			@sum_desconto_dolar           = ComprasProduto.sum( :desconto_dolar, :conditions => ['compra_id = ?', params[:id]])
			@sum_desconto_guarani         = ComprasProduto.sum( :desconto_guarani, :conditions => ['compra_id = ?', params[:id]])
			@condicoes                    = ComprasFinanca.all(:conditions => ['compra_id = ?', params[:id]], :order => "cota")

			@total_dolar                  = @sum_produtos_dolar - @sum_desconto_dolar
			@total_guarani                = @sum_produtos_guarani - @sum_desconto_guarani


			respond_to do |format|
		format.html do
			render  :pdf                    => "comprovante",
							:layout                 => "layer_relatorios",
							:margin => {:top        => '0.20in',
													:bottom     => '0.25in',
													:left       => '0.10in',
													:right      => '0.10in'},
							:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
													:font_size  => 7,
													:left       => '',
													:spacing    => 5},
							:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
													:font_size  => 7,
													:right      => "Pagina [page] de [toPage]",
													:left       => "Chronos Software - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
		end
		end
	end

	def comprovante_xls
		@compra                       = Compra.find(params[:id])
		@produtos                     = ComprasProduto.all(:conditions => ['compra_id = ?', params[:id]], :order => "fabricante_cod")
		@count_produtos               = ComprasProduto.count( :quantidade, :conditions => ['compra_id = ?', params[:id]])
		@sum_produtos_dolar           = ComprasProduto.sum( :total_dolar, :conditions => ['compra_id = ?', params[:id]])
		@sum_produtos_guarani         = ComprasProduto.sum( :total_guarani, :conditions => ['compra_id = ?', params[:id]])
		@sum_desconto_dolar           = ComprasProduto.sum( :desconto_dolar, :conditions => ['compra_id = ?', params[:id]])
		@sum_desconto_guarani         = ComprasProduto.sum( :desconto_guarani, :conditions => ['compra_id = ?', params[:id]])
		@condicoes                    = ComprasFinanca.all(:conditions => ['compra_id = ?', params[:id]], :order => "cota")

		@total_dolar                  = @sum_produtos_dolar - @sum_desconto_dolar
		@total_guarani                = @sum_produtos_guarani - @sum_desconto_guarani

		respond_to do |format|
			format.xls
		end
	end

	def index_gasto

		doc = Compra.select('id').last
		if doc == nil
			@last_doc = 1
		else
			@last_doc = doc.id.to_i + 1
		end

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @compras }
		end
	end

	def busca_gasto
		params[:unidade] = current_unidade.id

		params[:usuario_tipo] = current_user.tipo
		params[:usuario_id] = current_user.id
		@compras = Compra.filtro_busca_gasto(params)
		render :layout => false
	end

	def new_gasto
		@compra = Compra.new

		if params[:prov_gasto] == 'true'
			render layout: 'modal'
			session[:modal] = 'true'
		else
			session[:modal] = 'false'
		end

		doc = Compra.select('id').last
		if doc == nil
			@last_doc = 1
		else
			@last_doc = doc.id
		end
	end

	def edit_gasto
		@compra  = Compra.find(params[:id])
		if params[:prov_gasto] == 'true'
			render layout: 'modal'
			session[:modal] = 'true'
		else
			session[:modal] = 'false'
		end
	end

	def index_bens
		@compras = Compra.all(:conditions => ['tipo_compra = 1'])
		respond_to do |format|
				format.html # index.html.erb
				format.xml  { render :xml => @compras }
		end
	end

	def busca_bens
		params[:unidade] = current_unidade.id
		@compras = Compra.filtro_bens_gasto(params)
		render :layout => false
	end

	def new_bens
		@compra = Compra.new
		respond_to do |format|
				format.html # new.html.erb
				format.xml  { render :xml => @compra }
		end
	end

	def edit_bens
		@compra  = Compra.find(params[:id])
		session[:proraterio] = ""
	end

	def index
		respond_to do |format|
			format.html
		end
	end

	def busca
		params[:unidade] = current_unidade.id
		@compras = Compra.filtro_busca_compra(params)
		render :layout => false
	end

	def show
		@compra = Compra.find(params[:id])
		sql = "SELECT C.ID,
										C.COMPRA_ID,
										C.DEPOSITO_NOME,
										C.PRODUTO_NOME,
										C.QUANTIDADE,
										C.UNITARIO_DOLAR,
										C.UNITARIO_GUARANI,
										C.UNITARIO_REAL,
										C.UNITARIO_EURO,
										C.TOTAL_DOLAR,
										C.TOTAL_GUARANI,
										C.TOTAL_REAL,
										C.TOTAL_EURO,
										C.CUSTO_DOLAR,
										C.CUSTO_GUARANI,
										C.CUSTO_REAL,
										C.CUSTO_EURO,
										C.DESCONTO_GUARANI,
										C.DESCONTO_REAL,
										C.DESCONTO_DOLAR,
										C.PRODUTO_ID,
										C.DEPOSITO_ID,
										C.MOEDA,
										C.VALOR_REAL_BEN_US,
										C.VALOR_REAL_BEN_GS,
										C.ANOS,
										C.DESPACHO_EURO,
										C.FRETE_EURO,
										C.SEGURO_EURO,
										C.OUTROS_EURO,
										C.DESPACHO_DOLAR,
										C.FRETE_DOLAR,
										C.SEGURO_DOLAR,
										C.OUTROS_DOLAR,
										C.porcen,
										C.FRETE_GUARANI,
										C.OUTROS_GUARANI,
										C.FRETE_REAL,
										C.SEGURO_REAL,
										C.DESPACHO_REAL,
										C.OUTROS_REAL,
										C.PROMEDIO_GUARANI,
										C.PROMEDIO_DOLAR,
										(SELECT P.PRECO_1_GS FROM PRODUTOS_TABELA_PRECOS P WHERE P.PRODUTO_ID = C.PRODUTO_ID AND  P.UNIDADE_ID = #{current_unidade.id} ORDER BY P.ID LIMIT 1) AS PRECO_VENDA_GS,
										(SELECT P.PRECO_1_US FROM PRODUTOS_TABELA_PRECOS P WHERE P.PRODUTO_ID = C.PRODUTO_ID AND  P.UNIDADE_ID = #{current_unidade.id} ORDER BY P.ID LIMIT 1) AS PRECO_VENDA_US,
										(SELECT P.PRECO_1_RS FROM PRODUTOS_TABELA_PRECOS P WHERE P.PRODUTO_ID = C.PRODUTO_ID AND  P.UNIDADE_ID = #{current_unidade.id} ORDER BY P.ID LIMIT 1) AS PRECO_VENDA_RS

					FROM COMPRAS_PRODUTOS C
					LEFT JOIN PRODUTOS P
					ON P.ID = C.PRODUTO_ID
					WHERE C.COMPRA_ID = #{@compra.id}
					ORDER BY C.ID DESC"


		@compras_produto = ComprasProduto.find_by_sql(sql)

		if @compra.pedido == 1
			sql = "SELECT PC.ID,
											PC.DATA,
											PC.SUB_GRUPO_ID,
											PC.MOEDA
								FROM PEDIDO_COMPRAS PC
								WHERE (SELECT COUNT(CP.ID) FROM COMPRAS_PEDIDOS CP WHERE CP.PEDIDO_COMPRA_ID = PC.ID AND CP.COMPRA_ID = #{@compra.id}) = 0
								AND PC.PERSONA_ID = #{@compra.persona_id}
								ORDER BY 2 DESC
											"
			@pedidos_pendentes = PedidoCompra.find_by_sql(sql)
			@pedidos_faturas   = ComprasPedido.where("compra_id = #{@compra.id}")
		end

		render layout: 'chart'
	end

	def new
		@compra = Compra.new
		doc = Compra.select('id').last
		if doc == nil
			@last_doc = 1
		else
			@last_doc = doc.id
		end
	end

	def edit
		@compra  = Compra.find(params[:id])
	end

	def create
		@compra = Compra.new(params[:compra])
		#USUARIO UNIDADE
		@compra.usuario_created = current_user.id
		@compra.unidade_created = current_unidade.id
		@compra.unidade_id = current_unidade.id.to_i

		respond_to do |format|
			if @compra.save

				#compra produto e bens
				if @compra.tipo_compra == 0 || @compra.tipo_compra == 3
						format.html { redirect_to(@compra) }
				elsif @compra.tipo_compra == 2
					format.html { redirect_to(@compra) }
				else
					#gasto
					if Empresa.last.gasto_detalhado == false
						Compra.modal_gasto(@compra) if params[:modelo_form] == "modalv2"
						format.html { redirect_to(index_gasto_compras_url) }
					else
						format.html { redirect_to "/compras/#{@compra.id}/compras_custos" }
					end

				end
			else
				if @compra.tipo_compra == 0 || @compra.tipo_compra == 3 || @compra.tipo_compra == 2
						format.html { render :action => "new" }
				elsif @compra.tipo_compra == 3
					format.html { render :action => "new_bens" }
				elsif @compra.tipo_compra == 1
						format.html { render :action => "new_gasto" }
				end
			end
		end
	end

	def update
		@compra = Compra.find(params[:id])
		#USUARIO UNIDADE
		@compra.usuario_updated = current_user.id
		@compra.unidade_updated = current_unidade.id

		respond_to do |format|

				if @compra.update_attributes(params[:compra])
						if session[:proraterio] == "PRORATEIO"
								format.html { redirect_to "/compras/#{@compra.id}/prorateo" }
						end
						#compra produto e bens
						if @compra.tipo_compra == 0 || @compra.tipo_compra == 3
								format.html { redirect_to(@compra) }
						elsif @compra.tipo_compra == 2
							format.html { redirect_to(@compra) }
						else
							#gasto
							format.html { redirect_to "/compras/#{@compra.id}/compras_custos" }
						end
				else
						if @compra.tipo_compra == 0 || @compra.tipo_compra == 3 || @compra.tipo_compra == 2
							format.html { render :action => "new" }
						elsif @compra.tipo_compra == 3
							format.html { render :action => "new_bens" }
						elsif @compra.tipo_compra == 1
							format.html { render :action => "new_gasto" }
						end
				end
		end
	end

	def destroy              #
		@compra = Compra.find(params[:id])
		@compra.destroy

		respond_to do |format|
				if  @compra.tipo_compra == 1
						format.html { redirect_to "/compras/index_gasto" }
						format.xml  { head :ok }
				else
						format.html { redirect_to(compras_url) }
						format.xml  { head :ok }
				end
		end
	end

	def dynamic_compra_colecao
		@personas = Colecao.find_all_by_sub_grupo_id(params[:id])
		respond_to do |format|
			format.js
		end
	end

	def dynamic_rubro_grupo
		plano = PlanoDeConta.find_by_id(params[:id])
		@rubros = Rubro.where("codigo like '#{plano.codigo}%' ")
		respond_to do |format|
			format.json { render json: @rubros}
		end
	end

	def dynamic_centro_custo
		@rubros = CentroCusto.find_all_by_unidade_id(params[:id])
		respond_to do |format|
			format.js
		end
	end
end

