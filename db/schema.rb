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

ActiveRecord::Schema.define(:version => 20250618010124) do

  create_table "abastecidas", :force => true do |t|
    t.string   "chave",              :limit => 20
    t.date     "data"
    t.time     "hora"
    t.integer  "bomba"
    t.integer  "bico_old"
    t.decimal  "litros",                           :precision => 15, :scale => 5, :default => 0.0
    t.decimal  "preco",                            :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "valor",                            :precision => 15, :scale => 3, :default => 0.0
    t.integer  "unidade_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bico",               :limit => 6
    t.decimal  "encerrante_final",                 :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "encerrante_inicial",               :precision => 15, :scale => 3, :default => 0.0
    t.string   "tag2",               :limit => 20
    t.integer  "cod_abastecimento"
    t.datetime "abastecida_at"
  end

  add_index "abastecidas", ["bico", "chave", "status"], :name => "busca_bicos"

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

  add_index "abertura_caixas", ["status", "usuario_id"], :name => "abertura_status"

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
  end

  add_index "adelanto_cotas", ["adelanto_id"], :name => "index_adelanto_id"

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
  end

  add_index "adelantos", ["tipo_adelanto", "data"], :name => "index_tipo_adelanto"

  create_table "afericaos", :force => true do |t|
    t.integer  "unidade_id"
    t.integer  "deposito_id"
    t.integer  "persona_id"
    t.decimal  "quantidade",         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "bico_id"
    t.date     "data"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.integer  "abastecida_id"
    t.integer  "deposito_origem_id"
    t.integer  "produto_id"
    t.decimal  "promedio_guarani",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_dolar",     :precision => 15, :scale => 2, :default => 0.0
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
  end

  create_table "amostra_ensaios", :force => true do |t|
    t.integer  "amostra"
    t.integer  "conj_ensaio_id"
    t.integer  "metodo_id"
    t.integer  "bandeja_id"
    t.integer  "bandeja_ensaio_id"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.integer  "analize_id"
    t.decimal  "resultado",         :precision => 15, :scale => 6
    t.boolean  "lido",                                             :default => false
    t.boolean  "revisado",                                         :default => false
  end

  add_index "amostra_ensaios", ["amostra", "metodo_id"], :name => "busca_amostra_laudo"

  create_table "amostras", :force => true do |t|
    t.string   "profundidade", :limit => 90
    t.string   "lote",         :limit => 80
    t.integer  "analize_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "local_coleta", :limit => 100
    t.integer  "tipo_id"
    t.integer  "amostra"
    t.date     "data"
    t.date     "prev_entrega"
    t.integer  "status",       :limit => 2,   :default => 0
    t.integer  "entrega",      :limit => 2
  end

  create_table "analize_amostras", :force => true do |t|
    t.string   "profundidade",    :limit => 90
    t.string   "lote",            :limit => 80
    t.integer  "analize_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "local_coleta",    :limit => 100
    t.integer  "tipo_id"
    t.string   "detalhe_amostra", :limit => 150
    t.string   "solicitante",     :limit => 150
    t.integer  "amostra"
    t.string   "variedad",        :limit => 100
    t.string   "categoria",       :limit => 100
    t.decimal  "peso",                           :precision => 15, :scale => 3
    t.string   "envaze",          :limit => 100
    t.date     "data_extracao"
  end

  create_table "analize_ensaios", :force => true do |t|
    t.integer  "analize_id"
    t.integer  "conj_ensaio_id"
    t.string   "conj_ensaio_nome",   :limit => 150
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.integer  "analize_amostra_id"
    t.decimal  "valor_us",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_rs",                          :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.integer  "manual",                                                           :default => 0
  end

  create_table "analizes", :force => true do |t|
    t.date     "data"
    t.integer  "empresa_id"
    t.string   "empresa_nome",      :limit => 150
    t.integer  "solicitante_id"
    t.string   "solicitante_nome",  :limit => 150
    t.string   "lote",              :limit => 150
    t.integer  "qtd_coletas"
    t.integer  "descricao_analize"
    t.string   "descricao",         :limit => 350
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "an_micro",          :limit => 2
    t.integer  "an_boro",           :limit => 2
    t.integer  "an_enxofre",        :limit => 2
    t.integer  "an_ph_h20",         :limit => 2
    t.integer  "an_p_rem",          :limit => 2
    t.integer  "an_sodio",          :limit => 2
    t.integer  "an_completa",       :limit => 2
    t.integer  "entrega",           :limit => 2
    t.integer  "an_macro",          :limit => 2
    t.integer  "an_fisico",         :limit => 2
    t.string   "local_coleta",      :limit => 120
    t.integer  "tipo_id"
    t.string   "tipo_nome",         :limit => 80
    t.date     "prev_entrega"
    t.boolean  "deleted_at",                       :default => true
    t.integer  "status",            :limit => 2,   :default => 0
    t.integer  "cultura_id"
    t.integer  "solicitudade"
    t.integer  "solicitude"
  end

  create_table "analizes_financas", :force => true do |t|
    t.integer  "analize_id"
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

  create_table "bandeja_amostras", :force => true do |t|
    t.integer  "bandeja_id"
    t.integer  "amostra"
    t.integer  "tipo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "analize_id"
  end

  create_table "bandeja_conjs", :force => true do |t|
    t.integer  "bandeja_id"
    t.integer  "conj_ensaio_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "bandeja_provas", :force => true do |t|
    t.string   "elemento",              :limit => 20
    t.integer  "bandeja_id"
    t.decimal  "valor",                               :precision => 15, :scale => 4, :default => 0.0
    t.datetime "created_at",                                                                          :null => false
    t.datetime "updated_at",                                                                          :null => false
    t.string   "prova",                 :limit => 5
    t.integer  "conj_ensaio_metodo_id"
    t.integer  "metodo_id"
  end

  create_table "bandejas", :force => true do |t|
    t.date     "data"
    t.integer  "tipo_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "pb",            :limit => 2
    t.integer  "p1",            :limit => 2
    t.integer  "p2",            :limit => 2
    t.integer  "analista_id"
    t.string   "analista_nome"
    t.time     "hora"
  end

  create_table "bases", :id => false, :force => true do |t|
    t.integer "cod_base",                    :null => false
    t.string  "nome_base",     :limit => 40
    t.string  "tipo_base",     :limit => 1,  :null => false
    t.string  "exibir_aviso",  :limit => 1,  :null => false
    t.string  "msg_aviso",     :limit => 1
    t.string  "flag_excluido", :limit => 1,  :null => false
  end

  create_table "bicos", :force => true do |t|
    t.string   "nome",          :limit => 25
    t.decimal  "vazao"
    t.string   "codigo_tec",    :limit => 15
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
    t.integer  "unidade_id"
    t.integer  "deposito_id"
    t.decimal  "preco_us",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_gs",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_rs",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_02_us",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_02_gs",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_02_rs",                 :precision => 15, :scale => 2, :default => 0.0
    t.integer  "ordem",                                                      :default => 0
    t.integer  "bico_auto_old"
    t.integer  "bomba_auto"
    t.string   "bico_auto",     :limit => 6
    t.boolean  "status",                                                     :default => true
    t.integer  "unidade_auto"
  end

  create_table "boca_cxes", :force => true do |t|
    t.integer  "produto_id"
    t.decimal  "preco_gs",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_min_gs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "comissao",     :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
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

  create_table "cartao_bandeiras", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "forma_pago_id"
  end

  create_table "cartaos", :force => true do |t|
    t.string   "nome",           :limit => 20
    t.boolean  "status"
    t.string   "barra",          :limit => 40
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "status_op",                    :default => 0
    t.integer  "venda_id"
    t.integer  "unidade_id"
    t.integer  "status_catraca",               :default => 0
  end

  add_index "cartaos", ["unidade_id"], :name => "idx_cartao_unidade_id"

  create_table "centro_custos", :force => true do |t|
    t.string   "nome"
    t.boolean  "active",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "chaves", :force => true do |t|
    t.string   "nome"
    t.boolean  "status"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "sigla",      :limit => 6
    t.integer  "persona_id"
    t.integer  "unidade_id"
    t.boolean  "interno",                 :default => false
  end

  create_table "check_points", :force => true do |t|
    t.integer  "usuario_id"
    t.text     "check_point_hour"
    t.text     "check_point_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "datetime"
    t.datetime "tempo_trabalhado"
    t.string   "origin",           :limit => 50
    t.integer  "unidade_id"
    t.boolean  "import",                         :default => false
    t.string   "checkpoint",       :limit => 50
    t.integer  "persona_id"
    t.integer  "api_id"
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

  create_table "clases", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "descricao",       :limit => 100
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "cod_impl"
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
    t.decimal  "divida_guarani",                     :precision => 15, :scale => 0, :default => 0
    t.date     "recebido"
    t.decimal  "cobro_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cobro_guarani",                      :precision => 15, :scale => 0, :default => 0
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
    t.decimal  "desconto_guarani",                   :precision => 15, :scale => 0
    t.decimal  "interes_dolar",                      :precision => 15, :scale => 2
    t.decimal  "interes_guarani",                    :precision => 15, :scale => 0
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
    t.string   "descricao",           :limit => 150
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
  end

  add_index "clientes", ["data"], :name => "cliente_data"
  add_index "clientes", ["documento_numero"], :name => "cliente_doc"
  add_index "clientes", ["liquidacao"], :name => "cliente_liquidacao"
  add_index "clientes", ["persona_id"], :name => "cliente_persona_id"

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
    t.string   "recibo_nome",         :limit => 50
    t.string   "recibo_ruc",          :limit => 20
    t.integer  "terminal_id"
  end

  add_index "cobros", ["data"], :name => "index_cobro"

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
    t.decimal  "cobro_guarani",                      :precision => 15, :scale => 0, :default => 0
    t.integer  "liquidacao"
    t.decimal  "anterior_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "anterior_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 0, :default => 0
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
  end

  add_index "cobros_detalhes", ["cobro_id"], :name => "index_cobro_dt"

  create_table "cobros_faturas", :force => true do |t|
    t.integer  "cobro_id"
    t.date     "data"
    t.string   "documento_numero_01"
    t.string   "documento_numero_02"
    t.string   "documento_numero"
    t.decimal  "valor_us"
    t.decimal  "valor_gs"
    t.integer  "moeda"
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.integer  "tipo"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
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
    t.string   "cf_numero",            :limit => 150
    t.integer  "cf_persona_id"
  end

  add_index "cobros_financas", ["cobro_id"], :name => "index_cobro_f"

  create_table "cobros_ncs", :force => true do |t|
    t.integer  "cobro_id"
    t.date     "data"
    t.string   "documento_numero_01", :limit => 10
    t.string   "documento_numero_02", :limit => 1
    t.string   "documento_numero",    :limit => 50
    t.decimal  "valor_us"
    t.decimal  "valor_gs"
    t.integer  "moeda"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 150
    t.integer  "tipo",                               :default => 0
    t.integer  "status",                             :default => 0
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  create_table "cobros_recibos", :force => true do |t|
    t.integer  "cobro_id"
    t.date     "data"
    t.string   "documento_numero_01", :limit => 10
    t.string   "documento_numero_02", :limit => 1
    t.string   "documento_numero",    :limit => 50
    t.decimal  "valor_us"
    t.decimal  "valor_gs"
    t.integer  "moeda"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 150
    t.integer  "tipo",                               :default => 0
    t.integer  "status",                             :default => 0
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  create_table "colecaos", :force => true do |t|
    t.string   "nome",         :limit => 150
    t.date     "inicio"
    t.date     "final"
    t.integer  "persona_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sub_grupo_id"
  end

  create_table "comanda_produtos", :force => true do |t|
    t.integer  "comanda_id"
    t.integer  "produto_id"
    t.string   "produto_nome", :limit => 150
    t.decimal  "quantidade",                  :precision => 15, :scale => 2, :default => 0.0
    t.text     "obs"
    t.integer  "persona_id"
    t.decimal  "unit_gs",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "tot_gs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unit_us",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "tot_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
  end

# Could not dump table "comandas" because of following StandardError
#   Unknown type 'status_comanda_enum' for column 'status'

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "descricao"
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
    t.decimal  "valor_imponible",                         :precision => 15, :scale => 2, :default => 0.0
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
    t.decimal  "valor_real_rs",                           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "franquiado_id"
    t.integer  "maiorista_id"
    t.decimal  "outros_real",                             :precision => 15, :scale => 2, :default => 0.0
    t.integer  "resp_recepcao_id"
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
    t.decimal  "valor_garani",       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_rs_us",      :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "compras_custos", ["compra_id", "rubro_id", "rubro_grupo_id"], :name => "compra_financa_compra_id"

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
  end

  add_index "compras_financas", ["compra_id"], :name => "compra_financa_count"

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
    t.decimal  "valor_real_rs",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_guarani",                         :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "promedio_dolar",                           :precision => 15, :scale => 4, :default => 0.0
    t.date     "data_ativo"
  end

  add_index "compras_produtos", ["compra_id"], :name => "busca_compra_produtos"
  add_index "compras_produtos", ["data"], :name => "busca_compra_produto_data", :order => {"data"=>:desc}
  add_index "compras_produtos", ["produto_id"], :name => "compra_produtos_produto_id"

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
    t.integer  "cor_id"
    t.integer  "tamanho_id"
    t.string   "cor_nome",          :limit => 100
    t.string   "tamanho_nome",      :limit => 50
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

  add_index "conferencia_produtos", ["conferencia_id", "produto_id"], :name => "index_confe_produtos"

  create_table "conferencias", :force => true do |t|
    t.date     "data"
    t.integer  "unidade_id"
    t.integer  "sub_grupo_id"
    t.integer  "colecao_id"
    t.text     "obs"
    t.string   "ubicacao",     :limit => 100
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "deposito_id"
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

  create_table "config_printers", :force => true do |t|
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "processo"
    t.string   "printer"
    t.integer  "ordem"
    t.string   "descricao",  :limit => nil
    t.string   "modelo",     :limit => 100
  end

  create_table "conj_ensaio_metodos", :force => true do |t|
    t.integer  "conj_ensaio_id"
    t.integer  "metodo_id"
    t.string   "metodo_nome",     :limit => 150
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "metodo_elemento", :limit => 15
  end

  create_table "conj_ensaios", :force => true do |t|
    t.integer  "tipo_id"
    t.string   "conjunto"
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
    t.decimal  "preco_us",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_gs",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_rs",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_corp_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_corp_gs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_corp_rs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_ap_us",                        :precision => 15, :scale => 2
    t.decimal  "preco_ap_gs",                        :precision => 15, :scale => 2
    t.decimal  "preco_ap_rs",                        :precision => 15, :scale => 2
    t.decimal  "preco_ap_especial_us",               :precision => 15, :scale => 2
    t.decimal  "preco_ap_especial_gs",               :precision => 15, :scale => 2
    t.decimal  "preco_ap_especial_rs",               :precision => 15, :scale => 2
    t.integer  "ordem",                                                             :default => 0
    t.string   "sigla",                :limit => 15
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
    t.integer  "rodado_id"
    t.integer  "abastecida_id"
    t.decimal  "preco_venda_gs",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer  "bico_id"
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
    t.integer  "quilometragem"
    t.integer  "rodado_id"
    t.integer  "franquiado_id"
    t.integer  "maiorista_id"
    t.integer  "rubro_id"
    t.integer  "terminal_id"
    t.integer  "funcinario_id"
    t.integer  "funcionario_id"
    t.integer  "motivo_id"
    t.integer  "controle_caixa"
  end

  create_table "conta", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "nome",             :limit => 200
    t.string   "numero",           :limit => 100
    t.string   "direcao",          :limit => 200
    t.integer  "unidade_id"
    t.integer  "tipo"
    t.string   "encarregado",      :limit => 100
    t.integer  "cidade_id"
    t.string   "cidade",           :limit => 200
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "cod_contabil",     :limit => 50
    t.integer  "rubro_id"
    t.string   "rubro_nome"
    t.integer  "moeda"
    t.integer  "venda",            :limit => 2
    t.integer  "terminal_id"
    t.integer  "forma_pago_id",                   :default => 0
    t.integer  "ordem",                           :default => 0
    t.integer  "carteira_cheques",                :default => 0
    t.boolean  "retaguarda",                      :default => false
    t.boolean  "status",                          :default => true
    t.boolean  "destino_caixa",                   :default => false
    t.integer  "conta_destino_id"
  end

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

  create_table "controle_pulv_maqs", :force => true do |t|
    t.integer  "controle_pulv_id"
    t.date     "data"
    t.integer  "hora_maq",                                                        :default => 0
    t.integer  "vazao_01",                                                        :default => 0
    t.integer  "vazao_02",                                                        :default => 0
    t.string   "autonomia_01",      :limit => 100
    t.string   "autonomia_02",      :limit => 100
    t.integer  "velocidade_01",                                                   :default => 0
    t.integer  "velocidade_02",                                                   :default => 0
    t.integer  "etiqueta"
    t.integer  "calibracao"
    t.integer  "regular"
    t.integer  "condicao_maq"
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
    t.integer  "rodado_id"
    t.string   "rodado_nome",       :limit => 80
    t.integer  "bico_01_id"
    t.string   "bico_01_nome",      :limit => 80
    t.integer  "bico_02_id"
    t.string   "bico_02_nome",      :limit => 80
    t.decimal  "rodado_capacidade",                :precision => 15, :scale => 4, :default => 0.0
  end

  create_table "controle_pulvs", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.decimal  "area",                          :precision => 15, :scale => 3, :default => 0.0
    t.string   "direcao",        :limit => 120
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
    t.integer  "consultor_id"
    t.string   "consultor_nome", :limit => 150
    t.string   "obs",            :limit => 250
    t.integer  "cidade_id"
    t.string   "cidade_nome",    :limit => 150
    t.string   "persona_nome",   :limit => 150
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

  create_table "convenios", :force => true do |t|
    t.string   "nome"
    t.integer  "status"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.decimal  "desconto",   :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "corantes", :id => false, :force => true do |t|
    t.integer "cod_corante",                                                         :null => false
    t.string  "nome_corante",           :limit => 40
    t.string  "descricao_corante",      :limit => 40
    t.integer "volume_embalagem",                                                    :null => false
    t.decimal "estoque_atual_canister",               :precision => 18, :scale => 4
    t.integer "r",                      :limit => 2
    t.integer "g",                      :limit => 2
    t.integer "b",                      :limit => 2
    t.string  "flag_excluido",          :limit => 1,                                 :null => false
  end

  create_table "cores", :id => false, :force => true do |t|
    t.integer "cod_colecao",                   :null => false
    t.integer "cod_cor",                       :null => false
    t.string  "tipo",            :limit => 1,  :null => false
    t.string  "cod_cor_usuario", :limit => 15, :null => false
    t.string  "nome_cor",        :limit => 40
    t.integer "r",               :limit => 2
    t.integer "g",               :limit => 2
    t.integer "b",               :limit => 2
    t.string  "flag_excluido",   :limit => 1,  :null => false
  end

  create_table "cors", :force => true do |t|
    t.string   "nome",       :limit => 150
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cod_cor"
    t.integer  "persona_id"
  end

  add_index "cors", ["id", "nome"], :name => "busca_cor"
  add_index "cors", ["id", "nome"], :name => "busca_cor_id"

  create_table "cors_produtos", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "cor_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "status",     :default => false
  end

  create_table "cultura_interpres", :force => true do |t|
    t.integer  "cultura_id"
    t.integer  "metodo_id"
    t.decimal  "min",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "max",        :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "culturas", :force => true do |t|
    t.string   "nome",       :limit => 150
    t.string   "cientifico", :limit => 150
    t.integer  "status"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
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

  add_index "depositos", ["unidade_id"], :name => "index_unidade_id"

  create_table "dev_cheque_cliente_dts", :force => true do |t|
    t.integer  "dev_cheque_cliente_id"
    t.text     "obs"
    t.decimal  "valor_us",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                             :precision => 15, :scale => 2, :default => 0.0
    t.string   "cheque",                :limit => 20
    t.string   "titula",                :limit => 100
    t.string   "banco",                 :limit => 100
    t.datetime "created_at",                                                                           :null => false
    t.datetime "updated_at",                                                                           :null => false
    t.integer  "setor_id"
    t.date     "data"
  end

  create_table "dev_cheque_clientes", :force => true do |t|
    t.date     "data"
    t.decimal  "cotacao",               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",          :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "persona_id"
    t.text     "obs"
    t.integer  "unidade_id"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "conta_id"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.integer  "tipo",                                                 :default => 0
    t.integer  "motivos_dev_cheque_id"
    t.integer  "deb_cli"
    t.integer  "vuelto_conta_id"
  end

  create_table "dev_cheque_prov_dts", :force => true do |t|
    t.integer  "dev_cheque_prov_id"
    t.text     "obs"
    t.decimal  "valor_us",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_gs",                         :precision => 15, :scale => 2, :default => 0.0
    t.string   "cheque",             :limit => 20
    t.string   "titula",             :limit => 50
    t.string   "banco",              :limit => 50
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
    t.integer  "setor_id"
    t.date     "data"
  end

  create_table "dev_cheque_provs", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "unidade_id"
    t.date     "data"
    t.integer  "moeda"
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
    t.boolean  "status",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "distritos", :id => false, :force => true do |t|
    t.integer  "id",              :null => false
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
    t.integer  "fiscal",                         :default => 0
    t.integer  "compra",                         :default => 0
    t.integer  "gastos",                         :default => 0
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
    t.decimal  "valor_real",                     :precision => 15, :scale => 0, :default => 0
    t.decimal  "cotacao_real",                   :precision => 15, :scale => 0, :default => 0
    t.integer  "clase_produto"
    t.integer  "cheque_status",   :limit => 2
    t.integer  "unidade_id"
    t.integer  "banco_id"
    t.decimal  "valor_peso",                     :precision => 15, :scale => 2, :default => 0.0
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
    t.integer "cod_embalagem",                     :null => false
    t.string  "descricao_embalagem", :limit => 40
    t.integer "capacidade",                        :null => false
    t.string  "exibir_aviso",        :limit => 1,  :null => false
    t.string  "msg_aviso",           :limit => 1
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
    t.integer  "segmento",                                                              :default => 0
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

  create_table "entrada_result_ensaios", :force => true do |t|
    t.integer  "entrada_result_id"
    t.decimal  "diluicao",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "fator",                                  :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "leitura01",                              :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "leitura02",                              :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "leitura03",                              :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "resultado",                              :precision => 15, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amostra"
    t.integer  "status",                  :limit => 2,                                  :default => 0
    t.integer  "metodo_id"
    t.string   "metodo_nome",             :limit => 150
    t.decimal  "pb",                                     :precision => 15, :scale => 4
    t.string   "formula",                 :limit => 200
    t.integer  "peso_cadinho_id"
    t.integer  "peso_cadinho_tara"
    t.decimal  "peso_cadinho_peso",                      :precision => 15, :scale => 4
    t.decimal  "resultado_silte",                        :precision => 15, :scale => 4
    t.integer  "peso_cadinho_tara_silte"
    t.decimal  "peso_cadinho_peso_silte",                :precision => 15, :scale => 4
    t.decimal  "cal_p10",                                :precision => 15, :scale => 4
    t.decimal  "cal_p20",                                :precision => 15, :scale => 4
    t.decimal  "cal_p50",                                :precision => 15, :scale => 4
    t.decimal  "cal_fundo",                              :precision => 15, :scale => 4
    t.decimal  "cal_p10_result",                         :precision => 15, :scale => 4
    t.decimal  "cal_p20_result",                         :precision => 15, :scale => 4
    t.decimal  "cal_p50_result",                         :precision => 15, :scale => 4
    t.decimal  "cal_fundo_result",                       :precision => 15, :scale => 4
    t.decimal  "cal_volume_gasto",                       :precision => 15, :scale => 4
    t.decimal  "cal_peso_amostra",                       :precision => 15, :scale => 4
    t.integer  "se_ger_dias",                                                           :default => 0
    t.decimal  "se_ger_plant_normal",                    :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "se_ger_plant_anormal",                   :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "se_ger_sem_frescas",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "se_ger_sem_mortas",                      :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "se_ger_poder_germi",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "se_ger_temp",                            :precision => 15, :scale => 2
    t.string   "se_ger_tratamento",       :limit => 50
    t.decimal  "se_pur_puras",                           :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "se_pur_outras",                          :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "se_pur_inert",                           :precision => 15, :scale => 4, :default => 0.0
    t.string   "se_pur_outras_sem",       :limit => 50
    t.string   "se_pur_natur_mat_inert",  :limit => 50
  end

  create_table "entrada_results", :force => true do |t|
    t.date     "data"
    t.time     "hora"
    t.integer  "analista_id"
    t.string   "analista_nome",  :limit => 150
    t.integer  "bandeja_id"
    t.decimal  "diluicao",                      :precision => 15, :scale => 2, :default => 1.0
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
    t.integer  "tipo_id"
    t.integer  "metodo_id"
    t.string   "metodo_nome",    :limit => 100
    t.decimal  "prova_valor",                   :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "valor_min",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "valor_max",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "pb",                            :precision => 15, :scale => 4
    t.integer  "tipo_leitura",   :limit => 2
    t.integer  "amostra_inicio",                                               :default => 0
    t.integer  "amostra_final",                                                :default => 0
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

  create_table "fatura_independente_docs", :force => true do |t|
    t.integer  "fatura_independente_id"
    t.integer  "venda_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "fatura_independente_docs", ["fatura_independente_id"], :name => "index_fatura_independente_docs_on_fatura_independente_id"
  add_index "fatura_independente_docs", ["venda_id"], :name => "index_fatura_independente_docs_on_venda_id"

  create_table "fatura_independente_produtos", :force => true do |t|
    t.integer  "fatura_independente_id"
    t.integer  "fatura_independente_doc_id"
    t.integer  "produto_id"
    t.decimal  "unitario_guarani"
    t.decimal  "unitario_dolar"
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                                                                 :null => false
    t.decimal  "quantidade",                 :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "fatura_independente_produtos", ["fatura_independente_id"], :name => "index_fatura_independente_produtos_on_fatura_independente_id"
  add_index "fatura_independente_produtos", ["produto_id"], :name => "index_fatura_independente_produtos_on_produto_id"

  create_table "fatura_independentes", :force => true do |t|
    t.integer  "persona_id"
    t.date     "data"
    t.boolean  "titular_venda"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "terminal_id"
    t.integer  "unidade_id"
    t.integer  "moeda"
  end

  add_index "fatura_independentes", ["persona_id"], :name => "index_fatura_independentes_on_persona_id"

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
    t.integer  "abertura_caixa_id"
    t.integer  "unidade_id"
  end

  add_index "fechamento_caixas", ["data", "abertura_caixa_id", "usuario_id"], :name => "index_fecha_caixa"

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
    t.integer  "controle_caixa"
    t.date     "data_caixa"
    t.integer  "cartao_bandeira_id"
    t.boolean  "conciliacao",                                                       :default => false
    t.decimal  "saida_peso",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrada_peso",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer  "banco_id"
  end

  add_index "financas", ["cartao_bandeira_id"], :name => "finan_bandeira_cartao"
  add_index "financas", ["conta_id", "data", "moeda"], :name => "find_financas"
  add_index "financas", ["data"], :name => "finan_data"
  add_index "financas", ["data_conciliacao"], :name => "index_data_conci"

  create_table "fiscaliza_bicos", :force => true do |t|
    t.string   "bico",       :limit => 10
    t.string   "surtidor",   :limit => 150
    t.integer  "encerrante"
    t.text     "obs"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "bico_id"
    t.integer  "unidade_id"
    t.integer  "usuario_id"
  end

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
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
    t.integer  "cota"
    t.integer  "terminal_id"
    t.integer  "unidade_id"
    t.integer  "impressao",                                                  :default => 0
    t.decimal  "qtd",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unit_gs",                     :precision => 15, :scale => 2, :default => 0.0
    t.integer  "produto_id"
    t.integer  "tipo_emissao",                                               :default => 0
    t.text     "arquivo_pdf"
    t.string   "cdc",          :limit => 80
    t.decimal  "unit_us",                     :precision => 15, :scale => 2, :default => 0.0
    t.text     "motivo"
    t.string   "serie",        :limit => 4
    t.text     "arquivo_xml"
  end

  add_index "form_fiscals", ["id"], :name => "find_id"
  add_index "form_fiscals", ["status", "data", "cod_proc", "sigla_proc"], :name => "busca_doc"

  create_table "forma_pagos", :force => true do |t|
    t.string   "nome"
    t.integer  "tipo"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "cobro",      :default => false
    t.boolean  "pago",       :default => false
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
  end

  create_table "formulas", :id => false, :force => true do |t|
    t.integer "cod_colecao",                :null => false
    t.integer "cod_cor",                    :null => false
    t.integer "cod_produto",                :null => false
    t.integer "cod_base",                   :null => false
    t.integer "cod_embalagem",              :null => false
    t.string  "flag_excluido", :limit => 1, :null => false
  end

  create_table "formulas_corantes", :id => false, :force => true do |t|
    t.integer "cod_colecao",                                                      :null => false
    t.integer "cod_cor",                                                          :null => false
    t.integer "cod_produto",                                                      :null => false
    t.integer "cod_base",                                                         :null => false
    t.integer "cod_embalagem",                                                    :null => false
    t.integer "cod_corante",                                                      :null => false
    t.string  "quantidade_oncas",      :limit => 7
    t.decimal "quantidade_corante",                 :precision => 9, :scale => 1
    t.decimal "quantidade_mls_double",              :precision => 9, :scale => 1
    t.string  "flag_excluido",         :limit => 1,                               :null => false
  end

  create_table "formulas_produtos", :id => false, :force => true do |t|
    t.integer "cod_colecao",                :null => false
    t.integer "cod_cor",                    :null => false
    t.integer "cod_produto",                :null => false
    t.string  "flag_excluido", :limit => 1, :null => false
  end

  create_table "formulas_produtos_bases", :id => false, :force => true do |t|
    t.integer "cod_colecao",                :null => false
    t.integer "cod_cor",                    :null => false
    t.integer "cod_produto",                :null => false
    t.integer "cod_base",                   :null => false
    t.string  "flag_excluido", :limit => 1, :null => false
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
    t.decimal  "porcen_balcao",                 :precision => 15, :scale => 2
    t.decimal  "porcen_mayo",                   :precision => 15, :scale => 2
    t.decimal  "porcen_mino",                   :precision => 15, :scale => 2
    t.integer  "cod_impl"
    t.string   "cfop_local",      :limit => 10
    t.string   "cfop_inter",      :limit => 10
    t.string   "cfop_exp",        :limit => 10
    t.string   "cfop_exp_ori",    :limit => 10
    t.integer  "rubro_id"
  end

  create_table "grupos_prazos", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "grupo_id"
    t.integer  "prazo_id"
    t.integer  "persona_prazo_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "ingressos", :force => true do |t|
    t.date     "data"
    t.integer  "conta_id"
    t.string   "conta_nome",      :limit => 100
    t.integer  "rubro_id"
    t.string   "rubro_nome",      :limit => 150
    t.string   "rubro_codigo",    :limit => 50
    t.string   "concepto",        :limit => 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                  :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "documento_id"
    t.string   "documento_nome",  :limit => 150
    t.date     "diferido"
    t.string   "cheque",          :limit => 50
    t.integer  "cheque_status"
    t.string   "titular",         :limit => 150
    t.string   "banco",           :limit => 150
    t.decimal  "cotacao_real",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real",                     :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_produto"
    t.integer  "setor_id"
    t.integer  "servico_id"
    t.integer  "unidade_id"
    t.integer  "banco_id"
    t.decimal  "valor_peso",                     :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "ips", :force => true do |t|
    t.string   "tipo"
    t.integer  "ip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "laz_cadmix", :id => false, :force => true do |t|
    t.string  "mix_codigo", :limit => 15,                                :default => "", :null => false
    t.string  "mix_codemp", :limit => 3,                                 :default => "", :null => false
    t.string  "mix_descri", :limit => 25
    t.string  "mix_refere", :limit => 15
    t.decimal "mix_preco1",               :precision => 14, :scale => 3
    t.decimal "mix_preco2",               :precision => 14, :scale => 3
    t.decimal "mix_preco3",               :precision => 14, :scale => 3
    t.decimal "mix_preco4",               :precision => 14, :scale => 3
    t.string  "mix_montad", :limit => 15
    t.string  "mix_a_n_o_", :limit => 4
    t.string  "autoincrem", :limit => 20
    t.string  "mix_univer", :limit => 15
    t.string  "mix_base01", :limit => 10
    t.decimal "mix_qtdc01",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd01",               :precision => 12, :scale => 4
    t.string  "mix_base02", :limit => 10
    t.decimal "mix_qtdc02",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd02",               :precision => 12, :scale => 4
    t.string  "mix_base03", :limit => 10
    t.decimal "mix_qtdc03",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd03",               :precision => 12, :scale => 4
    t.string  "mix_base04", :limit => 10
    t.decimal "mix_qtdc04",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd04",               :precision => 12, :scale => 4
    t.string  "mix_base05", :limit => 10
    t.decimal "mix_qtdc05",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd05",               :precision => 12, :scale => 4
    t.string  "mix_base06", :limit => 10
    t.decimal "mix_qtdc06",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd06",               :precision => 12, :scale => 4
    t.string  "mix_base07", :limit => 10
    t.decimal "mix_qtdc07",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd07",               :precision => 12, :scale => 4
    t.string  "mix_base08", :limit => 10
    t.decimal "mix_qtdc08",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd08",               :precision => 12, :scale => 4
    t.string  "mix_base09", :limit => 10
    t.decimal "mix_qtdc09",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd09",               :precision => 12, :scale => 4
    t.string  "mix_base10", :limit => 10
    t.decimal "mix_qtdc10",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd10",               :precision => 12, :scale => 4
    t.string  "mix_base11", :limit => 10
    t.decimal "mix_qtdc11",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd11",               :precision => 12, :scale => 4
    t.string  "mix_base12", :limit => 10
    t.decimal "mix_qtdc12",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd12",               :precision => 12, :scale => 4
    t.string  "mix_base13", :limit => 10
    t.decimal "mix_qtdc13",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd13",               :precision => 12, :scale => 4
    t.string  "mix_base14", :limit => 10
    t.decimal "mix_qtdc14",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd14",               :precision => 12, :scale => 4
    t.string  "mix_base15", :limit => 10
    t.decimal "mix_qtdc15",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd15",               :precision => 12, :scale => 4
    t.decimal "mix_volcon",               :precision => 12, :scale => 4
    t.decimal "mix_voldil",               :precision => 12, :scale => 4
    t.string  "mix_base16", :limit => 10
    t.decimal "mix_qtdc16",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd16",               :precision => 12, :scale => 4
    t.string  "mix_base17", :limit => 10
    t.decimal "mix_qtdc17",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd17",               :precision => 12, :scale => 4
    t.string  "mix_base18", :limit => 10
    t.decimal "mix_qtdc18",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd18",               :precision => 12, :scale => 4
    t.string  "mix_base19", :limit => 10
    t.decimal "mix_qtdc19",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd19",               :precision => 12, :scale => 4
    t.string  "mix_base20", :limit => 10
    t.decimal "mix_qtdc20",               :precision => 12, :scale => 4
    t.decimal "mix_qtdd20",               :precision => 12, :scale => 4
    t.string  "mix_codnfm", :limit => 10
  end

  create_table "laz_estruturas", :force => true do |t|
    t.string   "codmat",     :limit => 10
    t.decimal  "quant",                    :precision => 15, :scale => 4, :default => 0.0
    t.string   "codpro",     :limit => 15
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
  end

  create_table "laz_mps", :force => true do |t|
    t.string   "codigo",     :limit => 10
    t.decimal  "densidade",                :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "litragem",                 :precision => 15, :scale => 4, :default => 0.0
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
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

  create_table "liq_analizes", :force => true do |t|
    t.date     "data"
    t.date     "periodo_inicio"
    t.date     "periodo_final"
    t.integer  "persona_id"
    t.string   "persona_nome",   :limit => 150
    t.text     "obs"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
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

  create_table "medicaos", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "encerrante"
    t.integer  "persona_bico_id"
    t.date     "data"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "menus", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "codigo",     :limit => 10
    t.string   "url",        :limit => 100
    t.string   "nome",       :limit => 100
    t.integer  "sub",        :limit => 2,   :default => 0
  end

  add_index "menus", ["id"], :name => "filtro_menu_cod"
  add_index "menus", ["id"], :name => "menu_id"

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

  create_table "metodos", :force => true do |t|
    t.integer  "cod"
    t.string   "nome",                 :limit => 150
    t.integer  "status"
    t.integer  "equipo_id"
    t.string   "equipo_nome",          :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "valor",                               :precision => 15, :scale => 5, :default => 0.0
    t.string   "valor_ensaio",         :limit => 100
    t.integer  "tipo_id"
    t.string   "tipo_nome",            :limit => 100
    t.integer  "var_01_id"
    t.string   "var_01_nome",          :limit => 100
    t.decimal  "var_01_fator",                        :precision => 15, :scale => 5, :default => 0.0
    t.integer  "var_02_id"
    t.string   "var_02_nome",          :limit => 100
    t.decimal  "var_02_fator",                        :precision => 15, :scale => 5, :default => 0.0
    t.integer  "var_03_id"
    t.string   "var_03_nome"
    t.decimal  "var_03_fator",                        :precision => 15, :scale => 5, :default => 0.0
    t.string   "calc_01",              :limit => 100
    t.string   "calc_02",              :limit => 100
    t.string   "calc_03",              :limit => 100
    t.decimal  "preco_us",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_gs",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_rs",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_min",                           :precision => 15, :scale => 5, :default => 0.0
    t.decimal  "valor_max",                           :precision => 15, :scale => 5, :default => 0.0
    t.integer  "unidade_metrica_id"
    t.string   "var_calc_03",          :limit => 2
    t.string   "sigla",                :limit => 100
    t.string   "unidade_metrica_nome", :limit => nil
    t.string   "metrica",              :limit => nil
    t.string   "elementos",            :limit => 10
    t.text     "formula"
    t.integer  "ordem_laudo"
    t.boolean  "leitura",                                                            :default => false
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
  end

  create_table "motivos", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.integer  "processo"
    t.boolean  "status",                    :default => true
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "motivos_dev_cheques", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "deb_cli_prov", :default => 0
  end

  create_table "mov_vantagens", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "produto_id"
    t.integer  "promo_id"
    t.date     "data"
    t.integer  "tipo_promo"
    t.text     "descricao"
    t.string   "titulo",     :limit => 100
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
    t.string   "timbrado",            :limit => 15
    t.integer  "abertura_caixa_id"
    t.integer  "terminal_id"
  end

  add_index "nota_creditos", ["data", "persona_id"], :name => "index_nc"

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

  add_index "nota_creditos_detalhes", ["nota_credito_id", "produto_id"], :name => "index_nc_dt"

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
    t.string   "documento_numero_01",       :limit => 10
    t.string   "documento_numero_02",       :limit => 10
    t.string   "documento_numero",          :limit => 50
    t.integer  "origem_unidade_id"
    t.string   "origem_unidade_nome",       :limit => 150
    t.integer  "deposito_id"
    t.string   "deposito_nome",             :limit => 150
    t.integer  "motivo"
    t.string   "chapa",                     :limit => 50
    t.integer  "chofer_id"
    t.string   "chofer_nome",               :limit => 150
    t.string   "chofer_ruc",                :limit => 50
    t.integer  "transportadora_id"
    t.string   "transportadora_nome",       :limit => 150
    t.integer  "destino_unidade_id"
    t.string   "destino_unidade_nome",      :limit => 150
    t.integer  "destino_persona_id"
    t.integer  "destino_persona_cod"
    t.string   "destino_persona_nome",      :limit => 150
    t.string   "destino_persona_ruc",       :limit => 150
    t.string   "direcao",                   :limit => 150
    t.string   "bairro",                    :limit => 150
    t.integer  "cidade_id"
    t.string   "cidade_nome",               :limit => 150
    t.string   "veiculo"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "estado"
    t.text     "obs"
    t.integer  "kms"
    t.integer  "rodado_id"
    t.integer  "persona_id"
    t.string   "persona_nome",              :limit => 200
    t.integer  "form_fiscal_id"
    t.integer  "terminal_id"
    t.integer  "cidade_origem_id"
    t.integer  "transferencia_deposito_id"
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

  create_table "ordem_servico_dts", :force => true do |t|
    t.integer  "ordem_servico_id"
    t.date     "data"
    t.text     "parecer"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "ordem_servicos", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.integer  "servico_id"
    t.integer  "status"
    t.integer  "responsavel_id"
    t.text     "obs"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

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
  end

  add_index "pagos", ["persona_id", "data"], :name => "index_pagos"

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
    t.decimal  "pago_guarani",                       :precision => 15, :scale => 0, :default => 0
    t.integer  "liquidacao"
    t.decimal  "anterior_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "anterior_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 0, :default => 0
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
    t.date     "data_lanz"
  end

  add_index "pagos_detalhes", ["documento_numero", "persona_id"], :name => "pago_doc_persona"
  add_index "pagos_detalhes", ["pago_id"], :name => "index_pago_dt"

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
  end

  add_index "pagos_financas", ["pago_id"], :name => "index_pago_fin"

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
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "set_print",  :limit => 50
  end

  create_table "paises", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
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
  end

  create_table "pedido_compras_presupuestos", :force => true do |t|
    t.integer  "pedido_compra_id"
    t.integer  "presupuesto_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "persona_bicos", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "produto_id"
    t.string   "bico_nome",  :limit => 50
    t.string   "bomba_nome", :limit => 50
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "persona_chofers", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "chofer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "persona_chofers", ["persona_id", "chofer_id"], :name => "index_per_chof"

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
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "cargo_id"
    t.boolean  "principal",                      :default => false
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
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "paise_id"
    t.date     "data_conclusao"
  end

  create_table "persona_prazos", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "grupo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "persona_prazos", ["persona_id"], :name => "index_per_prz"

  create_table "persona_produtos", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "produto_id"
    t.decimal  "preco_us",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_gs",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_rs",      :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.integer  "forma_pago_id"
    t.decimal  "qtd_min",       :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "persona_produtos", ["persona_id", "produto_id"], :name => "index_per_prod"

  create_table "persona_rodados", :force => true do |t|
    t.integer  "persona_id"
    t.string   "chapa"
    t.string   "responsavel"
    t.integer  "km_inicial"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "persona_rodados", ["persona_id"], :name => "index_per_rd"

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

  add_index "persona_tabela_descs", ["persona_id"], :name => "index_per_desc"

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
    t.string   "observacao"
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
    t.string   "telefone2",              :limit => 20
    t.string   "fax",                    :limit => 20
    t.string   "celular",                :limit => 20
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
    t.integer  "active",                                                               :default => 0,   :null => false
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
    t.integer  "cod_implantacao"
    t.integer  "tipo_frentista"
    t.decimal  "comissao_entrega",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "comissao_retirada",                     :precision => 15, :scale => 2, :default => 0.0
    t.integer  "paise_id"
    t.integer  "cidade_area_id"
    t.integer  "autoriza_vencido",                                                     :default => 0
    t.decimal  "comissao_responsavel",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "taxa_interes",                          :precision => 15, :scale => 2, :default => 0.0
    t.text     "finger_printer"
    t.integer  "tipo_estudante",                                                       :default => 0
    t.string   "dncp_modalidad",         :limit => 100
    t.string   "dncp_entidad",           :limit => 100
    t.string   "dncp_ano",               :limit => 10
    t.string   "dncp_sequencia",         :limit => 50
    t.date     "dncp_data"
  end

  add_index "personas", ["nome"], :name => "busca_persona_nome"
  add_index "personas", ["nome_fatura"], :name => "busca_persona_nome_fatura"
  add_index "personas", ["ruc"], :name => "busca_persona_ruc"
  add_index "personas", ["tipo_cliente", "tipo_franquiado", "tipo_maiorista"], :name => "idx_personas_tipos"

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

  create_table "personas_tabela_precos", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "tabela_preco_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
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
  end

  create_table "prazos", :force => true do |t|
    t.string   "nome",       :limit => 50
    t.integer  "dias"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
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
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "produto_id"
    t.string   "produto_nome",        :limit => 200
    t.decimal  "quantidade",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_balcao",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_mayorista",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_corporativo",                 :precision => 15, :scale => 2, :default => 0.0
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
    t.string   "deposito_nome",       :limit => 150
    t.integer  "deposito_destino_id"
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
    t.string   "nova_barra",        :limit => 15
  end

  add_index "produto_barras", ["produto_id"], :name => "busca_barra_produto_id"

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

  create_table "produto_composicaos_vendas_produtos", :id => false, :force => true do |t|
    t.integer  "id",                    :null => false
    t.integer  "produto_composicao_id"
    t.integer  "vendas_produto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "barra",                     :limit => 20
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
    t.integer  "peso_bruto"
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
    t.string   "marcas",                    :limit => 50
    t.string   "marca",                     :limit => 50
    t.decimal  "stock",                                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "recalc",                                                                  :default => 0
    t.boolean  "preparacao",                                                              :default => false
    t.integer  "multiplo_compra",                                                         :default => 0
    t.boolean  "status",                                                                  :default => true
    t.string   "chassi",                    :limit => 10
    t.string   "cor",                       :limit => 10
    t.string   "ano",                       :limit => 10
    t.integer  "tickets"
    t.string   "set_print",                 :limit => 50
  end

  add_index "produtos", ["grupo_id"], :name => "idx_produtos_grupo"
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

  create_table "produtos_tabela_preco_historicos", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "tabela_preco_id"
    t.integer  "unidade_id"
    t.integer  "usuario_id"
    t.decimal  "preco_1_us",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_1_gs",      :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
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
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
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
    t.integer  "usuario_updated"
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

  create_table "produtos_tributs", :force => true do |t|
    t.integer  "unidade_id"
    t.integer  "regime_id"
    t.integer  "tipo_icms"
    t.integer  "ncm"
    t.decimal  "aliq_icms"
    t.decimal  "aliq_pis"
    t.decimal  "aliq_cofins"
    t.decimal  "reducao_icms"
    t.integer  "situacao_trib"
    t.integer  "cst"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "produtos_tribut_id"
    t.integer  "produtos_id"
    t.integer  "produto_id"
  end

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
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "tabela_preco_id"
    t.integer  "tipo"
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
    t.integer  "cod_implantacao"
    t.integer  "rubro_id"
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

  create_table "recibos", :force => true do |t|
    t.integer  "unidade_id"
    t.integer  "cobro_id"
    t.date     "data"
    t.string   "recibo_01"
    t.string   "recibo_02"
    t.string   "recibo"
    t.integer  "impressao"
    t.decimal  "valor_us"
    t.decimal  "valor_gs"
    t.integer  "moeda"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "paise_id"
    t.integer  "estado_id"
    t.string   "uf",         :limit => 4
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

  create_table "revisao_result_liberacaos", :force => true do |t|
    t.integer  "tipo_id"
    t.integer  "amostra"
    t.integer  "analize_amostra_id"
    t.integer  "revisao_result_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "revisao_results", :force => true do |t|
    t.date     "data"
    t.time     "hora"
    t.integer  "analista_id"
    t.string   "analista_nome",  :limit => 150
    t.integer  "persona_id"
    t.string   "persona_nome",   :limit => 150
    t.integer  "analize_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "amostra_inicio"
    t.integer  "amostra_final"
    t.integer  "tipo_id"
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

  create_table "safra_ardidos", :force => true do |t|
    t.integer  "safra_produto_id"
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "safra_averiados", :force => true do |t|
    t.integer  "safra_produto_id"
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
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

  create_table "safra_impurezas", :force => true do |t|
    t.integer  "safra_produto_id"
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "safra_produtos", :force => true do |t|
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.string   "produto_nome"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "safra_quebrados", :force => true do |t|
    t.integer  "safra_produto_id"
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "safra_umidades", :force => true do |t|
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.integer  "safra_produto_id"
  end

  create_table "safra_verdosos", :force => true do |t|
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
    t.string   "descricao",  :limit => 50
    t.date     "inicio"
    t.date     "final"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "seguimentos", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "servicos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "nome",            :limit => 200
    t.integer  "tipo"
    t.decimal  "valor",                          :precision => 15, :scale => 2, :default => 0.0
    t.integer  "retorno"
    t.date     "data_inicio"
    t.date     "data_finale"
    t.string   "obs"
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.integer  "status",                                                        :default => 0
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
    t.integer  "produto_id"
    t.integer  "deposito_id"
    t.integer  "persona_id"
    t.integer  "tipo"
    t.integer  "unidade_id"
    t.text     "obs"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.decimal  "promedio_guarani", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_dolar",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "quantidade",       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "quantidade_sis",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "dif",              :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "stocks", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "produto_id"
    t.date     "data"
    t.integer  "status"
    t.decimal  "entrada",                               :precision => 25, :scale => 3, :default => 0.0
    t.decimal  "saida",                                 :precision => 25, :scale => 3, :default => 0.0
    t.decimal  "unitario_dolar",                        :precision => 25, :scale => 4, :default => 0.0
    t.decimal  "unitario_guarani",                      :precision => 25, :scale => 4, :default => 0.0
    t.string   "tabela",                 :limit => 200
    t.integer  "tabela_id"
    t.decimal  "custo_contabil_dolar",                  :precision => 25, :scale => 2, :default => 0.0
    t.decimal  "custo_contabil_guarani",                :precision => 25, :scale => 2, :default => 0.0
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
    t.decimal  "quantidade_bomba",                      :precision => 25, :scale => 2, :default => 0.0
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
    t.decimal  "total_dolar",                           :precision => 25, :scale => 2
    t.decimal  "total_guarani",                         :precision => 25, :scale => 2
    t.decimal  "promedio_dolar",                        :precision => 25, :scale => 2
    t.decimal  "promedio_guarani",                      :precision => 25, :scale => 2
    t.decimal  "saldo",                                 :precision => 25, :scale => 2, :default => 0.0
    t.integer  "cor_id"
    t.integer  "tamanho_id"
    t.integer  "produtos_grade_id"
    t.integer  "colecao_id"
    t.integer  "unidade_id"
    t.decimal  "unitario_real",                         :precision => 15, :scale => 4
    t.decimal  "stock",                                 :precision => 25, :scale => 3, :default => 0.0
    t.decimal  "saldo_dolar",                           :precision => 25, :scale => 4, :default => 0.0
    t.decimal  "saldo_guarani",                         :precision => 25, :scale => 4, :default => 0.0
    t.boolean  "recalc",                                                               :default => false
    t.string   "sigla_proc",             :limit => 4
    t.decimal  "promedio_venda_gs",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "promedio_venda_us",                     :precision => 15, :scale => 4, :default => 0.0
  end

  add_index "stocks", ["data"], :name => "stock_index_data"
  add_index "stocks", ["deposito_id"], :name => "stock_index_deposito_id"
  add_index "stocks", ["entrada", "saida"], :name => "stock_index_sum"
  add_index "stocks", ["produto_id"], :name => "stock_index_produto"

  create_table "stocks_2020", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "produto_id"
    t.date     "data"
    t.integer  "status"
    t.decimal  "entrada",                               :precision => 25, :scale => 3, :default => 0.0
    t.decimal  "saida",                                 :precision => 25, :scale => 3, :default => 0.0
    t.decimal  "unitario_dolar",                        :precision => 25, :scale => 4, :default => 0.0
    t.decimal  "unitario_guarani",                      :precision => 25, :scale => 4, :default => 0.0
    t.string   "tabela",                 :limit => 200
    t.integer  "tabela_id"
    t.decimal  "custo_contabil_dolar",                  :precision => 25, :scale => 2, :default => 0.0
    t.decimal  "custo_contabil_guarani",                :precision => 25, :scale => 2, :default => 0.0
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
    t.decimal  "quantidade_bomba",                      :precision => 25, :scale => 2, :default => 0.0
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
    t.decimal  "total_dolar",                           :precision => 25, :scale => 2
    t.decimal  "total_guarani",                         :precision => 25, :scale => 2
    t.decimal  "promedio_dolar",                        :precision => 25, :scale => 2
    t.decimal  "promedio_guarani",                      :precision => 25, :scale => 2
    t.decimal  "saldo",                                 :precision => 25, :scale => 2, :default => 0.0
    t.integer  "cor_id"
    t.integer  "tamanho_id"
    t.integer  "produtos_grade_id"
    t.integer  "colecao_id"
    t.integer  "unidade_id"
    t.decimal  "unitario_real",                         :precision => 15, :scale => 4
    t.decimal  "stock",                                 :precision => 25, :scale => 3, :default => 0.0
    t.decimal  "saldo_dolar",                           :precision => 25, :scale => 4, :default => 0.0
    t.decimal  "saldo_guarani",                         :precision => 25, :scale => 4, :default => 0.0
    t.boolean  "recalc",                                                               :default => false
    t.string   "sigla_proc",             :limit => 4
    t.decimal  "promedio_venda_gs",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "promedio_venda_us",                     :precision => 15, :scale => 4, :default => 0.0
  end

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
    t.integer  "rubro_id"
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
    t.integer  "cheque_status",       :limit => 2,   :default => 0
    t.integer  "centro_custo_id"
  end

  add_index "sueldo_pagos", ["sueldo_id", "persona_id"], :name => "index_sueld_pg"

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
    t.integer  "tipo_liquidacao",                                :default => 0
  end

  add_index "sueldos", ["data_inicio"], :name => "index_sueldo"

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
  end

  add_index "sueldos_detalhes", ["sueldo_id"], :name => "index_sueldo_dt"

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
    t.string   "nome",       :limit => 100
    t.text     "obs"
    t.boolean  "status"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "tamanhos", :force => true do |t|
    t.string   "nome",       :limit => 150
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tamanhos", ["id", "nome"], :name => "busca_tamanho_id"
  add_index "tamanhos", ["id", "nome"], :name => "tamanhos_id_nome_idx"

  create_table "tamanhos_produtos", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "tamanho_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tara_cadinhos", :force => true do |t|
    t.integer  "tara"
    t.decimal  "peso",       :precision => 15, :scale => 4, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "terminals", :force => true do |t|
    t.integer  "unidade_id"
    t.string   "nome"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "documento_numero",    :limit => 20
    t.integer  "deposito_id"
    t.string   "form_venda",          :limit => 200
    t.integer  "centro_custo_id"
    t.string   "form_pagare",         :limit => 150
    t.boolean  "status",                             :default => true
    t.string   "nome_api_fiscal",     :limit => 100
    t.string   "token_api",           :limit => 50
  end

  create_table "testes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tint_dacar_bases", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "cod_base"
    t.integer  "cod_produto"
    t.integer  "cod_embalagem"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "tint_dacar_basis", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "cod_base"
    t.integer  "cod_produto"
    t.integer  "cod_embalagem"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "tint_dacar_corantes", :force => true do |t|
    t.integer  "cod_corante"
    t.integer  "produto_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tint_per_forms", :force => true do |t|
    t.integer  "tint_per_id"
    t.integer  "produto_id"
    t.string   "produto_nome"
    t.decimal  "qtdc",         :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "qtdd",         :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "densidade",    :precision => 15, :scale => 4, :default => 0.0
    t.string   "codmat"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  create_table "tint_pers", :force => true do |t|
    t.integer  "persona_id"
    t.string   "nome",       :limit => 100
    t.string   "tint_cod",   :limit => 10
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "tintometria_produtos", :id => false, :force => true do |t|
    t.integer "cod_produto",                     :null => false
    t.string  "nome_produto",      :limit => 40
    t.string  "tipo_produto",      :limit => 1,  :null => false
    t.integer "cod_grupo_produto"
    t.string  "flag_excluido",     :limit => 1,  :null => false
  end

  create_table "tipos", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "sigla"
    t.integer  "amostra_inicio"
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

  add_index "transf_cartao_dts", ["tabela", "tabela_id", "nr_comprovante"], :name => "buscar_cartaos"
  add_index "transf_cartao_dts", ["transf_cartao_id", "cartao_bandeira_id"], :name => "index_carto_dt"

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

  add_index "transf_cartaos", ["data"], :name => "index_sd"

  create_table "transf_produtos", :force => true do |t|
    t.date     "data"
    t.integer  "unidade_id"
    t.integer  "usuario_created"
    t.integer  "deposito_id"
    t.integer  "produto_origem_id"
    t.integer  "produto_destino_id"
    t.decimal  "quantidade",          :precision => 15, :scale => 3, :default => 0.0
    t.integer  "moeda"
    t.decimal  "unitario_gs",         :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unitario_us",         :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unitario_rs",         :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "total_gs",            :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "total_us",            :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "total_rs",            :precision => 15, :scale => 3, :default => 0.0
    t.text     "obs"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.decimal  "qtd_origem",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "qtd_destino",         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "deposito_destino_id"
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
    t.decimal  "cotacao_peso",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_peso",                          :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "transferencia_contas", ["data"], :name => "trans_conta_data"

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
    t.decimal  "entrada_peso",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_peso",                            :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "transferencia_contas_detalhes", ["transferencia_conta_id"], :name => "transf_conta_id"

  create_table "transferencia_deposito_detalhes", :force => true do |t|
    t.integer  "transferencia_deposito_id"
    t.integer  "deposito_origem_id"
    t.string   "deposito_origem_nome",      :limit => 150
    t.integer  "deposito_destino_id"
    t.string   "deposito_destino_nome",     :limit => 150
    t.integer  "produto_id"
    t.string   "produto_nome",              :limit => 200
    t.decimal  "quantidade",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                              :precision => 22, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                            :precision => 22, :scale => 2, :default => 0.0
    t.decimal  "preco_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.decimal  "promedio_guarani",                         :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "promedio_dolar",                           :precision => 15, :scale => 4, :default => 0.0
  end

  add_index "transferencia_deposito_detalhes", ["transferencia_deposito_id", "produto_id"], :name => "index_trf_dep"

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

  add_index "transferencia_depositos", ["compra_id"], :name => "transf_compra"
  add_index "transferencia_depositos", ["data"], :name => "index_trf_pd"

  create_table "turnos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome",            :limit => 200
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "unidade_id"
  end

  create_table "unidade_medidas", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.string   "sigla"
    t.string   "5"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
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
    t.string   "bairro",                       :limit => 100
    t.string   "direcao",                      :limit => 100
    t.integer  "cidade_id"
    t.string   "cidade_nome",                  :limit => 150
    t.string   "cod_contabil",                 :limit => 50
    t.integer  "rubro_id"
    t.string   "rubro_nome",                   :limit => 100
    t.string   "tabela_ref",                   :limit => 30
    t.string   "nome_sys",                     :limit => 50
    t.string   "timbrado",                     :limit => 8
    t.string   "doc_01",                       :limit => 3
    t.string   "doc_02",                       :limit => 3
    t.integer  "block_vendas_atraso_dias",                    :default => 0
    t.integer  "block_vendas_atraso",                         :default => 0
    t.string   "imagem_file_name"
    t.string   "imagem_content_type"
    t.integer  "imagem_file_size"
    t.datetime "imagem_updated_at"
    t.integer  "gasto_pago_direto",                           :default => 0
    t.integer  "compra_pago_direto",                          :default => 0
    t.string   "ruc",                          :limit => 55
    t.string   "rasao_social"
    t.string   "token_api",                    :limit => 50
    t.string   "nome_api_fiscal",              :limit => 50
    t.boolean  "environment_production_fisca",                :default => false
    t.integer  "moeda"
    t.integer  "unidade_tabela_preco_id"
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
    t.string   "codigo",     :limit => 10
    t.boolean  "m",                        :default => false
    t.integer  "sub",        :limit => 2,  :default => 0
  end

  add_index "usuario_perfils", ["menu_id"], :name => "busca_menu_id"
  add_index "usuario_perfils", ["usuario_id"], :name => "menu_usuario"

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
    t.boolean  "stock_minimo",                        :default => false
    t.boolean  "desconto_pdv",                        :default => false
    t.boolean  "autoriza_venda",                      :default => false
    t.string   "senha_autoriza_venda",  :limit => 30
    t.text     "finger_printer"
    t.text     "menu_code"
    t.boolean  "altera_limite_credito",               :default => false
    t.boolean  "dash_finac",                          :default => false
    t.integer  "centro_custo_id"
    t.integer  "persona_id"
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
    t.integer  "conta_created"
    t.integer  "conta_updated"
    t.integer  "turno_created"
    t.integer  "turno_updated"
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
    t.integer  "tipo_ordem"
    t.integer  "conta_id"
    t.string   "conta_nome"
    t.decimal  "limite_credito",                     :precision => 15, :scale => 2
    t.string   "classificacao",       :limit => 5
    t.integer  "vendedor_id"
    t.string   "vendedor_nome"
    t.integer  "tipo_maiorista"
    t.integer  "persona_cod"
    t.integer  "pedido_numero"
    t.decimal  "saldo_disponivel",                   :precision => 15, :scale => 2
    t.integer  "tipo_venda"
    t.integer  "mecanico_id"
    t.string   "mecanico_nome",       :limit => 150
    t.integer  "clase_produto"
    t.string   "modelo",              :limit => 150
    t.string   "serie",               :limit => 150
    t.string   "chassi",              :limit => 150
    t.string   "cor",                 :limit => 150
    t.string   "solicitacao",         :limit => 300
    t.date     "data_entrega"
    t.string   "marca",               :limit => 150
    t.string   "acessorio",           :limit => 150
    t.decimal  "desconto_dolar",                     :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                   :precision => 15, :scale => 2
    t.integer  "status"
    t.string   "autori_motivo",       :limit => 200
    t.integer  "local_cobro",         :limit => 2
    t.integer  "local_venda",         :limit => 2
    t.integer  "pedido_id"
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer  "pedido"
    t.integer  "ob_ref"
    t.decimal  "exentas_us",                         :precision => 15, :scale => 2
    t.decimal  "gravadas_05_us",                     :precision => 15, :scale => 2
    t.decimal  "imposto_05_us",                      :precision => 15, :scale => 2
    t.decimal  "gravadas_10_us",                     :precision => 15, :scale => 2
    t.decimal  "imposto_10_us",                      :precision => 15, :scale => 2
    t.integer  "solicitudade"
    t.integer  "solicitude"
    t.integer  "unidade_id"
    t.integer  "condicional"
    t.integer  "sub_grupo_id"
    t.integer  "colecao_id"
    t.integer  "cond_liq_id"
    t.integer  "tipo_doc"
    t.string   "timbrado",            :limit => 10
    t.date     "timbrado_venc"
    t.date     "timbrado_venci"
    t.text     "obs"
    t.integer  "tabela_preco_id"
    t.decimal  "cotacao_rs_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "turno_id",                                                          :default => 0
    t.integer  "terminal_id",                                                       :default => 0
    t.integer  "usuario_id",                                                        :default => 0
    t.integer  "rodado_id"
    t.string   "ordem_carga",         :limit => 20
    t.string   "chapa",               :limit => 20
    t.integer  "carta_flete",                                                       :default => 0
    t.integer  "chofer_id"
    t.integer  "km"
    t.integer  "persona_rodado_id"
    t.text     "lacres"
    t.integer  "controle_caixa"
    t.date     "data_caixa"
    t.decimal  "cotacao_gs_ps",                      :precision => 15, :scale => 2, :default => 0.0
    t.boolean  "op",                                                                :default => false
    t.integer  "autoriza_rodados",                                                  :default => 0
    t.integer  "cartao_id"
    t.string   "nome_ref",            :limit => 50
    t.string   "remissao",            :limit => 30
    t.integer  "forma_pago_id"
    t.integer  "setor_id"
    t.integer  "finalidade"
    t.integer  "centro_custo_id"
    t.string   "cartao_nome",         :limit => 10
    t.integer  "status_op"
    t.decimal  "desconto_gs",                        :precision => 15, :scale => 2
    t.decimal  "desconto_porcen",                    :precision => 15, :scale => 2
    t.decimal  "desconto_us",                        :precision => 15, :scale => 2
    t.decimal  "desconto_rs",                        :precision => 15, :scale => 2
  end

  add_index "vendas", ["cartao_id"], :name => "busca_cartao"
  add_index "vendas", ["controle_caixa"], :name => "vendas_controle_caixa"
  add_index "vendas", ["data", "unidade_id"], :name => "idx_vendas_data_unidade"
  add_index "vendas", ["data"], :name => "busca_data"
  add_index "vendas", ["persona_id"], :name => "vendas_persona_id"
  add_index "vendas", ["unidade_id"], :name => "venda_unidade_id"

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
    t.boolean  "condicional",                                                         :default => false
    t.boolean  "plano",                                                               :default => false
    t.boolean  "centro_custo",                                                        :default => false
    t.boolean  "setor",                                                               :default => false
    t.boolean  "cartao",                                                              :default => false
    t.boolean  "pedido",                                                              :default => false
    t.boolean  "turma",                                                               :default => false
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
    t.integer  "venda_id"
    t.integer  "cota"
    t.date     "vencimento"
    t.integer  "conta_id"
    t.string   "conta_nome",            :limit => 200
    t.string   "cheque",                :limit => 100
    t.date     "diferido"
    t.decimal  "valor_dolar_contado",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani_contado",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",          :limit => 200
    t.decimal  "cotacao",                              :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
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
    t.integer  "forma_pago_id",                                                       :default => 0
    t.integer  "cartao_bandeira_id",                                                  :default => 0
    t.integer  "controle_caixa",                                                      :default => 0
    t.integer  "data_caixa"
    t.decimal  "valor_peso",                           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cred_deb",              :limit => 2,                                  :default => 0
    t.string   "nr_comprovante",        :limit => 30
    t.decimal  "desc_gs",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_desc_gs",                        :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "vendas_financas", ["id"], :name => "find_id_vendas_financa"
  add_index "vendas_financas", ["venda_id"], :name => "vendas_financa_venda_id"

  create_table "vendas_pedidos", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "presupuesto_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
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
    t.decimal  "unitario_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_dolar",                             :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "iva_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.string   "fabricante_cod",         :limit => 100
    t.decimal  "cotacao",                               :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.decimal  "quantidade",                            :precision => 15, :scale => 5, :default => 0.0
    t.decimal  "saldo",                                 :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "taxa",                                  :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.string   "barra",                  :limit => 100
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
    t.integer  "clase_produto"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",          :limit => 150
    t.decimal  "preco_dolar",                           :precision => 15, :scale => 2
    t.decimal  "preco_guarani",                         :precision => 15, :scale => 2
    t.decimal  "porcentagem",                           :precision => 15, :scale => 7
    t.decimal  "preco_fixo_dolar",                      :precision => 15, :scale => 2
    t.decimal  "preco_fixo_guarani",                    :precision => 15, :scale => 2
    t.decimal  "unitario_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_fixo_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_real",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "presupuesto_produto_id"
    t.integer  "presupuesto_id"
    t.integer  "count_fatura",                                                         :default => 0
    t.integer  "bico_id"
    t.integer  "abastecida_id"
    t.decimal  "promedio_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "promedio_stock",                        :precision => 20, :scale => 3, :default => 0.0
    t.boolean  "print",                                                                :default => false
    t.text     "obs"
    t.integer  "status_preparo"
    t.boolean  "op"
    t.integer  "tabela_preco_id"
    t.integer  "promo_id"
  end

  add_index "vendas_produtos", ["op"], :name => "idx_op"
  add_index "vendas_produtos", ["produto_id"], :name => "vendas_produtos_produto_id"
  add_index "vendas_produtos", ["venda_id", "produto_id"], :name => "idx_vendas_produtos_venda_produto"
  add_index "vendas_produtos", ["venda_id"], :name => "venda_produto_venda_id"

  create_table "vendas_produtos_comps", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "vendas_produto_id"
    t.decimal  "quantidade",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_us",       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_gs",       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_us",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_gs",          :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.integer  "produto_id"
  end

  add_index "vendas_produtos_comps", ["venda_id"], :name => "index_prod_comp"

  create_table "whatsapps", :force => true do |t|
    t.string   "instance"
    t.string   "token"
    t.integer  "status"
    t.integer  "unidade_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
