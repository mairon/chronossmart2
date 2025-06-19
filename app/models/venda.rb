class Venda < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }
  has_many :clientes,          :order => 1
  has_many :vendas_produtos,   :order => 1, :dependent => :destroy
  has_many :vendas_financas,   :order => 1, :dependent => :destroy
  has_many :vendas_pedidos,   :order => 1, :dependent => :destroy
  has_many :venda_romaneios,   :order => 1, :dependent => :destroy
  has_many :vendas_ordem_servs,   :order => 1, :dependent => :destroy
  has_many :vendas_cond_liqs,   :order => 1, :dependent => :destroy
  has_many :venda_devolucaos,   :order => 1, :dependent => :destroy
  has_many :vendas_faturas
  has_many :venda_compras
  has_many :evento_convidados
  has_many :ordem_entregas
  belongs_to :persona
  belongs_to :terminal
  belongs_to :usuario
  belongs_to :turno
  belongs_to :cidade
  belongs_to :cartao
  belongs_to :tabela_preco
  belongs_to :plano_venda
  belongs_to :unidade
  belongs_to :setor
  belongs_to :plano

  before_save :finds

  #validates_presence_of :persona_id, :tabela_preco_id, :moeda, :tipo_venda
  #validate  :block_cliente
  before_destroy :destroy_cartao
  after_create :update_status_op_cartao

  def update_status_op_cartao
    cartao.update_attributes(status_op: 1) unless cartao.nil?
    cartao.update_attributes(venda_id: self.id) unless cartao.nil?
  end

  def destroy_cartao
    cartao.update_attributes(status_op: 0) unless cartao.nil?
    cartao.update_attributes(venda_id: 0) unless cartao.nil?
  end

  def block_cliente
    #VERIFICA SE SALDO E MAIOR QUE A QUANTIDADE DA VENDA
    if ( persona.estado.to_i == 1  )
      errors.add( :persona_id,"Cliente Bloqueado Consulte a Parte Administrativa" )
    end
  end

  def pendencia_cliente
    #divida > que 90 dias
    dividas = Cliente.count(:id, :conditions => ["PERSONA_ID = ? AND LIQUIDACAO = 0 AND ( CURRENT_DATE - (VENCIMENTO + 90) ) >= 90",self.persona_id])

    if (dividas.to_i >  0  )
      errors.add(:persona_id, "Cliente Bloqueado Por Pendencias con Mas 90 Dias, Consulte la Parte Administrativa" )
    end
  end


  def self.gerador_cotas(params)
    forma_de_pagamento = FormaPago.find_by_id(params[:forma_pg])
    venda = Venda.find_by_id(params[:id])
    ct = 0 + (VendasFinanca.count(:id, :conditions => ["venda_id = #{params[:id]}"]).to_i)
    #transformacao das cotacaos
    if params[:moeda].to_s == '0'
      if params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f > params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
        if params[:vuelto].to_f > 0
          vuel_gs = params[:vuelto].to_s.gsub('.', '').gsub(',', '.').to_f
          vuel_us = vuel_gs.to_f / venda.cotacao.to_f
          vuel_rs = vuel_gs.to_f.to_f / venda.cotacao_real.to_i
          vuel_ps = 0
        end

        val_us = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_gs = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f.to_f * venda.cotacao.to_i
        val_rs = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f.to_f * venda.cotacao_rs_us.to_f
        val_ps = 0

      elsif params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f < params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_us = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_gs = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f.to_f * venda.cotacao.to_i
        val_rs = params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f.to_f * venda.cotacao_rs_us.to_f
        val_ps = 0

      elsif params[:valor_us].to_s.gsub('.', '').gsub(',', '.').to_f == params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f

        val_us = params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_gs = params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_rs = params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_ps = 0
      end

    elsif params[:moeda].to_s == '1'
      if params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f > params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f

        if params[:vuelto].to_f > 0
          vuel_gs = params[:vuelto].to_s.gsub('.', '').gsub(',', '.').to_f
          vuel_us = vuel_gs.to_f / venda.cotacao.to_f
          vuel_rs = vuel_gs.to_f.to_f / venda.cotacao_real.to_i
          vuel_ps = 0
        end

        val_us = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao.to_f
        val_gs = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_rs = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao_real.to_i

      elsif params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f < params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f

        val_us = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao.to_f
        val_gs = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_rs = params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao_real.to_i

      elsif params[:valor_gs].to_s.gsub('.', '').gsub(',', '.').to_f == params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_us = params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_gs = params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_rs = params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_ps = 0
      end

    elsif params[:moeda].to_s == '2'
      if params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f > params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        if params[:vuelto].to_f > 0
          vuel_gs = params[:vuelto].to_s.gsub('.', '').gsub(',', '.').to_f
          vuel_us = vuel_gs.to_f / venda.cotacao.to_f
          vuel_rs = vuel_gs.to_f.to_f / venda.cotacao_real.to_i
          vuel_ps = 0
        end

        val_us = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao_rs_us.to_f
        val_gs = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f * venda.cotacao_real.to_i
        val_rs = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_ps = 0
      elsif params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f < params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_us = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f / venda.cotacao_rs_us.to_f
        val_gs = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f * venda.cotacao_real.to_i
        val_rs = params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_ps = 0
      elsif params[:valor_rs].to_s.gsub('.', '').gsub(',', '.').to_f == params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_us = params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
        val_gs = params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_rs = params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
        val_ps = 0
      end
		elsif params[:moeda].to_s == '3'
      if params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f >= params[:valor_sem_ps].to_f
        if params[:vuelto].to_f > 0
          val_ps = params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f
          val_gs = (params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f * venda.cotacao_gs_ps.to_f)
          val_rs = (val_gs.to_f / venda.cotacao_real.to_f)
          val_us = (val_gs.to_f / venda.cotacao.to_f)

          vuel_gs = ((params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f * venda.cotacao_gs_ps.to_f).to_f - params[:valor_sem_gs].to_i)
          vuel_us = vuel_gs.to_f / venda.cotacao.to_f
          vuel_rs = vuel_gs.to_f.to_f / venda.cotacao_real.to_i
          vuel_ps = 0
        else

          val_us = params[:valor_sem_us].to_s.gsub('.', '').gsub(',', '.').to_f
          val_gs = params[:valor_sem_gs].to_s.gsub('.', '').gsub(',', '.').to_f
          val_rs = params[:valor_sem_rs].to_s.gsub('.', '').gsub(',', '.').to_f
          val_ps = params[:valor_sem_ps].to_s.gsub('.', '').gsub(',', '.').to_f
        end
      else
      	val_gs = (params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f * venda.cotacao_gs_ps.to_i)
        val_us = (val_gs.to_f / venda.cotacao.to_f)
        val_rs = (val_gs.to_f / venda.cotacao_real.to_i)
        val_ps = params[:valor].to_s.gsub('.', '').gsub(',', '.').to_f
      end
    end
    #forma de pagamento que afetam o caixa
    if forma_de_pagamento.tipo.to_i == 0

      if params[:forma_pg] == '15' #transf bancaria
        VendasFinanca.create( :venda_id        => params[:id],
                                :forma_pago_id   => params[:forma_pg],
                                :cartao_bandeira_id => params[:busca]["cartao_bandeiras"],
                                :conta_id => params[:busca]["conta_id"],
                                :controle_caixa => params[:controle_caixa],
                                :tipo            => forma_de_pagamento.tipo,
                                :cheque_status   => params[:cheque_status],
                                :cheque          => params[:cheque],
                                :diferido        => params[:diferido],
                                :data            => venda.data,
                                :vencimento      => venda.data,
                                :cotacao         => venda.cotacao,
                                :fatura          => 0,
                                :vendedor_id     => venda.vendedor_id,
                                :documento_numero_01 => '000',
                                :documento_numero_02 => '000',
                                :documento_numero    => params[:id],
                                :persona_id      => venda.persona_id,
                                :persona_nome    => venda.persona_nome,
                                :moeda           => params[:moeda],
                                :cota            => 0,
                                :valor_dolar     => val_us.to_f,
                                :valor_guarani   => val_gs.to_f,
                                :valor_real      => val_rs.to_f,
                                :valor_peso      => val_ps.to_f,
                                :cred_deb        => 0,
                                :titular         => params[:titular],
                                :nr_comprovante  => params[:nr_comprovante],
                                :desconto        => params[:desc_gs].to_f,
                                :usuario_id      => params[:usuario_id],
                                :usuario_created => params[:usuario_id],
                                  :fact_ad_01      => params[:fact_ad_01],
                                  :fact_ad_02      => params[:fact_ad_02],
                                  :fact_ad      => params[:fact_ad],
                                  :obs          => params[:obs]
               )
      else
        VendasFinanca.create( :venda_id        => params[:id],
                                :forma_pago_id   => params[:forma_pg],
                                :cartao_bandeira_id => params[:busca]["cartao_bandeiras"],
                                :controle_caixa => params[:controle_caixa],
                                :tipo            => forma_de_pagamento.tipo,
                                :cheque_status   => params[:cheque_status],
                                :cheque          => params[:cheque],
                                :diferido        => params[:diferido],
                                :data            => venda.data,
                                :vencimento      => venda.data,
                                :cotacao         => venda.cotacao,
                                :fatura          => 0,
                                :vendedor_id     => venda.vendedor_id,
                                :documento_numero_01 => '000',
                                :documento_numero_02 => '000',
                                :documento_numero    => params[:id],
                                :persona_id      => venda.persona_id,
                                :persona_nome    => venda.persona_nome,
                                :moeda           => params[:moeda],
                                :cota            => ct,
                                :valor_dolar     => val_us.to_f,
                                :valor_guarani   => val_gs.to_f,
                                :valor_real      => val_rs.to_f,
                                :valor_peso      => val_ps.to_f,
                                :cred_deb        => 0,
                                :titular         => params[:titular],
                                :nr_comprovante  => params[:nr_comprovante],
                                :desconto        => params[:desc_gs].to_f,
                                :usuario_id      => params[:usuario_id],
                                :usuario_created => params[:usuario_id],
                                  :fact_ad_01      => params[:fact_ad_01],
                                  :fact_ad_02      => params[:fact_ad_02],
                                  :fact_ad      => params[:fact_ad],
                                  :obs          => params[:obs]
               )

      end

    if params[:vuelto].to_f > 0
      VendasFinanca.create( :venda_id        => params[:id],
                              :forma_pago_id   => 8,
                              :cartao_bandeira_id => 0,
                              :controle_caixa => params[:controle_caixa],
                              :tipo            => forma_de_pagamento.tipo,
                              :cheque_status   => 0,
                              :cheque          => '',
                              :diferido        => params[:diferido],
                              :data            => venda.data,
                              :vencimento      => venda.data,
                              :cotacao         => venda.cotacao,
                              :fatura          => 0,
                              :vendedor_id     => venda.vendedor_id,
                              :vendedor_nome   => params[:vendedor_nome],
                              :clase_produto   => 0,
                              :documento_numero_01 => '000',
                              :documento_numero_02 => '000',
                              :documento_numero    => params[:id],
                                :persona_id      => venda.persona_id,
                                :persona_nome    => venda.persona_nome,
                              :moeda           => 1,
                              :cota            => ct,
                              :titular         => params[:titular],
                              :valor_dolar     => vuel_us,
                              :valor_guarani   => vuel_gs.to_f,
                              :valor_real      => vuel_rs,
                              :valor_peso      => vuel_ps,
                              :cred_deb        => 1,
                              :usuario_id      => params[:usuario_id],
                              :usuario_created => params[:usuario_id],
                                :fact_ad_01      => params[:fact_ad_01],
                                :fact_ad_02      => params[:fact_ad_02],
                                :fact_ad      => params[:fact_ad],
                                :obs          => params[:obs]
                              )
    end

    #forma de pagos a credito
    else
      if params[:cota_fixa] == '1'
        parc_us = (val_us.to_f)
        parc_gs = (val_gs.to_f)
        parc_rs = (val_rs.to_f)
        parc_ps = (val_ps.to_f)
      else
        parc_us = (val_us.to_f / params[:cota].to_i)
        parc_gs = (val_gs.to_f / params[:cota].to_i)
        parc_rs = (val_rs.to_f / params[:cota].to_i)
        parc_ps = (val_ps.to_f / params[:cota].to_i)
      end
      venc = 0
      cota = 1
      params[:cota].to_i.times do
        VendasFinanca.create( :venda_id        => params[:id],
                                :forma_pago_id   => params[:forma_pg],
                                :cartao_bandeira_id => params[:busca]["cartao_bandeiras"],
                                :controle_caixa => params[:controle_caixa],
                                :tipo            => forma_de_pagamento.tipo,
                                :cheque_status   => params[:cheque_status],
                                :diferido        => params[:diferido],
                                :data            => venda.data,
                                :vencimento      =>  params[:vencimento].to_date.months_since(venc.to_i),
                                :cotacao         => venda.cotacao,
                                :fatura          => 0,
                                :vendedor_id     => venda.vendedor_id,
                                :clase_produto   => 0,
                                :documento_numero_01 => '000',
                                :documento_numero_02 => '000',
                                :documento_numero    => params[:id],
                                :persona_id      => venda.persona_id,
                                :persona_nome    => venda.persona_nome,
                                :moeda           => params[:moeda],
                                :nr_comprovante  => params[:nr_comprovante],
                                :cota            => cota,
                                :titular         => params[:titular],
                                :valor_dolar     => parc_us.to_f,
                                :valor_guarani   => parc_gs.to_f,
                                :valor_real      => parc_rs.to_f,
                                :valor_peso      => parc_ps.to_f,
                                :desconto        => params[:desc_gs].to_f,
                                :usuario_id      => params[:usuario_id],
                                :usuario_created => params[:usuario_id],
                                :fact_ad_01      => params[:fact_ad_01],
                                :fact_ad_02      => params[:fact_ad_02],
                                :fact_ad      => params[:fact_ad],
                                :tot_cotas => params[:tot_cotas],
                                :obs          => params[:obs] )
        venc += 1
        cota += 1
      end
    end
  end


 def self.cached_vendas_config(unidade_id)
    begin
      # Força carregamento da classe se necessário
      require_dependency 'vendas_config' if Rails.env.development? && !defined?(VendasConfig)

      if defined?(VendasConfig)
        if Rails.cache && defined?(Rails.cache)
          Rails.cache.fetch("vendas_config_#{unidade_id}", expires_in: 15.minutes) do
            VendasConfig.where(:unidade_id => unidade_id).order("id DESC").first
          end
        else
          VendasConfig.where(:unidade_id => unidade_id).order("id DESC").first
        end
      else
        Rails.logger.warn "VendasConfig class not defined"
        nil
      end
    rescue NameError => e
      Rails.logger.error "VendasConfig não encontrada: #{e.message}"
      nil
    rescue => e
      Rails.logger.error "Erro no cached_vendas_config: #{e.message}"
      nil
    end
  end

def self.filtro_vendas_max_performance(params)
  unidade = params[:unidade]
  data_inicio = params[:inicio].split("/").reverse.join("-")
  data_final = params[:final].split("/").reverse.join("-")

  # Constrói condições
  where_conditions = []
  where_values = []

  where_conditions << "V.UNIDADE_ID = ?"
  where_values << unidade

  where_conditions << "V.DATA BETWEEN ? AND ?"
  where_values << data_inicio
  where_values << data_final

  # Finalidade
  if params[:finalidade] == "VENTA"
    where_conditions << "V.FINALIDADE = 0"
  else
    where_conditions << "V.FINALIDADE = 1"
  end

  # Filtros opcionais
  unless params[:caixa].blank?
    where_conditions << "V.CONTROLE_CAIXA = ?"
    where_values << params[:caixa]
  end

  unless params[:tipo_venda].blank?
    where_conditions << "V.TIPO_VENDA = ?"
    where_values << params[:tipo_venda]
  end

  # Busca por tipo
  unless params[:busca].blank?
    case params[:tipo]
    when "CODIGO"
      where_conditions << "V.ID = ?"
      where_values << params[:busca]
    when "DOC"
      where_conditions << "(V.DOCUMENTO_NUMERO_01 || '-' || V.DOCUMENTO_NUMERO_02 || '-' || V.DOCUMENTO_NUMERO) LIKE ?"
      where_values << "%#{params[:busca]}%"
    when "CLIENTE"
      where_conditions << "V.PERSONA_NOME LIKE ?"
      where_values << "%#{params[:busca]}%"
    when "COMANDA"
      where_conditions << "CT.NOME = ?"
      where_values << params[:busca]
    end
  end

  where_clause = where_conditions.join(" AND ")

  # SQL otimizado que PRIMEIRO filtra, depois agrega
  page = (params[:page] || 1).to_i
  per_page = 25
  offset = (page - 1) * per_page

  # Primeiro busca apenas as vendas que atendem aos critérios
  vendas_ids_sql = "
    SELECT V.ID
    FROM VENDAS V
      LEFT JOIN CARTAOS CT ON V.CARTAO_ID = CT.ID
    WHERE #{where_clause}
    ORDER BY V.DATA DESC, V.ID DESC
    LIMIT #{per_page} OFFSET #{offset}
  "

  # Count otimizado
  count_sql = "
    SELECT COUNT(*)
    FROM VENDAS V
      LEFT JOIN CARTAOS CT ON V.CARTAO_ID = CT.ID
    WHERE #{where_clause}
  "

  # SQL principal que usa os IDs pré-filtrados
  main_sql = "
    SELECT
      V.ID,
      V.USUARIO_CREATED,
      V.DATA,
      V.TIPO_VENDA,
      V.MOEDA,
      V.PERSONA_NOME,
      V.TIPO,
      V.CONTROLE_CAIXA,
      V.FINALIDADE,
      V.OP,
      V.OBS,
      V.DESCONTO_GS,
      V.DOCUMENTO_NUMERO_01,
      V.DOCUMENTO_NUMERO_02,
      V.DOCUMENTO_NUMERO,
      VD.NOME AS vendedor_nome,
      CT.NOME AS cartao_nome,
      U.USUARIO_NOME AS usuario_nome,
      V.DOCUMENTO_NUMERO_01 || '-' || V.DOCUMENTO_NUMERO_02 || '-' || V.DOCUMENTO_NUMERO AS doc,
      COALESCE(VP.qtd, 0) AS qtd,
      COALESCE(VP.total_guarani, 0) - COALESCE(V.DESCONTO_GS, 0) AS tot_gs,
      COALESCE(VP.total_dolar, 0) AS tot_us,
      COALESCE(VP.total_real, 0) AS tot_rs,
      COALESCE(VF.fin_count, 0) AS fin
    FROM (#{vendas_ids_sql}) filtered_vendas
      INNER JOIN VENDAS V ON filtered_vendas.ID = V.ID
      LEFT JOIN PERSONAS VD ON V.VENDEDOR_ID = VD.ID
      LEFT JOIN CARTAOS CT ON V.CARTAO_ID = CT.ID
      LEFT JOIN USUARIOS U ON V.USUARIO_CREATED = U.ID
      LEFT JOIN (
        SELECT
          VENDA_ID,
          SUM(QUANTIDADE) AS qtd,
          SUM(TOTAL_GUARANI) AS total_guarani,
          SUM(TOTAL_DOLAR) AS total_dolar,
          SUM(TOTAL_REAL) AS total_real
        FROM VENDAS_PRODUTOS
        WHERE VENDA_ID IN (#{vendas_ids_sql})
        GROUP BY VENDA_ID
      ) VP ON V.ID = VP.VENDA_ID
      LEFT JOIN (
        SELECT
          VENDA_ID,
          COUNT(ID) AS fin_count
        FROM VENDAS_FINANCAS
        WHERE VENDA_ID IN (#{vendas_ids_sql})
        GROUP BY VENDA_ID
      ) VF ON V.ID = VF.VENDA_ID
    ORDER BY V.DATA DESC, V.ID DESC
  "

  # Adiciona filtro para vendas finalizadas se necessário
  if params[:processo] == "venda-finalizada"
    main_sql = main_sql.gsub("LEFT JOIN (", "INNER JOIN (").gsub("VF.fin_count", "VF.fin_count").gsub("COALESCE(VF.fin_count, 0)", "VF.fin_count")
  end

  # Executa queries
  count_result = Venda.connection.execute(Venda.send(:sanitize_sql, [count_sql] + where_values))
  total_count = count_result.first['count'].to_i

  main_result = Venda.connection.execute(Venda.send(:sanitize_sql, [main_sql] + where_values * 3))

  if main_result.any?
    # Converte resultados para objetos Venda
    vendas = main_result.map do |row|
      venda = Venda.new

      # Atributos básicos da venda
      Venda.column_names.each do |column|
        if row.has_key?(column.downcase)
          venda.send("#{column}=", row[column.downcase])
        end
      end

      # Adiciona campos extras como métodos
      venda.define_singleton_method(:vendedor_nome) { row['vendedor_nome'] }
      venda.define_singleton_method(:cartao_nome) { row['cartao_nome'] }
      venda.define_singleton_method(:usuario_nome) { row['usuario_nome'] }
      venda.define_singleton_method(:doc) { row['doc'] }
      venda.define_singleton_method(:qtd) { row['qtd'].to_f }
      venda.define_singleton_method(:tot_gs) { row['tot_gs'].to_f }
      venda.define_singleton_method(:tot_us) { row['tot_us'].to_f }
      venda.define_singleton_method(:tot_rs) { row['tot_rs'].to_f }
      venda.define_singleton_method(:fin) { row['fin'].to_i }

      venda.readonly!
      venda
    end

    # Cria coleção paginada
    WillPaginate::Collection.create(page, per_page, total_count) do |pager|
      pager.replace(vendas)
    end
  else
    WillPaginate::Collection.create(page, per_page, 0) { |pager| pager.replace([]) }
  end
end


  def finds
    md =  Moeda.last(:select => 'dolar_compra,rs_us_compra,real_compra,ps_gs_compra')
    self.cotacao = md.dolar_compra
    self.cotacao_real = md.real_compra
    self.cotacao_rs_us = md.rs_us_compra
    self.cotacao_gs_ps = md.ps_gs_compra

    if self.moeda.to_i == 0
      self.desconto_gs = self.desconto_us.to_f * self.cotacao.to_f
    else
      self.desconto_us = self.desconto_gs.to_f / self.cotacao.to_f
      self.desconto_rs = self.desconto_gs.to_f / self.cotacao_real.to_f
    end
  end

end
