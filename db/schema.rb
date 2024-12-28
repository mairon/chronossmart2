# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20241030021539) do

  create_table "abastecidas", :force => true do |t|
    t.string   "chave",      :limit => 20
    t.date     "data"
    t.time     "hora"
    t.integer  "bomba"
    t.integer  "bico"
    t.decimal  "litros",                   :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "preco",                    :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "valor",                    :precision => 15, :scale => 3, :default => 0.0
    t.integer  "unidade_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abertura_caixas", :force => true do |t|
    t.date     "data"
    t.integer  "usuario_id"
    t.integer  "turno_id"
    t.integer  "terminal_id"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.integer  "unidade_id"
    t.integer  "deposito_id"
    t.boolean  "status",                                     :default => true
    t.decimal  "saldo_gs",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_us",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_rs",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_ps",    :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "abertura_turnos", :force => true do |t|
    t.integer  "unidade_id"
    t.integer  "usuario_id"
    t.integer  "chave_id"
    t.integer  "conta_id"
    t.integer  "terminal_id"
    t.decimal  "valar_gs"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "acoes", :force => true do |t|
    t.string   "nome"
    t.boolean  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "adelanto_cotas", :force => true do |t|
    t.integer  "adelanto_id"
    t.integer  "persona_id"
    t.integer  "cota"
    t.date     "data"
    t.date     "vencimento"
    t.integer  "moeda"
    t.decimal  "valor_us",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo"
    t.datetime "created_at",                                                                      :null => false
    t.datetime "updated_at",                                                                      :null => false
    t.string   "documento_numero", :limit => 100
    t.text     "concepto"
    t.integer  "unidade_id"
    t.string   "persona_nome",     :limit => 200
    t.integer  "status"
    t.integer  "tot_cotas"
  end

  create_table "adelantos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.date     "diferido"
    t.string   "cheque",              :limit => 50
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "moeda"
    t.integer  "tipo"
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 100
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 100
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 150
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2
    t.string   "concepto",            :limit => 600
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "usuario_updated"
    t.integer  "usuario_created"
    t.string   "rubro_cod_contabil",  :limit => 150
    t.string   "rubro_descricao",     :limit => 150
    t.integer  "rubro_id"
    t.integer  "status"
    t.integer  "clase_produto"
    t.string   "vendedor_nome",       :limit => 150
    t.integer  "vendedor_id"
    t.integer  "cheque_status"
    t.decimal  "valor_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer  "servico_id"
    t.string   "servico_noma"
    t.integer  "setor_id"
    t.string   "setor_nome"
    t.integer  "cota"
    t.date     "vencimento"
    t.integer  "unidade_id"
    t.integer  "banco_id"
    t.string   "banco",               :limit => 100
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.decimal  "encargos_us",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "encargos_gs",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "encargos_rs",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo_adelanto"
    t.integer  "tipo_empleado"
    t.integer  "terminal_id"
    t.decimal  "ips_gs",                             :precision => 15, :scale => 2, :default => 0.0
    t.integer  "centro_custo_id"
    t.integer  "plano_de_conta_id"
    t.integer  "rodado_cv_id"
    t.integer  "rodado_cr_id"
  end

  create_table "afericaos", :force => true do |t|
    t.integer  "unidade_id"
    t.integer  "deposito_id"
    t.integer  "persona_id"
    t.decimal  "quantidade",     :precision => 15, :scale => 2, :default => 0.0
    t.integer  "bico_id"
    t.decimal  "custo_medio_gs", :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "ajuste_preco_detalhes", :force => true do |t|
    t.integer  "ajuste_preco_id"
    t.integer  "tipo"
    t.integer  "status"
    t.integer  "produto_id"
    t.integer  "unidade_id"
    t.decimal  "preco_1_us",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_1_gs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_1_rs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_1",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_2_us",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_2_gs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_2_rs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_2",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_3_us",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_3_gs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_3_rs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_3",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_4_us",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_4_gs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_4_rs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_4",        :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.date     "data"
  end

  create_table "ajuste_precos", :force => true do |t|
    t.date     "data"
    t.integer  "unidade_id"
    t.integer  "sub_grupo_id"
    t.integer  "colecao_id"
    t.integer  "tipo"
    t.text     "obs"
    t.decimal  "porcen_1",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_2",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_3",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_4",     :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.integer  "grupo_id"
  end

  create_table "apartamentos", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.boolean  "status",                    :default => true
    t.integer  "persona_id"
    t.integer  "predio_id"
    t.text     "obs"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id",                                :null => false
    t.string   "auditable_type",                              :null => false
    t.integer  "owner_id",                                    :null => false
    t.string   "owner_type",                                  :null => false
    t.integer  "user_id",                                     :null => false
    t.string   "user_type",                                   :null => false
    t.string   "action",                                      :null => false
    t.text     "audited_changes"
    t.integer  "version",                      :default => 0
    t.text     "comment"
    t.datetime "created_at",                                  :null => false
    t.integer  "unidade_id"
    t.string   "cod_processo",    :limit => 8
  end

  add_index "audits", ["auditable_id", "auditable_type", "version"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "bancos", :force => true do |t|
    t.string   "nome"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bicos", :force => true do |t|
    t.string   "nome",        :limit => 25
    t.decimal  "vazao"
    t.string   "codigo_tec",  :limit => 15
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.integer  "unidade_id"
    t.integer  "deposito_id"
    t.decimal  "preco_us",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_gs",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_rs",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_02_us",               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_02_gs",               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_02_rs",               :precision => 15, :scale => 2, :default => 0.0
    t.integer  "ordem",                                                    :default => 0
    t.integer  "bico_auto"
    t.integer  "bomba_auto"
  end

  create_table "block_financeiros", :force => true do |t|
    t.date     "periodo"
    t.boolean  "status"
    t.integer  "usuario_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "boca_cx_produtos", :force => true do |t|
    t.integer  "boca_cx_id"
    t.integer  "produto_id"
    t.decimal  "comissao",   :precision => 15, :scale => 2
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "boca_cx_produtos", ["boca_cx_id"], :name => "index_boca_cx_produtos_on_boca_caixa_id"
  add_index "boca_cx_produtos", ["produto_id"], :name => "index_boca_cx_produtos_on_produto_id"

  create_table "boca_cxes", :force => true do |t|
    t.date     "periodo_inicio"
    t.date     "periodo_final"
    t.string   "nome",           :limit => 150
    t.decimal  "comissao",                      :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
  end

  create_table "bombas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "deposito_id"
    t.string   "deposito_nome",   :limit => 200
    t.string   "nome",            :limit => 200
  end

  create_table "brigadas", :force => true do |t|
    t.string   "nome",       :limit => 150
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "cancel_adelantos", :force => true do |t|
    t.date     "data"
    t.integer  "moeda"
    t.decimal  "cotacao",                   :precision => 15, :scale => 2, :default => 0.0
    t.text     "obs"
    t.integer  "persona_id"
    t.string   "persona_nome", :limit => 1
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
  end

  create_table "cancel_adelantos_detalhes", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.integer  "cancel_adelanto_id"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "documento_numero",    :limit => 30
    t.decimal  "valor_us",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",                          :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo_persona"
    t.integer  "setor_id"
    t.integer  "cota"
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
  end

  create_table "cargos", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "carros", :force => true do |t|
    t.string   "nome"
    t.string   "cor"
    t.string   "motor"
    t.string   "chassi"
    t.decimal  "valor"
    t.date     "fabricacao"
    t.text     "observacoes"
    t.integer  "marca_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "carros", ["marca_id"], :name => "index_carros_on_marca_id"

  create_table "cartao_bandeiras", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cartaos", :force => true do |t|
    t.string   "nome",       :limit => 20
    t.boolean  "status"
    t.string   "barra",      :limit => 40
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "status_op",                :default => 0
    t.integer  "venda_id"
  end

  create_table "centro_custos", :force => true do |t|
    t.string   "nome"
    t.boolean  "active",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "unidade_id"
  end

  create_table "chaves", :force => true do |t|
    t.string   "nome"
    t.boolean  "status"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "sigla",      :limit => 6
    t.integer  "persona_id"
  end

  create_table "check_points", :force => true do |t|
    t.integer  "usuario_id"
    t.text     "check_point_hour"
    t.text     "check_point_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "datetime"
    t.datetime "tempo_trabalhado"
    t.integer  "persona_id"
    t.boolean  "import",           :default => false
    t.integer  "produto_id"
    t.datetime "checkpoint"
  end

  create_table "cheque_diferidos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.date     "original"
    t.integer  "tabela_id"
    t.integer  "moeda"
    t.integer  "status"
    t.string   "tabela",          :limit => 150
    t.text     "concepto"
    t.integer  "persona_id"
    t.integer  "conta_id"
    t.string   "conta_nome",      :limit => 150
    t.string   "persona_nome",    :limit => 150
    t.string   "cheque",          :limit => 50
    t.decimal  "entrada_dolar",                  :precision => 15, :scale => 2
    t.decimal  "entrada_guarani",                :precision => 15, :scale => 2
    t.decimal  "saida_dolar",                    :precision => 15, :scale => 2
    t.decimal  "saida_guarani",                  :precision => 15, :scale => 2
    t.date     "depositado"
    t.string   "banco",           :limit => 180
    t.string   "titular",         :limit => 150
    t.integer  "estado"
    t.decimal  "saida_real",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrada_real",                   :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "cidade_areas", :force => true do |t|
    t.integer  "cidade_id"
    t.string   "nome"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cidades", :force => true do |t|
    t.string   "nome"
    t.integer  "estado_id"
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "paise_id"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "regiao_id"
    t.integer  "populacao"
    t.integer  "cmunfg"
    t.integer  "distrito_id"
    t.integer  "api_id"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["type"], :name => "index_ckeditor_assets_on_type"

  create_table "clase_tabela_precos", :force => true do |t|
    t.integer  "clase_id"
    t.integer  "tabela_preco_id"
    t.integer  "unidade_id"
    t.decimal  "perc",            :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  create_table "clases", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "descricao",       :limit => 100
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "cod_impl"
    t.decimal  "desc_compra_01",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desc_compra_02",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desc_compra_03",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "max_desc",                       :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "clientes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "tabela_id"
    t.string   "tabela",              :limit => 200
    t.date     "vencimento"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.integer  "venda_id"
    t.string   "documento_nome",      :limit => 100
    t.string   "documento_numero",    :limit => 100
    t.integer  "cota",                                                              :default => 0
    t.date     "data"
    t.date     "original"
    t.decimal  "divida_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "divida_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.date     "recebido"
    t.decimal  "cobro_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cobro_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "liquidacao"
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 150
    t.string   "cheque",              :limit => 150
    t.date     "diferido"
    t.string   "tipo",                :limit => 20
    t.integer  "conta_created"
    t.integer  "conta_updated"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "cobro_id"
    t.integer  "estado"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "numero_ordem"
    t.integer  "documento_id"
    t.decimal  "desconto_dolar",                     :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                   :precision => 15, :scale => 2
    t.decimal  "interes_dolar",                      :precision => 15, :scale => 2
    t.decimal  "interes_guarani",                    :precision => 15, :scale => 2
    t.integer  "clase_produto"
    t.integer  "moeda"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",       :limit => 150
    t.integer  "pagare"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.string   "local_pago",          :limit => 1
    t.integer  "cod_proc"
    t.string   "sigla_proc",          :limit => 3
    t.decimal  "divida_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cobro_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.text     "descricao"
    t.decimal  "desconto_real",                      :precision => 15, :scale => 0, :default => 0
    t.decimal  "interes_real",                       :precision => 15, :scale => 0, :default => 0
    t.integer  "saca",                :limit => 2
    t.string   "saca_prod",           :limit => 150
    t.decimal  "saca_preco_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saca_preco_gs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saca_preco_rs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saca_qtd",                           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "unidade_id"
    t.string   "chapa",               :limit => 20
    t.string   "ordem_carga",         :limit => 20
    t.integer  "centro_custo_id"
    t.integer  "forma_pago_id"
    t.integer  "tot_cotas"
    t.integer  "rubro_id"
    t.decimal  "saldo_gs",                           :precision => 15, :scale => 2
    t.decimal  "saldo_us",                           :precision => 15, :scale => 2
    t.decimal  "saldo_rs",                           :precision => 15, :scale => 2
    t.boolean  "finan",                                                             :default => false
    t.string   "titulo",              :limit => 50
  end

  add_index "clientes", ["data", "persona_id", "unidade_id", "liquidacao"], :name => "find_cliente"

  create_table "cobracas", :force => true do |t|
    t.date     "data"
    t.date     "vencimento"
    t.integer  "responsavel_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "cobrancas", :force => true do |t|
    t.date     "data"
    t.decimal  "cotacao",                         :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",     :limit => 150
    t.string   "persona_ruc",      :limit => 50
    t.string   "persona_telefone", :limit => 50
    t.integer  "moeda"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cobro_nc_fts", :force => true do |t|
    t.date     "data"
    t.integer  "cobro_id"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",    :limit => 200
    t.string   "fatura_01",       :limit => 4
    t.string   "fatura_02",       :limit => 4
    t.string   "fatura",          :limit => 10
    t.decimal  "fatura_valor_us",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "fatura_valor_gs",                :precision => 15, :scale => 2, :default => 0.0
    t.string   "nota_01",         :limit => 4
    t.string   "nota_02",         :limit => 4
    t.string   "nota",            :limit => 10
    t.decimal  "nota_valor_us",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "nota_valor_gs",                  :precision => 15, :scale => 2, :default => 0.0
    t.integer  "nota_moeda"
    t.integer  "fatura_moeda"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cobros", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 150
    t.string   "cheque",              :limit => 100
    t.date     "diferido"
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "moeda"
    t.string   "ruc",                 :limit => 100
    t.string   "documento_nome",      :limit => 150
    t.integer  "documento_id"
    t.string   "descricao"
    t.integer  "persona_cod"
    t.integer  "adelanto_id"
    t.integer  "adelanto",                                                          :default => 0
    t.integer  "clase_produto"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",       :limit => 150
    t.string   "documento_numero_02", :limit => 50
    t.string   "documento_numero_01", :limit => 50
    t.string   "documento_numero",    :limit => 100
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 0, :default => 0
    t.integer  "servico_id"
    t.string   "servico_noma"
    t.integer  "setor_id"
    t.string   "setor_nome"
    t.integer  "venda_id"
    t.integer  "unidade_id"
    t.decimal  "cotacao_rs_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.boolean  "op",                                                                :default => false
    t.integer  "cliente_id"
    t.integer  "terminal_id"
    t.integer  "tot_cotas"
  end

  create_table "cobros_adelantos", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.integer  "liquidacao"
    t.string   "documento_numero_01", :limit => 10
    t.string   "documento_numero_02", :limit => 10
    t.string   "documento_numero",    :limit => 50
    t.integer  "cota"
    t.integer  "moeda"
    t.decimal  "valor_us",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",                          :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.integer  "cobro_id"
  end

  create_table "cobros_detalhes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "cobro_id"
    t.date     "vencimento"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 150
    t.integer  "cota"
    t.date     "data"
    t.decimal  "cobro_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cobro_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "liquidacao"
    t.decimal  "anterior_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "anterior_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "estado"
    t.integer  "venda_id"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.decimal  "desconto_dolar",                     :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                   :precision => 15, :scale => 2
    t.decimal  "interes_dolar",                      :precision => 15, :scale => 2
    t.decimal  "interes_guarani",                    :precision => 15, :scale => 2
    t.integer  "clase_produto"
    t.integer  "moeda"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",       :limit => 150
    t.integer  "pagare"
    t.integer  "interes",             :limit => 2,                                  :default => 0
    t.decimal  "cobro_real",                         :precision => 15, :scale => 0, :default => 0
    t.decimal  "anterior_real",                      :precision => 15, :scale => 0, :default => 0
    t.decimal  "saldo_real",                         :precision => 15, :scale => 0, :default => 0
    t.decimal  "valor_real",                         :precision => 15, :scale => 0, :default => 0
    t.decimal  "interes_real",                       :precision => 15, :scale => 0, :default => 0
    t.decimal  "desconto_real",                      :precision => 15, :scale => 0, :default => 0
    t.date     "data_lanz"
    t.decimal  "dif_cambio_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "dif_cambio_gs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "dif_cambio_rs",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tot_cotas"
    t.integer  "centro_custo_id"
    t.decimal  "saldo_perc",                         :precision => 15, :scale => 2
  end

  create_table "cobros_financas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conta_id"
    t.string   "conta_nome",           :limit => 150
    t.integer  "persona_id"
    t.string   "persona_nome",         :limit => 200
    t.text     "descricao"
    t.date     "data"
    t.decimal  "valor_dolar",                         :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                       :precision => 15, :scale => 2
    t.integer  "documento_id"
    t.string   "documento_nome",       :limit => 150
    t.string   "documento_numero",     :limit => 50
    t.string   "cheque",               :limit => 50
    t.date     "diferido"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "cobro_id"
    t.integer  "moeda"
    t.string   "titular",              :limit => 150
    t.string   "banco",                :limit => 180
    t.string   "numero_recibo",        :limit => 50
    t.decimal  "valor_cheque_dolar",                  :precision => 15, :scale => 2
    t.decimal  "valor_cheque_guarani",                :precision => 15, :scale => 2
    t.decimal  "vuelto_dolar",                        :precision => 15, :scale => 2
    t.decimal  "vuelto_guarani",                      :precision => 15, :scale => 2
    t.string   "conta_vuelto_nome",    :limit => 150
    t.integer  "conta_vuelto_id"
    t.string   "cheque_vuelto",        :limit => 50
    t.date     "diferido_vuelto"
    t.decimal  "retencion_dolar",                     :precision => 15, :scale => 2
    t.decimal  "retencion_guarani",                   :precision => 15, :scale => 2
    t.decimal  "valor_vuelto_guarani",                :precision => 15, :scale => 2
    t.decimal  "valor_vuelto_dolar",                  :precision => 15, :scale => 2
    t.string   "documento_numero_02",  :limit => 50
    t.string   "documento_numero_01",  :limit => 50
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",        :limit => 150
    t.integer  "vuelto_cheque_status"
    t.decimal  "cheque_valor_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cheque_valor_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cheque_status"
    t.integer  "vuelto"
    t.integer  "vuelto_conta_id"
    t.string   "vuelto_conta_nome",    :limit => 150
    t.string   "vuelto_cheque",        :limit => 100
    t.date     "vuelto_diferido"
    t.decimal  "vuelto_valor_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "vuelto_valor_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real",                          :precision => 15, :scale => 0, :default => 0
    t.decimal  "vuelto_valor_real",                   :precision => 15, :scale => 0, :default => 0
    t.decimal  "cheque_valor_real",                   :precision => 15, :scale => 0, :default => 0
    t.integer  "banco_id"
    t.integer  "forma_pago_id"
    t.integer  "cred_deb",             :limit => 2
    t.integer  "cartao_bandeira_id"
    t.integer  "nr_comprovante"
  end

  create_table "comissaos", :force => true do |t|
    t.date     "data"
    t.date     "data_lib"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome", :limit => 150
    t.integer  "persona_id"
    t.string   "persona_nome",  :limit => 150
    t.integer  "tabela_id"
    t.string   "tabela",        :limit => 150
    t.decimal  "vd_valor_us",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "vd_valor_gs",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "vd_valor_rs",                  :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "cb_valor_us",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cb_valor_gs",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cb_valor_rs",                  :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "ad_valor_us",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ad_valor_gs",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ad_valor_rs",                  :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "dv_valor_us",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "dv_valor_gs",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "dv_valor_rs",                  :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "comissao",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "valor_comi_us",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_comi_gs",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_comi_rs",                :precision => 15, :scale => 2, :default => 0.0
    t.string   "proc",          :limit => 5
    t.integer  "proc_cod"
    t.integer  "status",                                                      :default => 0
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
  end

  create_table "comites", :force => true do |t|
    t.string   "nome",       :limit => 150
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "compra_produto_grades", :force => true do |t|
    t.integer  "compra_id"
    t.integer  "compras_produto_id"
    t.integer  "produto_id"
    t.integer  "cor_id"
    t.integer  "tamanho_id"
    t.decimal  "quantidade"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "compras", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_id"
    t.date     "data"
    t.integer  "persona_id"
    t.string   "persona_nome",             :limit => 200
    t.integer  "tipo"
    t.decimal  "cotacao",                                 :precision => 15, :scale => 2
    t.integer  "tipo_compra"
    t.integer  "moeda"
    t.decimal  "frete_dolar",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "frete_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.string   "numero_envoce",            :limit => 50
    t.decimal  "iva_total_dolar",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_total_guarani",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_dolar",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_guarani",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "seguro_dolar",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "seguro_guarani",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_despacho_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_despacho_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.integer  "despachante_id"
    t.string   "despachante_nome",         :limit => 200
    t.string   "persona_ruc",              :limit => 100
    t.integer  "documento_id"
    t.string   "documento_nome",           :limit => 200
    t.string   "documento_numero",         :limit => 100
    t.string   "documento_numero_01",      :limit => 5
    t.string   "documento_numero_02",      :limit => 5
    t.string   "documento_timbrado",       :limit => 100
    t.integer  "conta_id"
    t.string   "conta_nome",               :limit => 200
    t.string   "cheque",                   :limit => 100
    t.decimal  "total_dolar",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_dolar_01",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_01",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_cota_01"
    t.decimal  "cota_dolar_02",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_02",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_cota_02"
    t.decimal  "cota_dolar_03",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_03",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_dolar_04",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_04",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_cota_04"
    t.decimal  "cota_dolar_05",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_05",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_cota_05"
    t.decimal  "cota_dolar_06",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_06",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_cota_06"
    t.date     "data_cota_03"
    t.decimal  "gravadas_10_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "diferido"
    t.integer  "cota_dolar",                                                             :default => 0
    t.integer  "cota_guarani",                                                           :default => 0
    t.integer  "entrega_dolar",                                                          :default => 0
    t.integer  "entrega_guarani",                                                        :default => 0
    t.integer  "plano_de_conta_id"
    t.integer  "plano_de_conta_descricao"
    t.integer  "rubro_id"
    t.string   "rubro_descricao"
    t.string   "rubro_cod_contabil"
    t.string   "descricao"
    t.integer  "sueldo_id"
    t.integer  "adcionais"
    t.integer  "empregado_id"
    t.string   "empregado_nome",           :limit => 150
    t.integer  "tabela_id"
    t.string   "tabela",                   :limit => 150
    t.integer  "clase_produto",                                                          :default => 0
    t.integer  "rodado_id"
    t.string   "rodado_nome",              :limit => 150
    t.integer  "tipo_gasto"
    t.integer  "status"
    t.string   "ob_ref",                   :limit => 10
    t.decimal  "cotacao_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_real",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_real",                           :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_financa"
    t.decimal  "qtd",                                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_rs_us",                           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "km",                                                                     :default => 0
    t.integer  "colecao_id"
    t.integer  "sub_grupo_id"
    t.decimal  "ajuste_us",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ajuste_gs",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ajuste_rs",                               :precision => 15, :scale => 2, :default => 0.0
    t.integer  "pedido",                   :limit => 2
    t.integer  "mostruario",               :limit => 2
    t.integer  "mult_docs",                :limit => 2,                                  :default => 0
    t.integer  "sueldo_pago_id"
    t.boolean  "op",                                                                     :default => false
    t.integer  "centro_custo_id"
    t.date     "competencia"
    t.integer  "rubro_grupo_id"
    t.integer  "retencao"
    t.string   "retencao_numero_01",       :limit => 5
    t.string   "retencao_numero_02",       :limit => 5
    t.string   "retencao_numero",          :limit => 20
    t.decimal  "retencao_us",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "retencao_gs",                             :precision => 15, :scale => 2, :default => 0.0
    t.integer  "classif_bens"
    t.decimal  "valor_real_ben_us",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real_ben_gs",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real_ben_rs",                       :precision => 15, :scale => 2, :default => 0.0
    t.string   "sigla_proc",               :limit => 6
    t.integer  "tipo_rateio",                                                            :default => 0
    t.decimal  "outros_real",                             :precision => 15, :scale => 2, :default => 0.0
    t.date     "venc_timbrado"
    t.integer  "fiscal",                                                                 :default => 0
    t.integer  "maiorista_id"
    t.integer  "franquiado_id"
    t.integer  "despacho_id"
    t.decimal  "imponible_us",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imponible_gs",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "proveedore_id",                                                          :default => 0
    t.integer  "prov_gasto_id",                                                          :default => 0
    t.integer  "cota",                                                                   :default => 0
    t.integer  "funcionario_id"
    t.integer  "forma_pago_id"
    t.decimal  "cotacao_eu_us",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_eu_gs",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "frete_euro",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "seguro_euro",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_euro",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_euro",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_euro",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "contrato_id"
    t.boolean  "repasse",                                                                :default => false
    t.date     "vencimento"
    t.integer  "producao_id"
    t.integer  "safra_id"
    t.integer  "controle_caixa"
  end

  add_index "compras", ["data", "tipo_compra"], :name => "compras_data_tipo_compra_idx"

  create_table "compras_custos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "compra_id"
    t.integer  "moeda"
    t.date     "data"
    t.date     "competencia"
    t.integer  "centro_custo_id"
    t.integer  "rubro_id"
    t.integer  "rubro_grupo_id"
    t.decimal  "valor_us",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "compras_produto_id"
    t.integer  "compras_financa_id"
    t.integer  "unidade_id"
    t.integer  "plano_de_conta_id"
  end

  create_table "compras_depre_apres", :force => true do |t|
    t.integer  "compra_id"
    t.integer  "anos"
    t.integer  "moeda"
    t.decimal  "depre_us",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "depre_gs",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "depre_rs",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "apre_us",            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "apre_gs",            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "apre_rs",            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "compras_produto_id"
    t.date     "data"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.integer  "mes"
    t.integer  "rubro_id"
    t.decimal  "valor_mensal_us",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_mensal_gs",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_mensal_rs",    :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "compras_documentos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "compra_id"
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 100
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "persona_ruc",         :limit => 200
    t.string   "persona_timbrado",    :limit => 200
    t.date     "data"
    t.integer  "moeda_id"
    t.decimal  "exentas_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "contabilidade_id"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "tipo"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "tipo_documento",      :limit => 50
    t.integer  "moeda"
    t.string   "documento_numero_01", :limit => 5,                                  :default => "1"
    t.string   "documento_numero_02", :limit => 5,                                  :default => "1"
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => nil
    t.string   "cheque",              :limit => 100
    t.string   "tabela",              :limit => 200
    t.integer  "tabela_id"
    t.integer  "tipo_compra"
    t.integer  "clase_produto"
    t.integer  "rubro_id"
    t.string   "rubro_nome",          :limit => 150
    t.decimal  "exentas_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_real",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_real",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_real",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_real",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.text     "obs"
  end

  create_table "compras_empaques", :force => true do |t|
    t.integer  "compra_id"
    t.integer  "produtos_grade_id"
    t.integer  "compras_produto_id"
    t.integer  "produto_id"
    t.string   "barra",              :limit => 150
    t.decimal  "quantidade",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_gs",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_alterado_gs",                 :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.decimal  "custo_gs",                          :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "compras_empaques", ["compra_id", "produtos_grade_id", "quantidade"], :name => "busca_compra"

  create_table "compras_financas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "compra_id"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "persona_ruc",         :limit => 100
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 200
    t.string   "documento_numero",    :limit => 100
    t.date     "data"
    t.integer  "moeda"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo"
    t.date     "vencimento"
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 200
    t.string   "cheque",              :limit => 100
    t.integer  "cota"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "tabela",              :limit => 200
    t.integer  "tabela_id"
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "entrega_dolar"
    t.integer  "entrega_guarani"
    t.date     "diferido"
    t.string   "descricao"
    t.integer  "clase_produto"
    t.integer  "tipo_compra"
    t.integer  "cod_viatico"
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cheque_status",       :limit => 2
    t.integer  "banco_id"
    t.string   "titular",             :limit => nil
    t.integer  "forma_pago_id"
    t.string   "fact_an"
    t.string   "fact_an_01"
    t.string   "fact_an_02"
    t.integer  "cred_deb",                                                          :default => 0
    t.integer  "fact_an_cota",                                                      :default => 0
    t.decimal  "valor_euro",                         :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "compras_gastos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "compra_id"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_id"
    t.date     "data"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.integer  "tipo"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "tipo_compra"
    t.integer  "moeda"
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.integer  "rubro_id"
    t.string   "rubro_descricao"
    t.string   "rubro_cod_contabil"
    t.integer  "tabela_id"
    t.string   "tabela",              :limit => 150
    t.integer  "clase_produto"
    t.decimal  "exentas_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_real",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_real",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_real",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_real",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_real",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_real",                         :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "compras_pedidos", :force => true do |t|
    t.integer  "pedido_compra_id"
    t.integer  "compra_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "compras_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "produto_id"
    t.integer  "compra_id"
    t.string   "produto_nome",              :limit => 200
    t.decimal  "unitario_dolar",                           :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "unitario_guarani",                         :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "total_dolar",                              :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "total_guarani",                            :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "iva_taxa",                                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_dolar",                                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_contabil_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_contabil_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "deposito_id"
    t.string   "deposito_nome",             :limit => 200
    t.decimal  "frete_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "cotacao"
    t.string   "fabricante_cod",            :limit => 50
    t.string   "codigo",                    :limit => 50
    t.integer  "moeda"
    t.decimal  "despacho_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "frete_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcentagem_produto",                      :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "iva_total_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_total_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_dolar",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_dolar_iva",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_guarani_iva",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.decimal  "quantidade",                               :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "seguro_dolar",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "seguro_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_despacho_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_despacho_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcentagem",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo_compra"
    t.integer  "persona_id"
    t.string   "persona_nome",              :limit => 200
    t.integer  "porcen_minorista",                                                        :default => 0
    t.integer  "porcen_maiorista",                                                        :default => 0
    t.integer  "porcen_balcao",                                                           :default => 0
    t.integer  "clase_produto"
    t.decimal  "preco_maiorista_dolar",                    :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "porc_maiorista",                           :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "preco_maiorista_guarani",                  :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "porc_minorista",                           :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "preco_minorista_dolar",                    :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "preco_minorista_guarani",                  :precision => 15, :scale => 3, :default => 0.0
    t.integer  "status"
    t.decimal  "custo_dolar",                              :precision => 15, :scale => 2
    t.decimal  "custo_guarani",                            :precision => 15, :scale => 2
    t.decimal  "cotacao_real",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ultimo_custo_us",                          :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "ultimo_custo_gs",                          :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "ultimo_custo_rs",                          :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "unitario_real",                            :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "iva_real",                                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_real",                               :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "custo_contabil_real",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "frete_real",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_total_real",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "otros_real",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_real_iva",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "seguro_real",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_despacho_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_maiorista_real",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_minorista_real",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_real",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ultimo_custo_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cor_id"
    t.integer  "tamanho_id"
    t.integer  "produtos_grade_id"
    t.integer  "colecao_id"
    t.string   "cor_nome",                  :limit => 200
    t.string   "tamanho_nome",              :limit => 200
    t.string   "colecao_nome",              :limit => 200
    t.integer  "unidade_id"
    t.integer  "tipo_busca",                :limit => 2,                                  :default => 0
    t.integer  "rubro_id"
    t.string   "rubro_codigo",              :limit => 50
    t.string   "rubro_nome",                :limit => 200
    t.integer  "pedido_compra_id"
    t.integer  "pedido_compra_produto_id"
    t.string   "barra",                     :limit => 150
    t.integer  "apre_depre"
    t.integer  "anos"
    t.decimal  "porcen",                                   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "rodado_id"
    t.decimal  "valor_real_ben_us",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real_ben_gs",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real_ben_rs",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real_gs",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "peso_bruto",                               :precision => 15, :scale => 3, :default => 0.0
    t.integer  "compras_pedido_id"
    t.decimal  "promedio_gs",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_us",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_euro",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_euro",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_euro",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "frete_euro",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "seguro_euro",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_euro",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_euro",                            :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "compras_produtos", ["compra_id", "pedido_compra_id", "pedido_compra_produto_id", "quantidade"], :name => "busca_compra_produtos"

  create_table "cond_liq_docs", :force => true do |t|
    t.integer  "cond_liq_id"
    t.integer  "condicional_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "cond_liq_financas", :force => true do |t|
    t.integer  "cond_liq_id"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 100
    t.integer  "tipo",                :limit => 2
    t.integer  "moeda",               :limit => 2
    t.decimal  "valor_us",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.date     "diferido"
    t.integer  "cota"
    t.string   "cheque",              :limit => 20
    t.string   "obs",                 :limit => 300
    t.string   "documento_numero",    :limit => 100
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.integer  "fatura",              :limit => 2
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 100
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
    t.date     "vencimento"
  end

  create_table "cond_liq_produtos", :force => true do |t|
    t.date     "data"
    t.integer  "cond_liq_id"
    t.integer  "condicional_produto_id"
    t.integer  "produto_id"
    t.string   "produto_nome"
    t.integer  "colecao_id"
    t.string   "colecao_nome"
    t.integer  "cor_id"
    t.string   "cor_nome"
    t.integer  "tamanho_id"
    t.string   "tamanho_nome"
    t.string   "fabricante_cod"
    t.decimal  "quantidade"
    t.decimal  "unitario_us"
    t.decimal  "unitario_gs"
    t.decimal  "total_us"
    t.decimal  "total_gs"
    t.integer  "deposito_id"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "produtos_grade_id"
    t.datetime "created_at",                                                                          :null => false
    t.datetime "updated_at",                                                                          :null => false
    t.integer  "sub_grupo_id"
    t.decimal  "saldo",                               :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "persona_id"
    t.integer  "tipo_busca",             :limit => 2,                                :default => 0
    t.integer  "condicional_id"
  end

  create_table "cond_liq_vendidos", :force => true do |t|
    t.integer  "tipo"
    t.date     "data"
    t.integer  "cond_liq_id"
    t.integer  "condicional_produto_id"
    t.integer  "produto_id"
    t.string   "produto_nome"
    t.integer  "colecao_id"
    t.string   "colecao_nome"
    t.integer  "cor_id"
    t.string   "cor_nome"
    t.integer  "tamanho_id"
    t.string   "tamanho_nome"
    t.string   "fabricante_cod"
    t.decimal  "quantidade"
    t.decimal  "unitario_us"
    t.decimal  "unitario_gs"
    t.decimal  "total_us"
    t.decimal  "total_gs"
    t.integer  "deposito_id"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "produtos_grade_id"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.integer  "sub_grupo_id"
    t.decimal  "saldo",                  :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "persona_id"
    t.integer  "condicional_id"
  end

  create_table "cond_liqs", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.text     "obs"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "unidade_id"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "moeda"
    t.integer  "status",          :default => 0
    t.integer  "vendedor_id"
    t.integer  "venda_id"
  end

  create_table "condicional_produtos", :force => true do |t|
    t.date     "data"
    t.integer  "condicional_id"
    t.integer  "produto_id"
    t.string   "produto_nome"
    t.integer  "colecao_id"
    t.string   "colecao_nome"
    t.integer  "cor_id"
    t.string   "cor_nome"
    t.integer  "tamanho_id"
    t.string   "tamanho_nome"
    t.string   "fabricante_cod"
    t.decimal  "quantidade"
    t.decimal  "unitario_us"
    t.decimal  "unitario_gs"
    t.decimal  "total_us"
    t.decimal  "total_gs"
    t.integer  "deposito_id"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "produtos_grade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sub_grupo_id"
    t.decimal  "saldo",                          :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "persona_id"
    t.integer  "tipo_busca",        :limit => 2,                                :default => 0
  end

  create_table "condicionals", :force => true do |t|
    t.integer  "persona_id"
    t.date     "data"
    t.decimal  "cotacao",                     :precision => 15, :scale => 2, :default => 0.0
    t.date     "prazo"
    t.text     "obs"
    t.integer  "moeda"
    t.integer  "vendedor_id"
    t.integer  "unidade_id"
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
    t.integer  "tabela_preco"
    t.string   "persona_nome", :limit => 150
    t.integer  "status",       :limit => 2,                                  :default => 0
  end

  create_table "conferencia_produtos", :force => true do |t|
    t.integer  "conferencia_id"
    t.integer  "produto_id"
    t.integer  "produtos_grade_id"
    t.string   "produto_nome",      :limit => 150
    t.string   "fabricante_cod",    :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "quantidade",                       :precision => 15, :scale => 2, :default => 0.0
    t.string   "doca",              :limit => 50
    t.integer  "usuario_created"
    t.string   "barra",             :limit => 50
    t.decimal  "saldo_anterior",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_medio_us",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_medio_gs",                   :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "conferencias", :force => true do |t|
    t.date     "data"
    t.integer  "unidade_id"
    t.integer  "sub_grupo_id"
    t.text     "obs"
    t.string   "ubicacao",     :limit => 100
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "deposito_id"
    t.integer  "grupo_id"
    t.integer  "clase_id"
    t.integer  "moeda"
  end

  create_table "config_contabils", :force => true do |t|
    t.string   "tabela",           :limit => 50
    t.integer  "rubro_id"
    t.string   "rubro_nome",       :limit => 50
    t.string   "rubro_codigo",     :limit => 100
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "rubro_deb_id"
    t.string   "rubro_deb_nome",   :limit => 50
    t.string   "rubro_deb_codigo", :limit => 50
    t.integer  "rubro_cre_id"
    t.string   "rubro_cre_nome",   :limit => 50
    t.string   "rubro_cre_codigo", :limit => 50
  end

  create_table "config_forms", :force => true do |t|
    t.integer  "tipo_form"
    t.integer  "modelo"
    t.integer  "m_data"
    t.integer  "data_x",                      :default => 0
    t.integer  "data_y",                      :default => 0
    t.integer  "dia_x",                       :default => 0
    t.integer  "dia_y",                       :default => 0
    t.integer  "mes_x",                       :default => 0
    t.integer  "mes_y",                       :default => 0
    t.integer  "ano_x",                       :default => 0
    t.integer  "ano_y",                       :default => 0
    t.integer  "n_fatura_x",                  :default => 0
    t.integer  "n_fatura_y",                  :default => 0
    t.integer  "cred_x",                      :default => 0
    t.integer  "cred_y",                      :default => 0
    t.integer  "cont_x",                      :default => 0
    t.integer  "cont_y",                      :default => 0
    t.integer  "cliente_x",                   :default => 0
    t.integer  "cliente_y",                   :default => 0
    t.integer  "ruc_x",                       :default => 0
    t.integer  "ruc_y",                       :default => 0
    t.integer  "direcao_x",                   :default => 0
    t.integer  "direcao_y",                   :default => 0
    t.integer  "telefone_x",                  :default => 0
    t.integer  "telefone_y",                  :default => 0
    t.integer  "box_produto_x",               :default => 0
    t.integer  "box_produto_y",               :default => 0
    t.integer  "sub_tot_ext_x",               :default => 0
    t.integer  "sub_tot_ext_y",               :default => 0
    t.integer  "sub_tot_05_x",                :default => 0
    t.integer  "sub_tot_05_y",                :default => 0
    t.integer  "sub_tot_10_x",                :default => 0
    t.integer  "sub_tot_10_y",                :default => 0
    t.integer  "en_letras_x",                 :default => 0
    t.integer  "en_letras_y",                 :default => 0
    t.integer  "iva_05_x",                    :default => 0
    t.integer  "iva_05_y",                    :default => 0
    t.integer  "iva_10_x",                    :default => 0
    t.integer  "iva_10_y",                    :default => 0
    t.integer  "tot_iva_x",                   :default => 0
    t.integer  "tot_iva_y",                   :default => 0
    t.integer  "tot_x",                       :default => 0
    t.integer  "tot_y",                       :default => 0
    t.integer  "terminal_id"
    t.integer  "unidade_id"
    t.text     "obs"
    t.string   "nome",          :limit => 50
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "space_01",                    :default => 0
    t.integer  "space_02",                    :default => 0
    t.integer  "obs_x",                       :default => 0
    t.integer  "obs_y",                       :default => 0
    t.integer  "os_x",                        :default => 0
    t.integer  "os_y",                        :default => 0
    t.integer  "venc_x",                      :default => 0
    t.integer  "venc_y",                      :default => 0
  end

  create_table "config_printers", :force => true do |t|
    t.string   "processo"
    t.string   "printer"
    t.integer  "ordem"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "descricao",  :limit => nil
    t.string   "modelo",     :limit => nil
  end

  create_table "consumicao_interna_produtos", :force => true do |t|
    t.integer  "consumicao_interna_id"
    t.decimal  "cotacao",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.integer  "produto_id"
    t.string   "produto_nome",          :limit => 200
    t.integer  "deposito_id"
    t.string   "deposito_nome",         :limit => 200
    t.decimal  "quantidade",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "taxa",                                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_dolar",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                          :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "produtos_grade_id"
    t.integer  "cor_id"
    t.integer  "tamanho_id"
    t.string   "cor_nome",              :limit => 150
    t.string   "tamanho_nome",          :limit => 150
    t.integer  "tipo_busca",            :limit => 2
    t.string   "fabricante_cod",        :limit => 150
    t.decimal  "saldo",                                :precision => 15, :scale => 2
  end

  create_table "consumicao_internas", :force => true do |t|
    t.decimal  "cotacao",                        :precision => 15, :scale => 2, :default => 0.0
    t.string   "concepto",        :limit => 250
    t.date     "data"
    t.integer  "moeda"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",   :limit => 150
    t.decimal  "total_dolar",                    :precision => 15, :scale => 2
    t.decimal  "total_guarani",                  :precision => 15, :scale => 2
    t.integer  "setor_id"
    t.string   "setor_nome",      :limit => 120
    t.integer  "servico_id"
    t.string   "servico_nome",    :limit => 120
    t.integer  "sub_grupo_id"
    t.integer  "colecao_id"
    t.integer  "unidade_id"
    t.integer  "persona_id"
    t.integer  "tipo_economico"
    t.string   "persona_nome",    :limit => 150
    t.integer  "motivo_id"
  end

  create_table "conta", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "conta_cheques", :force => true do |t|
    t.integer  "conta_id"
    t.integer  "numero"
    t.text     "obs"
    t.integer  "status",     :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "contas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "nome",              :limit => 200
    t.string   "numero",            :limit => 100
    t.string   "direcao",           :limit => 200
    t.integer  "unidade_id"
    t.integer  "tipo"
    t.string   "encarregado",       :limit => 100
    t.integer  "cidade_id"
    t.string   "cidade",            :limit => 200
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "cod_contabil",      :limit => 50
    t.integer  "rubro_id"
    t.string   "rubro_nome"
    t.integer  "moeda"
    t.integer  "venda",             :limit => 2
    t.integer  "terminal_id"
    t.integer  "ordem",                            :default => 0
    t.boolean  "tesouraria",                       :default => false
    t.boolean  "status"
    t.integer  "centro_custo_id"
    t.boolean  "modal"
    t.integer  "persona_id"
    t.boolean  "consolidado",                      :default => false
    t.boolean  "consolidado_modal",                :default => false
    t.integer  "forma_pago_id"
  end

  create_table "contas_forma_pagos", :force => true do |t|
    t.integer  "conta_id"
    t.integer  "forma_pago_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contas_usuarios", :force => true do |t|
    t.integer  "conta_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contrato_custo_dts", :force => true do |t|
    t.integer  "contrato_id"
    t.date     "data"
    t.integer  "persona_id"
    t.decimal  "valor_rs",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_us",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",          :precision => 15, :scale => 2, :default => 0.0
    t.integer  "contrato_custo_id"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
  end

  create_table "contrato_custos", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "tipo"
    t.integer  "moeda"
    t.decimal  "valor_gs",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_us",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",    :precision => 15, :scale => 2, :default => 0.0
    t.integer  "contrato_id"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.integer  "cargo_id"
  end

  create_table "contrato_financas", :force => true do |t|
    t.integer  "contrato_id"
    t.date     "vencimento"
    t.decimal  "valor_us",    :precision => 15, :scale => 3
    t.decimal  "valor_gs",    :precision => 15, :scale => 3
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "cota"
  end

  add_index "contrato_financas", ["contrato_id"], :name => "index_contrato_financas_on_contrato_id"

  create_table "contrato_servicos", :force => true do |t|
    t.integer  "contrato_id"
    t.integer  "produto_id"
    t.integer  "quantidade",                                 :default => 0
    t.decimal  "unitario_us", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_gs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_rs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_us",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_gs",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_rs",    :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.text     "obs"
    t.integer  "persona_id"
  end

  add_index "contrato_servicos", ["contrato_id"], :name => "index_contrato_servicos_on_contrato_id"
  add_index "contrato_servicos", ["produto_id"], :name => "index_contrato_servicos_on_produto_id"

  create_table "contratos", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "conta_id"
    t.integer  "moeda"
    t.integer  "dia_venc"
    t.integer  "competencia"
    t.decimal  "valor_gs",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_us",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                           :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                                 :null => false
    t.datetime "updated_at",                                                                                 :null => false
    t.text     "obs"
    t.integer  "vendedor_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "tipo",                                                                  :default => 0
    t.integer  "mes_inicio"
    t.integer  "unidade_id"
    t.date     "data_final"
    t.string   "status",                  :limit => 100,                                :default => "Ativo"
    t.integer  "centro_custo_id"
    t.integer  "deposito_id"
    t.date     "data"
    t.integer  "cota_inicio"
    t.string   "documento_numero",        :limit => 100
    t.boolean  "gerar_financas",                                                        :default => true
    t.integer  "terminal_id"
    t.string   "periodicidade",           :limit => 30
    t.integer  "apartamento_id"
    t.integer  "presupuesto_id"
  end

  add_index "contratos", ["persona_id"], :name => "index_contratos_on_persona_id"

  create_table "controle_kms", :force => true do |t|
    t.integer  "rodado_id"
    t.integer  "unidade_id"
    t.integer  "km"
    t.string   "tabela",     :limit => 50
    t.integer  "tabela_id"
    t.integer  "cod_proc"
    t.string   "sigla_proc", :limit => 4
    t.date     "data"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "controle_visita", :force => true do |t|
    t.date     "data"
    t.integer  "consultor_id"
    t.string   "consultor_nome"
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.integer  "servico_id"
    t.string   "servico_nome"
    t.integer  "cidade_id"
    t.string   "cidade_nome"
    t.decimal  "nc"
    t.string   "obs"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "cultivos", :force => true do |t|
    t.string   "nome",       :limit => 150
    t.boolean  "status",                    :default => true
    t.text     "obs"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "deposito_produtos", :force => true do |t|
    t.integer  "produto_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "deposito_id"
  end

  create_table "depositos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "nome",            :limit => 200
    t.integer  "unidade_id"
    t.string   "bairro",          :limit => 200
    t.string   "complemento",     :limit => 300
    t.integer  "cidade_id"
    t.string   "direcao",         :limit => 200
    t.string   "cidade",          :limit => 200
    t.integer  "seta_produto"
    t.decimal  "capacidade",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "minimo",                         :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "dev_cheque_cliente_dts", :force => true do |t|
    t.integer  "dev_cheque_cliente_id"
    t.text     "obs"
    t.decimal  "valor_us",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                            :precision => 15, :scale => 2, :default => 0.0
    t.string   "cheque",                :limit => 20
    t.string   "titula",                :limit => 50
    t.string   "banco",                 :limit => 50
    t.datetime "created_at",                                                                          :null => false
    t.datetime "updated_at",                                                                          :null => false
  end

  create_table "dev_cheque_clientes", :force => true do |t|
    t.date     "data"
    t.decimal  "cotacao",         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",    :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "persona_id"
    t.text     "obs"
    t.integer  "unidade_id"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "conta_id"
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  create_table "dev_cheque_prov_dts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "dev_cheque_provs", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "devices", :force => true do |t|
    t.string   "nome",         :limit => 50
    t.string   "host",         :limit => 50
    t.string   "instance_key", :limit => 50
    t.string   "token",        :limit => 50
    t.string   "id_control",   :limit => 50
    t.string   "webhook",      :limit => 100
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "diario_debes", :force => true do |t|
    t.integer  "diario_id"
    t.date     "data"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2
    t.decimal  "valor_dolar",                    :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                  :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",    :limit => 150
    t.integer  "produto_id"
    t.string   "produto_nome",    :limit => 250
    t.integer  "unidade_id"
    t.string   "unidade_nome",    :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tabela_id"
    t.string   "tabela_nome",     :limit => 150
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.string   "contabilidade",   :limit => 50
    t.string   "descricao",       :limit => 150
    t.integer  "rubro_id"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "status"
  end

  add_index "diario_debes", ["contabilidade", "data", "diario_id"], :name => "diario_dd"

  create_table "diario_habers", :force => true do |t|
    t.integer  "diario_id"
    t.date     "data"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2
    t.decimal  "valor_dolar",                    :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                  :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",    :limit => 150
    t.integer  "produto_id"
    t.string   "produto_nome",    :limit => 250
    t.integer  "unidade_id"
    t.string   "unidade_nome",    :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tabela_id"
    t.string   "tabela_nome",     :limit => 150
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.string   "contabilidade",   :limit => 50
    t.string   "descricao",       :limit => 150
    t.integer  "rubro_id"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "status"
  end

  add_index "diario_habers", ["descricao", "data", "diario_id"], :name => "diario_dh"

  create_table "diarios", :force => true do |t|
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "numero"
    t.decimal  "debito_dolar",                       :precision => 15, :scale => 2
    t.decimal  "credito_dolar",                      :precision => 15, :scale => 2
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tabela_id"
    t.string   "tabela_nome",         :limit => 150
    t.decimal  "credito_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "debito_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.string   "descricao",           :limit => 600
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.string   "documento_numero",    :limit => 150
    t.integer  "status"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "sigla",               :limit => 10
    t.integer  "moeda"
    t.integer  "unidade_id"
  end

  add_index "diarios", ["tabela_id", "tabela_nome", "data"], :name => "busca_id"

  create_table "dias_uteis", :force => true do |t|
    t.date     "data"
    t.string   "entrada",        :limit => 10
    t.string   "saida",          :limit => 10
    t.string   "almoco_entrada", :limit => 10
    t.string   "almoco_saida",   :limit => 10
    t.text     "obs"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.boolean  "util",                         :default => true
  end

  create_table "distritos", :force => true do |t|
    t.string   "nome"
    t.integer  "departamento_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "estado_id"
    t.integer  "api_id"
    t.text     "cidades_json"
  end

  create_table "documentos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome",            :limit => 200
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "sigla",           :limit => 10
    t.integer  "compra",                         :default => 0
    t.integer  "fiscal",                         :default => 0
    t.integer  "gasto",                          :default => 0
    t.integer  "gastos",                         :default => 0
    t.boolean  "folha",                          :default => false
    t.integer  "processo",                       :default => 0
  end

  create_table "egressos", :force => true do |t|
    t.date     "data"
    t.date     "diferido"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2
    t.integer  "moeda"
    t.integer  "conta_id"
    t.string   "conta_nome",      :limit => 100
    t.integer  "documento_id"
    t.string   "documento_nome",  :limit => 150
    t.decimal  "valor_dolar",                    :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                  :precision => 15, :scale => 2
    t.integer  "rubro_id"
    t.string   "rubro_nome",      :limit => 150
    t.string   "rubro_codigo",    :limit => 50
    t.string   "concepto",        :limit => 200
    t.string   "cheque",          :limit => 50
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "valor_real",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                   :precision => 15, :scale => 0, :default => 0
    t.integer  "clase_produto"
    t.integer  "cheque_status",   :limit => 2
    t.integer  "unidade_id"
    t.integer  "banco_id"
    t.string   "titular",         :limit => 150
    t.integer  "persona_id"
    t.string   "persona_nome",    :limit => 150
  end

  create_table "elementos", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.string   "sigla",      :limit => 20
    t.string   "formula",    :limit => 50
    t.decimal  "fator",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "decimal",                   :precision => 15, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "embalagens", :id => false, :force => true do |t|
    t.integer  "cod_embalagem",                     :null => false
    t.string   "descricao_embalagem", :limit => 40
    t.integer  "capacidade",                        :null => false
    t.string   "exibir_aviso",        :limit => 1,  :null => false
    t.string   "msg_aviso",           :limit => 1
    t.integer  "id",                                :null => false
    t.integer  "persona_id"
    t.integer  "produto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "empaque_produtos", :force => true do |t|
    t.integer  "empaque_id"
    t.integer  "produto_id"
    t.integer  "produtos_grade_id"
    t.integer  "venda_produto_id"
    t.integer  "cor_id"
    t.string   "cor_nome",          :limit => 50
    t.string   "produto_nome",      :limit => 150
    t.integer  "tamanho_id"
    t.string   "tamanho_nome",      :limit => 50
    t.integer  "tipo_busca"
    t.decimal  "quantidade",                       :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
    t.integer  "caixa",                                                           :default => 0
  end

  create_table "empaques", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.integer  "venda_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "unidade_id"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.text     "obs"
    t.integer  "qtd_caixas",                      :default => 0
    t.integer  "enviado",          :limit => 2,   :default => 0
    t.date     "enviado_data"
    t.integer  "trans_id"
    t.string   "trans_nome",       :limit => 200
    t.integer  "responsavel_id"
    t.string   "responsavel_nome", :limit => 200
  end

  create_table "empresas", :force => true do |t|
    t.integer  "base_calc_preco_venda"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "taxa_interes",                           :precision => 15, :scale => 2, :default => 0.0
    t.boolean  "modulo_laboratorio"
    t.boolean  "modulo_producao"
    t.boolean  "modulo_granos"
    t.integer  "venda_persona_id"
    t.string   "venda_persona_nome",      :limit => 150
    t.string   "venda_persona_ruc",       :limit => 20
    t.integer  "venda_moeda"
    t.string   "nome",                    :limit => 150
    t.string   "direcao",                 :limit => 100
    t.string   "ruc",                     :limit => 20
    t.integer  "unidade_id"
    t.integer  "tipo_venda"
    t.integer  "modelo_cadastro_produto"
    t.integer  "tabela_preco_id"
    t.integer  "produto_id"
    t.boolean  "modulo_tintometrico"
    t.decimal  "base_calc_retencao_gs",                  :precision => 15, :scale => 2, :default => 0.0
    t.integer  "segmento",                                                              :default => 0
    t.boolean  "mobile_integration",                                                    :default => false
    t.boolean  "gasto_detalhado",                                                       :default => false
  end

  create_table "entrada_curvas", :force => true do |t|
    t.date     "data"
    t.integer  "amostra_inicio"
    t.integer  "amostra_final"
    t.decimal  "y",              :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "x",              :precision => 15, :scale => 6, :default => 0.0
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "entrada_saida_func_detalhes", :force => true do |t|
    t.integer  "entrada_sainda_func_id"
    t.date     "data"
    t.integer  "ob_ref"
    t.integer  "persona_id"
    t.string   "persona_nome",           :limit => 100
    t.string   "descricao",              :limit => 150
    t.integer  "status"
    t.string   "servico",                :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "responsavel_id"
    t.string   "responsavel_nome",       :limit => 150
    t.string   "persona_doc",            :limit => 50
  end

  create_table "entrada_saida_funcs", :force => true do |t|
    t.date     "data"
    t.integer  "ob_ref"
    t.integer  "produto_id"
    t.string   "produto_nome",     :limit => 100
    t.string   "descricao",        :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "responsavel_id"
    t.string   "responsavel_nome", :limit => 150
  end

  create_table "entrega_vendas", :force => true do |t|
    t.integer  "entrega_id"
    t.integer  "venda_id"
    t.boolean  "status",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "entregas", :force => true do |t|
    t.integer  "tipo",       :default => 0
    t.integer  "persona_id"
    t.integer  "rodado_id"
    t.date     "data"
    t.integer  "unidade_id"
    t.text     "obs"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "status",     :default => 0
  end

  create_table "equipos", :force => true do |t|
    t.string   "descricao",            :limit => 150
    t.string   "sigla",                :limit => 15
    t.integer  "status"
    t.date     "data_calibracao"
    t.date     "prox_data_calibracao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "marca",                :limit => 100
    t.integer  "setor_id"
    t.string   "setor_nome",           :limit => 100
    t.string   "posicao",              :limit => 100
    t.string   "uso",                  :limit => 100
    t.string   "automacao",            :limit => 150
    t.text     "obs"
  end

  create_table "estados", :force => true do |t|
    t.string   "nome"
    t.integer  "paise_id"
    t.string   "pais"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "uf",              :limit => 4
    t.string   "cuf",             :limit => 4
    t.integer  "api_id"
  end

  create_table "etapas", :force => true do |t|
    t.integer  "pipeline_id"
    t.integer  "ordem"
    t.date     "max_data"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "nome",        :limit => 100
  end

  create_table "etiquetas", :force => true do |t|
    t.string   "especie",     :limit => 30
    t.string   "variedade",   :limit => 30
    t.string   "lote",        :limit => 10
    t.string   "categoria",   :limit => 30
    t.string   "origem",      :limit => 10
    t.string   "zaranda",     :limit => 10
    t.string   "germ_min",    :limit => 5
    t.string   "pureza_min",  :limit => 5
    t.date     "validez"
    t.string   "peso_neto",   :limit => 15
    t.string   "ing_respons", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "evento_convidados", :force => true do |t|
    t.integer  "evento_id"
    t.string   "nome",              :limit => 100
    t.string   "doc",               :limit => 50
    t.boolean  "confirmado",                       :default => false
    t.boolean  "presente",                         :default => false
    t.date     "confirmado_data"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "telefone",          :limit => 20
    t.text     "comple"
    t.integer  "venda_id"
    t.integer  "produto_id"
    t.integer  "vendas_produto_id"
    t.integer  "persona_id"
  end

  create_table "faturas", :force => true do |t|
    t.date     "data"
    t.integer  "status"
    t.integer  "moeda"
    t.integer  "tipo"
    t.integer  "tabela_id"
    t.string   "tabela",              :limit => 150
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 250
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "documento_numero",    :limit => 20
    t.decimal  "cotacao",                            :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "exentas_dolar",                      :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "exentas_guarani",                    :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "gravadas_05_dolar",                  :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "gravadas_05_guarani",                :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "imposto_05_dolar",                   :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "imposto_05_guarani",                 :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "gravadas_10_dolar",                  :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "gravadas_10_guarani",                :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "imposto_10_dolar",                   :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "imposto_10_guarani",                 :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "total_dolar",                        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 3, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ruc",                 :limit => 50
  end

  create_table "fechamento_caixa_cheques", :force => true do |t|
    t.date    "data"
    t.date    "diferido"
    t.string  "cheque",              :limit => 50
    t.decimal "cotacao",                            :precision => 15, :scale => 2
    t.integer "moeda"
    t.integer "conta_id"
    t.string  "conta_nome",          :limit => 100
    t.integer "persona_id"
    t.string  "persona_nome",        :limit => 100
    t.string  "titular",             :limit => 150
    t.string  "banco",               :limit => 150
    t.decimal "valor_dolar",                        :precision => 15, :scale => 2
    t.decimal "valor_guarani",                      :precision => 15, :scale => 2
    t.string  "concepto",            :limit => 200
    t.integer "status"
    t.integer "clase_produto"
    t.integer "cheque_status"
    t.decimal "valor_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer "fechamento_caixa_id"
  end

  create_table "fechamento_caixa_dts", :force => true do |t|
    t.integer  "fechamento_caixa_id"
    t.integer  "forma_pago_id"
    t.integer  "moeda"
    t.integer  "cartao_bandeira_id"
    t.decimal  "valor",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_sis",                        :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
    t.integer  "cred_deb",            :limit => 2,                                :default => 0
    t.integer  "conta_origem_id"
    t.integer  "conta_destino_id"
  end

  add_index "fechamento_caixa_dts", ["fechamento_caixa_id"], :name => "index_fecha_cai_dts"

  create_table "fechamento_caixas", :force => true do |t|
    t.integer  "conta_id"
    t.string   "conta_nome",                   :limit => 150
    t.integer  "usuario_id"
    t.string   "usuario_nome",                 :limit => 150
    t.date     "data"
    t.integer  "status"
    t.decimal  "cotacao",                                     :precision => 15, :scale => 2, :default => 0.0
    t.string   "obs",                          :limit => 250
    t.string   "contato01",                    :limit => 150
    t.string   "contato02",                    :limit => 150
    t.string   "contato03",                    :limit => 150
    t.string   "contato04",                    :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "entrada_efetivo_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrada_efetivo_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrada_cheq_dia_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrada_cheq_dia_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.integer  "qtd_entrada_cheq_dia_dolar"
    t.integer  "qtd_entrada_cheq_dia_guarani"
    t.integer  "qtd_entrada_cheq_dif_dolar"
    t.integer  "qtd_entrada_cheq_dif_guarani"
    t.decimal  "entrada_cheq_dif_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrada_cheq_dif_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_efetivo_dolar",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_efetivo_guarani",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_cheq_dia_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_cheq_dia_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "qtd_saida_cheq_dia_dolar"
    t.integer  "qtd_saida_cheq_dia_guarani"
    t.integer  "qtd_saida_cheq_dif_dolar"
    t.integer  "qtd_saida_cheq_dif_guarani"
    t.decimal  "saida_cheq_dif_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_cheq_dif_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "conta_viatico_id"
    t.string   "conta_viatico_nome"
    t.integer  "unidade_id"
    t.integer  "abertura_caixa_id"
    t.boolean  "conferido"
  end

  create_table "fechamento_turnos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.decimal  "inicio",                         :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "final",                          :precision => 15, :scale => 3, :default => 0.0
    t.string   "turno_nome",      :limit => 150
    t.integer  "bomba_id"
    t.string   "bomba_nome",      :limit => 150
    t.integer  "deposito_id"
    t.string   "deposito_nome",   :limit => 150
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "turno_id"
  end

  create_table "financas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "tabela_id"
    t.string   "tabela",              :limit => 150
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 200
    t.date     "data"
    t.decimal  "entrada_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.integer  "compra_id"
    t.date     "vencimento"
    t.string   "cheque",              :limit => 100
    t.decimal  "entrada_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "venda_id"
    t.string   "documento_nome",      :limit => 100
    t.string   "documento_numero",    :limit => 100
    t.integer  "tipo"
    t.date     "diferido"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.integer  "documento_id"
    t.integer  "estado"
    t.text     "concepto"
    t.integer  "moeda"
    t.date     "original"
    t.integer  "status"
    t.string   "titular",             :limit => 150
    t.string   "banco",               :limit => 180
    t.integer  "cheque_status",                                                     :default => 0
    t.date     "depositado"
    t.integer  "cod_processo"
    t.string   "ob_ref"
    t.decimal  "entrada_real",                       :precision => 15, :scale => 2
    t.decimal  "saida_real",                         :precision => 15, :scale => 2
    t.date     "data_conciliacao"
    t.integer  "cod_proc"
    t.string   "sigla_proc",          :limit => 6
    t.integer  "forma_pago_id"
    t.integer  "cartao_bandeira_id"
    t.boolean  "conciliacao",                                                       :default => false
    t.integer  "controle_caixa"
    t.decimal  "saida_peso",                         :precision => 15, :scale => 2
    t.decimal  "entrada_peso",                       :precision => 15, :scale => 2
    t.string   "titulo",              :limit => 50
    t.integer  "plano_de_conta_id"
    t.integer  "centro_custo_id"
  end

  add_index "financas", ["data", "conta_id", "moeda"], :name => "find_financas"

  create_table "form_fiscals", :force => true do |t|
    t.date     "data"
    t.date     "vencimento"
    t.string   "doc_01",       :limit => 5
    t.string   "doc_02",       :limit => 5
    t.string   "doc",          :limit => 15
    t.string   "timbrado",     :limit => 20
    t.integer  "status"
    t.integer  "tipo"
    t.integer  "tipo_doc"
    t.string   "ruc",          :limit => 20
    t.string   "persona_nome", :limit => 150
    t.integer  "persona_id"
    t.integer  "cod_proc"
    t.string   "sigla_proc",   :limit => 10
    t.integer  "moeda"
    t.integer  "cotas"
    t.integer  "dv"
    t.integer  "tipo_op"
    t.decimal  "gv_10_gs",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gv_05_gs",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ip_10_gs",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ip_05_gs",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ex_gs",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "tot_gs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gv_10_us",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gv_05_us",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ip_10_us",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ip_05_us",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ex_us",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "tot_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
    t.integer  "cota"
    t.integer  "terminal_id"
    t.integer  "unidade_id"
    t.integer  "impressao",                                                  :default => 0
    t.decimal  "qtd",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unit_gs",                     :precision => 15, :scale => 2, :default => 0.0
    t.integer  "produto_id"
    t.boolean  "autorizacao",                                                :default => true
    t.string   "cdc",          :limit => 80
    t.integer  "tipo_emissao",                                               :default => 0
    t.text     "arquivo_pdf"
    t.decimal  "unit_us",                     :precision => 15, :scale => 2, :default => 0.0
    t.text     "motivo"
    t.string   "serie",        :limit => 4
    t.boolean  "consumicao",                                                 :default => false
    t.string   "situacion",    :limit => 50
    t.string   "estado_set",   :limit => 50
  end

  create_table "forma_pagos", :force => true do |t|
    t.string   "nome"
    t.integer  "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cobro",                    :default => false
    t.boolean  "pago",                     :default => false
    t.boolean  "status",                   :default => true
    t.boolean  "venda",                    :default => true
    t.string   "tag_icon",   :limit => 50
    t.boolean  "gasto",                    :default => false
    t.boolean  "adelanto",                 :default => false
  end

  create_table "forma_pagos_personas", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "forma_pago_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forms", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "form_venda_fatura",       :limit => 100
    t.string   "rl_comissao",             :limit => 100
    t.string   "consulta_stock",          :limit => 150
    t.string   "recibo_cobro",            :limit => 50
    t.string   "recibo_adelanto",         :limit => 50
    t.string   "form_venda_cliente",      :limit => 30
    t.string   "form_ingressos",          :limit => 50
    t.string   "form_compras",            :limit => 100
    t.string   "form_gastos",             :limit => 100
    t.string   "form_venda_produtos"
    t.string   "form_venda_financa"
    t.string   "venda_index_new"
    t.string   "busca_venda_cliente",     :limit => nil
    t.string   "form_principal_personas", :limit => nil
    t.string   "form_venda_show",         :limit => 50
    t.string   "form_compra_produtos",    :limit => 150
    t.text     "vendas_comprovante"
    t.text     "sql_comissao"
    t.text     "vendas_fatura"
  end

  create_table "grupo_comissaos", :force => true do |t|
    t.string   "nome"
    t.decimal  "porcen",     :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "grupo_personas", :force => true do |t|
    t.string   "nome",       :limit => 200
    t.integer  "status",                    :default => 0
    t.text     "obs"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "grupo_personas_dts", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "status",     :default => 0
    t.text     "motivo"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "grupos", :force => true do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.decimal  "porcen_balcao",   :precision => 15, :scale => 2
    t.decimal  "porcen_mayo",     :precision => 15, :scale => 2
    t.decimal  "porcen_mino",     :precision => 15, :scale => 2
    t.integer  "cod_impl"
  end

  create_table "ingressos", :force => true do |t|
    t.date     "data"
    t.integer  "conta_id"
    t.string   "conta_nome",       :limit => 100
    t.integer  "rubro_id"
    t.string   "rubro_nome",       :limit => 150
    t.string   "rubro_codigo",     :limit => 50
    t.string   "concepto",         :limit => 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.decimal  "cotacao",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "documento_id"
    t.string   "documento_nome",   :limit => 150
    t.date     "diferido"
    t.string   "cheque",           :limit => 50
    t.integer  "cheque_status"
    t.string   "titular",          :limit => 150
    t.string   "banco",            :limit => 150
    t.decimal  "cotacao_real",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_produto"
    t.integer  "setor_id"
    t.integer  "servico_id"
    t.integer  "unidade_id"
    t.integer  "banco_id"
    t.integer  "persona_id_modal"
    t.string   "bc_conta",         :limit => 100
    t.string   "bc_agencia",       :limit => 50
  end

  create_table "itempedidosovis", :id => false, :force => true do |t|
    t.integer  "nr_itempedido",                                               :null => false
    t.integer  "cd_tabpreco",                                                 :null => false
    t.integer  "nr_pedidopalm",                                               :null => false
    t.integer  "cd_item",                                                     :null => false
    t.decimal  "qt_item",                      :precision => 15, :scale => 2
    t.decimal  "qt_faturada",                  :precision => 15, :scale => 3
    t.decimal  "vl_desconto",                  :precision => 15, :scale => 2
    t.decimal  "vl_unitario",                  :precision => 15, :scale => 4
    t.decimal  "vl_total",                     :precision => 15, :scale => 2
    t.decimal  "vl_saldogerado",               :precision => 15, :scale => 2
    t.decimal  "vl_diferenca",                 :precision => 15, :scale => 2
    t.integer  "tp_item"
    t.string   "ds_usuario",     :limit => 60
    t.decimal  "vl_custo",                     :precision => 15, :scale => 2
    t.datetime "dt_registro"
  end

  create_table "itempedidotmp", :id => false, :force => true do |t|
    t.integer "nr_sequencia",                                                   :null => false
    t.integer "nr_itemseq",                                                     :null => false
    t.string  "cd_filial",         :limit => 9
    t.string  "nr_pedidotmp",      :limit => 20
    t.string  "nr_itemtmp",        :limit => 10
    t.string  "cd_produto",        :limit => 15
    t.decimal "qt_produto",                      :precision => 15, :scale => 5
    t.decimal "vl_preco",                        :precision => 15, :scale => 5
    t.decimal "vl_total",                        :precision => 15, :scale => 5
    t.decimal "vl_unit",                         :precision => 15, :scale => 5
    t.decimal "vl_desconto",                     :precision => 15, :scale => 5
    t.string  "tp_origem",         :limit => 1
    t.decimal "qt_sugestaoatual",                :precision => 15, :scale => 5
    t.decimal "qt_estoquecliente",               :precision => 15, :scale => 5
  end

  create_table "liq_analize_dts", :force => true do |t|
    t.integer  "liq_analize_id"
    t.decimal  "valor_us",       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",       :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.text     "obs"
    t.string   "analize_id"
    t.decimal  "porcen_liq",     :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "liquidacao_custos", :force => true do |t|
    t.date     "data"
    t.date     "date_inicio"
    t.date     "data_final"
    t.integer  "obra_origem"
    t.integer  "obra_destino"
    t.integer  "rubro_inicio_id"
    t.string   "rubro_inicio_nome", :limit => 150
    t.integer  "rubro_final_id"
    t.string   "rubro_final_nome",  :limit => 150
    t.integer  "moeda"
    t.decimal  "valor_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                          :precision => 15, :scale => 2, :default => 0.0
    t.string   "obs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rodado_id"
    t.string   "rodado_nome"
  end

  create_table "lista_cargas", :force => true do |t|
    t.integer  "rodado_id"
    t.integer  "cidade_id"
    t.text     "obs"
    t.boolean  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "localidades", :force => true do |t|
    t.string   "codigo",     :limit => 50
    t.string   "ocupacao",   :limit => 120
    t.integer  "status"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "localizacaos", :force => true do |t|
    t.string   "ocupacao"
    t.string   "sigla"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "logins", :force => true do |t|
    t.integer  "unidade_id"
    t.string   "unidade_nome"
    t.integer  "usuario_id"
    t.string   "usuario_nome"
    t.string   "usuario_senha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo"
    t.string   "conta_nome",    :limit => 200
    t.integer  "conta_id"
    t.string   "turno_nome",    :limit => 250
    t.integer  "turno_id"
    t.date     "vencimento"
    t.integer  "status"
    t.string   "senha",         :limit => 100
    t.string   "liberacao",     :limit => 100
  end

  create_table "lotes", :force => true do |t|
    t.string   "numero"
    t.date     "vencimento"
    t.string   "numero_registro"
    t.integer  "unidade_id"
    t.integer  "usuario_created"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "manifestacao_de_bens", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "persona_id"
    t.string   "persona_nome",     :limit => 200
    t.string   "tipo",             :limit => 50
    t.string   "caracteristicas",  :limit => 100
    t.decimal  "valor_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.string   "escrivania",       :limit => 100
    t.string   "escritura",        :limit => 50
    t.string   "numero",           :limit => 50
    t.integer  "hipotecado"
    t.string   "favorecido",       :limit => 100
    t.integer  "rango"
    t.decimal  "hipoteca_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "hipoteca_guarani",                :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "manutencao_maquina_produtos", :force => true do |t|
    t.integer  "manutencao_maquina_id"
    t.decimal  "cotacao",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.integer  "produto_id"
    t.string   "produto_nome",          :limit => 200
    t.integer  "responsavel_id"
    t.string   "responsavel_nome",      :limit => 200
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",         :limit => 200
    t.decimal  "quantidade",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposito_id"
    t.string   "deposito_nome",         :limit => 150
  end

  create_table "manutencao_maquinas", :force => true do |t|
    t.decimal  "cotacao",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "produto_id"
    t.string   "produto_nome",          :limit => 200
    t.decimal  "quantidade",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_balcao",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_mayorista",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_corporativo",                   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.date     "data"
    t.date     "data_finalizacao"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.integer  "deposito_id"
    t.string   "deposito_nome",         :limit => 150
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",         :limit => 150
    t.decimal  "custo_maquina_dolar",                  :precision => 15, :scale => 2
    t.decimal  "custo_maquina_guarani",                :precision => 15, :scale => 2
  end

  create_table "marcas", :force => true do |t|
    t.string   "nome"
    t.string   "registro"
    t.string   "endereco"
    t.string   "telefone"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "menus", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "codigo",     :limit => 20
    t.string   "url",        :limit => 100
    t.string   "nome",       :limit => 100
    t.integer  "sub",        :limit => 2,   :default => 0
    t.string   "nome_es",    :limit => 100
    t.string   "nome_pt_br", :limit => 100
  end

  add_index "menus", ["id"], :name => "filtro_cod"

  create_table "meta", :force => true do |t|
    t.date     "periodo_inicio"
    t.date     "periodo_final"
    t.integer  "moeda"
    t.decimal  "valor_min_us",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_min_gs",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_min_rs",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_us",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_gs",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_rs",   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.text     "descricao"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "meta_detalhes", :force => true do |t|
    t.integer  "meta_id"
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.integer  "setor_id"
    t.string   "setor_nome"
    t.decimal  "valor_min_us", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_min_gs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_min_rs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_us", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_gs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_rs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "comicao_min",  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "comicao_max",  :precision => 15, :scale => 2, :default => 0.0
    t.text     "descricao"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  create_table "metas", :force => true do |t|
    t.date     "periodo_inicio"
    t.date     "periodo_final"
    t.integer  "moeda"
    t.decimal  "valor_min_us"
    t.decimal  "valor_min_gs"
    t.decimal  "valor_min_rs"
    t.decimal  "valor_max_us"
    t.decimal  "valor_max_gs"
    t.decimal  "valor_max_rs"
    t.integer  "status"
    t.text     "descricao"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "modelo_contratos", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.text     "modelo"
    t.string   "processo",   :limit => 100
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "moedas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.decimal  "dolar_compra",           :precision => 15, :scale => 2
    t.decimal  "dolar_venda",            :precision => 15, :scale => 2
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.decimal  "cotacao_oficial_compra", :precision => 15, :scale => 2
    t.decimal  "cotacao_oficial_venda",  :precision => 15, :scale => 2
    t.decimal  "real_compra"
    t.decimal  "real_venda"
    t.decimal  "rs_us_compra",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "rs_us_venda",            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ps_gs_compra",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ps_gs_venda",            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ps_us_compra",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ps_us_venda",            :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "motivos", :force => true do |t|
    t.string   "nome",             :limit => 150
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.integer  "score",                           :default => 0
    t.boolean  "add_sueldo",                      :default => false
    t.integer  "avaliacao_ref_id"
  end

  create_table "motivos_dev_cheques", :force => true do |t|
    t.string   "nome"
    t.boolean  "deb_cli_prov"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "mov_vantagens", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "produto_id"
    t.integer  "promo_id"
    t.date     "data"
    t.integer  "tipo_promo"
    t.text     "descricao"
    t.string   "titulo",     :limit => 150
    t.integer  "pontos",                                                   :default => 0
    t.decimal  "valor_us",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",                  :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
  end

  create_table "nc_proveedor_faturas", :force => true do |t|
    t.integer  "nota_credito_proveedor_id"
    t.integer  "persona_id"
    t.integer  "compra_id"
    t.string   "persona_nome"
    t.string   "documento_numero_01",       :limit => 5
    t.string   "documento_numero_02",       :limit => 5
    t.string   "documento_numero",          :limit => 20
    t.integer  "operacao"
    t.date     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "valor_dolar",                             :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                           :precision => 15, :scale => 2
    t.integer  "moeda"
    t.integer  "clase_produto"
    t.integer  "tipo"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
  end

  create_table "negocio_historicos", :force => true do |t|
    t.integer  "negocio_id"
    t.integer  "etapa_id"
    t.integer  "tarefa_id"
    t.string   "tipo_tarefa_id"
    t.string   "titulo",         :limit => 100
    t.string   "origem",         :limit => 50
    t.text     "detalhe"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "usuario_id"
    t.integer  "nota_id"
  end

  create_table "negocio_produtos", :force => true do |t|
    t.integer  "negocio_id"
    t.integer  "produto_id"
    t.integer  "moeda"
    t.decimal  "quantidade", :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unit_us",    :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unit_gs",    :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "tot_gs",     :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "tot_us",     :precision => 15, :scale => 3, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "negocios", :force => true do |t|
    t.string   "titulo"
    t.integer  "persona_id"
    t.integer  "etapa_id"
    t.integer  "moeda"
    t.integer  "vendedor_id"
    t.date     "expect_fechamento"
    t.integer  "status"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "usuario_id"
  end

  create_table "noft_apps", :force => true do |t|
    t.string   "titulo",         :limit => 100
    t.text     "descricao"
    t.integer  "persona_id"
    t.integer  "persona_api_id"
    t.integer  "cod_proc"
    t.string   "sigla_proc",     :limit => 10
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "nota_credito_proveedor_aplics", :force => true do |t|
    t.integer  "nota_credito_proveedor_id"
    t.date     "data"
    t.integer  "persona_id"
    t.string   "persona_nome",              :limit => 150
    t.string   "documento_numero_01",       :limit => 10
    t.string   "documento_numero_02",       :limit => 10
    t.string   "documento_numero",          :limit => 30
    t.decimal  "valor_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real",                               :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "clase_produto"
    t.integer  "tipo"
    t.integer  "liquidacao"
    t.integer  "vencimento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cota"
  end

  create_table "nota_credito_proveedor_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "nota_credito_proveedor_id"
    t.integer  "produto_id"
    t.string   "produto_nome",              :limit => 200
    t.decimal  "quantidade",                               :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unitario_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "deposito_id"
    t.string   "deposito_nome",             :limit => 100
    t.string   "documento_nome",            :limit => 150
    t.string   "documento_numero",          :limit => 100
    t.string   "documento_numero_01",       :limit => 5
    t.string   "documento_numero_02",       :limit => 5
    t.string   "codigo",                    :limit => 150
    t.decimal  "iva_dolar",                                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                              :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.decimal  "taxa",                                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                                  :precision => 15, :scale => 2, :default => 0.0
    t.integer  "venda_id"
    t.integer  "clase_produto"
    t.integer  "compra_id"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "produtos_grade_id"
    t.integer  "sub_grupo_id"
    t.integer  "colecao_id"
    t.integer  "cor_id"
    t.string   "cor_nome",                  :limit => 100
    t.integer  "tamanho_id"
    t.string   "tamanho_nome",              :limit => 100
    t.decimal  "unitario_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_real",                               :precision => 15, :scale => 2, :default => 0.0
    t.string   "fabricante_cod",            :limit => 100
  end

  create_table "nota_credito_proveedors", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "ruc",                 :limit => 100
    t.string   "direcao",             :limit => 150
    t.string   "cidade",              :limit => 200
    t.string   "telefone",            :limit => 50
    t.integer  "vendedor_id"
    t.string   "vendedor",            :limit => 200
    t.integer  "tipo"
    t.integer  "moeda"
    t.text     "concepto"
    t.integer  "operacao"
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 200
    t.string   "cheque",              :limit => 100
    t.date     "diferido"
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 100
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.integer  "cidade_id"
    t.integer  "clase_produto"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer  "unidade_id"
  end

  create_table "nota_creditos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "ruc",                 :limit => 100
    t.string   "direcao",             :limit => 150
    t.string   "cidade",              :limit => 200
    t.string   "telefone",            :limit => 50
    t.integer  "vendedor_id"
    t.string   "vendedor",            :limit => 200
    t.integer  "tipo"
    t.integer  "moeda"
    t.string   "concepto",            :limit => 100
    t.integer  "operacao"
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 200
    t.string   "cheque",              :limit => 100
    t.date     "diferido"
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 100
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.integer  "cidade_id"
    t.integer  "clase_produto"
    t.integer  "status"
    t.string   "fatura_01",           :limit => 5
    t.string   "fatura_02",           :limit => 5
    t.string   "fatura",              :limit => 50
    t.decimal  "exenta_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exenta_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_05_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_05_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_10_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_10_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cota"
    t.integer  "taxa"
    t.integer  "financa_moeda"
    t.integer  "setor_id"
    t.string   "setor_nome",          :limit => 120
    t.integer  "servico_id"
    t.string   "servico_nome",        :limit => 120
    t.integer  "unidade_id"
    t.integer  "contrato_id"
    t.integer  "motivo"
    t.integer  "origem_proc",                                                       :default => 0
    t.integer  "fiscal",                                                            :default => 0
  end

  create_table "nota_creditos_detalhes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "nota_credito_id"
    t.integer  "produto_id"
    t.string   "produto_nome",        :limit => 200
    t.decimal  "quantidade",                         :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unitario_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "deposito_id"
    t.string   "deposito_nome",       :limit => 100
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 100
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "codigo",              :limit => 150
    t.string   "fabricante_cod",      :limit => 150
    t.decimal  "iva_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.decimal  "taxa",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "venda_id"
    t.integer  "clase_produto"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",       :limit => 150
    t.integer  "tipo"
    t.integer  "moeda"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 150
    t.integer  "documento_id"
    t.string   "cota",                :limit => 5
    t.integer  "produtos_grade_id"
    t.integer  "tamanho_id"
    t.integer  "cor_id"
    t.string   "tamanho_nome",        :limit => 50
    t.string   "cor_nome",            :limit => 150
  end

  create_table "nota_creditos_docs", :force => true do |t|
    t.integer  "nota_credito_id"
    t.date     "data"
    t.date     "vencimento"
    t.integer  "persona_id"
    t.integer  "moeda"
    t.integer  "status"
    t.integer  "cota"
    t.string   "persona_nome",        :limit => 150
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "documento_numero",    :limit => 15
    t.string   "tipo",                :limit => 2
    t.integer  "liquidacao"
    t.integer  "vendedor_id"
    t.decimal  "valor_dolar"
    t.decimal  "valor_guarani"
    t.string   "vendedor_nome",       :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clase_produto"
  end

  create_table "nota_remicao_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nota_remicao_id"
    t.date     "data"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "produto_id"
    t.string   "produto_nome",           :limit => 200
    t.integer  "produto_cod"
    t.integer  "deposito_id"
    t.string   "deposito_nome",          :limit => 150
    t.decimal  "custo_dolar",                           :precision => 15, :scale => 2
    t.decimal  "custo_guarani",                         :precision => 15, :scale => 2
    t.decimal  "valor_dolar",                           :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                         :precision => 15, :scale => 2
    t.decimal  "saldo",                                 :precision => 15, :scale => 3
    t.decimal  "quantidade",                            :precision => 15, :scale => 3
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "estado"
    t.decimal  "custo_contabil_dolar",                  :precision => 15, :scale => 2
    t.decimal  "custo_contabil_guarani",                :precision => 15, :scale => 2
    t.string   "persona_nome",           :limit => 200
    t.integer  "persona_id"
  end

  create_table "nota_remicaos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.string   "documento_numero_01",  :limit => 10
    t.string   "documento_numero_02",  :limit => 10
    t.string   "documento_numero",     :limit => 50
    t.integer  "origem_unidade_id"
    t.string   "origem_unidade_nome",  :limit => 150
    t.integer  "deposito_id"
    t.string   "deposito_nome",        :limit => 150
    t.integer  "motivo"
    t.string   "chapa",                :limit => 50
    t.integer  "chofer_id"
    t.string   "chofer_nome",          :limit => 150
    t.string   "chofer_ruc",           :limit => 50
    t.integer  "transportadora_id"
    t.string   "transportadora_nome",  :limit => 150
    t.integer  "destino_unidade_id"
    t.string   "destino_unidade_nome", :limit => 150
    t.integer  "destino_persona_id"
    t.integer  "destino_persona_cod"
    t.string   "destino_persona_nome", :limit => 150
    t.string   "destino_persona_ruc",  :limit => 150
    t.string   "direcao",              :limit => 150
    t.string   "bairro",               :limit => 150
    t.integer  "cidade_id"
    t.string   "cidade_nome",          :limit => 150
    t.string   "veiculo"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "estado"
    t.string   "kms",                  :limit => 30
    t.text     "obs"
    t.integer  "safra_id"
    t.integer  "cultivo_id"
    t.decimal  "valor_guarani",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                         :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "notas", :force => true do |t|
    t.text     "descricao"
    t.integer  "usuario_id"
    t.integer  "negocio_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "tarefa_id"
  end

  create_table "ordem_producaos", :force => true do |t|
    t.date     "data"
    t.integer  "produto_id"
    t.string   "produto_nome",     :limit => 200
    t.integer  "responsavel_id"
    t.string   "responsavel_nome", :limit => 200
    t.decimal  "quantidade",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.text     "obs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ordem_serv_files", :force => true do |t|
    t.integer  "ordem_serv_id"
    t.string   "nome",                 :limit => 100
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "ordem_serv_prods", :force => true do |t|
    t.integer  "ordem_serv_id"
    t.integer  "deposito_id"
    t.integer  "produto_id"
    t.integer  "quantidade"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.date     "data"
    t.boolean  "status",                                       :default => true
    t.decimal  "valor_gs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_us",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",      :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "ordem_serv_prods", ["deposito_id"], :name => "index_ordem_serv_prods_on_deposito_id"
  add_index "ordem_serv_prods", ["ordem_serv_id"], :name => "index_ordem_serv_prods_on_ordem_serv_id"
  add_index "ordem_serv_prods", ["produto_id"], :name => "index_ordem_serv_prods_on_produto_id"

  create_table "ordem_servs", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.integer  "responsavel_id"
    t.text     "obs"
    t.string   "status"
    t.integer  "moeda"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "persona_nome"
    t.integer  "unidade_id"
    t.integer  "usuario_created"
    t.string   "tipo",              :limit => 50
    t.string   "acopio"
    t.string   "modelo"
    t.string   "plataforma"
    t.string   "uso"
    t.string   "cabeca"
    t.string   "celda"
    t.string   "rt",                :limit => 30
    t.boolean  "recebido",                         :default => false
    t.boolean  "garantia",                         :default => false
    t.string   "signature",         :limit => nil
    t.integer  "equipo_id"
    t.boolean  "luz_display"
    t.boolean  "luz_interna"
    t.boolean  "freio"
    t.boolean  "sinalizadores"
    t.boolean  "volante"
    t.boolean  "audio"
    t.boolean  "ventilador"
    t.text     "obs_checklist"
    t.integer  "persona_rodado_id"
    t.integer  "indicador_id"
  end

  add_index "ordem_servs", ["persona_id"], :name => "index_ordem_servs_on_persona_id"

  create_table "pagares", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "unidade_id"
    t.string   "unidade_nome",    :limit => 150
    t.date     "data"
    t.integer  "moeda"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",    :limit => 150
    t.string   "persona_ruc",     :limit => 50
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",   :limit => 150
    t.date     "vencimento"
    t.decimal  "valor_dolar",                    :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                  :precision => 15, :scale => 2
    t.integer  "venda_id"
    t.string   "tabela",          :limit => 150
    t.integer  "tabela_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo"
    t.integer  "cota"
    t.string   "co_deodor"
    t.string   "co_deodor_ruc"
    t.string   "domicilio",       :limit => 150
    t.string   "m_tipo",          :limit => 150
    t.string   "marca",           :limit => 150
    t.string   "modelo",          :limit => 150
    t.string   "ano",             :limit => 150
    t.string   "chassi",          :limit => 150
    t.string   "motor",           :limit => 150
    t.string   "seria",           :limit => 150
    t.string   "obs",             :limit => 150
    t.integer  "cidade_id"
    t.string   "cidade_nome",     :limit => 150
    t.integer  "estado_id"
    t.string   "estado_nome",     :limit => 150
    t.integer  "pais_id"
    t.string   "pais_nome",       :limit => 150
    t.string   "nacionalidade",   :limit => 50
    t.decimal  "entrega_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrega_guarani",                :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "pagares_detalhes", :force => true do |t|
    t.integer  "pagare_id"
    t.date     "data"
    t.date     "vencimento"
    t.integer  "cota"
    t.decimal  "valor_guarani", :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "valor_dolar",   :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "pagos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 150
    t.string   "cheque",              :limit => 100
    t.date     "diferido"
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "moeda"
    t.string   "ruc",                 :limit => 100
    t.integer  "compra_id"
    t.string   "documento_nome",      :limit => 150
    t.integer  "documento_id"
    t.string   "descricao"
    t.integer  "clase_produto"
    t.string   "documento_numero_02", :limit => 50
    t.string   "documento_numero_01", :limit => 50
    t.string   "documento_numero",    :limit => 100
    t.integer  "adelanto"
    t.integer  "adelanto_id"
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 0, :default => 0
    t.integer  "servico_id"
    t.string   "servico_noma"
    t.integer  "setor_id"
    t.string   "setor_nome"
    t.integer  "unidade_id"
    t.decimal  "cotacao_rs_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.boolean  "op",                                                                :default => false
    t.integer  "proveedore_id"
  end

  create_table "pagos_adelantos", :force => true do |t|
    t.integer  "pago_id"
    t.date     "data"
    t.integer  "persona_id"
    t.integer  "liquidacao"
    t.string   "documento_numero_01", :limit => 10
    t.string   "documento_numero_02", :limit => 10
    t.string   "documento_numero",    :limit => 50
    t.integer  "cota"
    t.integer  "moeda"
    t.decimal  "valor_us",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",                          :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
  end

  create_table "pagos_detalhes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "pago_id"
    t.date     "vencimento"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 150
    t.integer  "cota"
    t.date     "data"
    t.decimal  "pago_dolar",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "pago_guarani",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer  "liquidacao"
    t.decimal  "anterior_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "anterior_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "estado"
    t.integer  "compra_id"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.decimal  "desconto_dolar",                     :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                   :precision => 15, :scale => 2
    t.decimal  "interes_dolar",                      :precision => 15, :scale => 2
    t.decimal  "interes_guarani",                    :precision => 15, :scale => 2
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "moeda"
    t.integer  "clase_produto"
    t.decimal  "pago_real",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "anterior_real",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "interes_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_real",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "dif_cambio_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "dif_cambio_gs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "dif_cambio_rs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "retencao_gs",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "retencao_us",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_gs",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_us",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_lanz"
    t.integer  "tot_cotas"
    t.integer  "rubro_id"
    t.integer  "centro_custo_id"
    t.integer  "plano_de_conta_id"
  end

  create_table "pagos_financas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pago_id"
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 150
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.text     "descricao"
    t.date     "data"
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 50
    t.string   "cheque",              :limit => 50
    t.date     "diferido"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "moeda"
    t.integer  "usuario_updated"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.string   "documento_numero_02", :limit => 50
    t.string   "documento_numero_01", :limit => 50
    t.string   "numero_recibo",       :limit => 50
    t.integer  "cod_viatico"
    t.decimal  "valor_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cheque_status",       :limit => 2
    t.integer  "banco_id"
    t.integer  "forma_pago_id"
    t.integer  "cred_deb",            :limit => 2
    t.string   "titular",             :limit => 200
    t.integer  "centro_custo_id"
    t.integer  "plano_de_conta_id"
  end

  create_table "painel_cliente_logs", :force => true do |t|
    t.string   "ip"
    t.string   "login"
    t.string   "senha"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "painel_preparos", :force => true do |t|
    t.string   "nome"
    t.text     "grupo_ids"
    t.integer  "unidade_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "paises", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "cp"
    t.integer  "api_id"
  end

  create_table "parcelas", :force => true do |t|
    t.string   "nome",       :limit => 150
    t.boolean  "status",                    :default => true
    t.text     "obs"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "pc_resumo_mes", :force => true do |t|
    t.date     "data"
    t.decimal  "custo_fixo_gs",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_variavel_gs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_variavel_perc_gs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "faturamento_gs",         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "lucro_gs",               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_fixo_rs",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_variavel_rs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_variavel_perc_rs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "faturamento_rs",         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "lucro_rs",               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_fixo_us",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_variavel_us",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_variavel_perc_us", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "faturamento_us",         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "lucro_us",               :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
  end

  create_table "pedido_compra_produtos", :force => true do |t|
    t.integer  "pedido_compra_id"
    t.date     "data"
    t.integer  "moeda"
    t.decimal  "cotacao",                               :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_produto"
    t.integer  "produto_id"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.string   "produto_nome"
    t.string   "produto_fabricante_cod"
    t.decimal  "quantidade",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "deposito_id"
    t.string   "deposito_nome"
    t.integer  "unidade_created"
    t.integer  "usuario_created"
    t.integer  "unidade_updated"
    t.integer  "usuario_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "produtos_grade_id"
    t.integer  "cor_id"
    t.integer  "tamanho_id"
    t.integer  "colecao_id"
    t.string   "cor_nome",               :limit => 100
    t.string   "tamanho_nome",           :limit => 100
    t.string   "fabricante_cod",         :limit => 120
    t.decimal  "desconto_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",           :limit => 150
    t.decimal  "unitario_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "disp",                   :limit => 2,                                  :default => 0
  end

  add_index "pedido_compra_produtos", ["pedido_compra_id", "produto_id", "produtos_grade_id"], :name => "busca_produto_pedido_compra"

  create_table "pedido_compras", :force => true do |t|
    t.date     "data"
    t.date     "data_entrega"
    t.decimal  "cotacao",          :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "status"
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.integer  "requerente_id"
    t.string   "requerente_nome"
    t.integer  "clase_produto"
    t.integer  "documento_id"
    t.string   "documento_nome"
    t.integer  "unidade_id"
    t.string   "unidade_nome"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sub_grupo_id"
    t.integer  "colecao_id"
    t.date     "pedido_venda_ate"
    t.integer  "tipo_pedido"
    t.decimal  "cotacao_real",     :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "pedido_compras_presupuestos", :force => true do |t|
    t.integer  "pedido_compra_id"
    t.integer  "presupuesto_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "pedidosovis", :id => false, :force => true do |t|
    t.integer  "nr_pedidopalm",                                                         :null => false
    t.integer  "cd_empresa",                                                            :null => false
    t.integer  "cd_vendedor"
    t.integer  "cd_pessoa"
    t.string   "nr_cnpjcpf",              :limit => 22
    t.integer  "cd_endereco"
    t.integer  "cd_tipopedido"
    t.string   "cd_formapagto",           :limit => 2
    t.integer  "cd_condpagto"
    t.integer  "cd_transportador"
    t.string   "nr_cnpjcpftransportador", :limit => 22
    t.integer  "nr_ordemcompra"
    t.date     "dt_entrega"
    t.datetime "dt_emissao"
    t.string   "ds_obspedido",            :limit => 240
    t.string   "ds_obsnota",              :limit => 240
    t.decimal  "vl_total",                               :precision => 15, :scale => 2
    t.decimal  "vl_desconto",                            :precision => 15, :scale => 2
    t.decimal  "vl_saldogerado",                         :precision => 15, :scale => 2
    t.string   "st_pedidopalm",           :limit => 10
    t.string   "st_pedidoerp",            :limit => 30
    t.string   "st_email",                :limit => 1
    t.string   "st_fax",                  :limit => 1
    t.integer  "tp_pagtofrete"
    t.decimal  "vl_despesa",                             :precision => 15, :scale => 2
    t.decimal  "vl_liquido",                             :precision => 15, :scale => 2
    t.datetime "dt_registro"
  end

  create_table "pedidovendatmp", :id => false, :force => true do |t|
    t.integer  "nr_sequencia",                                                                           :null => false
    t.string   "cd_filial",             :limit => 9
    t.string   "nr_pedidotmp",          :limit => 20
    t.date     "dt_inclusao"
    t.string   "cd_cliente",            :limit => 9
    t.string   "nr_loja",               :limit => 4
    t.string   "cd_condpag",            :limit => 3
    t.string   "cd_tabela",             :limit => 10
    t.string   "cd_transportador",      :limit => 9
    t.string   "tp_pedido",             :limit => 1
    t.string   "cd_vendedor1",          :limit => 6
    t.decimal  "pc_comissao1",                         :precision => 5,  :scale => 2
    t.string   "cd_formapag",           :limit => 3
    t.string   "ds_mensagemnota",       :limit => 400
    t.string   "ds_mensagemped",        :limit => 400
    t.boolean  "st_importado",                                                        :default => false
    t.datetime "dt_registro"
    t.integer  "nr_pedidovenda"
    t.boolean  "st_autorizaimportacao",                                               :default => false
    t.string   "tp_origem",             :limit => 1
    t.text     "ds_motivobloqueio"
    t.integer  "qt_diassugestao",                                                     :default => 7
    t.time     "hr_inclusao"
    t.decimal  "nr_latitude",                          :precision => 15, :scale => 8
    t.decimal  "nr_longitude",                         :precision => 15, :scale => 8
    t.integer  "nr_diaspedido"
  end

  create_table "persona_acessos", :force => true do |t|
    t.integer  "persona_id"
    t.datetime "data_hora"
    t.integer  "entrada_saida"
    t.boolean  "visitante",     :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "persona_acoes", :force => true do |t|
    t.integer  "acao_id"
    t.date     "data"
    t.integer  "persona_id"
    t.text     "obs"
    t.integer  "responsavel_id"
    t.time     "horas"
    t.boolean  "retorno"
    t.integer  "status"
    t.date     "retorno_data"
    t.time     "retorno_horas"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "persona_apis", :force => true do |t|
    t.date     "data_nascimento"
    t.string   "email",           :limit => 50
    t.string   "nome",            :limit => 150
    t.string   "ruc",             :limit => 20
    t.string   "telefone",        :limit => 20
    t.text     "token_device"
    t.string   "endereco",        :limit => 80
    t.string   "bairro",          :limit => 80
    t.string   "cidade",          :limit => 80
    t.integer  "tipo_cliente"
    t.boolean  "crm_app",                        :default => false
    t.string   "mobile_auth",     :limit => 20
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  create_table "persona_ativos", :force => true do |t|
    t.integer  "moeda"
    t.decimal  "valor",      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "persona_bancos", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "banco_id"
    t.string   "conta",         :limit => 30
    t.decimal  "ahorro_avista",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cda",                          :precision => 15, :scale => 2, :default => 0.0
    t.string   "oficial_conta", :limit => 100
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
  end

  create_table "persona_chofers", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "chofer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "persona_contatos", :force => true do |t|
    t.integer  "persona_id"
    t.string   "nome",            :limit => 80
    t.string   "telefone_01",     :limit => 25
    t.string   "ramal_01",        :limit => 100
    t.string   "telefone_02",     :limit => 25
    t.string   "ramal_02",        :limit => 5
    t.string   "setor",           :limit => 5
    t.date     "data_nascimento"
    t.string   "email_01",        :limit => 80
    t.string   "email_02",        :limit => 80
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "cargo_id"
  end

  create_table "persona_docs", :force => true do |t|
    t.integer  "documento_id"
    t.string   "doc_attach_file_name"
    t.string   "doc_attach_content_type"
    t.integer  "doc_attach_file_size"
    t.datetime "doc_attach_updated_at"
    t.string   "nome",                    :limit => 150
    t.integer  "persona_id"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.date     "vencimento"
    t.text     "obs"
    t.boolean  "status",                                 :default => true
    t.boolean  "sem_venc",                               :default => false
    t.integer  "plano_venda_id"
  end

  create_table "persona_escalas", :force => true do |t|
    t.integer  "persona_id"
    t.date     "data"
    t.text     "obs"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "tipo",             :default => 0
    t.integer  "persona_feria_id"
  end

  create_table "persona_ferias", :force => true do |t|
    t.date     "inicio"
    t.date     "final"
    t.integer  "persona_id"
    t.boolean  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "persona_locais_entregas", :force => true do |t|
    t.integer  "persona_id"
    t.date     "data"
    t.integer  "estado_id"
    t.integer  "cidade_id"
    t.integer  "regiao_id"
    t.string   "nr",             :limit => 10
    t.string   "cep",            :limit => 20
    t.text     "obs"
    t.string   "nome",           :limit => 80
    t.boolean  "status"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "paise_id"
    t.date     "data_conclusao"
    t.string   "direcao",        :limit => 200
  end

  create_table "persona_produtos", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "produto_id"
    t.decimal  "preco_us",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_gs",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_rs",   :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.integer  "equipo_id"
    t.decimal  "comissao",   :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "persona_rodados", :force => true do |t|
    t.integer  "persona_id"
    t.string   "chapa"
    t.string   "responsavel"
    t.integer  "km_inicial"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "marca",       :limit => 100
    t.string   "modelo",      :limit => 100
    t.string   "ano",         :limit => 10
    t.string   "portas",      :limit => 10
    t.string   "cor",         :limit => 50
    t.text     "obs"
  end

  create_table "persona_tabela_descs", :force => true do |t|
    t.integer  "persona_id"
    t.date     "data"
    t.integer  "conj_ensaio_id"
    t.decimal  "desc_us",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desc_gs",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desc_rs",        :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "persona_unidades", :force => true do |t|
    t.integer  "persona_id"
    t.string   "gerente",    :limit => 100
    t.string   "nome",       :limit => 100
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "personas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome",                   :limit => 300
    t.string   "direcao",                :limit => 300
    t.string   "bairro",                 :limit => 300
    t.string   "cidade",                 :limit => 200
    t.string   "telefone",               :limit => 50
    t.date     "data"
    t.string   "direcao_complemento",    :limit => 400
    t.string   "ruc",                    :limit => 20
    t.integer  "tipo_fornecedor",                                                      :default => 0
    t.integer  "tipo_cliente",                                                         :default => 0
    t.integer  "tipo_vendedor",                                                        :default => 0
    t.integer  "tipo_funcionario",                                                     :default => 0
    t.integer  "estado",                                                               :default => 0
    t.integer  "tipo",                                                                 :default => 0
    t.integer  "tipo_fabricante",                                                      :default => 0
    t.integer  "cidade_id"
    t.string   "classificacao",          :limit => 10
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "chapa",                  :limit => 20
    t.integer  "tipo_transportadora"
    t.string   "departamento",           :limit => 150
    t.date     "data_entrada"
    t.decimal  "salario",                               :precision => 15, :scale => 2
    t.decimal  "salario_minimo",                        :precision => 15, :scale => 2
    t.decimal  "comissao",                              :precision => 15, :scale => 2
    t.decimal  "ci",                                    :precision => 15, :scale => 2
    t.string   "cod_contabil"
    t.decimal  "ips",                                   :precision => 15, :scale => 2
    t.date     "data_nascimento"
    t.string   "email",                  :limit => 100
    t.string   "estado_civil",           :limit => 100
    t.string   "lugar_trabalho",         :limit => 150
    t.string   "cargo",                  :limit => 100
    t.string   "profisao",               :limit => 100
    t.string   "referencia1",            :limit => 100
    t.string   "referenciatel1",         :limit => 100
    t.string   "referencia2",            :limit => 100
    t.string   "referenciatel2",         :limit => 100
    t.string   "referencia3",            :limit => 100
    t.string   "referenciatel3",         :limit => 100
    t.decimal  "limite_credito",                        :precision => 15, :scale => 2
    t.integer  "cod_velho"
    t.integer  "tipo_maiorista"
    t.integer  "tipo_chofer"
    t.integer  "tipo_despachante"
    t.string   "nacionalidade"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "residencia_numero",      :limit => 10
    t.string   "telefone2",              :limit => 60
    t.string   "fax",                    :limit => 20
    t.string   "celular",                :limit => 60
    t.string   "banco",                  :limit => 100
    t.string   "conta_numero",           :limit => 50
    t.string   "oficial_conta",          :limit => 100
    t.string   "conta",                  :limit => 100
    t.integer  "tipo_intermediario"
    t.date     "antiguidade"
    t.string   "referencia4",            :limit => 100
    t.string   "referencia_ci1",         :limit => 100
    t.string   "referencia_ci2",         :limit => 100
    t.string   "referencia_ci3",         :limit => 100
    t.string   "referencia_ci4",         :limit => 100
    t.string   "referencia_cargo1",      :limit => 100
    t.string   "referencia_cargo2",      :limit => 100
    t.string   "referencia_cargo3",      :limit => 100
    t.string   "referencia_cargo4",      :limit => 100
    t.integer  "estado_id"
    t.string   "estado_nome",            :limit => 150
    t.integer  "pais_id"
    t.string   "pais_nome",              :limit => 150
    t.string   "atividade",              :limit => 150
    t.integer  "cliente"
    t.integer  "rubro_id"
    t.string   "rubro_nome",             :limit => 150
    t.integer  "active",                                                               :default => 0,     :null => false
    t.string   "setor",                  :limit => 10
    t.integer  "per_inter_exter",        :limit => 2,                                  :default => 0
    t.integer  "tipo_laboratorio"
    t.string   "codeudor_nome",          :limit => 100
    t.string   "codeudor_ruc",           :limit => 15
    t.string   "codeudor_direcion",      :limit => 100
    t.string   "codeudor_lugar_trab",    :limit => 100
    t.string   "codeudor_telefone",      :limit => 20
    t.integer  "vend_responsavel_id"
    t.string   "vend_responsavel_nome",  :limit => 150
    t.string   "nome_fantasia"
    t.integer  "folha_pagamento",        :limit => 2
    t.integer  "folha_pagamento_moeda"
    t.integer  "comissao_vendas",        :limit => 2
    t.integer  "comissao_cobros",        :limit => 2
    t.integer  "comissao_adelantos",     :limit => 2
    t.integer  "comissao_nota_creditos", :limit => 2
    t.integer  "tipo_ap",                                                              :default => 0
    t.integer  "tipo_ap_especial",                                                     :default => 0
    t.decimal  "desc_especial",                         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo_banco",                                                           :default => 0
    t.integer  "retencao",               :limit => 2
    t.string   "senha",                  :limit => 50
    t.string   "nome_fatura",            :limit => 200
    t.integer  "unidade_id"
    t.integer  "tipo_trans",                                                           :default => 0
    t.integer  "emp_forma_cobro",                                                      :default => 0
    t.integer  "tabela_preco_id"
    t.string   "placa",                  :limit => 20
    t.string   "marca",                  :limit => 50
    t.string   "modelo",                 :limit => 50
    t.integer  "capacidade",                                                           :default => 0
    t.integer  "tara",                                                                 :default => 0
    t.integer  "tipo_franquiado",                                                      :default => 0
    t.integer  "regiao_id"
    t.integer  "seguimento_id"
    t.string   "cep",                    :limit => 30
    t.decimal  "limite_carteira_us",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "limite_carteira_gs",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "limite_carteira_rs",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "limite_cheque_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "limite_cheque_gs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "limite_cheque_rs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "limite_boleto_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "limite_boleto_gs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "limite_boleto_rs",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "autoriza_rodados",                                                     :default => 0
    t.integer  "tipo_frentista"
    t.integer  "paise_id"
    t.integer  "cidade_area_id"
    t.integer  "tipo_indicador"
    t.integer  "tipo_tintometrico",                                                    :default => 0
    t.string   "tipo_embalagem",         :limit => 5
    t.text     "observacao"
    t.string   "cod_impl",               :limit => 10
    t.integer  "usuario_id"
    t.boolean  "entrega",                                                              :default => false
    t.string   "dv",                     :limit => 4
    t.string   "conta_moeda",            :limit => 10
    t.integer  "cargo_id"
    t.string   "email_comercial",        :limit => 150
    t.string   "primeiro_nome",          :limit => 50
    t.string   "ultimo_nome",            :limit => 50
    t.string   "primeiro_apelido",       :limit => 50
    t.string   "ultimo_apelido",         :limit => 50
    t.string   "n_passaporte",           :limit => 50
    t.string   "nome_pai",               :limit => 100
    t.string   "nome_mae",               :limit => 100
    t.string   "tipo_residencia",        :limit => 50
    t.string   "regime_casamento",       :limit => 50
    t.string   "escolaridade",           :limit => 50
    t.string   "conyuge"
    t.string   "estado_civil_outros",    :limit => 100
    t.string   "escolaridade_outros",    :limit => 100
    t.boolean  "conyuge_trabalho",                                                     :default => false
    t.string   "perfil",                 :limit => 100
    t.string   "nr_contrato",            :limit => 50
    t.string   "estado_antecedente",     :limit => 50
    t.integer  "comite_id"
    t.integer  "brigada_id"
    t.integer  "saldo_ferias",                                                         :default => 0
    t.boolean  "consolidado_interno",                                                  :default => false
    t.boolean  "consolidado",                                                          :default => false
    t.boolean  "consolidado_modal",                                                    :default => false
    t.text     "obs"
    t.string   "color_tag",              :limit => 30
    t.string   "facial_id",              :limit => 50
    t.integer  "tipo_aluno",                                                           :default => 0
    t.integer  "turma_id"
    t.string   "coordenadas",            :limit => 150
  end

  add_index "personas", ["id", "nome", "nome_fatura"], :name => "busca_persona"
  add_index "personas", ["tipo_cliente"], :name => "filtro_tipo_compra"

  create_table "personas_ips", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "ip_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "personas_servicos", :force => true do |t|
    t.integer  "persona_id"
    t.date     "data"
    t.date     "vencimento"
    t.integer  "produto_id"
    t.decimal  "valor_us"
    t.decimal  "valor_gs"
    t.text     "obs"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pesos", :force => true do |t|
    t.decimal  "peso",       :precision => 15, :scale => 3, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pets", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pipeline_usuarios", :force => true do |t|
    t.integer  "pipeline_id"
    t.integer  "usuario_id"
    t.integer  "permissao",   :default => 2
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "pipelines", :force => true do |t|
    t.string   "nome",       :limit => 150
    t.boolean  "status"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "plano_de_contas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "descricao",       :limit => 200
    t.string   "codigo",          :limit => 20
    t.integer  "rubro",           :limit => 2
    t.integer  "competencia",                    :default => 1
  end

  create_table "plano_regras", :force => true do |t|
    t.integer  "plano_id"
    t.decimal  "min_gs",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "max_gs",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "max_desc",   :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "plano_venda_conds", :force => true do |t|
    t.integer  "plano_venda_id"
    t.string   "nome",           :limit => 150
    t.decimal  "quantidade",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.text     "obs"
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
  end

  create_table "plano_venda_docs", :force => true do |t|
    t.integer  "plano_venda_id"
    t.string   "nome"
    t.string   "obs"
    t.integer  "documento_id"
    t.string   "anexo_file_name"
    t.string   "anexo_content_type"
    t.integer  "anexo_file_size"
    t.datetime "anexo_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "plano_vendas", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.integer  "vendedor_id"
    t.integer  "produto_id"
    t.text     "obs"
    t.integer  "status",                                                              :default => 0
    t.datetime "created_at",                                                                           :null => false
    t.datetime "updated_at",                                                                           :null => false
    t.string   "persona_nome",          :limit => 150
    t.integer  "moeda"
    t.integer  "tabela_preco_id"
    t.decimal  "valor_us",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                             :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_escrivania_id"
    t.integer  "persona_seguro_id"
    t.integer  "autorizado_por"
    t.text     "autorizacao_obs"
    t.decimal  "valor_gs_seguro",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs_escritura",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_us_escritura",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_us_seguro",                      :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "planos", :force => true do |t|
    t.string   "condicao",   :limit => 200
    t.integer  "mes"
    t.integer  "ano"
    t.integer  "status"
    t.integer  "periodo"
    t.decimal  "taxa",                      :precision => 15, :scale => 2
    t.decimal  "decimal",                   :precision => 15, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pdv",                                                      :default => false
  end

  create_table "prazos", :force => true do |t|
    t.string   "nome",       :limit => 50
    t.integer  "dias"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "predios", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.boolean  "status",                    :default => true
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "presupuesto_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "presupuesto_id"
    t.integer  "produto_id"
    t.string   "produto_nome",      :limit => 200
    t.decimal  "unitario_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.string   "fabricante_cod",    :limit => 100
    t.decimal  "cotacao",                          :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.decimal  "quantidade",                       :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "saldo",                            :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "taxa",                             :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.string   "barra",             :limit => 100
    t.integer  "moeda"
    t.integer  "persona_id"
    t.string   "persona_nome",      :limit => 200
    t.string   "deposito_nome",     :limit => 150
    t.integer  "deposito_id"
    t.decimal  "desconto",                         :precision => 15, :scale => 2
    t.decimal  "total_desconto",                   :precision => 15, :scale => 2
    t.integer  "produto_cod"
    t.decimal  "interes"
    t.integer  "sub_grupo_id"
    t.integer  "tipo_venda"
    t.integer  "clase_produto"
    t.decimal  "unitario_real",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cor_id"
    t.string   "cor_nome",          :limit => 100
    t.integer  "tamanho_id"
    t.string   "tamanho_nome",      :limit => 100
    t.integer  "colecao_id"
    t.integer  "produtos_grade_id"
    t.decimal  "desconto_real",                    :precision => 15, :scale => 2
    t.integer  "tabela_preco_id"
    t.decimal  "promedio_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
  end

  add_index "presupuesto_produtos", ["presupuesto_id", "quantidade"], :name => "busca_presupuesto"

  create_table "presupuestos", :force => true do |t|
    t.integer "tipo"
    t.date    "data"
    t.decimal "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer "moeda"
    t.string  "ruc",                 :limit => 50
    t.string  "persona_nome",        :limit => 200
    t.string  "telefone",            :limit => 50
    t.integer "persona_id"
    t.integer "usuario_created"
    t.integer "usuario_updated"
    t.string  "direcao",             :limit => 150
    t.string  "bairro",              :limit => 150
    t.integer "cidade_id"
    t.string  "cidade_nome",         :limit => 150
    t.string  "documento_numero",    :limit => 50
    t.string  "documento_numero_01", :limit => 50
    t.string  "documento_numero_02", :limit => 50
    t.integer "documento_id"
    t.integer "fatura"
    t.string  "documento_nome",      :limit => 150
    t.integer "conta_id"
    t.string  "conta_nome",          :limit => 50
    t.decimal "limite_credito",                     :precision => 15, :scale => 2, :default => 0.0
    t.string  "classificacao",       :limit => 50
    t.integer "vendedor_id"
    t.string  "vendedor_nome",       :limit => 50
    t.integer "tipo_maiorista"
    t.integer "persona_cod"
    t.string  "pedido_numero",       :limit => 50
    t.decimal "saldo_disponivel",                   :precision => 15, :scale => 2, :default => 0.0
    t.integer "tipo_venda"
    t.integer "clase_produto"
    t.date    "prazo_entrega"
    t.integer "status"
    t.decimal "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer "venda_id"
    t.string  "forma_pago"
    t.string  "obs"
    t.string  "entrega"
    t.integer "plano_id"
    t.integer "tabela_preco"
    t.integer "colecao_id"
    t.integer "unidade_id"
    t.integer "sub_grupo_id"
    t.integer "cod_imp"
    t.integer "indicador_id"
    t.integer "prazo_id"
    t.integer "tabela_preco_id"
    t.integer "origem",                                                            :default => 0
    t.decimal "desconto",                           :precision => 15, :scale => 2, :default => 0.0
    t.integer "persona_rodado_id"
  end

  create_table "producao_produtos", :force => true do |t|
    t.integer  "producao_id"
    t.decimal  "cotacao",                         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.integer  "produto_id"
    t.string   "produto_nome",     :limit => 200
    t.integer  "responsavel_id"
    t.string   "responsavel_nome", :limit => 200
    t.decimal  "quantidade",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposito_id"
    t.string   "deposito_nome",    :limit => 150
    t.integer  "finalizado"
  end

  create_table "producaos", :force => true do |t|
    t.decimal  "cotacao",                           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "produto_id"
    t.string   "produto_nome",       :limit => 200
    t.decimal  "quantidade",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_balcao",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_mayorista",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_corporativo",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.date     "data"
    t.date     "data_finalizacao"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.integer  "deposito_id"
    t.string   "deposito_nome",      :limit => 150
    t.string   "nome",               :limit => 100
    t.integer  "safra_id"
    t.integer  "cultivo_id"
    t.integer  "parcela_id"
  end

  create_table "produto_barras", :force => true do |t|
    t.integer  "produto_id"
    t.string   "produto_nome"
    t.string   "barra"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "produtos_grade_id"
    t.integer  "cod_implantacao"
    t.integer  "grupo_id"
  end

  create_table "produto_composicaos", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "componente_id"
    t.string   "componente_nome",      :limit => 150
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.decimal  "quantidade",                          :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "ultimo_custo_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ultimo_custo_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "produto_composicaos_vendas_produtos", :force => true do |t|
    t.integer  "produto_composicao_id"
    t.integer  "vendas_produto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "produto_custo_medios", :force => true do |t|
    t.integer  "produto_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "produto_custo_medios", ["produto_id"], :name => "index_produto_custo_medios_on_produto_id"

  create_table "produto_imagens", :force => true do |t|
    t.integer  "produto_id"
    t.boolean  "status"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "foto_file_name"
    t.string   "foto_content_type"
    t.integer  "foto_file_size"
    t.datetime "foto_updated_at"
  end

  create_table "produto_sugeridos", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "quantidade",          :default => 0
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "produto_sugerido_id"
  end

  create_table "produto_tamanhos", :force => true do |t|
    t.integer  "produto_id"
    t.string   "tamanho_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome",                      :limit => 200
    t.string   "embalagem",                 :limit => 30
    t.string   "referencia",                :limit => 20
    t.string   "barra",                     :limit => 40
    t.string   "fabricante_cod",            :limit => 30
    t.integer  "fabricante_id"
    t.decimal  "taxa",                                     :precision => 15, :scale => 2, :default => 0.0
    t.integer  "grupo_id"
    t.integer  "clase_id"
    t.string   "codigo",                    :limit => 20
    t.string   "fabricante",                :limit => 200
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.decimal  "preco_venda_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.decimal  "cotacao",                                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_dolar_iva",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_guarani_iva",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo",                                                                    :default => 0
    t.decimal  "quantidade",                               :precision => 15, :scale => 2, :default => 0.0
    t.integer  "numero_bomba",                                                            :default => 0
    t.decimal  "porcentagem",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "cod_contabil",              :limit => 50
    t.integer  "stock_minimo"
    t.integer  "stock_maximo"
    t.decimal  "peso",                                     :precision => 15, :scale => 3
    t.integer  "cod_velho"
    t.decimal  "preco_maiorista_dolar",                    :precision => 15, :scale => 2
    t.decimal  "preco_maiorista_guarani",                  :precision => 15, :scale => 2
    t.decimal  "preco_minorista_dolar",                    :precision => 15, :scale => 2
    t.decimal  "preco_minorista_guarani",                  :precision => 15, :scale => 2
    t.integer  "desconto"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "sub_grupo_id"
    t.string   "locacao",                   :limit => 150
    t.decimal  "porcen_balcao",                            :precision => 15, :scale => 2
    t.decimal  "porcen_mayo",                              :precision => 15, :scale => 2
    t.decimal  "porcen_mino",                              :precision => 15, :scale => 2
    t.integer  "tipo_produto"
    t.string   "obs"
    t.decimal  "desconto_maio",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_mino",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "montagem"
    t.string   "nome_fatura",               :limit => 100
    t.decimal  "cotacao_real",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_maiorista_real",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_minorista_real",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "concentracao",                             :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "fator",                                    :precision => 15, :scale => 4, :default => 0.0
    t.date     "data_fabric"
    t.date     "data_valid"
    t.decimal  "volume_inicial",                           :precision => 15, :scale => 4, :default => 0.0
    t.string   "lote"
    t.integer  "colecao_id"
    t.decimal  "custo_base_gs",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_base_us",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_base_rs",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_rs_us",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_rs_gs",                            :precision => 15, :scale => 2, :default => 0.0
    t.string   "sexo",                      :limit => 50
    t.integer  "pagina"
    t.decimal  "custo_inicial_gs",                         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cod_implantacao"
    t.decimal  "ite_preve1",                               :precision => 15, :scale => 2
    t.decimal  "ite_preve2",                               :precision => 15, :scale => 2
    t.decimal  "ite_preve3",                               :precision => 15, :scale => 2
    t.decimal  "ite_preve4",                               :precision => 15, :scale => 2
    t.decimal  "ite_preve5",                               :precision => 15, :scale => 2
    t.decimal  "ite_preve6",                               :precision => 15, :scale => 2
    t.decimal  "ite_preve7",                               :precision => 15, :scale => 2
    t.integer  "unidade_medida_id"
    t.integer  "multiplo_compra",                                                         :default => 0
    t.boolean  "status",                                                                  :default => true
    t.decimal  "promedio_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "stock",                                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "peso_bruto",                               :precision => 15, :scale => 3, :default => 0.0
    t.string   "unidade_medida_nome",       :limit => 4
    t.string   "grupo_nome",                :limit => 150
    t.boolean  "black_list",                                                              :default => false
    t.boolean  "faturar",                                                                 :default => true
    t.decimal  "perc_comissao",                            :precision => 15, :scale => 2, :default => 0.0
    t.string   "clase_nome",                :limit => 80
    t.boolean  "balanca",                                                                 :default => false
    t.boolean  "preparacao",                                                              :default => false
    t.boolean  "altera_preco_venda",                                                      :default => false
    t.string   "set_print",                 :limit => 30
    t.integer  "tickets",                                                                 :default => 0
    t.string   "cor",                       :limit => 50
    t.string   "ano",                       :limit => 10
    t.string   "chassi",                    :limit => 100
  end

  add_index "produtos", ["nome", "fabricante_cod"], :name => "produto_busca"

  create_table "produtos_comissaos", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "persona_id"
    t.decimal  "valor",      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo"
    t.integer  "moeda",                                     :default => 1
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "produtos_custos", :force => true do |t|
    t.integer  "unidade_id"
    t.decimal  "custo_medio_us",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_medio_gs",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_medio_rs",    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "quantidade",        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "stock",             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_us",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_gs",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_rs",          :precision => 15, :scale => 2, :default => 0.0
    t.integer  "produto_id"
    t.integer  "produtos_grade_id"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.integer  "deposito_id"
  end

  add_index "produtos_custos", ["produtos_grade_id", "produto_id", "deposito_id"], :name => "busca_prod_custo"

  create_table "produtos_grades", :force => true do |t|
    t.integer  "produto_id"
    t.string   "barra",         :limit => 250
    t.integer  "cor_id"
    t.integer  "tamanho_id"
    t.decimal  "preco_1_us",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_1_gs",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_1_rs",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_2_us",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_2_gs",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_2_rs",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_3_us",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_3_gs",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_3_rs",                   :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "preco_4_us",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_4_gs",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_4_rs",                   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "sub_grupo_id"
    t.integer  "clase_id"
    t.string   "sexo",          :limit => 100
    t.string   "referencia",    :limit => 100
    t.string   "descricao",     :limit => 250
    t.string   "colecao",       :limit => 100
    t.string   "color",         :limit => 100
    t.string   "tamanho",       :limit => 100
    t.integer  "fornecedor_id"
    t.integer  "fabricante_id"
    t.integer  "colecao_id"
  end

  add_index "produtos_grades", ["produto_id", "cor_id", "tamanho_id", "sub_grupo_id"], :name => "busca_grade"

  create_table "produtos_roteiros", :force => true do |t|
    t.integer  "produto_id"
    t.string   "descricao",        :limit => 50
    t.string   "setor",            :limit => 50
    t.integer  "tempo_estimado"
    t.integer  "responsavel_id"
    t.string   "responsavel_nome", :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "produtos_tabela_precos", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "unidade_id"
    t.decimal  "preco_1_us",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_1_gs",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_1_rs",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_2_us",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_2_gs",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_2_rs",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_3_us",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_3_gs",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_3_rs",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_4_us",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_4_gs",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_4_rs",                       :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data_atulizacao"
    t.integer  "tabela_id"
    t.string   "tabela",            :limit => 50
    t.string   "fabricante_cod",    :limit => 100
    t.integer  "tabela_preco_id"
    t.decimal  "margem",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "comissao",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "max_desc",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_fixo_us",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_fixo_gs",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_fixo_rs",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_variavel_us",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_variavel_gs",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_variavel_rs",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_medio_us",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_medio_gs",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_medio_rs",                   :precision => 15, :scale => 2, :default => 0.0
    t.string   "produto_nome",      :limit => 180
  end

  add_index "produtos_tabela_precos", ["produto_id", "unidade_id"], :name => "busca_prod"

  create_table "produtos_tamanhos", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "tamanho_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "status",     :default => false
  end

  add_index "produtos_tamanhos", ["produto_id"], :name => "busca_prod_tamanho"

  create_table "produtos_tarefas", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "tarefa_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "produtos_tarefas", ["produto_id", "tarefa_id"], :name => "index_tarefa_id"

  create_table "promo_dts", :force => true do |t|
    t.integer  "promo_id"
    t.integer  "produto_id"
    t.decimal  "desc_porce",     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "preco_venda_gs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_us", :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "promos", :force => true do |t|
    t.string   "nome",            :limit => 100
    t.date     "valid_inicio"
    t.date     "valid_final"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "tabela_preco_id"
    t.integer  "tipo",                           :default => 0
  end

  create_table "prov_gastos", :force => true do |t|
    t.date     "data"
    t.integer  "rubro_id"
    t.integer  "conta_id"
    t.integer  "moeda"
    t.integer  "dia_venc"
    t.integer  "competencia"
    t.decimal  "valor_us",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",      :precision => 15, :scale => 2, :default => 0.0
    t.text     "obs"
    t.integer  "persona_id"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.integer  "usuario_created"
    t.integer  "unidade_id"
    t.integer  "centro_custo_id"
    t.integer  "mes_inicio"
    t.integer  "ano_inicio"
    t.decimal  "cotacao_rs_us",     :precision => 15, :scale => 2, :default => 0.0
    t.integer  "plano_de_conta_id"
  end

  create_table "provas", :force => true do |t|
    t.string   "prova",                 :limit => 15
    t.integer  "conj_ensaio_metodo_id"
    t.integer  "metodo_id"
    t.decimal  "valor",                               :precision => 15, :scale => 4, :default => 0.0
    t.datetime "created_at",                                                                          :null => false
    t.datetime "updated_at",                                                                          :null => false
  end

  create_table "proveedores", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "tabela_id"
    t.string   "tabela",               :limit => 200
    t.date     "vencimento"
    t.string   "documento_nome",       :limit => 100
    t.string   "documento_numero",     :limit => 100
    t.integer  "cota",                                                               :default => 0
    t.date     "data"
    t.date     "original"
    t.decimal  "divida_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "divida_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.date     "pagamento"
    t.decimal  "pago_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "pago_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "liquidacao"
    t.string   "persona_nome",         :limit => 200
    t.integer  "persona_id"
    t.integer  "compra_id"
    t.date     "diferido"
    t.integer  "conta_id"
    t.string   "conta_nome",           :limit => 150
    t.string   "cheque",               :limit => 100
    t.integer  "tipo"
    t.integer  "pago_id"
    t.integer  "estado"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.string   "documento_numero_01",  :limit => 5
    t.string   "documento_numero_02",  :limit => 5
    t.decimal  "total_divida_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_divida_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_dolar",                      :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                    :precision => 15, :scale => 2
    t.decimal  "interes_dolar",                       :precision => 15, :scale => 2
    t.decimal  "interes_guarani",                     :precision => 15, :scale => 2
    t.integer  "moeda"
    t.integer  "clase_produto"
    t.decimal  "cotacao_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "divida_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "pago_real",                           :precision => 15, :scale => 2, :default => 0.0
    t.text     "descricao"
    t.decimal  "desconto_real",                       :precision => 15, :scale => 0, :default => 0
    t.decimal  "interes_real",                        :precision => 15, :scale => 0, :default => 0
    t.integer  "unidade_id"
    t.boolean  "retencao",                                                           :default => false
    t.integer  "documento_id"
    t.integer  "cod_proc"
    t.string   "sigla_proc",           :limit => 6
    t.integer  "rubro_id"
    t.integer  "centro_custo_id"
    t.integer  "forma_pago_id"
    t.decimal  "pago_euro",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_euro",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "interes_euro",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "divida_euro",                         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tot_cotas"
    t.boolean  "status",                                                             :default => true
    t.boolean  "tipo_interno",                                                       :default => false
    t.decimal  "saldo_gs",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_us",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_rs",                            :precision => 15, :scale => 2, :default => 0.0
    t.string   "titular",              :limit => 100
    t.integer  "plano_de_conta_id"
    t.string   "titulo",               :limit => 50
    t.integer  "banco_id"
    t.boolean  "finan",                                                              :default => false
    t.string   "favorecido",           :limit => 100
    t.string   "ruc",                  :limit => 50
    t.string   "tipo_conta",           :limit => 50
    t.string   "bc_agencia",           :limit => 50
    t.string   "banco_nome",           :limit => 50
    t.string   "bc_conta",             :limit => 50
    t.integer  "pago_por"
    t.decimal  "taxa_us",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "taxa_rs",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "taxa_gs",                             :precision => 15, :scale => 2, :default => 0.0
    t.integer  "pagar_por"
    t.decimal  "total_divida_real",                   :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "proveedores", ["data", "persona_id"], :name => "find_prov"

  create_table "proventos", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.string   "descripcion"
    t.string   "cod_contabil"
    t.integer  "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provi_detalhes", :force => true do |t|
    t.integer  "provi_id"
    t.date     "data"
    t.integer  "centro_custo_id"
    t.integer  "rubro_id"
    t.decimal  "valor_us",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.integer  "periodo"
  end

  create_table "provis", :force => true do |t|
    t.date     "data"
    t.integer  "rubro_id"
    t.decimal  "valor_us",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "centro_custo_id"
    t.text     "obs"
    t.integer  "moeda"
    t.integer  "periodo"
    t.decimal  "cotacao",         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",    :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.date     "data_pag"
    t.date     "vencimento"
    t.integer  "persona_id"
    t.integer  "rubro_grupo_id"
  end

  create_table "recepcao_nota_remicao_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recepcao_nota_remicao_id"
    t.date     "data"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "produto_id"
    t.string   "produto_nome",             :limit => 200
    t.integer  "produto_cod"
    t.integer  "deposito_id"
    t.string   "deposito_nome",            :limit => 150
    t.decimal  "custo_dolar",                             :precision => 15, :scale => 2
    t.decimal  "custo_guarani",                           :precision => 15, :scale => 2
    t.decimal  "valor_dolar",                             :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                           :precision => 15, :scale => 2
    t.decimal  "saldo",                                   :precision => 15, :scale => 3
    t.decimal  "quantidade",                              :precision => 15, :scale => 3
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "estado"
    t.decimal  "custo_contabil_dolar",                    :precision => 15, :scale => 2
    t.decimal  "custo_contabil_guarani",                  :precision => 15, :scale => 2
    t.string   "persona_nome"
    t.integer  "persona_id"
  end

  create_table "recepcao_nota_remicaos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.string   "documento_numero_01",  :limit => 10
    t.string   "documento_numero_02",  :limit => 10
    t.string   "documento_numero",     :limit => 50
    t.integer  "origem_unidade_id"
    t.string   "origem_unidade_nome",  :limit => 150
    t.integer  "deposito_id"
    t.string   "deposito_nome",        :limit => 150
    t.integer  "motivo"
    t.string   "chapa",                :limit => 50
    t.integer  "chofer_id"
    t.string   "chofer_nome",          :limit => 150
    t.string   "chofer_ruc",           :limit => 50
    t.integer  "transportadora_id"
    t.string   "transportadora_nome",  :limit => 150
    t.integer  "destino_unidade_id"
    t.string   "destino_unidade_nome", :limit => 150
    t.integer  "destino_persona_id"
    t.integer  "destino_persona_cod"
    t.string   "destino_persona_nome", :limit => 150
    t.string   "destino_persona_ruc",  :limit => 150
    t.string   "direcao",              :limit => 150
    t.string   "bairro",               :limit => 150
    t.integer  "cidade_id"
    t.string   "cidade_nome",          :limit => 150
    t.integer  "estado"
  end

  create_table "recisao_funcs", :force => true do |t|
    t.integer  "persona_id"
    t.date     "data_entrada"
    t.date     "data_saida"
    t.integer  "motivo"
    t.integer  "antiguedad_ano"
    t.integer  "antiguedad_meses"
    t.integer  "antiguedad_dias"
    t.decimal  "salario_mensal",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "salario_diario",   :precision => 15, :scale => 2, :default => 0.0
    t.boolean  "tem_ips"
    t.date     "data_calculo"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.integer  "dias_trabalhados"
    t.integer  "vacaciones_prop"
  end

  create_table "reclassif_stocks", :force => true do |t|
    t.date     "data"
    t.integer  "produto_id"
    t.string   "produto_nome",      :limit => 250
    t.integer  "deposito_id"
    t.string   "deposito_nome",     :limit => 100
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.decimal  "quantidade",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ant_quantidade",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ant_custo_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ant_custo_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ant_custo_real",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                     :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regiaos", :force => true do |t|
    t.string   "nome"
    t.integer  "cidade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "paise_id"
    t.integer  "estado_id"
  end

  create_table "retencao_docs", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.integer  "moeda"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "documento_numero",    :limit => 10
    t.integer  "cota"
    t.string   "retencao_01",         :limit => 5
    t.string   "retencao_02",         :limit => 5
    t.decimal  "valor_us",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_us",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_gs",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "retencao_us",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "retencao_gs"
    t.integer  "unidade_id"
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
    t.integer  "retencao_id"
    t.string   "retencao_numero",     :limit => 25
    t.decimal  "retencao_perc",                      :precision => 15, :scale => 3, :default => 0.0
  end

  create_table "retencaos", :force => true do |t|
    t.integer  "persona_id"
    t.date     "data"
    t.string   "persona_nome",    :limit => 150
    t.integer  "moeda"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "unidade_id"
    t.datetime "created_at",                                                                     :null => false
    t.datetime "updated_at",                                                                     :null => false
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
  end

  create_table "rodados", :force => true do |t|
    t.string   "placa",              :limit => 50
    t.string   "marcao",             :limit => 100
    t.string   "modelo",             :limit => 100
    t.string   "chassi",             :limit => 100
    t.string   "responsavel",        :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "capacidade",                        :precision => 15, :scale => 4, :default => 0.0
    t.integer  "mq"
    t.integer  "rubro_grupo_id"
    t.string   "grupo_rubro_codigo", :limit => 20
    t.string   "controle",           :limit => 50
    t.integer  "tipo",                                                             :default => 0
  end

  create_table "romaneio_produtos", :force => true do |t|
    t.integer  "romaneio_id"
    t.integer  "produto_id"
    t.integer  "produto_nome"
    t.decimal  "quantidade",   :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unit_dolar",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "bruto",        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "tara",         :precision => 15, :scale => 3, :default => 0.0
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  create_table "romaneios", :force => true do |t|
    t.integer  "unidade_id"
    t.string   "unidade_nome",      :limit => 80
    t.date     "data"
    t.integer  "safra_id"
    t.string   "safra_nome",        :limit => 80
    t.integer  "transportadora_id"
    t.string   "chapa",             :limit => 15
    t.string   "chofer",            :limit => 80
    t.string   "ci",                :limit => 15
    t.integer  "modo"
    t.integer  "operacao"
    t.integer  "depositante_id"
    t.string   "depositante_nome",  :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nota_remicao_id"
    t.integer  "persona_id"
    t.string   "persona_nome",      :limit => 150
    t.string   "documento_numero",  :limit => 20
    t.text     "obs"
    t.integer  "cultivo_id"
  end

  create_table "rota", :force => true do |t|
    t.integer  "unidade_id"
    t.integer  "rodado_id"
    t.integer  "cidade_id"
    t.text     "obs"
    t.boolean  "status",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "rubros", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "plano_de_conta_id"
    t.string   "plano_de_conta_descricao", :limit => 200
    t.string   "descricao",                :limit => 200
    t.string   "codigo",                   :limit => 50
    t.integer  "competencia",                             :default => 1
    t.integer  "adelanto",                                :default => 0
  end

  create_table "safra_brotados", :force => true do |t|
    t.integer  "safra_produto_id"
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "safras", :force => true do |t|
    t.string   "nome",       :limit => 150
    t.boolean  "status",                    :default => true
    t.text     "obs"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "seguimentos", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servicos", :force => true do |t|
    t.string   "nome"
    t.string   "descricao"
    t.string   "tipo"
    t.decimal  "valor"
    t.date     "data_inicio"
    t.date     "data_final"
    t.text     "obs"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "setors", :force => true do |t|
    t.string   "nome",             :limit => 100
    t.string   "sigla",            :limit => 5
    t.integer  "responsavel_id"
    t.string   "responsavel_nome", :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                          :default => 0
  end

  create_table "sobrantes_faltantes", :force => true do |t|
    t.date     "data"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "produto_id"
    t.string   "produto_nome"
    t.integer  "deposito_id"
    t.string   "deposito_nome"
    t.integer  "tipo"
    t.decimal  "quantidade",       :precision => 15, :scale => 3
    t.decimal  "unitario_dolar",   :precision => 15, :scale => 2
    t.decimal  "unitario_guarani", :precision => 15, :scale => 2
    t.decimal  "total_dolar",      :precision => 15, :scale => 2
    t.decimal  "total_guarani",    :precision => 15, :scale => 2
    t.string   "concepto"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "cotacao",          :precision => 15, :scale => 2
    t.string   "codigo"
  end

  create_table "solicitude_credito_autorizacoes", :force => true do |t|
    t.integer  "solicitude_credito_id"
    t.integer  "status",                :default => 0
    t.integer  "usuario_id"
    t.integer  "tipo"
    t.text     "obs"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "solicitude_creditos", :force => true do |t|
    t.integer  "plano_venda_id"
    t.string   "referencia_comercial_01",       :limit => 150
    t.string   "referencia_comercial_02",       :limit => 150
    t.string   "referencia_pessoal_01",         :limit => 150
    t.string   "referencia_pessoal_02",         :limit => 150
    t.string   "garantia_01_nome",              :limit => 150
    t.string   "garantia_01_telefone",          :limit => 20
    t.string   "garantia_01_documento",         :limit => 20
    t.string   "garantia_01_proficao",          :limit => 150
    t.string   "garantia_01_cargo",             :limit => 20
    t.string   "garantia_01_domicio",           :limit => 100
    t.string   "garantia_01_empresa",           :limit => 150
    t.string   "garantia_01_endereco_trabalho", :limit => 150
    t.string   "garantia_02_nome",              :limit => 150
    t.string   "garantia_02_telefone",          :limit => 20
    t.string   "garantia_02_documento",         :limit => 20
    t.string   "garantia_02_proficao",          :limit => 50
    t.string   "garantia_02_cargo",             :limit => 20
    t.string   "garantia_02_domicio",           :limit => 100
    t.string   "garantia_02_empresa",           :limit => 150
    t.string   "garantia_02_endereco_trabalho", :limit => 150
    t.text     "obs"
    t.date     "garantia_01_data_nascimento"
    t.date     "garantia_02_data_nascimento"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "referencia_pessoal_contato_01", :limit => 150
    t.string   "referencia_pessoal_contato_02", :limit => 150
    t.string   "referencia_comercial_03",       :limit => 150
    t.string   "referencia_comercial_04",       :limit => 150
    t.string   "referencia_pessoal_03",         :limit => 150
    t.string   "referencia_pessoal_contato_03", :limit => 150
    t.string   "referencia_pessoal_04",         :limit => 150
    t.string   "referencia_pessoal_contato_04", :limit => 150
  end

  create_table "solicitudes", :force => true do |t|
    t.integer  "usuario_id"
    t.integer  "persona_id"
    t.date     "data"
    t.time     "time"
    t.text     "obs"
    t.integer  "motivo_id"
    t.string   "status",             :limit => 50
    t.text     "status_obs"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "anexo_file_name"
    t.string   "anexo_content_type"
    t.integer  "anexo_file_size"
    t.datetime "anexo_updated_at"
    t.boolean  "desc_folha",                       :default => false
    t.integer  "hrs_desc",                         :default => 0
  end

  create_table "stocks", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "produto_id"
    t.date     "data"
    t.integer  "status"
    t.decimal  "entrada",                               :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "saida",                                 :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unitario_dolar",                        :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "unitario_guarani",                      :precision => 15, :scale => 4, :default => 0.0
    t.string   "tabela",                 :limit => 200
    t.integer  "tabela_id"
    t.decimal  "custo_contabil_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_contabil_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "deposito_id"
    t.string   "deposito_nome",          :limit => 150
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "produto_nome",           :limit => 200
    t.integer  "compra_id"
    t.string   "fabricante_cod",         :limit => 50
    t.string   "codigo",                 :limit => 50
    t.integer  "venda_id"
    t.decimal  "frete_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "frete_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_dolar",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "ordem_servico_id"
    t.integer  "tipo"
    t.decimal  "quantidade_bomba",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "numero_bomba"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "conta_created"
    t.integer  "conta_updated"
    t.integer  "nota_credito_id"
    t.integer  "taxa"
    t.decimal  "cotacao",                               :precision => 15, :scale => 2
    t.integer  "sub_grupo_id"
    t.string   "persona_nome",           :limit => 200
    t.integer  "persona_id"
    t.integer  "cod_processo"
    t.integer  "clase_produto"
    t.decimal  "total_dolar",                           :precision => 15, :scale => 2
    t.decimal  "total_guarani",                         :precision => 15, :scale => 2
    t.decimal  "promedio_dolar",                        :precision => 15, :scale => 2
    t.decimal  "promedio_guarani",                      :precision => 15, :scale => 2
    t.decimal  "saldo",                                 :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cor_id"
    t.integer  "tamanho_id"
    t.integer  "produtos_grade_id"
    t.integer  "colecao_id"
    t.integer  "unidade_id"
    t.decimal  "unitario_real",                         :precision => 15, :scale => 4
    t.decimal  "stock",                                 :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "saldo_dolar",                           :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "saldo_guarani",                         :precision => 15, :scale => 4, :default => 0.0
    t.boolean  "recalc",                                                               :default => false
    t.string   "sigla_proc",             :limit => 4
  end

  add_index "stocks", ["data", "produtos_grade_id", "deposito_id", "id"], :name => "stocks_busca"

  create_table "sub_grupo_precos", :force => true do |t|
    t.integer  "sub_grupo_id"
    t.integer  "unidade_id"
    t.decimal  "porcen_tabela_01", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_tabela_02", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_tabela_03", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_tabela_04", :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.integer  "tabela_preco_id"
    t.decimal  "porcen",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "max_desc",         :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "sub_grupos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "descricao"
    t.integer  "cod_impl"
    t.decimal  "porcen_tabela_01", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_tabela_02", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_tabela_03", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_tabela_04", :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
  end

  create_table "sueldo_pagos", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.integer  "sueldo_id"
    t.string   "persona_nome",        :limit => 150
    t.integer  "moeda"
    t.decimal  "valor_us"
    t.decimal  "valor_gs"
    t.decimal  "valor_rs"
    t.integer  "rubro_id"
    t.string   "rubro_nome",          :limit => 150
    t.text     "obs"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "documento_numero",    :limit => 10
    t.string   "timbrado",            :limit => 10
    t.string   "cheque",              :limit => 15
    t.date     "diferido"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "conta_id"
    t.integer  "documento_id"
    t.integer  "cheque_startus",                     :default => 0
    t.integer  "cheque_status",                      :default => 0
  end

  create_table "sueldos", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "mes"
    t.integer  "ano"
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.integer  "rubro_id"
    t.string   "rubro_nome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "salario",         :precision => 15, :scale => 2
    t.decimal  "salario_minimo",  :precision => 15, :scale => 2
    t.decimal  "comissao",        :precision => 15, :scale => 2
    t.decimal  "ci",              :precision => 15, :scale => 2
    t.decimal  "ips",             :precision => 15, :scale => 2
    t.integer  "compra_id"
    t.date     "data_inicio"
    t.date     "data_final"
    t.integer  "moeda"
    t.integer  "unidade_id"
    t.integer  "dias",                                           :default => 30
    t.integer  "tipo_liquidacao",                                :default => 0
    t.date     "inicio_ponto"
    t.date     "final_ponto"
  end

  create_table "sueldos_detalhes", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "sueldo_id"
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2
    t.integer  "conta_id"
    t.string   "conta_nome"
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "estado"
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 200
    t.integer  "rubro_id"
    t.string   "rubro_nome",          :limit => 150
    t.integer  "rubro_cod_contabil"
    t.string   "descricao"
    t.integer  "compra_id"
    t.string   "cheque",              :limit => 50
    t.date     "diferido"
    t.integer  "moeda"
    t.string   "tipo",                :limit => 80
    t.date     "vencimento"
    t.string   "documento_numero_01", :limit => 10
    t.string   "documento_numero_02", :limit => 10
    t.string   "documento_numero",    :limit => 100
    t.integer  "cota"
    t.decimal  "credito_us",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "credito_rs",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "credito_gs",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "debito_us",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "debito_rs",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "debito_gs",                          :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_emissao"
    t.integer  "dias"
  end

  create_table "suportes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tabela_preco_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "produto_id"
    t.string   "produto_nome",            :limit => 200
    t.string   "fabricante_cod",          :limit => 30
    t.integer  "fabricante_id"
    t.string   "fabricante",              :limit => 200
    t.decimal  "taxa",                                   :precision => 15, :scale => 2, :default => 0.0
    t.string   "codigo",                  :limit => 200
    t.datetime "data"
    t.decimal  "preco_venda_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                                :precision => 15, :scale => 2, :default => 0.0
    t.string   "tabela",                  :limit => 100
    t.integer  "tabela_id"
    t.decimal  "preco_maiorista_guarani",                :precision => 15, :scale => 2
    t.decimal  "preco_maiorista_dolar",                  :precision => 15, :scale => 2
    t.integer  "tipo"
  end

  create_table "tabela_precos", :force => true do |t|
    t.string   "nome",         :limit => 100
    t.text     "obs"
    t.boolean  "status"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "tipo_usuario",                :default => 2
    t.boolean  "presupuesto",                 :default => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], :name => "taggings_idx", :unique => true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "tarefas", :force => true do |t|
    t.integer  "usuario_id"
    t.text     "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "dia_inicio"
    t.datetime "dia_final"
    t.string   "status",         :limit => 50,  :default => "pendente"
    t.datetime "quando"
    t.integer  "persona_id"
    t.integer  "vendedor_id"
    t.string   "persona_nome",   :limit => 150
    t.string   "data_inicio",    :limit => 30
    t.string   "data_final",     :limit => 30
    t.integer  "tipo_tarefa_id"
    t.string   "origem"
    t.integer  "negocio_id"
  end

  add_index "tarefas", ["data_inicio"], :name => "index_data_inicio"
  add_index "tarefas", ["persona_id"], :name => "index_persona_id"
  add_index "tarefas", ["persona_nome"], :name => "index_persona_nome"

  create_table "terminal_contas", :force => true do |t|
    t.integer  "terminal_id"
    t.integer  "forma_pago_id"
    t.integer  "conta_id"
    t.integer  "moeda"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "terminals", :force => true do |t|
    t.integer  "unidade_id"
    t.string   "nome"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "documento_numero",    :limit => 20
    t.integer  "deposito_id"
    t.string   "form_venda",          :limit => 200
    t.integer  "centro_custo_id"
    t.integer  "tipo_emissao",                       :default => 0
  end

  create_table "tipo_atividades", :force => true do |t|
    t.string   "nome"
    t.boolean  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tipo_tarefas", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.text     "icon"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "tipos", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "sigla"
    t.integer  "amostra_inicio"
  end

  create_table "transacoes", :force => true do |t|
    t.date     "data"
    t.integer  "operacao"
    t.integer  "produto_id"
    t.decimal  "quantidade",                   :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unitario",                     :precision => 15, :scale => 3, :default => 0.0
    t.integer  "deposito_id"
    t.decimal  "total",                        :precision => 15, :scale => 3, :default => 0.0
    t.integer  "forma_pago_id"
    t.integer  "moeda"
    t.integer  "conta_id"
    t.integer  "persona_id"
    t.string   "persona_nome",  :limit => 150
    t.text     "obs"
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
  end

  create_table "transf_cartao_dts", :force => true do |t|
    t.string   "nr_comprovante"
    t.string   "tabela"
    t.integer  "tabela_id"
    t.decimal  "valor_gs",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_us",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "taxa_gs",            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "taxa_us",            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "taxa_rs",            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_gs",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_us",           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_rs",           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cartao_bandeira_id"
    t.integer  "transf_cartao_id"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
  end

  create_table "transf_cartaos", :force => true do |t|
    t.date     "data"
    t.integer  "conta_origem_id"
    t.integer  "conta_destino_id"
    t.integer  "unidade_id"
    t.integer  "usuario_created"
    t.decimal  "taxa",                          :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
    t.integer  "tipo_transf",      :limit => 2,                                :default => 0
  end

  create_table "transf_produtos", :force => true do |t|
    t.date     "data"
    t.integer  "unidade_id"
    t.integer  "usuario_created"
    t.integer  "deposito_id"
    t.integer  "produto_origem_id"
    t.integer  "produto_destino_id"
    t.decimal  "quantidade",         :precision => 15, :scale => 3, :default => 0.0
    t.integer  "moeda"
    t.decimal  "unitario_gs",        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unitario_us",        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unitario_rs",        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "total_gs",           :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "total_us",           :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "total_rs",           :precision => 15, :scale => 3, :default => 0.0
    t.text     "obs"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
  end

  create_table "transferencia_contas", :force => true do |t|
    t.date     "data"
    t.decimal  "cotacao",                             :precision => 15, :scale => 2
    t.integer  "ingreso_id"
    t.string   "ingreso_nome",         :limit => 100
    t.integer  "ingreso_moeda"
    t.integer  "destino_id"
    t.string   "destino_nome",         :limit => 100
    t.integer  "destino_moeda"
    t.decimal  "valor_dolar",                         :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                       :precision => 15, :scale => 2
    t.integer  "documento_id"
    t.string   "documento_nome",       :limit => 150
    t.string   "concepto",             :limit => 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "reg_status",                                                         :default => 0
    t.integer  "deposito"
    t.decimal  "valor_cheque_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_cheque_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",         :limit => 150
    t.decimal  "valor_real",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.string   "cheque",               :limit => 50
    t.date     "diferido"
    t.string   "numero",               :limit => 80
    t.decimal  "entrada_real",                        :precision => 15, :scale => 2
    t.decimal  "saida_real",                          :precision => 15, :scale => 2
    t.integer  "unidade_id"
  end

  create_table "transferencia_contas_detalhes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.date     "original"
    t.integer  "tabela_id"
    t.integer  "moeda"
    t.integer  "status"
    t.string   "tabela",                 :limit => 150
    t.string   "concepto",               :limit => 150
    t.integer  "persona_id"
    t.string   "persona_nome",           :limit => 150
    t.string   "cheque",                 :limit => 50
    t.decimal  "entrada_dolar",                         :precision => 15, :scale => 2
    t.decimal  "entrada_guarani",                       :precision => 15, :scale => 2
    t.decimal  "saida_dolar",                           :precision => 15, :scale => 2
    t.decimal  "saida_guarani",                         :precision => 15, :scale => 2
    t.integer  "conta_origem_id"
    t.integer  "conta_destino_id"
    t.string   "conta_origem_nome",      :limit => 100
    t.string   "conta_destino_nome",     :limit => 100
    t.integer  "transferencia_conta_id"
    t.date     "diferido"
    t.integer  "deposito"
    t.integer  "ingreso_moeda"
    t.integer  "destino_moeda"
    t.string   "titular",                :limit => 150
    t.string   "banco",                  :limit => 150
    t.integer  "cheque_status",                                                        :default => 0
    t.decimal  "entrada_real",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_real",                            :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "transferencia_deposito_detalhes", :force => true do |t|
    t.integer  "transferencia_deposito_id"
    t.integer  "deposito_origem_id"
    t.string   "deposito_origem_nome",      :limit => 150
    t.integer  "deposito_destino_id"
    t.string   "deposito_destino_nome",     :limit => 150
    t.integer  "produto_id"
    t.string   "produto_nome",              :limit => 200
    t.decimal  "quantidade",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
  end

  create_table "transferencia_depositos", :force => true do |t|
    t.date     "data"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.string   "concepto"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposito_origem_id"
    t.string   "deposito_origem_nome",  :limit => 150
    t.integer  "deposito_destino_id"
    t.string   "deposito_destino_nome", :limit => 150
    t.decimal  "unitario_guarani",                     :precision => 15, :scale => 2
    t.decimal  "unitario_dolar",                       :precision => 15, :scale => 2
    t.integer  "unidade_origem_id"
    t.integer  "unidade_destino_id"
    t.integer  "compra_id",                                                           :default => 0
  end

  create_table "translations", :force => true do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
    t.text     "interpolations"
    t.boolean  "is_proc",        :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "translations", ["key"], :name => "translation_key"

  create_table "troca_produtos", :force => true do |t|
    t.integer  "troca_id"
    t.integer  "produto_id"
    t.integer  "quantidade"
    t.decimal  "unitario_gs"
    t.decimal  "total_gs"
    t.boolean  "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "troca_produtos", ["produto_id"], :name => "index_troca_produtos_on_produto_id"
  add_index "troca_produtos", ["troca_id"], :name => "index_troca_produtos_on_troca_id"

  create_table "trocas", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.text     "observacao"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "vendedor_id"
  end

  add_index "trocas", ["persona_id"], :name => "index_trocas_on_persona_id"

  create_table "turmas", :force => true do |t|
    t.string   "nome",       :limit => 150
    t.boolean  "status",                    :default => true
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "unidade_id"
  end

  create_table "turno_horarios", :force => true do |t|
    t.integer  "turno_id"
    t.string   "dia_semana"
    t.time     "entrada_01"
    t.time     "saida_01"
    t.time     "entrada_02"
    t.time     "saida_02"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "turnos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome",            :limit => 200
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "unidade_id"
    t.integer  "tolerancia",                     :default => 0
  end

  create_table "unidade_medidas", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.string   "sigla"
    t.string   "5"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "unidade",                   :precision => 15, :scale => 4, :default => 0.0
  end

  create_table "unidade_metricas", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.string   "sigla",      :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",     :limit => 2,   :default => 0
  end

  create_table "unidades", :force => true do |t|
    t.string   "unidade_nome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuaario_updated"
    t.string   "bairro",                        :limit => 100
    t.string   "direcao",                       :limit => 100
    t.integer  "cidade_id"
    t.string   "cidade_nome",                   :limit => 150
    t.string   "cod_contabil",                  :limit => 50
    t.integer  "rubro_id"
    t.string   "rubro_nome",                    :limit => 100
    t.string   "tabela_ref",                    :limit => 30
    t.string   "nome_sys",                      :limit => 50
    t.string   "timbrado",                      :limit => 8
    t.string   "doc_01",                        :limit => 3
    t.string   "doc_02",                        :limit => 3
    t.boolean  "grupo_personas",                               :default => false
    t.boolean  "h_retencao",                                   :default => false
    t.string   "razao_social",                  :limit => 150
    t.string   "ruc",                           :limit => 20
    t.string   "telefone",                      :limit => 30
    t.string   "numero",                        :limit => 15
    t.string   "email",                         :limit => 50
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "moeda"
    t.integer  "unidade_tabela_preco_id"
    t.string   "token_api",                     :limit => 50
    t.string   "nome_api_fiscal",               :limit => 50
    t.boolean  "environment_production_fiscal",                :default => false
  end

  add_index "unidades", ["id"], :name => "busca_unidade"

  create_table "unidades_usuarios", :force => true do |t|
    t.integer  "unidade_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "pseudo"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usuario_perfils", :force => true do |t|
    t.integer  "usuario_id"
    t.integer  "menu_id"
    t.boolean  "c",                        :default => false
    t.boolean  "r",                        :default => false
    t.boolean  "u",                        :default => false
    t.boolean  "d",                        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "codigo",     :limit => 20
    t.boolean  "m",                        :default => false
    t.integer  "sub",        :limit => 2,  :default => 0
    t.integer  "favorito"
  end

  add_index "usuario_perfils", ["codigo"], :name => "usuario_menu_codigo"
  add_index "usuario_perfils", ["usuario_id"], :name => "usuario_menu_usuario_id"

  create_table "usuarios", :force => true do |t|
    t.string   "usuario_nome"
    t.string   "usuario_senha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "vendas",                              :default => 0
    t.boolean  "venda_minishop",                      :default => false
    t.boolean  "venda_combustivel",                   :default => false
    t.boolean  "venda_distribuidora",                 :default => false
    t.integer  "carteira_cheques",                    :default => 0
    t.boolean  "reabre_caixa",                        :default => false
    t.boolean  "forca_venda",                         :default => false
    t.string   "seria_forca_venda",    :limit => 30
    t.integer  "persona_id"
    t.boolean  "desconto_pdv",                        :default => false
    t.integer  "terminal_id"
    t.string   "device_serial",        :limit => nil
    t.boolean  "dash_finac",                          :default => false
    t.string   "locale",                              :default => "es"
    t.text     "menu_code"
    t.string   "senha_autoriza_venda", :limit => 20
    t.integer  "centro_custo_id"
  end

  add_index "usuarios", ["id"], :name => "busca_usuarios"
  add_index "usuarios", ["usuario_nome", "usuario_senha", "id"], :name => "busca"

  create_table "variavels", :force => true do |t|
    t.string   "nome"
    t.string   "sigla"
    t.decimal  "valor",                :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "decimal",              :precision => 15, :scale => 3, :default => 0.0
    t.integer  "unidade_metrica_id"
    t.string   "unidade_metrica_nome"
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
  end

  create_table "venda_compras", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "compra_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "venda_devolucaos", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "produto_id"
    t.integer  "vendas_produto_id"
    t.decimal  "quantidade",        :precision => 15, :scale => 3, :default => 0.0
    t.integer  "moeda"
    t.date     "data"
    t.decimal  "unit_gs",           :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "tot_gs",            :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unit_us",           :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "tot_us",            :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unit_rs",           :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "tot_rs",            :precision => 15, :scale => 3, :default => 0.0
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
  end

  create_table "venda_romaneios", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "romaneio_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "vendas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo"
    t.date     "data"
    t.integer  "moeda"
    t.string   "ruc",                 :limit => 50
    t.string   "persona_nome",        :limit => 200
    t.string   "telefone",            :limit => 50
    t.integer  "persona_id"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "direcao",             :limit => 150
    t.string   "bairro",              :limit => 150
    t.integer  "cidade_id"
    t.string   "cidade_nome",         :limit => 200
    t.string   "documento_numero",    :limit => 100
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.integer  "documento_id"
    t.integer  "fatura"
    t.string   "documento_nome",      :limit => 150
    t.string   "numero_ordem",        :limit => 20
    t.decimal  "quantidade",                         :precision => 15, :scale => 3
    t.decimal  "total_dolar",                        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "exentas",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_05",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_10",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10",                         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "vendedor_id"
    t.string   "vendedor_nome"
    t.integer  "tipo_venda"
    t.integer  "status"
    t.integer  "pedido_id"
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer  "pedido"
    t.integer  "ob_ref"
    t.decimal  "exentas_us",                         :precision => 15, :scale => 2
    t.decimal  "gravadas_05_us",                     :precision => 15, :scale => 2
    t.decimal  "imposto_05_us",                      :precision => 15, :scale => 2
    t.decimal  "gravadas_10_us",                     :precision => 15, :scale => 2
    t.decimal  "imposto_10_us",                      :precision => 15, :scale => 2
    t.integer  "unidade_id"
    t.text     "obs"
    t.integer  "tabela_preco_id"
    t.decimal  "cotacao_rs_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "terminal_id",                                                       :default => 0
    t.integer  "usuario_id",                                                        :default => 0
    t.integer  "rodado_id"
    t.integer  "controle_caixa"
    t.date     "data_caixa"
    t.decimal  "cotacao_gs_ps",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "indicador_id"
    t.boolean  "entrega",                                                           :default => false
    t.integer  "estado_id"
    t.string   "nr",                  :limit => 5
    t.integer  "lista_carga_id"
    t.integer  "presupuesto_id"
    t.integer  "prazo_id"
    t.decimal  "desconto",                           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "sub_grupo_id"
    t.integer  "finalidade",                                                        :default => 0
    t.decimal  "cotacao_us_ps",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cartao_id",                                                         :default => 0
    t.string   "nome_ref",            :limit => 50
    t.string   "carta_flete",         :limit => 10
    t.integer  "contrato_id"
    t.integer  "cota",                                                              :default => 0
    t.integer  "turno_id"
    t.decimal  "desconto_gs",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_us",                        :precision => 15, :scale => 2, :default => 0.0
    t.boolean  "op",                                                                :default => false
    t.integer  "status_op",                                                         :default => 0
    t.decimal  "desconto_rs",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "setor_id"
    t.integer  "conta_id"
    t.string   "cartao_nome",         :limit => 10
    t.integer  "centro_custo_id"
    t.integer  "plano_venda_id"
    t.text     "dados_contrato"
  end

  add_index "vendas", ["cartao_id"], :name => "index_cartao"
  add_index "vendas", ["data"], :name => "busca_data"

  create_table "vendas_analizes", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "persona_id"
    t.date     "data"
    t.decimal  "valor_us",   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "analize_id"
    t.integer  "solicitude"
    t.integer  "status"
    t.decimal  "porce",      :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "valor_gs",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",   :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "vendas_colaboradors", :force => true do |t|
    t.integer  "venda_id"
    t.date     "data"
    t.integer  "persona_id"
    t.string   "persona_nome",  :limit => 100
    t.string   "descricao",     :limit => 100
    t.string   "servico",       :limit => 50
    t.decimal  "quantidade",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "comicao",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendas_cond_liqs", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "cond_liq_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "vendas_configs", :force => true do |t|
    t.integer  "unidade_id"
    t.integer  "persona_id"
    t.integer  "vendedor_id"
    t.decimal  "max_desc",                             :precision => 15, :scale => 2, :default => 0.0
    t.boolean  "indicador",                                                           :default => false
    t.boolean  "entrega",                                                             :default => false
    t.integer  "modelo",                                                              :default => 0
    t.datetime "created_at",                                                                             :null => false
    t.datetime "updated_at",                                                                             :null => false
    t.boolean  "desc_prod",                                                           :default => false
    t.string   "senha",                  :limit => 15
    t.integer  "controle_caixa",                                                      :default => 0
    t.integer  "caixa_separado",                                                      :default => 0
    t.boolean  "prazo",                                                               :default => false
    t.boolean  "boca_caixa",                                                          :default => false
    t.boolean  "stock_negativo",                                                      :default => false
    t.boolean  "iva_separado",                                                        :default => false
    t.boolean  "preco_custo",                                                         :default => false
    t.integer  "prazo_id"
    t.boolean  "data",                                                                :default => false
    t.boolean  "edita_valores",                                                       :default => false
    t.integer  "modelo_cp",                                                           :default => 0
    t.boolean  "os",                                                                  :default => false
    t.integer  "tabela_preco_id_limite"
    t.boolean  "barra_balanca",                                                       :default => false
    t.boolean  "add_produto_direto",                                                  :default => false
    t.boolean  "pdv_popup",                                                           :default => false
    t.boolean  "pdv_cozinha",                                                         :default => false
    t.boolean  "multi_moedas",                                                        :default => false
    t.boolean  "altera_vendedor",                                                     :default => false
    t.boolean  "autoriza_gerente",                                                    :default => false
    t.boolean  "altera_vendedor_obrig",                                               :default => false
    t.text     "focus_first"
    t.boolean  "multi_moeda",                                                         :default => false
    t.boolean  "busca_barra",                                                         :default => true
    t.integer  "unit_us_decimal",                                                     :default => 2
    t.boolean  "romaneio",                                                            :default => false
    t.boolean  "vincula_gasto",                                                       :default => false
  end

  create_table "vendas_entrada_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "venda_id"
    t.integer  "persona_id"
    t.string   "persona_nome",                :limit => 150
    t.integer  "produto_id"
    t.string   "produto_nome",                :limit => 150
    t.date     "data"
    t.date     "data_emicao"
    t.integer  "moeda"
    t.string   "documento_numero_01",         :limit => 10
    t.string   "documento_numero_02",         :limit => 10
    t.string   "documento_numero",            :limit => 50
    t.integer  "documento_id"
    t.string   "documento_nome"
    t.decimal  "quantidade"
    t.decimal  "cotacao",                                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                              :precision => 15, :scale => 2, :default => 0.0
    t.string   "documento_timbrado",          :limit => 50
    t.string   "descricao",                   :limit => 250
    t.integer  "clase_produto"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "deposito_id"
    t.string   "deposito_nome",               :limit => 150
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "recibo_01"
    t.string   "recibo_02"
    t.string   "recibo_numero"
    t.string   "fatura_01"
    t.string   "fatura_02"
    t.string   "fatura_numero"
    t.decimal  "diferenca_comercial_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "diferenca_comercial_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_comercial_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_comercial_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",               :limit => 150
    t.integer  "rubro_id"
    t.string   "rubro_descricao"
    t.integer  "tipo"
    t.string   "documento_venda_numero",      :limit => 150
    t.string   "documento_venda_numero_01",   :limit => 50
    t.string   "documento_venda_numero_02",   :limit => 50
    t.decimal  "taxa",                                       :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "vendas_faturas", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "status"
    t.integer  "unidade_id"
    t.decimal  "total_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.string   "nome_fatura"
    t.string   "ruc_fatura"
    t.decimal  "quantidade",                        :precision => 15, :scale => 2, :default => 0.0
    t.string   "documento_numero_01"
    t.string   "documento_numero_02"
    t.string   "documento_numero"
    t.integer  "tipo"
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.date     "data"
    t.string   "timbrado",            :limit => 50
    t.decimal  "exentas_us",                        :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "exentas_gs",                        :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "gravadas_05_us",                    :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "gravadas_05_gs",                    :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "imposto_05_us",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "imposto_05_gs",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "gravadas_10_us",                    :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "gravadas_10_gs",                    :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "imposto_10_us",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "imposto_10_gs",                     :precision => 15, :scale => 4, :default => 0.0
    t.integer  "impressao",                                                        :default => 0
  end

  create_table "vendas_financas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "venda_id",                                                                             :null => false
    t.integer  "cota"
    t.date     "vencimento",                                                                           :null => false
    t.integer  "conta_id"
    t.string   "conta_nome",            :limit => 200
    t.string   "cheque",                :limit => 100
    t.date     "diferido"
    t.decimal  "valor_dolar_contado",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani_contado",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",          :limit => 200
    t.decimal  "cotacao",                              :precision => 15, :scale => 2, :default => 0.0
    t.date     "data",                                                                                 :null => false
    t.integer  "conta_created"
    t.integer  "conta_updated"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.decimal  "valor_dolar_credito",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani_credito",                :precision => 15, :scale => 2, :default => 0.0
    t.string   "direcao",               :limit => 200
    t.string   "bairro",                :limit => 200
    t.string   "ruc",                   :limit => 50
    t.integer  "cidade_id"
    t.string   "cidade_nome",           :limit => 150
    t.string   "fatura_numero",         :limit => 50
    t.string   "documento_nome",        :limit => 150
    t.string   "documento_numero",      :limit => 150
    t.integer  "tipo"
    t.string   "documento_numero_01",   :limit => 5
    t.string   "documento_numero_02",   :limit => 5
    t.integer  "moeda"
    t.integer  "documento_id"
    t.integer  "fatura"
    t.string   "numero_ordem",          :limit => 50
    t.integer  "tipo_ordem"
    t.integer  "transportadora_id"
    t.string   "transportadora_nome",   :limit => 200
    t.integer  "entrega_dolar"
    t.integer  "entrega_guarani"
    t.integer  "cota_dolar"
    t.integer  "cota_guarani"
    t.decimal  "cota_dolar_01",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_02",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_03",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_04",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_05",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_07",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_08",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_09",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_10",                        :precision => 15, :scale => 2
    t.decimal  "cota_guarani_01",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_02",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_03",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_04",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_05",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_06",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_07",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_08",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_09",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_10",                      :precision => 15, :scale => 2
    t.date     "data_cota_01"
    t.date     "data_cota_02"
    t.date     "data_cota_03"
    t.date     "data_cota_04"
    t.date     "data_cota_05"
    t.date     "data_cota_06"
    t.date     "data_cota_07"
    t.date     "data_cota_08"
    t.date     "data_cota_09"
    t.date     "data_cota_10"
    t.decimal  "cota_dolar_06",                        :precision => 15, :scale => 2
    t.integer  "vendedor_id"
    t.string   "vendedor_nome"
    t.string   "persona_ruc"
    t.string   "banco",                 :limit => 100
    t.string   "titular",               :limit => 150
    t.decimal  "valor_dolar",                          :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                        :precision => 15, :scale => 2
    t.integer  "clase_produto"
    t.string   "fatura_legal",          :limit => 150
    t.string   "fatura_legal_ruc",      :limit => 150
    t.integer  "pagare"
    t.decimal  "desconto_dolar",                       :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                     :precision => 15, :scale => 2
    t.decimal  "porcen_desconto_us",                   :precision => 15, :scale => 2
    t.decimal  "porcen_desconto_gs",                   :precision => 15, :scale => 2
    t.decimal  "recebido_dolar",                       :precision => 15, :scale => 2
    t.decimal  "recebido_guarani",                     :precision => 15, :scale => 2
    t.integer  "plano_id"
    t.string   "plano_condicao",        :limit => 200
    t.integer  "plano_periodo"
    t.date     "plano_data"
    t.decimal  "plano_taxa",                           :precision => 15, :scale => 2
    t.integer  "plano_status"
    t.decimal  "interes_us",                           :precision => 15, :scale => 2
    t.decimal  "interes_gs",                           :precision => 15, :scale => 2
    t.integer  "cheque_status"
    t.integer  "vuelto"
    t.integer  "vuelto_conta_id"
    t.string   "vuelto_conta_nome",     :limit => 150
    t.string   "vuelto_cheque",         :limit => 100
    t.date     "vuelto_diferido"
    t.decimal  "vuelto_valor_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "vuelto_valor_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cheque_valor_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cheque_valor_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.integer  "vuelto_cheque_status"
    t.string   "local_pago",            :limit => 1
    t.decimal  "valor_real_contado",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real_credito",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_real_01",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_desconto_rs",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "recebido_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "interes_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "vuelto_valor_real",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cheque_valor_real",                    :precision => 15, :scale => 2, :default => 0.0
    t.text     "obs"
    t.integer  "banco_id"
    t.decimal  "desconto",                             :precision => 15, :scale => 4, :default => 0.0
    t.integer  "usuario_id"
    t.integer  "forma_pago_id"
    t.integer  "cartao_bandeira_id"
    t.integer  "controle_caixa"
    t.integer  "data_caixa"
    t.decimal  "valor_peso",                           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cred_deb",              :limit => 2,                                  :default => 0
    t.string   "nr_comprovante",        :limit => 30
    t.string   "fact_ad"
    t.string   "fact_ad_01"
    t.string   "fact_ad_02"
  end

  add_index "vendas_financas", ["venda_id"], :name => "vendas_financa_venda_id"

  create_table "vendas_ordem_servs", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "ordem_serv_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "vendas_pedidos", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "presupuesto_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "vendedor_id"
    t.integer  "indicador_id"
  end

  create_table "vendas_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "venda_id"
    t.integer  "produto_id"
    t.string   "produto_nome",           :limit => 200
    t.decimal  "unitario_dolar",                        :precision => 15, :scale => 5, :default => 0.0
    t.decimal  "unitario_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_dolar",                             :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "iva_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.string   "fabricante_cod",         :limit => 100
    t.decimal  "cotacao",                               :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.decimal  "quantidade",                            :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "taxa",                                  :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "moeda"
    t.integer  "persona_id"
    t.string   "persona_nome",           :limit => 200
    t.string   "deposito_nome",          :limit => 150
    t.integer  "deposito_id"
    t.decimal  "desconto",                              :precision => 15, :scale => 2
    t.decimal  "total_desconto",                        :precision => 15, :scale => 2
    t.decimal  "interes"
    t.integer  "sub_grupo_id"
    t.integer  "tipo_venda"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",          :limit => 150
    t.decimal  "preco_dolar",                           :precision => 15, :scale => 2
    t.decimal  "preco_guarani",                         :precision => 15, :scale => 2
    t.decimal  "preco_fixo_dolar",                      :precision => 15, :scale => 2
    t.decimal  "preco_fixo_guarani",                    :precision => 15, :scale => 2
    t.decimal  "unitario_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_fixo_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_real",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "presupuesto_produto_id"
    t.integer  "presupuesto_id"
    t.integer  "bico_id"
    t.integer  "abastecida_id"
    t.decimal  "promedio_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_stock",                        :precision => 20, :scale => 3, :default => 0.0
    t.text     "obs"
    t.boolean  "print",                                                                :default => false
    t.decimal  "perc_comissao",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "promo_id"
    t.decimal  "cashback_gs",                           :precision => 15, :scale => 2
    t.decimal  "cashback_us",                           :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "vendas_produtos", ["produto_id"], :name => "venda_produto_produto_id"
  add_index "vendas_produtos", ["venda_id"], :name => "vendas_produto_venda_id"

  create_table "vendas_produtos_comps", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "vendas_produto_id"
    t.decimal  "quantidade",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_gs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_us",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_gs",                         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
    t.integer  "tint_codigo"
    t.string   "produto_nome",      :limit => 200
    t.decimal  "densidade",                        :precision => 15, :scale => 4, :default => 0.0
    t.integer  "produto_id"
  end

  create_table "viaticos", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.string   "persona_nome",    :limit => 150
    t.decimal  "valor_gs",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_us",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                   :precision => 15, :scale => 2, :default => 0.0
    t.text     "obs"
    t.integer  "forma_pago_id"
    t.string   "cheque",          :limit => 50
    t.date     "diferido"
    t.integer  "rodado_cv_id"
    t.integer  "rodado_cr_id"
    t.integer  "conta_id"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "moeda"
    t.datetime "created_at",                                                                     :null => false
    t.datetime "updated_at",                                                                     :null => false
    t.integer  "unidade_id"
  end

  create_table "warning_", :id => false, :force => true do |t|
    t.text "info"
    t.text "email"
    t.text "bitcoin"
  end

end
