class PersonasController < ApplicationController
	before_filter :authenticate

	def envia_login_app
		@persona = Persona.find(params[:id])
		PersonaLogin.mensagem_login(@persona).deliver
		
		redirect_to(persona_path(@persona))
	end

	def resultado_listado_aluno
        head =
        "                                                                                                                 #{current_unidade.nome_sys}
                                                                                                               Listado Alunos


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Codigo        Turma                               Aluno                                                            Responsable                               
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        "
		turma = "AND P.TURMA_ID = #{params[:busca]["turma"]}" unless params[:busca]["turma"].blank?
		per   = "AND P.PERSONA_ID = #{params[:persona_id]}" unless params[:persona_id].blank?
		sql = "SELECT P.ID,
								  P.NOME,
								  T.NOME AS TURMA_NOME,
								  R.NOME AS RESPONSAVEL_NOME	

							FROM PERSONAS P

							LEFT JOIN TURMAS T
							ON T.ID = P.TURMA_ID

							LEFT JOIN PERSONAS R
							ON R.ID = P.vend_responsavel_id

							WHERE P.TIPO_ALUNO = 1 AND P.UNIDADE_ID = #{current_unidade.id} #{turma} #{per}

							ORDER BY 3,2"
		@personas = Persona.find_by_sql(sql)							

		respond_to do |format|

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

	def comprovante_vacacciones
		@persona = Persona.find(params[:id])

		respond_to do |format|

			format.html do
				render  :pdf                    => "print_funcionario",
								:layout                 => "layer_relatorios",
								:margin => {:top        => '0.15in',
														:bottom     => '0.25in',
														:left       => '0.10in',
														:right      => '0.10in'},
								:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:spacing    => 10},
								:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:right      => "Pagina [page] de [toPage]",
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end
	end

	def historico_vendas
    @persona = Persona.find(params[:id])
    render layout: 'consulta'
  end

	def busca_historico_vendas
		@persona = Persona.find(params[:id])
    unless params[:inicio].blank?
      data =  "AND S.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'" unless params[:inicio].blank?
    end

      if [:tipo] == "TODOS"
        todos = ""
      elsif params[:tipo] == "VENDEDOR"
        vendedor_nome = "AND  VD.NOME ILIKE '%#{params[:busca]}%'"
      elsif params[:tipo] == "PRODUTO"
        produto = "AND S.PRODUTO_NOME ILIKE '%#{params[:busca]}%'"
      end

    sql = "SELECT S.DATA,
            S.COD_PROCESSO,
            S.SIGLA_PROC,
            C.DESCRICAO AS CLASE_NOME,
            S.PRODUTO_NOME AS PRODUTO_NOME,
            S.PRODUTO_ID,
            S.ENTRADA,
            S.SAIDA,
            S.UNITARIO_GUARANI,
            (V.DESCONTO + VP.desconto) AS DESCONTO,
            VD.NOME AS VENDEDOR_NOME

        FROM STOCKS S
        INNER JOIN PRODUTOS P
          ON P.ID = S.PRODUTO_ID
        LEFT JOIN VENDAS V
          ON S.VENDA_ID = V.ID
        LEFT OUTER JOIN PERSONAS VD
          ON VD.ID = V.VENDEDOR_ID

        LEFT JOIN CLASES C
          ON C.ID = P.CLASE_ID
        LEFT JOIN VENDAS_PRODUTOS VP
          ON S.TABELA_ID = VP.ID AND S.TABELA = 'VENDAS_PRODUTOS'


        WHERE
          S.PERSONA_ID = #{@persona.id}
          AND to_tsvector(upper((P.NOME)) ) @@ to_tsquery(upper('#{params[:busca].gsub(/\s/,'&')}:*'))
          #{data}

        ORDER BY S.DATA DESC, S.ID LIMIT 50"

    @historico_compras = Persona.find_by_sql(sql)
    render layout: false
  end

	def print_funcionario
		@persona = Persona.find(params[:id])

		respond_to do |format|

			format.html do
				render  :pdf                    => "print_funcionario",
								:layout                 => "layer_relatorios",
								:margin => {:top        => '0.15in',
														:bottom     => '0.25in',
														:left       => '0.10in',
														:right      => '0.10in'},
								:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:spacing    => 10},
								:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
														:font_size  => 7,
														:right      => "Pagina [page] de [toPage]",
														:left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
			end
		end
	end

	def decla_jurada
		@persona = Persona.find(params[:id])
		render layout: 'chart'
	end

	def new_funcionario
		@persona = Persona.new
		render layout: 'chart'
	end

	def show_funcionario
		@persona = Persona.find(params[:id])
		render layout: 'chart'
	end

	def edit_funcionario
		@persona = Persona.find(params[:id])
		render layout: 'chart'
	end

	def index_funcionario
			@personas = Persona.paginate( select: ' id,estado,unidade_id,setor,data_entrada,cargo_id, nome, nome_fatura, limite_credito, classificacao, ruc, direcao, cidade_id, cidade, bairro',
					:conditions => ["tipo_funcionario = 1"], :page => params[:page], :per_page   => 100, :order => "unidade_id, estado,nome")
	end

	def visao_geral_cliente
		@persona = Persona.find(params[:id])
		@cliente_saldo = Cliente.sum('divida_guarani - cobro_guarani',:conditions => ["liquidacao = 0 and persona_id = ?",@persona.id])
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
											C.COTA,
											C.DIVIDA_DOLAR,
											C.DIVIDA_GUARANI,
											C.DIVIDA_REAL,
											C.COBRO_DOLAR,
											C.COBRO_GUARANI,
											C.COBRO_REAL,
											C.DESCRICAO,
											C.VENDA_ID,
											C.DOCUMENTO_NUMERO_01 || '-' || C.documento_numero_02 || '-' || C.DOCUMENTO_NUMERO as doc,
											U.UNIDADE_NOME,
											V.COTACAO AS COTACAO_VENDA,
											(SELECT SUM(AT.COBRO_DOLAR) FROM CLIENTES AT WHERE AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_US,
											(SELECT SUM(AT.COBRO_GUARANI) FROM CLIENTES AT WHERE AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_GS
						FROM CLIENTES C
						LEFT JOIN VENDAS V
						ON C.VENDA_ID = V.ID
						LEFT JOIN UNIDADES U
						ON C.UNIDADE_ID = U.ID
						WHERE C.PERSONA_ID = #{@persona.id} AND C.LIQUIDACAO = 0 AND (C.DIVIDA_GUARANI + C.DIVIDA_DOLAR + c.DIVIDA_REAL ) > 0
						ORDER BY 11,15
											"
		@cliente  = Cliente.find_by_sql(sql)
		render :layout => 'consulta'
	end


	def consulta_cliente
		render :layout => 'consulta'
	end


	def busca_consulta_cliente

			@personas = Persona.paginate( :select     => ' id,
																									 nome,
																									 nome_fatura,
																									 limite_credito,
																									 classificacao,
																									 ruc,
																									 direcao,
																									 cidade_id,
																									 cidade,
																									 bairro
					',
					:conditions => ["tipo_cliente = 1 and nome ILIKE ? OR NOME_FATURA ILIKE ? OR RUC ILIKE ?", "%#{params[:busca]}%", "%#{params[:busca]}%", "%#{params[:busca]}%"],
					:page       => params[:page],
					:per_page   => 100,
					:order      => "nome"
			)

			render :layout => false

	end


	def update_multiple
		Persona.update(params[:personas].keys, params[:personas].values)
	 redirect_to(:back)
		flash[:notice] = "Datos Actulizados!"
	end

	def resultado_busca_detalhada
			persona = "tipo_fornecedor = 1"    if params[:per] == "PROVEEDOR"
			persona = "tipo_cliente = 1"       if params[:per] == "CLIENTE"
			persona = "tipo_fabricante = 1"    if params[:per] == "FABRICANTE"
			persona = "tipo_intermediario = 1" if params[:per] == "CORPORATIVO"
			persona = "tipo_laboratorio = 1"   if params[:per] == "LABORATORIO"
			persona = "tipo_vendedor = 1"      if params[:per] == "VENDEDOR"
			persona = "tipo_funcionario = 1"   if params[:per] == "EMPLEADO"
			persona = "tipo_maiorista = 1"     if params[:per] == "MAYORISTA"
			persona = "tipo_despachante = 1"   if params[:per] == "DESPACHANTE"
			persona = ""   if params[:persona] == ""

			@personas = Persona.all(
					:conditions => ["#{persona}", "%#{params[:busca]}%", "%#{params[:busca]}%"],
					:order => "nome")

	end

	def get_estado                  #
			@cidade =  Cidade.find(:first, :conditions =>  [ "id = ?", params[:persona_cidade_id]])
			return render :text => "<script type='text/javascript'>
														document.getElementById('persona_estado_nome').value       = '#{@cidade.nome.to_s}';
													</script>"
	end

	def persona_compra              #
			render :layout => 'consulta'
	end

	def busca_persona_compra        #

			@personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado',
					:conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
					:page     => params[:page],
					:per_page => 100,
					:order => "nome"
			)

			render :layout => false
	end


	def busca_cliente        #

			tipo = "nome" if params[:tipo] == "DESCRIPCION"
			tipo = "ruc"  if params[:tipo] == "RUC"
			persona = "AND tipo_fornecedor = 1"    if params[:per] == "PROVEEDOR"
			persona = "AND tipo_cliente = 1"       if params[:per] == "CLIENTE"
			persona = "AND tipo_fabricante = 1"    if params[:per] == "FABRICANTE"
			persona = "AND tipo_intermediario = 1" if params[:per] == "CORPORATIVO"
			persona = "AND tipo_laboratorio = 1"   if params[:per] == "LABORATORIO"
			persona = "AND tipo_vendedor = 1"      if params[:per] == "VENDEDOR"
			persona = "AND tipo_funcionario = 1"   if params[:per] == "EMPLEADO"
			persona = "AND tipo_maiorista = 1"     if params[:per] == "MAYORISTA"
			persona = "AND tipo_despachante = 1"   if params[:per] == "DESPACHANTE"
			unidade = "AND unidade_id = #{params[:unidade_id]}"  unless params[:unidade_id].blank?
			persona = ""   if params[:persona] == ""

			@personas = Persona.all(
					:conditions => ["estado = 0 and #{tipo} ILIKE ? #{unidade} #{persona} OR estado = 0 and NOME_FATURA ILIKE ? #{unidade} #{persona}", "%#{params[:busca]}%", "%#{params[:busca]}%"],
					:order => "unidade_id,nome")
			respond_to do |format|
					format.html do
							render  :pdf                    => "resultado_fechamento_caixa",
											:layout                 => "layer_relatorios",
											:orientation                    => 'Landscape',
											:margin => {:top        => '1.20in',
																	:bottom     => '0.25in',
																	:left       => '0.10in',
																	:right      => '0.10in'},
											:header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
																	:font_size  => 7,
																	:spacing    => 25},
											:footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
																	:font_size  => 7,
																	:right      => "Pagina [page] de [toPage]",
																	:left       => "Chronos Smart - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
		end

					format.js { render :layout => false }
			end
	end


	def persona_venda
			render :layout => 'consulta'
	end

	def busca_persona_venda
			filtro = "AND to_tsvector(upper( CAST(NOME AS VARCHAR) || ' ' ||  COALESCE(NOME_FATURA,' ') || ' ' || COALESCE(RUC,' ') || ' ' || COALESCE(TELEFONE,' ')) ) @@ to_tsquery(upper('#{params[:busca].gsub(/\s/,'&')}:*'))" unless params[:busca].blank?
			@personas = Persona.paginate( :select     => 'id,nome,nome_fatura,ruc,estado_id,cidade_id,direcao,residencia_numero,direcao_complemento, telefone',
					:conditions => ["tipo_cliente = 1 #{filtro}", "%#{params[:busca]}%", "%#{params[:busca]}%", "%#{params[:busca]}%", "%#{params[:busca]}%"],
					:page       => params[:page],
					:per_page   => 100,
					:order      => "nome"
			)

			render :layout => false

	end

	def persona_presupuesto         #
			render :layout => 'consulta'
	end

	def busca_persona_presupuesto   #

			@personas = Persona.paginate( :select     => ' id,
																									 nome,
																									 nome_fatura,
																									 classificacao,
																									 ruc,
																									 cliente,
																									 direcao,
																									 cidade_id,
																									 cidade,
																									 bairro
					',
					:conditions => ["tipo_cliente = 1 and nome ILIKE ? OR NOME_FATURA ILIKE ?", "%#{params[:busca]}%", "%#{params[:busca]}%"],
					:page       => params[:page],
					:per_page   => 100,
					:order      => "nome"
			)

			render :layout => false

	end

	def persona_nota_credito        #
			render :layout => 'consulta'
	end

	def busca_persona_nota_credito  #

			@personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado,cidade,cidade_id,direcao',
					:conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
					:page     => params[:page],
					:per_page => 100,
					:order => "nome"
			)

			render :layout => false

	end

	def persona_nota_credito_proveedor        #
			render :layout => 'consulta'
	end

	def busca_persona_nota_credito_proveedor  #

			@personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado,cidade,cidade_id,direcao',
					:conditions => ['nome LIKE ? AND tipo_fornecedor = 100', "%#{params[:busca]}%"],
					:page     => params[:page],
					:per_page => 100,
					:order => "nome"
			)

			render :layout => false

	end

	def persona_venda_financa       #
			render :layout => 'consulta'
	end

	def busca_persona_venda_financa #

			@personas = Persona.paginate(:select => 'id,nome,classificacao,bairro,ruc,tipo,estado,cidade,cidade_id,direcao',
					:conditions => ['tipo_cliente = 1 and nome LIKE ?', "%#{params[:busca]}%"],
					:page     => params[:page],
					:per_page => 100,
					:order => "nome"
			)

			render :layout => false

	end

	def persona_ordem               #
			render :layout => 'consulta'
	end

	def busca_persona_ordem         #

			@personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado',
					:conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
					:page     => params[:page],
					:per_page => 100,
					:order => "nome"
			)

			render :layout => false

	end

	def persona_cobro               #
			render :layout => 'consulta'
	end

	def busca_persona_dividas

		sql = "	SELECT P.ID, P.NOME, C.VENCIMENTO, C.DIVIDA_GUARANI
				FROM CLIENTES C
				INNER JOIN PERSONAS P ON P.ID = C.PERSONA_ID
				WHERE P.NOME LIKE '%#{params[:busca]}%' AND C.VENCIMENTO < NOW() AND LIQUIDACAO = 0"

		@personas = Persona.find_by_sql(sql)

		render :layout => false
	end

	def busca_persona_cobro         #

			@personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado,cod_velho',
					:conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
					:page     => params[:page],
					:per_page => 100,
					:order => "nome"
			)

			render :layout => false

	end

	def persona_pago                #
			render :layout => 'consulta'
	end

	def busca_persona_pago          #

			@personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado',
					:conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
					:page     => params[:page],
					:per_page => 100,
					:order => "nome"
			)

			render :layout => false

	end

	def busca                       #
			tipo = "nome" if params[:tipo] == "DESCRIPCION"
			tipo = "ruc"  if params[:tipo] == "RUC"
			persona = "AND tipo_fornecedor = 1"    if params[:per] == "PROVEEDOR"
			persona = "AND tipo_cliente = 1"       if params[:per] == "CLIENTE"
			persona = "AND tipo_fabricante = 1"    if params[:per] == "FABRICANTE"
			persona = "AND tipo_intermediario = 1" if params[:per] == "CORPORATIVO"
			persona = "AND tipo_laboratorio = 1"   if params[:per] == "LABORATORIO"
			persona = "AND tipo_vendedor = 1"      if params[:per] == "VENDEDOR"
			persona = "AND tipo_funcionario = 1"   if params[:per] == "EMPLEADO"
			persona = "AND tipo_maiorista = 1"     if params[:per] == "MAYORISTA"
			persona = "AND tipo_despachante = 1"   if params[:per] == "DESPACHANTE"
			persona = "AND tipo_aluno = 1"   if params[:per] == "ALUNO"
			persona = ""   if params[:persona] == ""

			if params[:per] == 'TUTOR'
				tp = "AND TIPO_CLIENTE = 1 AND TIPO_ALUNO = 0"
			end

			@personas = Persona.paginate(select: "escolaridade, data_nascimento,id,obs,cod_impl, data, nome, classificacao,ruc,tipo,estado,telefone,telefone2,nome_fatura,tabela_preco_id,estado_id,cidade_id,direcao,residencia_numero,direcao_complemento",
					:conditions => ["unidade_id = #{current_unidade.id} and #{tipo} ILIKE ? #{persona} OR NOME_FATURA ILIKE ? #{persona} #{tp}", "%#{params[:busca]}%", "%#{params[:busca]}%"],
					:page     => params[:page],
					:per_page => 100,
					:order => "nome"
			)
			respond_to do |format|
					format.html {render :layout => false}
					format.js { render :layout => false }
					format.json  { list = @personas.map {|u| Hash[ id: u.id, label: "#{u.nome} #{u.escolaridade}",
						name: u.nome, tabela_preco_id: u.tabela_preco_id, estado_id: u.estado_id, cidade_id: u.cidade_id,
						direcao: u.direcao, residencia_numero: u.residencia_numero, direcao_complemento: u.direcao_complemento, ruc: u.ruc]}
							render json: list }

			end
	end

	#METHOD BASE--------------------------------------------------------------------

	def tarjeta          #

			@persona = Persona.find(params[:id])
			render :layout => false

	end


	def index

	end

	def show
		@persona = Persona.find(params[:id])
    @cliente_saldo = Cliente.sum('divida_guarani - cobro_guarani',:conditions => ["liquidacao = 0 and persona_id = ?",@persona.id])
    @cheque_carteira = Financa.where("contas.tipo = 0 and financas.cheque_status = 1 and financas.persona_id = #{@persona.id}").joins(:conta).sum('financas.entrada_guarani')

		render layout: 'chart'
	end

	def rodados
		@persona = Persona.find(params[:id])
	end

	def folha_de_pagamento
		@persona = Persona.find(params[:id])
	end

	def descontos
		@persona = Persona.find(params[:id])
		render layout: 'iframe'
	end

	def prazos
		@persona = Persona.find(params[:id])
	end

	def local_entregas
		@persona = Persona.find(params[:id])
	end

	def atualiza_ubicacion
		@persona = Persona.find(params[:persona_id])
		@persona.update(coordenadas: params[:coordenadas])
		redirect_to @persona, notice: 'Ubicación guardada con éxito.'
	end

	def contatos
		@persona = Persona.find(params[:id])
	end

	def marcas_relacionadas
		@persona = Persona.find(params[:id])
		@marcas = SubGrupo.where("persona_id = #{@persona.id}")
	end

	def tags
		if params[:tag]
			@persona = Persona.tagged_with(params[:tag])
		else
			@persona = Persona.tagged_with(params[:tag_list])
		end
	end

	def new
		@persona = Persona.new
		render layout: 'chart'
	end

	def edit
		@persona = Persona.find(params[:id])
		@cliente_saldo = Cliente.sum('divida_guarani - cobro_guarani',:conditions => ["liquidacao = 0 and persona_id = ?",@persona.id])
		render layout: 'chart'
	end

	def create
		@persona = Persona.new(params[:persona])

		if params[:tipo_func] != '1'
    	@persona.unidade_id = current_unidade.id.to_i
  	end

    @persona.usuario_created = current_user.id
    @persona.unidade_created = current_unidade.id


		respond_to do |format|
			if @persona.save
					flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
					if params[:tipo_func] == '1'
						format.html { redirect_to(show_funcionario_persona_path(@persona)) }
					else
						format.html { redirect_to(persona_path(@persona)) }
					end
			else
				if params[:tipo_func] == '1'
					format.html { render :action => "new_funcionario" }
				else
					format.html { render :action => "new" }
				end

			end
		end
	end

	def update
			@persona = Persona.find(params[:id])
			@persona.usuario_updated = current_user.usuario_nome
			@persona.unidade_updated = current_unidade.unidade_nome

			respond_to do |format|
					if @persona.update_attributes(params[:persona])
						flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
						if params[:tipo_func] == '1'
								format.html { redirect_to(show_funcionario_persona_path(@persona)) }
						else
								format.html { redirect_to(persona_path(@persona)) }
						end
					else
						if params[:tipo_func] == '1'
							format.html { render :action => "edit_funcionario" }
						else
							format.html { render :action => "edit" }
						end
					end
			end
	end

	def destroy
			@persona = Persona.find(params[:id])
			begin
			@persona.destroy
			flash[:notice] = t('SUCESSFUL_DELETION_MESSAGE')
			rescue ActiveRecord::DeleteRestrictionError => e
				@persona.errors.add(:base, e)
				flash[:error] = "No es possible remover lo cadastro porque elle possui  un vinculo con otro cadastro"
			ensure
				if params[:tipo_func] == '1'
					redirect_to(index_funcionario_personas_url)
				else
					redirect_to(personas_url)
				end
			end
	end


	def dynamic_estados
		@estados = Estado.where("paise_id = #{params[:id]}").select('nome,id').order('nome')
		respond_to do |format|
			format.js
		end
	end


	def dynamic_regioes
		@regioes = Regiao.where("estado_id = #{params[:id]}").select('nome,id').order('nome')
		respond_to do |format|
			format.js
		end
	end

	def dynamic_cidades
		@cidades = Cidade.where("estado_id = #{params[:id]}").select('nome,id').order('nome')
		respond_to do |format|
			format.js
		end
	end
	def dynamic_areas
		@areas = CidadeArea.where("cidade_id = #{params[:id]}").select('nome,id').order('nome')
		respond_to do |format|
			format.js
		end
	end

end
