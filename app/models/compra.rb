class Compra < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.id.to_s.rjust(8,'0')}|Hecho por #{user.usuario_nome}" }

  has_many :compras_produtos,   order: 'fabricante_cod', dependent: :destroy
  has_many :compras_documentos, order: 1, dependent: :destroy
  has_many :compras_financas,   order: 1, dependent: :destroy
  has_many :compras_gastos,     order: 1, dependent: :destroy
  has_many :compras_pedidos,    order: 1, dependent: :destroy
  has_many :compras_custos,     order: 'data, id',  dependent: :destroy
  has_many :compras_depre_apres, dependent: :destroy
  has_many :compras_empaques,   order: '1 desc', dependent: :destroy
  belongs_to :sub_grupo
  belongs_to :sueldo
  belongs_to :persona
  belongs_to :unidade
  belongs_to :plano_de_conta

  validates :cotacao, :cotacao_real, :moeda, :persona_id,
            :documento_numero_01, :documento_numero_02,
            :documento_numero, :tipo_compra, presence: true

  #validates :cotacao, :cotacao_real, :cotacao_rs_us, numericality:  { :greater_than => 0 }

  validates :documento_numero_01,
                :documento_numero_02, length: { :maximum => 3 } , if: :fiscal?


  validates :documento_timbrado, length: { :is => 8 }, if: :fiscal?

  validates_uniqueness_of :documento_numero, scope: [:persona_id, :documento_numero_01,
                          :documento_numero_02], message: " ja cadastrado."

  validate :valid_tipo_compra

  before_save :calcs
  after_save :add_prov_gasto_custo

  def self.modal_gasto(params)
    ComprasCusto.create(
      :compra_id       => params.id,
      :moeda           => params.moeda,
      :unidade_id      => params.unidade_id,
      :rodado_id       => params.rodado_id,
      :funcionario_id  => params.funcionario_id,
      :centro_custo_id => params.centro_custo_id,
      :plano_de_conta_id => params.plano_de_conta_id,
      :valor_us        => params.total_dolar,
      :valor_gs        => params.total_guarani,
      :valor_rs        => params.total_real,
      :data            => params.data
    )

    if params.tipo.to_i == 0
      ComprasFinanca.create( compra_id:          params.id,
                            tipo:                params.tipo,
                            data:                params.data,
                            tipo_compra:         params.tipo_compra,
                            descricao:           params.descricao,
                            documento_numero_01: params.documento_numero_01,
                            documento_numero_02: params.documento_numero_02,
                            documento_numero:    params.documento_numero,
                            persona_id:          params.persona_id,
                            persona_nome:        params.persona_nome,
                            moeda:               params.moeda,
                            cota:                params.cota,
                            conta_id:            params.conta_id,
                            forma_pago_id:       params.forma_pago_id,
                            cred_deb:            0,
                            cheque:              params.cheque,
                            diferido:            params.diferido,
                            valor_guarani:       (params.total_guarani.to_f - (params.desconto_guarani.to_f + params.retencao_gs.to_f)),
                            valor_dolar:         (params.total_dolar.to_f - (params.desconto_dolar.to_f + params.retencao_us.to_f)),
                            valor_real:          (params.total_real.to_f - (params.desconto_real.to_f)),
                            vencimento:          params.vencimento
                          )

      else
      cota = 1
      venc = 0

      params.cota.to_i.times do
        compra_financa = ComprasFinanca.create( compra_id:          params.id,
                              tipo:                1,
                              data:                params.data,
                              tipo_compra:         params.tipo_compra,
                              descricao:           params.descricao,
                              documento_numero_01: params.documento_numero_01,
                              documento_numero_02: params.documento_numero_02,
                              documento_numero:    params.documento_numero,
                              persona_id:          params.persona_id,
                              persona_nome:        params.persona_nome,
                              moeda:               params.moeda,
                              cota:                cota,
                              valor_guarani:       ((params.total_guarani.to_f - (params.desconto_guarani.to_f + params.retencao_gs.to_f)) / params.cota.to_i),
                              valor_dolar:         ((params.total_dolar.to_f - (params.desconto_dolar.to_f + params.retencao_us.to_f)) / params.cota.to_i),
                              valor_real:          ((params.total_real.to_f - (params.desconto_real.to_f)) / params.cota.to_i),
                              vencimento:          params.vencimento.to_date.months_since(venc.to_i) )
        cota += 1
        venc += 1
      end
    end
  end

  def fiscal?
    self.fiscal.to_i == 1
  end


  def valid_tipo_compra
    if self.tipo_compra != 2
      #OBRIGATORIO TOTAL DA FATURA
      if (self.total_dolar.to_f + self.total_guarani.to_f + self.total_real.to_f) <= 0
        errors[:base] << ( "Por Favor Agrege o Total de la Factura!" )
      end
    return false
    end

    if self.tipo_compra == 1
      #OBRIGATORIO RUBRO
      if self.rubro_id != ""
        errors[:base] << ( "Por Favor Agrege un Rubro!" )
      end
    return false
    end
  end

  def self.filtro_busca_compra(params)

    unidade = "G.UNIDADE_ID = #{params[:unidade]}"
    unless params[:inicio].blank?
        cond =  "#{unidade} and G.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    else
        cond =  "#{unidade}"
    end

    if params[:tipo] == "CODIGO"
      tipo = "G.ID"
      cond =  "#{unidade} AND #{tipo} = #{params[:busca]}" unless params[:busca].blank?
    elsif params[:tipo] == "PROVEEDOR"
      tipo = "G.PERSONA_NOME"
      cond =  "#{unidade} AND #{tipo} ILIKE '%#{params[:busca]}%'" unless params[:busca].blank?
    elsif params[:tipo] == "DOCUMENTO"
      tipo = "G.DOCUMENTO_NUMERO"
      cond =  "#{unidade} AND #{tipo} LIKE '%#{params[:busca]}%'" unless params[:busca].blank?
    elsif params[:tipo] == "REFERENCIA"
      tipo = "G.OB_REF"
      cond =  "#{unidade} AND #{tipo} LIKE '%#{params[:busca]}%'" unless params[:busca].blank?
    end

    sql = "SELECT G.ID,
                  G.MOEDA,
                  G.CREATED_AT,
                  G.USUARIO_CREATED,
                  U.USUARIO_NOME,
                  G.DATA,
                  G.TIPO_COMPRA,
                  G.TIPO,
                  G.FISCAL,
                  P.NOME AS PERSONA_NOME,
                  G.DOCUMENTO_NUMERO_01,
                  G.DOCUMENTO_NUMERO_02,
                  G.DOCUMENTO_NUMERO,
                  G.PERSONA_ID,
                  G.RUBRO_DESCRICAO,
                  coalesce((SELECT SUM(QUANTIDADE) FROM COMPRAS_PRODUTOS CP WHERE CP.COMPRA_ID = G.ID),0) AS QTD,
                  coalesce((SELECT SUM(TOTAL_DOLAR) FROM COMPRAS_PRODUTOS CP WHERE CP.COMPRA_ID = G.ID),0) AS TOT_US,
                  coalesce((SELECT SUM(TOTAL_GUARANI) FROM COMPRAS_PRODUTOS CP WHERE CP.COMPRA_ID = G.ID),0) AS TOT_GS,
                  coalesce((SELECT SUM(TOTAL_REAL) FROM COMPRAS_PRODUTOS CP WHERE CP.COMPRA_ID = G.ID),0) AS TOT_RS,
                  (SELECT COUNT(ID) FROM COMPRAS_FINANCAS CF WHERE CF.COMPRA_ID = G.ID) AS FINANCEIRO
            FROM COMPRAS G
            LEFT JOIN USUARIOS U
            ON U.ID = G.USUARIO_CREATED
            INNER JOIN PERSONAS P
            ON P.ID = G.PERSONA_ID
            WHERE G.TIPO_COMPRA <> 1 AND #{cond}
            ORDER BY G.DATA DESC, G.ID DESC"
      Compra.paginate_by_sql(sql, page: params[:page], :per_page => 25)
  end

  def self.filtro_busca_gasto(params)

    if params[:usuario_tipo].to_i <= 1
      usuar = ""
    else
      usuar = "AND G.USUARIO_CREATED = #{params[:usuario_id]}"
    end

    unidade = "G.UNIDADE_ID = #{params[:unidade]}"
    unless params[:inicio].blank?
      data = "AND G.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    end

    unless params[:busca].blank?
      if params[:tipo] == "CODIGO"
        tipo = "G.ID"
        cond = "AND #{tipo} = #{params[:busca]} "
      elsif params[:tipo] == "DOCUMENTO"
        tipo = "G.DOCUMENTO_NUMERO"
        cond =  " AND #{tipo} LIKE '%#{params[:busca]}%'" unless params[:busca].blank?
      elsif params[:tipo] == "REFERENCIA"
      tipo = "AND G.OB_REF"
      cond =  "#{tipo} LIKE '%#{params[:busca]}%'" unless params[:busca].blank?
      else
        tipo = "G.PERSONA_NOME"
        cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%'"
      end
    end

    sql = "SELECT G.ID,
                  G.CREATED_AT,
                  G.USUARIO_CREATED,
                  U.USUARIO_NOME,
                  G.DATA,
                  G.PERSONA_NOME,
                  G.MOEDA,
                  G.TIPO,
                  G.DESCRICAO,
                  G.DOCUMENTO_NUMERO_01,
                  G.DOCUMENTO_NUMERO_02,
                  G.DOCUMENTO_NUMERO,
                  G.PERSONA_ID,
                  G.RUBRO_DESCRICAO,
                  G.TOTAL_GUARANI,
                  G.TOTAL_DOLAR,
                  G.TOTAL_REAL,
                  G.OB_REF,
                  PC.DESCRICAO AS PLANO_DE_CONTA_NOME,
                  (SELECT COUNT(ID) FROM COMPRAS_FINANCAS CF WHERE CF.COMPRA_ID = G.ID) AS FINANCEIRO
            FROM COMPRAS G
            LEFT JOIN USUARIOS U
            ON U.ID = G.USUARIO_CREATED

            LEFT JOIN PLANO_DE_CONTAS PC
            ON PC.ID = G.PLANO_DE_CONTA_ID

            WHERE  #{unidade} #{data} #{cond} #{usuar} AND G.TIPO_COMPRA = 1
            ORDER BY G.DATA DESC, G.ID DESC"
      Compra.paginate_by_sql(sql, page: params[:page], :per_page => 25)

  end

  def self.filtro_bens_gasto(params)
    unidade = "G.UNIDADE_ID = #{params[:unidade]}"
    cond =  " AND G.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND
              '#{params[:final].split("/").reverse.join("-")}'" unless params[:inicio].blank?

    if params[:tipo] == "CODIGO"
      tipo = "G.ID"
      cond =  "AND #{tipo} = #{params[:busca]}" unless params[:busca].blank?
    else
      tipo = "G.PERSONA_NOME"
      cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%'" unless params[:busca].blank?
    end

    sql = "SELECT G.ID,
                  G.CREATED_AT,
                  G.USUARIO_CREATED,
                  U.USUARIO_NOME,
                  G.DATA,
                  G.TIPO,
                  G.PERSONA_NOME,
                  G.MOEDA,
                  G.DOCUMENTO_NUMERO_01,
                  G.DOCUMENTO_NUMERO_02,
                  G.DOCUMENTO_NUMERO,
                  G.PERSONA_ID,
                  G.RUBRO_DESCRICAO,
                  G.TOTAL_GUARANI,
                  G.TOTAL_DOLAR,
                  G.TOTAL_REAL,
                  (SELECT COUNT(ID) FROM COMPRAS_FINANCAS CF WHERE CF.COMPRA_ID = G.ID) AS FINANCEIRO
            FROM COMPRAS G
            LEFT JOIN USUARIOS U
            ON U.ID = G.USUARIO_CREATED
            WHERE #{unidade} AND G.TIPO_COMPRA = 3 #{cond}
            ORDER BY G.DATA DESC, G.ID DESC"
      Compra.paginate_by_sql(sql, page: params[:page], :per_page => 25)

  end

 	def calcs

      if self.tipo.to_i == 1
        self.retencao_gs = 0
        self.retencao_us = 0
      end


	    	#tipo_compra = 0 compra normal
	    	#tipo_compra = 1 gastos
	    	#tipo_compra = 2 importacao
	    	if self.tipo_compra == 0
	      	self.sigla_proc = 'CM'
	    	elsif self.tipo_compra == 1
	     	 	self.sigla_proc = 'GT'
	    	elsif self.tipo_compra == 2
	      	self.sigla_proc = 'IM'
	    	elsif self.tipo_compra == 3
	      	self.sigla_proc = 'CB'
	    	end

	    	if self.tipo_compra == 1
		      if self.descricao.to_s == ''
		        	self.descricao = "GASTO #{self.plano_de_conta.descricao unless self.plano_de_conta.nil?} Prov #{self.persona.nome}"
		      end
	    		elsif self.tipo_compra == 0
	      	if self.descricao == ''
	        		self.descricao = "Compra Mercaderia Prov. #{self.persona_nome} Doc. #{self.documento_numero_01} - #{self.documento_numero_02} - #{self.documento_numero}"
	      	end
	    		elsif self.tipo_compra == 2
	      	if self.descricao == ''
	        		self.descricao = "Compra Importacion Prov. #{self.persona_nome} Doc. #{self.documento_numero_01} - #{self.documento_numero_02} - #{self.documento_numero}"
	      	end
	    		elsif self.tipo_compra == 3
	      	if self.descricao == ''
	        		self.descricao = "Compra De Bienes #{self.persona_nome} Doc. #{self.documento_numero_01} - #{self.documento_numero_02} - #{self.documento_numero}"
	      	end
    		end

    		#CALCULO COTACAO FATURA
    		if self.moeda == 0
      		 #dolar / guarani
      		 self.exentas_guarani     =  self.exentas_dolar.to_f  * self.cotacao.to_f
      		 self.gravadas_05_guarani =  self.gravadas_05_dolar.to_f * self.cotacao.to_f
      	  	 self.gravadas_10_guarani =  self.gravadas_10_dolar.to_f * self.cotacao.to_f
      	 	 self.total_guarani       =  self.total_dolar.to_f * self.cotacao.to_f
      		 self.desconto_guarani    =  self.desconto_dolar.to_f * self.cotacao.to_f

		     #dolar / real
		      self.exentas_real     =  self.exentas_dolar.to_f  * self.cotacao_rs_us.to_f
		      self.gravadas_05_real =  self.gravadas_05_dolar.to_f * self.cotacao_rs_us.to_f
		      self.gravadas_10_real =  self.gravadas_10_dolar.to_f * self.cotacao_rs_us.to_f
		      self.total_real       =  self.total_dolar.to_f * self.cotacao_rs_us.to_f
		      self.desconto_real    =  self.desconto_dolar.to_f * self.cotacao_rs_us.to_f

    		elsif self.moeda == 1
		      #guarani / dolar
		      self.exentas_dolar     =  self.exentas_guarani.to_f  / self.cotacao.to_f
		      self.gravadas_05_dolar =  self.gravadas_05_guarani.to_f / self.cotacao.to_f
		      self.gravadas_10_dolar =  self.gravadas_10_guarani.to_f / self.cotacao.to_f
		      self.total_dolar       =  self.total_guarani.to_f / self.cotacao.to_f
		      self.desconto_dolar    =  self.desconto_guarani.to_f / self.cotacao.to_f

		      #guarani / real
		      #self.exentas_real     =  self.exentas_guarani.to_f  / self.cotacao_real.to_f
		      #self.gravadas_05_real =  self.gravadas_05_guarani.to_f / self.cotacao_real.to_f
		      #self.gravadas_10_real =  self.gravadas_10_guarani.to_f / self.cotacao_real.to_f
		      #self.total_real       =  self.total_guarani.to_f / self.cotacao_real.to_f
		      #self.desconto_real    =  self.desconto_guarani.to_f / self.cotacao_real.to_f
    		elsif self.moeda == 2
		      #real / guarani
		      self.exentas_guarani     =  self.exentas_real.to_f  * self.cotacao_real.to_f
		      self.gravadas_05_guarani =  self.gravadas_05_real.to_f * self.cotacao_real.to_f
		      self.gravadas_10_guarani =  self.gravadas_10_real.to_f * self.cotacao_real.to_f
		      self.total_guarani       =  self.total_real.to_f * self.cotacao_real.to_f
		      self.desconto_guarani    =  self.desconto_real.to_f * self.cotacao_real.to_f

		      #real / dolar
		      self.exentas_dolar     =  self.exentas_guarani.to_f  / self.cotacao_real.to_f
		      self.gravadas_05_dolar =  self.gravadas_05_guarani.to_f / self.cotacao_real.to_f
		      self.gravadas_10_dolar =  self.gravadas_10_guarani.to_f / self.cotacao_real.to_f
		      self.total_dolar       =  self.total_guarani.to_f / self.cotacao_real.to_f
		      self.desconto_dolar    =  self.desconto_guarani.to_f / self.cotacao_real.to_f
    		end
  	end

  def self.gerador_cotas(params)

    cota = 1
    venc = 0
    cp = Compra.find_by_id(params[:id])
    valor_real_ben_us = ComprasProduto.sum(:valor_real_ben_us, :conditions => ["compra_id = #{params[:id]}"])
    valor_real_ben_gs = ComprasProduto.sum(:valor_real_ben_gs, :conditions => ["compra_id = #{params[:id]}"])
    valor_real_ben_rs = ComprasProduto.sum(:valor_real_ben_rs, :conditions => ["compra_id = #{params[:id]}"])

    if cp.moeda.to_i == 0
      valor_us = params[:valor_us].gsub('.', '').gsub(',', '.').to_f / params[:cotas].to_i

      #juros
      juros_us = (params[:valor_us].gsub('.', '').gsub(',', '.').to_f - valor_real_ben_us.to_f) / params[:cotas].to_i

      valor_gs = (params[:valor_us].gsub('.', '').gsub(',', '.').to_f / params[:cotas].to_i) * cp.cotacao.to_f
      valor_rs = (params[:valor_us].gsub('.', '').gsub(',', '.').to_f / params[:cotas].to_i) * cp.cotacao_rs_us.to_f
    elsif cp.moeda.to_i == 1
      valor_gs = params[:valor_gs].gsub('.', '').gsub(',', '.').to_f / params[:cotas].to_i

      #juros
      juros_gs = (params[:valor_gs].gsub('.', '').gsub(',', '.').to_f - valor_real_ben_gs.to_f) / params[:cotas].to_i

      valor_us = (params[:valor_gs].gsub('.', '').gsub(',', '.').to_f / params[:cotas].to_i) / cp.cotacao.to_f
      #valor_rs = (params[:valor_gs].gsub('.', '').gsub(',', '.').to_f  / params[:cotas].to_i) / cp.cotacao_real.to_f
    elsif cp.moeda.to_i == 2
      valor_rs = params[:valor_rs].gsub('.', '').gsub(',', '.').to_f / params[:cotas].to_i

      #juros
      juros_rs = (params[:valor_rs].gsub('.', '').gsub(',', '.').to_f - valor_real_ben_rs.to_f) / params[:cotas].to_i

      valor_gs = (params[:valor_rs].gsub('.', '').gsub(',', '.').to_f / params[:cotas].to_i) * cp.cotacao_real.to_f
      valor_us = ((params[:valor_rs].gsub('.', '').gsub(',', '.').to_f / params[:cotas].to_i)) / cp.cotacao_rs_us.to_f

    elsif cp.moeda.to_i == 4
      valor_eu = params[:valor_eu].gsub('.', '').gsub(',', '.').to_f / params[:cotas].to_i

      #juros
      juros_eu = (params[:valor_eu].gsub('.', '').gsub(',', '.').to_f - valor_real_ben_rs.to_f) / params[:cotas].to_i

      valor_gs = (params[:valor_eu].gsub('.', '').gsub(',', '.').to_f / params[:cotas].to_i) * cp.cotacao_eu_gs.to_f
      valor_us = ((params[:valor_eu].gsub('.', '').gsub(',', '.').to_f / params[:cotas].to_i)) * cp.cotacao_eu_us.to_f

    end


    if params[:tipo].to_i == 0
      ComprasFinanca.create( compra_id:          params[:id],
                            tipo:                cp.tipo,
                            data:                params[:data],
                            tipo_compra:         cp.tipo_compra,
                            descricao:           cp.descricao,
                            documento_numero_01: params[:documento_numero_01],
                            documento_numero_02: params[:documento_numero_02],
                            documento_numero:    params[:documento_numero],
                            fact_an:             params[:fact_an],
                            fact_an_01:          params[:fact_an_01],
                            fact_an_02:          params[:fact_an_02],
                            fact_an_cota:        params[:fact_an_cota],
                            total_guarani:       params[:total_guarani],
                            total_dolar:         params[:total_dolar],
                            total_real:          params[:total_real],
                            documento_id:        cp.documento_id,
                            documento_nome:      cp.documento_nome,
                            persona_id:          cp.persona_id,
                            persona_nome:        cp.persona_nome,
                            moeda:               params[:moeda],
                            cota:                cp.cota,
                            conta_id:            params[:busca]["conta"],
                            banco_id:            params[:busca]["banco_id"],
                            titular:             params[:titular],
                            forma_pago_id:       params[:busca]["forma_pago"],
                            cheque_status:       params[:cheque_status],
                            cred_deb:            params[:cred_deb],
                            cheque:              params[:cheque],
                            diferido:            params[:diferido].to_date,
                            valor_guarani:       valor_gs.to_f,
                            valor_dolar:         valor_us.to_f,
                            valor_real:          valor_rs.to_f,
                            valor_euro:          valor_eu.to_f,
                            vencimento:          params[:venci].to_date.months_since(venc.to_i) )

      else

      params[:cotas].to_i.times do
        if cp.adcionais.to_i == 1
          get_proveedor = params[:busca]["persona"]
        else
          get_proveedor = cp.persona_id
        end

         compra_financa = ComprasFinanca.create( compra_id:          params[:id],
                              tipo:                1,
                              data:                cp.data,
                              tipo_compra:         cp.tipo_compra,
                              descricao:           cp.descricao,
                              conta_id:            params[:busca]["conta"],
                              documento_numero_01: cp.documento_numero_01,
                              documento_numero_02: cp.documento_numero_02,
                              documento_numero:    cp.documento_numero,
                              documento_id:        cp.documento_id,
                              documento_nome:      cp.documento_nome,
                              persona_id:          get_proveedor,
                              persona_nome:        cp.persona_nome,
                              moeda:               (Conta.find_by_id(params[:busca]["conta"]).moeda),
                              cota:                cota,
                              valor_guarani:       valor_gs.to_f,
                              valor_dolar:         valor_us.to_f,
                              valor_real:          valor_rs.to_f,
                              valor_euro:          valor_eu.to_f,
                              vencimento:          params[:venci].to_date.months_since(venc.to_i) )
        if params[:tipo_compra] == 3
          ComprasCusto.create(
            compra_id: params[:id],
            rubro_id: 331,
            moeda: cp.moeda,
            compras_financa_id: compra_financa.id,
            data:  cp.data.to_date.months_since(venc.to_i),
            :valor_us => juros_us.to_f,
            :valor_gs => juros_gs.to_f,
            :valor_rs => juros_rs.to_f
          )
        end

        cota += 1
        venc += 1
      end
    end
  end

  def add_prov_gasto_custo

  	if self.proveedore_id.to_i > 0
	  	prov = Proveedore.find_by_id(self.proveedore_id)
	    venc = 0
	    prov.rubro.competencia.to_i.times do |rc|
	      ComprasCusto.create(
	        :compra_id       => self.id,
	        :moeda           => self.moeda,
	        :unidade_id      => self.unidade_id,
	        :centro_custo_id => prov.centro_custo_id,
	        :rubro_grupo_id  => 0,
	        :rubro_id        => prov.rubro_id,
	        :valor_us        => (self.total_dolar - self.desconto_dolar) / prov.rubro.competencia.to_i,
	        :valor_gs        => (self.total_guarani - self.desconto_guarani) / prov.rubro.competencia.to_i,
	        :valor_rs        => (self.total_real - self.desconto_real) / prov.rubro.competencia.to_i,
	        :data            => self.competencia.to_date.months_since(venc.to_i),

	      )
	      venc += 1
	    end
      ComprasFinanca.create( compra_id:          self.id,
                            tipo:                0,
                            data:                self.data,
                            tipo_compra:         self.tipo_compra,
                            descricao:           self.descricao,
                            documento_numero_01: self.documento_numero_01,
                            documento_numero_02: self.documento_numero_02,
                            documento_numero:    self.documento_numero,
                            persona_id:          self.persona_id,
                            persona_nome:        self.persona_nome,
                            moeda:               self.moeda,
                            cota:                prov.cota,
                            conta_id:            prov.conta_id,
                            cheque_status:       0,
                            diferido:            self.data,
                            valor_guarani:       (self.total_guarani - self.desconto_guarani),
                            valor_dolar:         (self.total_dolar - self.desconto_dolar),
                            valor_real:          (self.total_real.to_f - self.desconto_real.to_f),
                            vencimento:           self.data )
		end
  end

end
