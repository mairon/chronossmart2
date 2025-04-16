Zetta::Application.routes.draw do

  resources :custom_fields


  resources :fatura_import_produtos


  resources :fatura_imports do
		collection do
			post 'update_individual'
		end
  end


  resources :ordem_entrega_produtos


  resources :ordem_entregas do
  	collection do
  		get 'modal_add'
  		get 'modal_status'
  		get 'modal_endereco'
  		post 'add_produtos'
  		get 'modal_consulta'
  		get 'busca_consulta'
  	end
  end


  resources :turma_responsavels


  resources :turma_personas


  resources :modelo_contratos


  resources :solicitude_credito_autorizacoes


  resources :painel_preparos do
  	collection do
  		get 'status_preparo'
  		get 'preparo_pendentes'
  	end
  end


  resources :lotes


  resources :plano_venda_docs


  resources :transf_produtos do
  	collection do
  		get 'busca'
  	end

  end

  resources :solicitude_creditos do
  	member do
  		get 'comprovante'
  	end
  	collection do
  		get 'gera_venda'
  	end
  end

  resources :produto_imagens

  resources :tipo_tarefas

  namespace :tms do
  	resources :ordem_cargas do
	  	collection do
	  		get 'busca'
	  	end
  	end

  	resources :pedido_traslado_docs

  	resources :pedido_traslados do
	  	collection do
	  		get 'busca'
	  		get 'gera_receber'
	  	end
  	end
  	resources :frota do
	  	collection do
	  		get 'busca_frota'
	  	end
  	end

  	get "/main" => 'main#index'
  end

	namespace :crm do
		get "/main" => 'main#index'

		resources :notas
  	resources :pipeline_usuarios
		resources :negocio_historicos
  	resources :negocio_produtos
  	resources :tarefas
  	resources :negocios do
			collection do
				post 'draggable'
				post 'update_status'
				get 'update_task'
			end
  	end
	  resources :pipelines do
	  	member do
	  		get 'configs'
	  	end

	  end
	  resources :etapas do
	  	collection do
	  		get 'update_order_etapas'
	  	end
	  end
	end


  resources :plano_venda_conds


  resources :plano_vendas do
  	collection do
  		post 'update_individual'

  	end
  	member do
  		get 'comprovante'
  	end
  end


  resources :devices


  resources :transacoes do
  	collection do
  		get 'busca'
  	end

  end


  resources :conta_cheques


  resources :venda_compras do
  	collection do
  		get 'lista_gastos'
  		post 'baixa_gasto'
  	end
  end


  resources :venda_devolucaos do
  	collection do
  		get 'busca_vendas'
  	end

  end


  resources :venda_romaneios do
  	collection do
  		get 'lista_romaneios'
  		post 'baixa_romaneio'
  	end
  end


  resources :romaneio_produtos


  resources :turmas do
  	collection do
  		get 'busca'
  	end

  end

  resources :romaneios


	namespace 'api' do
    namespace 'v1' do
      resources :produtos
      resources :vendas
      resources :vendas_produtos
      resources :check_points
      post 'postback', to: 'postback#index'
    end
  end
  resources :presupuesto_cotas

  resources :viaticos do
  	collection do
  		get 'busca_viatico'
  	end

		member do
			get 'comprovante'
		end

  end


  get 'main/result_main_fluxo_caixa', to: 'main#result_main_fluxo_caixa'
  get 'main/fc_detalhe', to: 'main#fc_detalhe'

  resources :produto_composicaos_vendas_produtos

  resources :noft_apps


  resources :persona_apis


  resources :mov_vantagens


  resources :evento_convidados do
		member do
			get 'qrcode'
			get 'confirm'
		end
		collection do
			get 'controle_tickets'
			get 'ticket_detalhe'
		end

  end

  resources :eventos


  resources :contas_usuarios


  resources :contas_forma_pagos


  resources :persona_acessos


  resources :produtos_tarefas


  resources :parcelas


  resources :cultivos


  resources :safras


  resources :persona_ferias do
		collection do
			get 'add_escala'
		end
		member do
			get 'comprovante'
			get 'retorno_empleado'
		end

  end


  resources :persona_feria

  resources :dias_uteis


  resources :brigadas


  resources :comites


  resources :distritos


  resources :persona_escalas do
		collection do
			get 'multi_datas'
		end
  end


  resources :apartamentos


  resources :predios


  resources :avaliacao_func_refs


  resources :avaliacao_funcs do
		collection do
			post 'update_individual'
			get 'ranked'
			get 'desempenho_anual_refs'
			get 'busca'
		end
	end


  resources :avaliacao_refs


  resources :turno_horarios


  resources :turnos do
  	collection do
  		get 'gerar_carga_horaria'
  	end
  end

  get "dashboard/index"

  get "dashboard/faturamento"

  resources :check_points do
    collection do
      post 'import_point'
      get 'atualiza_cancela_titulo'
      get 'busca'
      get 'busca_ticket'
      get 'lista_presenca'
      get 'resultado_lista_presenca'
      get 'busca_token'
      get 'notificacao_app'
    end
  end

  get "/faceid" => 'faceid#index'
  get "/faceid/registro" => 'faceid#registro'
  get "/faceid/registro_consumo" => 'faceid#registro_consumo'
  get "/faceid/aula_extra" => 'faceid#aula_extra'
  get "/faceid/deactivate" => 'faceid#deactivate'


  resources :pc_resumo_mes


  get "dashboard/index"
  get "dashboard/faturamento"

  get 'fluxo_caixa/movimentos'
  get 'fluxo_caixa/busca'
  get 'fluxo_caixa/main'

  resources :ordem_serv_files


  resources :recisao_funcs do
		member do
			get 'comprovante'
		end
	end


  resources :motivos


  resources :solicitudes do
  	collection do
  		get 'get_solicitudes'
  		get 'busca'
  	end
  	member do
  		get 'add_anexo'
  		get 'comprovante'
  	end
  end


  resources :persona_bancos


  resources :persona_ativos


  resources :persona_docs


  resources :terminal_contas

  resources :users do
		collection do
			post 'auth'
		end
  end


  resources :persona_unidades


  resources :contrato_custo_dts


  resources :contrato_custos


	resources :locales do
	  resources :translations, constraints: { id: /[^\/]+/ }
	end

  get 'personas/tags/:tag', to: 'personas#tags', as: :tag
  get 'personas/tags', to: 'personas#tags'


  resources :clase_tabela_precos


  resources :tarefas do
		collection do
			get 'busca_tarefas'
		end
  end


	resources :vendas_ordem_servs
  resources :ordem_serv_prods


  resources :ordem_servs do
		member do
			get 'comprovante'
			get 'checklist'
		end
		collection do
			get 'busca'
			post 'dynamic_ordem_serv_dev_prod'
		end
	end


  resources :block_financeiros


  resources :fact_indep_produtos


  resources :fact_indeps do
  	member do
  		post 'baixa_produto'
  	end
  end


  #mount Ckeditor::Engine => '/ckeditor'

  resources :config_printers

  resources :prov_gastos


	resources :troca_produtos


	resources :trocas do
		collection do
			get 'busca_produtos_faturados'
		end
	end




	resources :importa_dados do
	 collection do
		post 'imp'
	 end
	end
	resources :contrato_financas


	resources :contrato_servicos

	resources :contratos do
		member do
			get 'financas'
			get 'gera_cotas'
			get 'comprovante'
			get 'destroy_all'
			get 'cancelar'
		end
		collection do
			get 'busca'
			get 'gera_titulos'
			get 'multi_faturamento'
		end
	end
	resources :boca_cx_produtos
	resources :produto_sugeridos

	resources :lista_carga_produtos do
		collection do
			post 'add_produtos_direto'
		end
	end

	resources :lista_cargas_personas
	resources :plano_regras
	resources :afericaos
	resources :config_forms
	resources :recalculos do
		collection do
			get 'gera_recalc'
		end
	end


	resources :pedido_compra_financas

	resources :entrega_vendas


	resources :entregas do
		collection do
			get 'dynamic_tipo_entrega'
			get 'busca'
			post 'add_entregas'
		end
		member do
			get 'comprovante'
		end
	end


	resources :tipo_atividades


	resources :persona_acoes


	resources :acoes

	 get "applet" => "applet"
	  get "printApplet" => "printApplet"

	 resources :applet do
	 	collection do
	 		get 'glc_update'
	 	end
	 end



	#logistica
	match '/logistica'     => 'logistica#index'
	get "/logistica/busca" => 'logistica#busca'
	get "/logistica/separacao/:id" => "logistica#separacao"
	post "/logistica/add_venda" => 'logistica#add_venda'

	resources :lista_cargas do
		collection do
			get 'detalhe_pedido'
		end

		member do
			post 'add_produtos'
			get 'separacao'
			get 'rota'
			get 'produtos_adicionados'
		end
	end

	resources :rota


	resources :cartaos


	resources :produtos_comissaos


	resources :vendas_configs


	resources :boca_cxes


	resources :promos do
		collection do
			get 'gera_cashback_produtos'
		end

	end
	resources :promo_dts

	resources :despachos do
		member do
			get 'produtos'
		end
	end

	resources :despacho_docs

	resources :grupo_personas_dts


	resources :grupo_personas


	get "tintometrias/painel_preparacao" => "tintometrias#painel_preparacao"
	resources :tint_per_forms

	resources :tint_pers


	resources :vendas_produtos_comps


	resources :laz_mps


	resources :ordem_serv_prods


	resources :sobrantes_faltantes


	resources :tint_farben_bases


	resources :farben_produtos do
		collection do
			post 'imp'
		end

	end

	resources :sobrantes_faltantes
	resources :embalagens

	resources :tint_laz_bases


	resources :motivos_dev_cheques


	resources :tint_dacar_basis


	resources :tint_dacar_bases


	resources :tint_dacar_corantes

	resources :menus do
		collection do
			get 'estrutura'
			get 'testeChart'
			get 'testeChartt'
			get 'financeiro_chart'
			get 'autoriza_doc'
			get 'dt_autorizacao'
		end
	end

	resources :transf_cartao_dts

	resources :transf_cartaos do
		member do
			post 'baixa_cartao'
		end

	end

	resources :unidade_medidas
	resources :abertura_turnos
	resources :chaves

	resources :abastecidas do
		collection do
			post 'atualiza_abastecida'
			get 'get_api'
			get 'update_status'
			get 'get_abastecidas_sql'
			get 'modal_abastecidas'
			get 'busca'
		end

	end

	resources :form_fiscals do
		collection do
			get 'gerador'
			get 'fatura_independente'
			post 'atualiza_fatura_independente'
			post 'gera_docs'
			post 'cobro_update_nc'
			post 'cobro_update_fc'
			post 'cobro_update_rd'
			post 'venda_update_ft'
			post 'contrato_update_ft'
			post 'fact_indep_update_ft'
			get 'cliente_update_ft'
			post 'nota_cred_update_nc'
			post 'anula_nc'
			post 'inutilizacion'
			post 'cancelacion'
			post 'retencao_update_cp'
			post 'adelanto_update_rd'
			get 'nc'
			get 'rt'
			get 'busca'
			get 'print'
			get 'transmite_de'
			get 'gera_pdf_cdc'
			post 'compra_update_af'
			get 'reenviar'

		end
		member do
			get 'form_anula_nc'
			get 'impressao_ft'
			get 'impressao_rc'
			get 'impressao_rc_adelanto'
			get 'fatura_matricial'
			post 'update_impressao'
		end

	end

	resources :grupo_comissaos

	resources :cartao_bandeiras

	resources :fechamento_caixa_dts

	resources :cobros_recibos


	resources :cobros_ncs


	resources :cobros_faturas


	resources :cidade_areas


	resources :personas_tabela_precos
	resources :produtos_tributs


	resources :condicional_prov_produtos


	resources :condicional_provs do
		collection do
			get 'busca'
		end
		member do
			get 'print_comprovante'
		end
	end


	resources :nfe_statuses


	resources :nfe_produtos


	resources :operacao_fiscals

	resources :nfes do
		member do
			get 'gerar_nfe'
			get 'enviar_nfe'
			get 'imprime_nfe'
			get 'get_status'
			get 'get_danfe'
			get 'cancel_nfe'
			get 'get_cancel'
			get 'email_nfe'
			get 'get_email'
		end
	end

	resources :operacao_ficals


	resources :nves


	resources :unidades_usuarios


	resources :usuario_perfils do
		collection do
			post 'update_individual'
			get 'add_favorite'
			get 'remove_favorite'
		end
	end

	resources :cargos


	resources :grupos_prazos


	resources :persona_prazos


	resources :prazos


	resources :recibos


	resources :controle_kms do
		collection do
			get 'busca'
		end
	end


	resources :persona_rodados


	resources :persona_locais_entregas


	resources :persona_contatos


	resources :regiaos


	resources :seguimentos


	resources :persona_produtos


	resources :abertura_caixas do
		collection do
			get 'print_transf_saldo'
			get 'modal_detalhe'
		end
	end
	resources :turnos

	resources :terminals

	resources :compras_depre_apres
	resources :deposito_produtos


	resources :persona_chofers


	resources :forma_pagos_personas


	resources :forma_pagos

	resources :produto_composicaos

	resources :material_analisados

	resources :material_analisados

	resources :tabela_precos do
		collection do
			get 'gera_tabela_produtos'
		end
	end

	resources :dev_cheque_prov_dts

	resources :dev_cheque_provs do
		member do
			post 'add_cheque'
			get 'comprovante'
		end

	end

	resources :provi_detalhes

	resources :provis

	resources :compras_custos

	resources :dev_cheque_cliente_dts

	resources :dev_cheque_clientes do
		member do
			post 'add_cheque'
			get 'comprovante'
		end

	end

	resources :centro_custos


	resources :cobros_adelantos


	resources :personas_ips


	resources :personas_servicos


	resources :ips do
		collection do
			get 'gerador_ip'
			post 'gerar_ip'
		end

	end


	resources :compras_empaques


	resources :vendas_faturas do
		member do
			get 'fatura'
			post 'update_impressao'
			post 'anula_fatura'
		end
	end


	resources :compras_pedidos


	resources :painel_cliente_logs


	resources :revisao_result_liberacaos


	resources :empaque_produtos


	resources :empaques do
		collection do
			get 'busca'
		end
		member do
			get 'comprovante'
			get 'print_pendente'
			get 'caixa_comprovante'
		end
	end


	resources :cond_liq_vendidos

	resources :hongos


	resources :vendas_pedidos
	resources :vendas_cond_liqs


	resources :cond_liq_financas


	resources :cond_liq_produtos


	resources :cond_liq_docs


	resources :cond_liqs do
		collection do
			post 'liq_lanzs'
			post 'liq_lanzs_produtos'
			post 'liq_lanzs_vendidos'
			get  'gerar_cotas_credito'
			get  'busca'
			get 'dynamic_condicional'
		end
		member do
			get 'produtos'
			get 'financas'
			get 'print_comprovante'
			get 'valida_op'
		end
	end


	resources :config_contabils


	resources :conferencias do
		member do
			get 'print_conferencia'
			get 'grade'
			post 'add_produtos'
			get 'resultado_grade'
			get 'gera_stock_conferido'
		end

	end


	resources :conferencia_produtos


	match 'painel_cliente'  => "painel_cliente#index", :via => :get
	match 'laudo_pdf'       => "painel_cliente#laudo_pdf", :via => :get
	match 'laudo_xls_sue'   => "painel_cliente#laudo_xls_sue", :via => :get
	match 'laudo_xls_gn'   => "painel_cliente#laudo_xls_gn", :via => :get
	match 'laudo_xls_tev'   => "painel_cliente#laudo_xls_tev", :via => :get
	match 'login_cliente'   => "login_painel_cliente#index", :via => :get
	match 'logar_cliente'   => "login_painel_cliente#logar_cliente", :via => :post
	resources :ajuste_preco_detalhes


	resources :ajuste_preco_dts


	resources :pagos_adelantos


	resources :ajuste_precos


	resources :entrada_curvas


	resources :retencao_docs


	resources :retencaos


	resources :adelanto_cotas do
		collection do
			post 'update_individual'
		end
	end

	resources :bancos


	resources :condicionals do
		collection do
			get 'busca'
		end
		member do
			get 'print_comprovante'
			get 'comprovante'
			get 'entrada'
		end
	end

	resources :condicional_produtos
	resources :produtos_custos


	resources :pedido_compras_presupuestos


	resources :testes


	resources :produtos_tabela_precos


	resources :sub_grupo_precos


	resources :produtos_grades


	resources :colecaos


	resources :vendas_analizes


	resources :produtos_tamanhos


	resources :cors_produtos
	resources :produto_cors


	resources :compra_produto_grades


	resources :tamanhos


	resources :cors


	resources :persona_tabela_descs


	resources :liq_analize_dts


	resources :liq_analizes


	resources :cultura_interpres

	resources :culturas

	resources :tara_cadinhos
	resources :nc_proveedor_faturas
	resources :nota_credito_proveedor_aplics
	resources :nota_credito_proveedor_produtos

	resources :nota_credito_proveedors do
		collection do
			get 'filtro_busca_faturas'
			get 'nc_proveedor_financa'
			get 'nota_credito_comprovante'
		end
		member do
			get 'nc_proveedor_produtos'
			get 'nc_proveedor_aplic'
			get 'nc_proveedor_docs'
			get 'comprovante'
			post 'add_docs'
		end
	end

	resources :cancel_adelantos_detalhes
	post "dynamic_tipo_entrada_resultado/:id" => "entrada_results#dynamic_tipo_entrada_resultado"
	post "dynamic_ensaios_entrada_resultado/:id" => "entrada_results#dynamic_ensaios_entrada_resultado"
	post "dynamic_conj_ensaio_nematoide/:id" => "laboratorio/nematoides#dynamic_conj_ensaio_nematoide"
	post "dynamic_ensaios_entrada_resultado/:id" => "entrada_results#dynamic_ensaios_entrada_resultado"
	post "dynamic_analize_tipo/:id" => "laboratorio/analizes#dynamic_analize_tipo"
	post "dynamic_entrada_result_metodos/:id" => "entrada_results#dynamic_entrada_result_metodos"
	post "dynamic_colecao/:id" => "produtos#dynamic_colecao"
	post "dynamic_compra_colecao/:id" => "compras#dynamic_compra_colecao"
	post "dynamic_venda_colecao/:id" => "vendas#dynamic_venda_colecao"
	post "dynamic_bandeira/:id" => "vendas#dynamic_bandeira"

	post "dynamic_dispo_stock/:id" => "stocks#dynamic_dispo_stock"
	post "dynamic_marca/:id" => "relatorios#dynamic_marca"
	post "dynamic_col/:id" => "relatorios#dynamic_col"
	post "dynamic_cole/:id" => "pedido_compras#dynamic_cole"
	post "dynamic_consumicao_colecao/:id" => "consumicao_internas#dynamic_consumicao_colecao"
	post "presupuesto_dynamic_colecao/:id" => "presupuestos#presupuesto_dynamic_colecao"

	post "transf_deposito_origem/:id" => "transferencia_depositos#transf_deposito_origem"
	post "transf_deposito_destino/:id" => "transferencia_depositos#transf_deposito_destino"
	get "dynamic_compra_empaque_produto" => "compras#dynamic_compra_empaque_produto"
	get "dynamic_cond_liq_produto" => "cond_liqs#dynamic_cond_liq_produto"
	get "dynamic_empaque_produto" => "empaques#dynamic_empaque_produto"
	get "compras/dynamic_rubro_grupo/:id" => "compras#dynamic_rubro_grupo"
	get "compras/dynamic_centro_custo/:id" => "compras#dynamic_centro_custo"
	get "provis/dynamic_rubro_grupo/:id" => "provis#dynamic_rubro_grupo"
	get "regiaos/dynamic_estados/:id" => "regiaos#dynamic_estados"
	get "cidades/dynamic_estados/:id" => "cidades#dynamic_estados"
	get "cidades/dynamic_regioes/:id" => "cidades#dynamic_regioes"
	get "personas/dynamic_estados/:id" => "personas#dynamic_estados"
	get "personas/dynamic_regioes/:id" => "personas#dynamic_regioes"
	get "personas/dynamic_cidades/:id" => "personas#dynamic_cidades"
	get "personas/dynamic_areas/:id" => "personas#dynamic_areas"
	get "relatorios/dynamic_terminal/:id" => "relatorios#dynamic_terminal"
	get "relatorios/dynamic_rubro_grupo/:id" => "relatorios#dynamic_rubro_grupo"
	post "busca_deposito_unidade/:id" => "stocks#busca_deposito_unidade"
	post "afericao_deposito_destino/:id" => "afericaos#afericao_deposito_destino"
	get "dynamic_condicional_empaque_produto" => "condicionals#dynamic_condicional_empaque_produto"


	get "crm/clientes_sem_venda" => "crm#clientes_sem_venda"
	get "crm/resultado_clientes_sem_venda" => "crm#resultado_clientes_sem_venda"


	resources :cancel_adelantos do
		member do
			get 'liq_lanzs'
		end
	end


	resources :revisao_results do
			member do
			get 'laudo'
			get 'laudo_pdf'
			get 'listado_resultxls'
			post  'liberacao'
		end
		collection do
			get 'busca_protocolo'
			get 'busca'
		end
	end


	resources :sueldo_pagos

	resources :reclassif_stocks do
		collection do
			post 'update_liberado'
		end
	end

	resources :cobracas


	resources :amostra_ensaios


	resources :comissaos


	resources :entrada_result_ensaios


	resources :entrada_results do
		member do
			put 'liq_lanzs'
			get 'ensaios_lidos'
		end
		collection do
			get 'busca_entrada_result'
		end
	end


	resources :provas


	resources :bandeja_conjs


	resources :bandeja_provas


	resources :bandeja_amostras

	resources :bandejas do
		collection do
			post 'filtro_amostras'
		end
		member do
			post 'liq_lanzs'
			get 'formularios'
			get 'provas'
		end
	end

	resources :suportes do
		collection do
			get 'comando'
			post 'consulta'
		end
	end

resources :analizes_financas

	resources :metas
	resources :meta_detalhes

	resources :produto_barras

	namespace :laboratorio do
		resources :nematoides
		resources :nematoide_detalhes
		resources :especies
		resources :metodos
		resources :unidade_metricas
		resources :localizacaos
		resources :elementos
		resources :variavels
		resources :equipos
		resources :conj_ensaios
		resources :conj_ensaio_metodos
		resources :tipos
		resources :analize_ensaios
		resources :analize_amostras
		resources :analizes_financas
		resources :analizes do
			member do
				get 'conj_ensaios'
				get 'amostras'
				get 'forma_pago'
			end
			collection do
				get 'busca_analizes'
			end
		end
		resources :lab_relatorios do
			collection do
				get 'analises'
				get 'resultado_analises'
				get 'amostra'
				get 'resultado_amostra'
				get 'analise_clientes'
				get 'resultado_analise_clientes'
			end
		end

	end
	#safra
	resources :safras
	resources :safra_brotados
	resources :servicos
	resources :safra_ardidos
	resources :safra_verdosos
	resources :safra_quebrados
	resources :safra_averiados
	resources :safra_umidades
	resources :safra_impurezas

	resources :safra_produtos do
		member do
			get 'descontos'
		end
	end

	match 'zetta' => 'logins#new'
	match 'chronos' => 'logins#new'


	scope 'dev_cheque_clientes' do
		match 'dynamic_motivo_dev_cheque'   => "dev_cheque_clientes#dynamic_motivo_dev_cheque", :via => :post
	end

	#buscas
	scope 'buscas' do
		match 'busca_embalagem'       => "buscas#busca_embalagem", :via => :get
		match 'busca_sigle_produto'         => "buscas#busca_sigle_produto", :via => :get
		match 'busca_preco_produto'         => "buscas#busca_preco_produto", :via => :get
		match 'search_all_produtos'   => "buscas#search_all_produtos", :via => :get
		match 'busca_transf'          => "buscas#busca_transf", :via => :get
		match 'get_unidade'           => "buscas#get_unidade", :via => :post
		match 'get_usuario'           => "buscas#get_usuario", :via => :post
		match 'cotz_us_compra'        => "buscas#cotz_us_compra", :via => :post
		match 'cotz_us_venda'         => "buscas#cotz_us_venda", :via => :post
		match 'cotz_rs_compra'        => "buscas#cotz_rs_compra", :via => :post
		match 'cotz_rs_venda'         => "buscas#cotz_rs_venda", :via => :post
		match 'cotz_rs_us_compra'     => "buscas#cotz_rs_us_compra", :via => :post
		match 'cotz_ps_compra'        => "buscas#cotz_ps_compra", :via => :post
		match 'cotz_rs_us_venda'      => "buscas#cotz_rs_us_venda", :via => :post
		match 'busca_produto'         => "buscas#busca_produto", :via => :get
		match 'get_produto'           => "buscas#get_produto", :via => :get
		match 'get_clase'             => "buscas#get_clase", :via => :post
		match 'get_grupo'             => "buscas#get_grupo", :via => :post
		match 'get_subgrupo'          => "buscas#get_subgrupo", :via => :post
		match 'get_pedido'            => "buscas#get_pedido", :via => :get
		match 'get_plano'             => "buscas#get_plano", :via => :post
		match 'get_vendedor'          => "buscas#get_vendedor", :via => :get
		match 'get_cliente'           => "buscas#get_cliente", :via => :post
		match 'get_funcionario'           => "buscas#get_funcionario", :via => :get
		match 'busca_compra_produto'  => "buscas#busca_compra_produto", :via => :get
		match 'busca_venda_produto'   => "buscas#busca_venda_produto", :via => :get
		match 'get_tara_cadinho'      => "buscas#get_tara_cadinho", :via => :post
		match 'get_fabricante_cod'    => "buscas#get_fabricante_cod", :via => :post
		match 'get_referencia'        => "buscas#get_referencia", :via => :post
		match 'get_compra_empaque_referencia_grade'  => "buscas#get_compra_empaque_referencia_grade", :via => :post
		match 'busca_conferencia_produto'   => "buscas#busca_conferencia_produto", :via => :get
		match 'busca_empaque_produto'       => "buscas#busca_empaque_produto", :via => :get
		match 'busca_bico'                  => "buscas#busca_bico", :via => :get
		match 'busca_produto_por_tabela_preco' => "buscas#busca_produto_por_tabela_preco", :via => :get
		match 'compra_documento'   => "buscas#compra_documento", :via => :get
		match 'busca_timbrado_vecimento'   => "buscas#busca_timbrado_vecimento", :via => :get
		match 'busca_placa_obrigatoria'    => "buscas#busca_placa_obrigatoria", :via => :get
		match 'get_produtos_precos'   => "buscas#get_produtos_precos", :via => :get
		match 'get_moeda_conta'       => "buscas#get_moeda_conta", :via => :get
		match 'gera_cotas_cota_path'  => "buscas#gera_cotas_cota_path", :via => :get
		match 'busca_tipo_contas'  => "buscas#busca_tipo_contas", :via => :get
		match 'busca_pedido_traslado'  => "buscas#busca_pedido_traslado", :via => :get
		match 'proveedor_pagar'       => "buscas#proveedor_pagar", :via => :post
		match 'autoriza_acao_venda'       => "buscas#autoriza_acao_venda", :via => :get
		match 'busca_cartao'       => "buscas#busca_cartao", :via => :get
		match 'busca_ruc'       => "buscas#busca_ruc", :via => :get
		match 'busca_default_produto'       => "buscas#busca_default_produto", :via => :get
		match 'busca_produto_tabela_preco'  => "buscas#busca_produto_tabela_preco", :via => :get
		match 'busca_viaticos'  => "buscas#busca_viaticos", :via => :get
		match 'busca_custo'  => "buscas#busca_custo", :via => :get


	end

	scope 'geradors' do
		match 'gerador_arquivo'  => "geradors#gerador_arquivo", :via => :get
		match 'result_gerador'   => "geradors#result_gerador", :via => :get
	end
	#login
	resources :logins do
		collection do
			get 'acesso'
			get 'liberacao'
			post 'logar'
			post 'troca_unidade'
			post 'get_unidade'
		end
	end

	#cadastros
	resources :localizacaos
	resources :produto_barras
	resources :localidades
	resources :metodos
	resources :equipos
	resources :servicos
	resources :variavels
	resources :elementos
	resources :unidade_metricas
	resources :empresas

	resources :contas do
		collection do
			get 'gerador_cheque'
			post 'gera_docs'
		end
	end


	resources :sub_grupos do
		collection do
			post 'update_individual'
		end
	end
	resources :depositos
	resources :bicos
	resources :grupos
	resources :usuarios do
		collection do
			get :gerar_perfil
      get :historico_acesso
      get :resultado_historico_acesso
		end
	end
	resources :unidades
	resources :clases do
		collection do
			post 'update_individual'
		end
	end
	resources :rodados
	resources :documentos
	resources :metas
	resources :meta_detalhes
	resources :planos
	resources :plano_de_contas do
		collection do
			get 'print'
		end
	end
	resources :moedas
	resources :cidades
	resources :estados
	resources :paises
	resources :setors

	resources :personas do
		collection do
			get 'persona_nota_credito'
			get 'persona_cobro'
			get 'persona_pago'
			get 'persona_dividas'
			get 'busca_persona_pago'
			get 'busca_persona_cobro'
			get 'busca_persona_dividas'
			get 'persona_presupuesto'
			get 'persona_nota_credito_proveedor'
			get 'busca_persona_presupuesto'
			get 'busca'
			get 'persona_compra'
			get 'busca_persona_compra'
			get 'busca_cliente'
			get 'busca_persona_nota_credito'
			get 'busca_persona_nota_credito_proveedor'
			get 'busca_persona_venda_financa'
			get 'busca_persona_venda'
			get 'persona_venda'
			get 'lista_faturamento'
			get 'result_lista_faturamento'
			get 'busca_detalhada'
			get 'resultado_busca_detalhada'
			post 'update_multiple'
			get 'consulta_cliente'
			get 'busca_consulta_cliente'
			get 'troca_cadastro'
			post 'executa_troca_cadastro'
			get 'index_funcionario'
			get 'new_funcionario'
			get 'listado_aluno'
			get 'resultado_listado_aluno'
			get 'envia_login_app'
			get 'comprovante_dividas'

		end
		member do
			get 'tarjeta'
			get 'marcas_relacionadas'
			get 'local_entregas'
			get 'contatos'
			get 'rodados'
			get 'prazos'
			get 'descontos'
			get 'visao_geral_cliente'
			get 'folha_de_pagamento'
			get 'unidades'
			get 'show_funcionario'
			get 'edit_funcionario'
			get 'decla_jurada'
			get 'print_funcionario'
			get 'historico_vendas'
			get 'busca_historico_vendas'
			get 'visao_geral_cliente_print'
		end
	end
	resources :produtos do
		collection do
			get 'dinamic_busca_consulta_stock'
			get 'index_print'
			get 'consulta_stock'
			get 'busca_compra_produto'
			get 'dinamic_busca_compra_produto'
			get 'busca_composicao_produto'
			get 'dinamic_busca_composicao_produto'
			get 'busca_pedido_compra_produto'
			get 'dinamic_busca_pedido_compra_produto'
			get 'busca_presupuesto_produto'
			get 'dinamic_busca_presupuesto_produto'
			get 'busca_venda_produto'
			get 'dinamic_busca_venda_produto'
			get 'busca_consumicao_interna_produto'
			get 'dinamic_busca_consumicao_interna_produto'
			get 'busca_manutencao_mq_produto'
			get 'dinamic_busca_manutencao_mq_produto'
			get 'busca_producao_produto'
			get 'dinamic_busca_producao_produto'
			get 'busca_remicao_produto'
			get 'dinamic_busca_remicao_produto'
			get 'busca_venda_produto_maiorista'
			get 'dinamic_busca_venda_produto_maiorista'
			get 'dinamic_busca'
			get 'busca_ordem_produto'
			get 'dinamic_busca_ordem_produto'
			get 'busca_condicional_produto'
			get 'dinamic_busca_condicional_produto'
			get 'busca_transf_produto'
			get 'dinamic_busca_transf_produto'
			get 'imagem'
			post 'update_individual'
			get 'etiquetas'
			get 'grades'
			get 'historico'
			get 'busca_grades'
			get 'busca_empaque_produto'
			get 'dinamic_busca_empaque_produto'
			get 'busca_condicional_prov_produto'
			get 'dinamic_busca_condicional_prov_produto'
			post 'update_individual_compra'
			get 'busca_detalhada'
			get 'resultado_busca_detalhada'
			post 'update_multiple'
			get 'busca_conferencia_produto'
			get 'dinamic_busca_conferencia_produto'
			get 'busca_os_produto'
			get 'dinamic_os_produto'
			get 'busca_venda_produtos_faturados'
			get 'dinamic_busca_venda_produtos_faturados'
			get 'gera_etiqueta'
		end

		member do
			get 'cod_barra'
			get 'roteiro'
			get 'composicao'
			post 'add_cor'
			post 'add_tamanho'
			post 'gerar_disponibilidades'
			get 'tabelas_precos'
			get 'atributs'
			get 'atualizar_precos'
			get 'historico'
			get 'comissao'
			get 'statisticas'
			get 'sugeridos'
			get 'galeria'
		end
	end
	resources :financas do
		collection do
			get 'relatorio_financas'
			get 'extrato_tarjeta'
			get 'resultado_extrato_tarjeta'
			get 'extrato_bancario'
			get 'resultado_extrato_bancario'
			get 'resumo_contas'
			get 'resultado_resumo_contas'
			get 'conciliacao_bancaria'
			get 'resultado_conciliacao_bancaria'
			post 'update_individual'
			get 'emprestimos'
			get 'resultado_emprestimos'
			get 'calcula_valores_fluxo_caixa'
			get 'resultado_doacao'
			get 'doacao'
			get 'consolidado'
			get 'recebimentos'
			get 'resultado_recebimentos'
			get 'pagamentos'
			get 'resultado_pagamentos'
			get 'painel'

		end
	end
	resources :forms

	#processos
	resources :controle_pulv_maqs
	resources :controle_pulvs
	resources :controle_visita
	resources :setores
	#
	resources :controle_pulvs
	resources :controle_visita
	#COMPRAS
	resources :compras_gastos
	resources :compras_documentos
	resources :compras_produtos do
		collection do
			post 'gerar_raterio'
		end
	end

	resources :compras_financas do
		collection do
			post 'update_individual'
		end
	end

	resources :compras do
		collection do
			get 'modal_gasto'
			get 'busca'
			get 'busca_gasto'
			get 'compras_gasto'
			get 'busca_bens'
			get 'compras_bens'
			get 'cheque_terceiros'
			get 'pago_antecipado'
			get 'compras_financa'
			get 'compras_documento'
			get 'novo_financa'
			get 'novo_gasto'
			get 'new_gasto'
			get 'new_bens'
			get 'index_gasto'
			get 'index_bens'
			get 'pedido_compras'
			get  'gerar_cotas_credito'
			post 'add_pedidos'
			get 'lista_viaticos'
			post 'agregar_produtos'
			get 'add_prod_import'
			get 'add_produtos_cadastro'
		end
		member do
			get 'compras_custos'
			get 'compras_gasto'
			get "compras_financa"
			get "novo_financa"
			get "novo_gasto"
			get "edit_gasto"
			get "edit_bens"
			get 'novo_produto'
			get 'compras_documento'
			get 'total_documento'
			get 'novo_documento'
			get 'prorateo'
			get 'pedidos'
			get 'comprovante'
			get 'comprovante_xls'
			get 'adicionar_codigo'
			get 'empaque'
			get 'etiquetas'
			get 'valida_processo'
		end
	end
	resources :stocks do
		collection do
			get 'iventario'
			get 'resultado_iventario_xls'
			get 'stock_inicial'
			get 'relatorio_stock'
			get 'rentabilidade'
			get 'resultado_rentabilidade'
			get 'dinamic_busca_stock_inicial'
			get 'resultado_iventario'
			get 'resultado_relatorio_consumo_bomba'
			get 'projecao_compras'
			get 'resultado_projecao_compras'
			get 'disponibilidade_stock'
			get 'resultado_disponibilidade_stock'
			get 'quadro_produtos'
			get 'resultado_quadro_produtos'
			get 'conferencia'
			get 'resultado_conferencia'
			get 'resumo_deposito'
			get 'resultado_resumo_deposito'
			get 'resumo_colecao'
			get 'resultado_resumo_colecao'
			get 'stock_minimo'
			get 'resultado_stock_minimo'
			get 'cmv'
			get 'resultado_cmv'
			get 'afericao'
			get 'resultado_afericao'
			get 'abastecidas'
			get 'resultado_abastecidas'
			get 'curva_abc'
			get 'resultado_curva_abc'
			get 'registro_consumo'
			get 'resultado_registro_consumo'

		end
	end
	resources :pagares do
		member do
			get 'autorizacao_desc'
			get 'print'
		end
	end


resources :pagares_detalhe

	resources :consumicao_internas do
		collection do
			get 'busca'
		end
		member do
			get 'comprovante'
			get 'comprovante_ticket'
		end

		resources :consumicao_interna_produtos
	end
	resources :ingressos do
		collection do
			get 'busca_ingreso'
			get 'index_modal'
			get 'create_multiple'
			get 'multi_registros'
			get 'atualiza_registro'
			get 'multi_registros'
			get 'atualiza_registro'
		end
		member do
			get 'comprovante'
		end
	end

	resources :presupuestos do
		resources :presupuesto_produtos
		collection do
			get 'busca'
			get 'gera_cotas'
		end

		member do
			get 'print_presupuesto'
			get 'grade'
			get 'print_presupuesto_grade'
			post 'add_produtos'
			get 'resultado_grade'
		end

	end
	resources :vendas do
		collection do
			get  'new_balcao'
			get  'venda_produto'
			get  'faturas_pendentes'
			get  'pagare'
			get  'comprovante'
			get  'comprovante01'
			get  'comprovante_fatura_pendentes'
			get  'detalhes_produto'
			get  'busca_vendas'
			get  'vendas_financa_contado'
			get  'vendas_financa'
			get  'gerar_cotas_credito'
			get  'busca_vendas'
			post 'filtro_faturas_pendentes'
			post 'filtro_faturas_pendentes_comprovante'
			get  'vendas_entrada_produto'
			post 'filtro_faturas_pendentes'
			post 'filtro_faturas_pendentes_comprovante'
			put  'update_faturas_pendentes'
			post 'add_pedidos'
			post 'add_cond_liq_fatura'
			post 'add_cond_liqs'
			post 'update_individual'
			get 'abastecidas'
			get 'busca_placas'
			put 'update_venda'
			get 'busca_endereco'
			get 'mapa_mesas'
			get 'atualiza_pedido'
			get 'atualiza_desconto'
			get 'painel_cobranca_venda'
			get 'busca_painel_cobranca_venda'
			get 'presupuesto_pendentes'
			get 'consulta_produtos'
			get 'result_consulta_produtos'
			get 'busca_nota_credito'
			get 'lista_produtos_sugeridos'
			get 'verifica_financas'
			get 'busca_pago_antecipado'
			get 'em_curso'
			get 'tabela_preco_produto'
			get 'lista_mapa_mesas'
			get 'gerar_cashback'
			get 'send_print'
			get 'update_set_print'
			post 'send_mult_prods'
			get 'tela_preparo'
			get 'status_preparo'
			get 'entregas_pendentes'
			get 'entregas_pendentes_busca'

		end
		member do
			get 'add_fatura'
			get 'vendas_financa'
			get 'gerador_cotas'
			get 'gerador_faturas'
			get 'comprovante'
			get 'comprovante_devolucao'
			get 'pagare'
			get 'comprovante01'
			get 'comprovante02'
			get 'fatura'
			get 'ticket'
			get 'ticket_cozinha'
			get 'pedidos'
			get 'financas'
			get 'cond_liqs'
			get 'gerador_codigo'
			get 'gerador_produtos'
			get 'comprovante_entrega'
			get 'valida_processo'
			get 'visualizacao'
			post 'add_produto_sugeridos'
			get 'devolucaos'
			get 'certificado_venda'
			get 'print_contrato'
			get 'pagare_escritura'
			get 'pagare_usado'
			get 'modal_ordem_entrega'
		end
	end
	resources :vendas_financas

	resources :vendas_produtos do
		collection do
			get 'busca_nota_credito_produto'
			get 'modal_update'
		end
		member do
			get 'formula'
			get 'etiqueta'
		end
	end

	resources :producaos do
		collection do
			get 'busca'
		end
		member do
			get 'producao_final'
			get 'detalhe_print'
		end
	end

	resources :producao_produtos

	resources :manutencao_maquinas do
		resources :manutencao_maquina_produtos
	end
	resources :recepcao_nota_remicao_produtos
	resources :recepcao_nota_remicaos
	resources :nota_remicao_produtos

	resources :nota_remicaos do
		member do
			get 'comprovante'
			get 'detalhes_produtos_print'
		end
	end

	resources :nota_creditos_detalhes
	resources :nota_creditos_docs
	resources :nota_creditos do
		collection do
			get 'busca_nc'
		end
		member do
			get 'documentos'
			get 'nota_credito_financas'
			get 'nota_credito_comprovante'
			get 'comprovante'
			get 'nota'
		end
	end

	resources :vendas_entrada_produtos

	resources :cobros_detalhes
	resources :cobros_financas
	resources :cobros do
		collection do
			get 'busca'
			get 'nova_cota'
			get 'filtro_busca_cliente'
			get 'busca'
			get 'nova_cota'
			get 'cheque_terceiros'
			get 'lista_adelantos'
		end
		member do
			get 'filtro_busca_cliente'
			get 'cobro_final'
			get 'cobro_adelanto'
			get 'recibo'
			get 'comprovante'
			get 'valida_processo'
			post 'baixa_divida'
			get 'gera_pdf_cobros'
			get 'financa_painel_receber'
			get 'visualizar'
		end
	end

	resources :pagos do
		collection do
			post 'filtro_dividas'
			get  'busca'
			get 'cheque_terceiros'
		end
		member do
			get 'pago_final'
			get 'pago_adelanto'
			get 'comprovante'
			post 'baixa_divida'
			get 'gera_pdf_pagos'
			get 'financa_painel_pagar'
			get 'valida_processo'
			get 'print_cheque'
		end
	end

	resources :pagos_detalhes
	resources :pagos_financas
	resources :egressos do
		collection do
			get 'busca_egreso'
			get 'multi_registros'
			get 'create_multiple'
		end
		member do
			get 'comprovante'
		end
	end
	resources :transferencia_contas_detalhes
	resources :transferencia_contas do
		collection do
			get 'busca_diferido'
			post 'resultado_busca_diferido'
			get 'busca'
		end
		member do
			get 'comprovante'
		end
	end
	resources :transferencia_entre_contas
 	resources :fechamento_caixas do
    member do
      get 'produtos'
      get 'print'
      get 'print_dt_fechamento'
    end
    collection do
      post 'conferir_caixa'
      get 'atuliza_forma_pagos'
      get 'fecha_caixa'
      get 'reabre_fechamento'

    end
  end
	resources :sueldos_detalhes

	resources :sueldos do
		collection do
			get 'gerar_sueldos'
			get 'result_gerar_sueldos'
			get 'busca'
		end
		member do
			get 'form_sueldos_detalhes'
			get 'comprovante'
			get 'financas'
			get 'liquidacao'
			post 'baixa_divida'
			get 'print_cheque'

		end
	end

	resources :adelantos do
		collection do
			get 'busca'
			get  'gerar_cotas_credito'
		end
		member do
			get 'comprovante'
			get 'recibo'
			get 'liquidacao'
		end
	end

	resources :pedido_compras do
		collection do
			get 'busca_pedido_compra'
		end
		member do
			get 'print_pedido'
			get 'comprovante_xls'
			get 'financas'
		end
	end

	resources :pedido_compra_produtos

	resources :transferencia_depositos do
		collection do
			get 'busca'
		end
		member do
			get 'comprovante'
			post 'add_produtos'
		end
	end

	resources :transferencia_deposito_detalhes
	resources :entrada_saida_func_detalhes

	resources :entrada_saida_funcs do
		collection do
			get 'busca'
		end
	end

	resources :clientes do
		collection do
			get 'relatorio_contas_receber'
			get 'atualizacao_carpeta_cliente'
			get 'busca_atualizacao_carpeta_cliente'
			get 'index_inicio'
			get 'extracto_funcionario'
			get 'resultado_extracto_funcionario'
			get 'clientes_vencidos'
			get 'resultado_clientes_vencidos'
			get 'resultado_consulta_simples'
			get 'painel_receber'
			get 'painel_receber_lancamento'
			get 'cancelacao_titulo'
			get 'baixa_parcial_titulo'
			post 'enviar_email_dividas'
			get 'acerto_clientes'
			get 'resultado_acerto_clientes'
			get 'acerto_modal'
			get 'resultado_acerto_modal'
      get 'titulo_historico'
      get 'edit_doc'

		end
		member do
			get 'faturamento'
		end
	end

	resources :proveedores do
		collection do
			get 'relatorio_contas_pagar'
			get 'index_inicio'
			get 'painel_pagar'
			get 'painel_pagar_lancamento'
			get 'cancelacao_titulo'
			get 'baixa_parcial_titulo'
			get 'titulo_historico'
			post 'imp'
			get 'estorno_titulo'
			get 'consolidado'
			get 'consolidado_interno'
			get 'consolidado_modal'
			get 'atualiza_pagar_por'
			get 'atualiza_voltar_pagar_por'
			get 'multi_pagamentos'
			get 'atualiza_cancela_titulo'
      get 'titulo_historico'
      get 'edit_doc'
			get 'multi_registros'
			get 'atualiza_registro'
			get 'pagamentos'
			get 'resultado_pagamentos'
		end
	end

	resources :relatorios do
		collection do
			get 'vendas'
			get 'historico_precos'
			get 'cheque_diferido'
			get 'fechamento_caixa'
			get 'resultado_resumo_compra'
			get 'resumo_mes'
			get 'resultado_resumo_mes'
			get 'cobros'
			get 'resultado_cobros'
			get 'consumicao_interna'
			get 'resultado_consumicao_interna'
			get 'pagos'
			get 'resultado_pagos'
			get 'gastos'
			get 'resultado_gastos'
			get 'comissoes'
			get 'resultado_comissoes'
			get 'compras'
			get 'resultado_compras'
			get 'resultado_fechamento_caixa'
			get 'resultado_vendas'
			get 'resultado_historico_precos'
			get 'resultado_relatorio_fechamento_turno'
			get 'remicao'
			get 'resultado_remicao'
			get 'controle_func'
			get 'resultado_controle_func'
			get 'recepcao_remicao'
			get 'resultado_recepcao_remicao'
			get 'resultado_cheque_diferido'
			get 'resultado_tabela_preco'
			get 'adelantos'
			get 'resultado_adelantos'
			get 'pedidos_vendas'
			get 'resultado_pedidos_vendas'
			get 'tabela_preco'
			get 'livro_diario'
			get 'resultado_livro_diario'
			get 'controle_visitas'
			get 'resultado_controle_visitas'
			get 'fluxo_caixa'
			get 'fluxo_caixa_realizado'
			get 'resultado_fluxo_caixa_realizado'
			get 'resultado_fluxo_caixa'
			get 'metas'
			get 'resultado_metas'
			get 'folha_de_pagamento'
			get 'resultado_folha_de_pagamento'
			get 'control_obra'
			get 'resultado_control_obra'
			get 'demonstrativo_resultados'
			get 'resultado_demonstrativo_resultados'
			get 'condicionals'
			get 'resultado_condicionals'
			get 'sueldo'
			get 'resultado_sueldo'
			get 'planilha_custos'
			get 'resultado_planilha_custos'
			get 'obra_faturamento'
			get 'resultado_obra_faturamento'
			get 'pedidos_compras'
			get 'resultado_pedidos_compras'
			get 'vendas_marcas'
			get 'resultado_vendas_marcas'
			get 'fopag'
			get 'resultado_fopag'
			get 'vendas_produtos'
			get 'result_vendas_produtos'
			get 'pago_antecipado'
			get 'resultado_pago_antecipado'
			get 'compras_x_vendas'
			get 'resultado_compras_x_vendas'
			get 'vendas_turno'
			get 'resultado_vendas_turno'
			get 'controle_km'
			get 'resultado_controle_km'
			get 'faturamento'
			get 'resultado_faturamento'
			get 'entregas'
			get 'resultado_entregas'
			get 'resultado_detalhe_a_receber'
			get 'resultado_detalhe_cheques_diferidos'
			get 'resultado_detalhe_a_pagar'
			get 'resultado_detalhe_cheques_emitidos'
			get 'resultado_detalhe_atraso_receber'
			get 'resultado_detalhe_atraso_pagar'
			get 'resultado_detalhe_efetivo'
			get 'fluxo_caixa_dt'
			get 'antecipo_empleado'
			get 'resultado_antecipo_empleado'
			get 'nota_creditos'
			get 'resultado_nota_creditos'
			get 'contratos'
			get 'resultado_contratos'
			get 'evolucao_faturamento'
			get 'resultado_evolucao_faturamento'
      get 'ponto_funciario'
      get 'resultado_ponto_funciario'
			get 'ferias'
			get 'resultado_ferias'
			get 'entrada_modal'
			get 'resultado_entrada_modal'
			get 'rodados'
			get 'resultado_rodados'
      get 'km_veiculos'
      get 'resultado_km_veiculos'

		end
	end

	 #safra
	 resources :safras

	 resources :safra_produtos do
		member do
			get 'descontos'
		end
	end

	resources :safra_brotados
	resources :safra_ardidos
	resources :safra_verdosos
	resources :safra_quebrados
	resources :safra_averiados
	resources :safra_impurezas
	resources :safra_umidades

	resources :financas do
		collection do
			get 'relatorio_financas'
			get 'extrato_bancario'
			get 'resultado_extrato_bancario'

		end
	end

	#safra
	resources :safras
	resources :safra_produtos do
		member do
			get 'descontos'
		end
	end

	resources :safra_umidades
	resources :safra_ardidos
	resources :safra_verdosos
	resources :safra_quebrados
	resources :safra_averiados
	resources :safra_impurezas
	resources :safra_brotados

#contabilidade
resources :diarios do
	collection do
		get 'busca'
	end
end

resources :diario_habers
resources :diario_debes

resources :contabilidades do
	collection do
		get 'generar_acientos_contables'
		get 'resultado_generar_acientos_contables'
		get 'resumo_vendas'
		get 'resultado_resumo_vendas'
		get 'resumo_compra'
		get 'resultado_resumo_compra'
		get 'livro_venda'
		get 'resultado_livro_venda'
		get 'livro_mayor_produtos'
		get 'resultado_livro_mayor_produtos'
		get 'livro_mayor'
		get 'resultado_livro_mayor'
		get 'livro_diario'
		get 'resultado_livro_diario'
		get 'livro_compra'
		get 'resultado_livro_compra'
		get 'balance_general'
		get 'resultado_balance_general'
		get 'balance'
		get 'resultado_balance'
		get 'nota_creditos'
		get 'resultado_nota_creditos'
		get 'nota_creditos_provs'
		get 'resultado_nota_creditos_provs'
	end
end

resources :faturas do
	collection do
		get 'multi_faturas'
		get 'busca'
		get 'print_busca'
	end
end

resources :rubros
resources :plano_de_contas

end
