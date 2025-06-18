class VendasProduto < ActiveRecord::Base
  #audit(:destroy) { |model, user, action| "|#{model.venda_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
  belongs_to :venda
  belongs_to :produto
  belongs_to :bico
  belongs_to :deposito
  has_many :vendas_produtos_comps, :dependent => :destroy
  has_many :evento_convidados, :dependent => :destroy
  has_many :ordem_entrega_produtos, dependent: :destroy
  has_and_belongs_to_many :produto_composicaos
  has_one :presupuesto_produto
  validates_presence_of :produto_nome, :quantidade
  #validates :quantidade, numericality:  { :greater_than => 0 }
  validate :valid_stock
  before_save :calcs
  after_save :add_produtos_compostos, :gera_tickets
  before_update :calc_qtd
  belongs_to :promo

  attr_accessor :current_user

  def add_produtos_compostos
    if self.produto.tipo_produto == 2
      prods = ProdutoComposicao.where(produto_id: self.produto_id)
      VendasProdutosComp.destroy_all("vendas_produto_id = #{self.id}")
      prods.each do |p|
        VendasProdutosComp.create(
          venda_id:            self.venda_id,
          vendas_produto_id:   self.id,
          produto_id:          p.componente_id,
          quantidade:         (p.quantidade.to_f * self.quantidade.to_f)
        )
      end
    end
  end


  def gera_tickets
    #ticket

    if produto.tickets.to_i > 0
      (produto.tickets.to_i * self.quantidade.to_i).times do |t|
        EventoConvidado.create(venda_id: self.venda_id,
          nome: venda.persona_nome,
          persona_id: venda.persona_id,
          vendas_produto_id: self.id)
      end
    end
  end

  def calc_qtd
    self.total_guarani = (self.unitario_guarani.to_f * self.quantidade.to_f).round
    self.total_real = self.unitario_real.to_f * self.quantidade.to_f
    self.total_dolar = self.unitario_dolar.to_f * self.quantidade.to_f
  end

  def self.nota_credito_produto(params)
    sql = "SELECT VP.id,
                  V.data,
                  VP.quantidade,
                  VP.produto_id,
                  VP.produto_nome,
                  VP.taxa,
                  VP.fabricante_cod,
                  VP.unitario_dolar,
                  VP.total_dolar,
                  VP.iva_dolar,
                  VP.unitario_guarani,
                  VP.total_guarani,
                  VP.iva_guarani,
                  VP.deposito_id,
                  VP.deposito_nome,
                  VP.venda_id
        FROM VENDAS_PRODUTOS VP
        INNER JOIN VENDAS V
        ON V.ID = VP.VENDA_ID
        WHERE V.PERSONA_ID = #{params[:persona_id]}
        ORDER BY V.DATA DESC"

    VendasProduto.find_by_sql(sql)

  end

  def valid_stock
    regra = VendasConfig.where(unidade_id: venda.unidade_id).last

    if regra.stock_negativo == false
      if produto.tipo_produto == 0

        #VERIFICA SALDO EM STOCK DISPONIVEL
         saldo = Stock.sum('entrada - saida',:conditions => ["deposito_id = ? and produto_id = ? AND data <= ?",self.deposito_id,self.produto_id, venda.data])
        if ( saldo.to_f  <= 0 )
          errors[:base] << ( "No tiene saldo Disponible" )
        end

        #VERIFICA SE SALDO E MAIOR QUE A QUANTIDADE DA VENDA
        if ( self.quantidade > saldo.to_f   )
          errors[:base] << ("La quantidade es Mayor que su Saldo" )
        end

        #VERIFICA MAXIMO DE DESCONTO
        if self.current_user.to_i != 0
          if ( self.total_desconto.to_i > self.desconto.to_i   )
            errors[:base] << ("Descuento no Autorizando!" )
          end
        end
      end
    end

    #if regra.tabela_preco_id_limite != nil
    #  if self.venda.persona.tabela_preco_id.to_i != 4
    #    if self.current_user.to_i == 2
    #      tabela_minima = ProdutosTabelaPreco.where(produto_id: self.produto_id, tabela_preco_id: regra.tabela_preco_id_limite).last
    #      if self.moeda.to_i == 0
    #        if self.unitario_dolar.to_f < tabela_minima.preco_1_us.to_f
    #          errors[:base] << ( "Precio a barro del minimo" )
    #        end
    #      elsif self.moeda.to_i == 1
    #        if self.unitario_guarani.to_f < tabela_minima.preco_1_gs.to_f
    #          errors[:base] << ( "Precio a barro del minimo" )
    #        end
    #      end
    #    end
    #  end
    #end


    if self.moeda == 0
      if ( self.unitario_dolar.to_f <= 0   )
        errors[:base] << ("Agrege lo Unitario" )
      end
      if ( self.total_dolar.to_f <= 0   )
        errors[:base] << ("Agrege lo Total" )
      end
    elsif self.moeda == 1
      if ( self.unitario_guarani.to_f <= 0   )
        errors[:base] << ("Agrege lo Unitario GS" )
      end
      if ( self.total_guarani.to_f <= 0   )
        errors[:base] << ("Agrege lo Total GS" )
      end
    elsif self.moeda == 2
      if ( self.unitario_real.to_f <= 0   )
        errors[:base] << ("Agrege lo Unitario R$" )
      end
      if ( self.total_real.to_f <= 0   )
        errors[:base] << ("Agrege lo Total R$" )
      end
    end

  end

  def calcs
	  self.data = venda.data
    self.taxa     = produto.taxa
    self.persona_id = venda.persona_id

      preco_personal = PersonaProduto.find_by_produto_id(self.produto_id, conditions: ["persona_id = #{venda.persona_id}"])
      if preco_personal
        self.unitario_guarani = preco_personal.preco_gs
        self.total_guarani = preco_personal.preco_gs.to_f * self.quantidade.to_f
      else
        self.total_guarani = self.unitario_guarani.to_f * quantidade.to_f
      end

    if venda.moeda.to_i == 0
      self.unitario_guarani = self.unitario_dolar * venda.cotacao.to_i
      self.total_guarani = self.total_dolar * venda.cotacao.to_i
      self.preco_guarani = self.preco_dolar * venda.cotacao.to_i

      self.unitario_real = self.unitario_dolar * venda.cotacao_rs_us.to_f
      self.total_real = self.total_dolar * venda.cotacao_rs_us.to_f
      self.preco_real = self.preco_dolar * venda.cotacao_rs_us.to_f
    elsif venda.moeda.to_i == 1
      self.unitario_dolar = self.unitario_guarani / venda.cotacao.to_i
      self.total_dolar = self.total_guarani / venda.cotacao.to_i
      self.preco_dolar = self.preco_guarani / venda.cotacao.to_i

      self.unitario_real = self.unitario_guarani.to_f / venda.cotacao_real.to_i
      self.total_real = self.total_guarani.to_f / venda.cotacao_real.to_i
      self.preco_real = self.preco_guarani.to_f / venda.cotacao_real.to_i
    elsif venda.moeda.to_i == 2
      self.unitario_guarani = self.unitario_real.to_f * venda.cotacao_real.to_f
      self.total_guarani = self.total_real.to_f * venda.cotacao_real.to_f
      self.preco_guarani = self.preco_real.to_f * venda.cotacao_real.to_f

    end


    #promo
    promo = PromoDt.joins(:promo).select('promos.id, promo_dts.promo_id, promos.tipo as tipo, promo_dts.desc_porce as desc_porce').where("promo_dts.produto_id = #{self.produto_id} and '#{self.data}' between promos.valid_inicio and promos.valid_final").last

    unless promo.nil?
      if promo.tipo.to_i == 1 #cashback por produto
        self.promo_id = promo.promo_id
        self.cashback_gs =  (  self.total_guarani.to_f * (promo.desc_porce.to_f / 100))
      end
    end

  end
end
