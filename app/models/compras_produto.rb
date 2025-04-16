  class ComprasProduto < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.compra_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
  belongs_to :compra
  belongs_to  :produto
  belongs_to  :compras_pedido
  has_many :compras_depre_apres, dependent: :destroy
  has_many :compras_custos, dependent: :destroy

  after_create :distribui_apre_depre, :if => :usa_compra_patrimonio?
  #efore_update :atuliza_peso_bruto
  before_create :atribui_custo, :gera_tabela_de_preco
  before_save :calc_promedio_update, :gera_tabela_de_preco
  before_update :calc_promedio_update
  before_save :calcs

  validates_presence_of :produto_id, :if => :compra_patrimonio?
  validates_presence_of :quantidade

  def compra_patrimonio?
    compra.tipo_compra.to_i != 3
  end

  def usa_compra_patrimonio?
    compra.tipo_compra.to_i == 3
  end

  def atuliza_peso_bruto
    if compra.tipo_compra == 2
      self.produto.update_attributes(peso_bruto: self.peso_bruto.to_f)
    end
  end


  def atribui_custo
    self.custo_dolar   = self.unitario_dolar.to_f
    self.custo_guarani = self.unitario_guarani.to_f
    self.custo_real = self.unitario_real.to_f
    self.custo_euro = self.unitario_euro.to_f
  end

  def distribui_apre_depre
    if self.anos.to_i > 0
        meses = self.anos.to_i * 12
        porc  = ( (100 - self.porcen.to_f) / 100)

        #rateio depreciacao dolar
        valor_rateado_us = (self.total_dolar.to_f * porc.to_f)
        tot_rateio_us    = valor_rateado_us.to_f / meses.to_f

        #rateio depreciacao guarani
        valor_rateado_gs = (self.total_guarani.to_f * porc.to_f)
        tot_rateio_gs    = valor_rateado_gs.to_f / meses.to_f

        #rateio depreciacao real
        valor_rateado_rs = (self.total_real.to_f * porc.to_f)
        tot_rateio_rs    = valor_rateado_rs.to_f / meses.to_f

        m    = 1
        venc = 0
        tot_depre_us = tot_rateio_us.to_f
        tot_depre_gs = tot_rateio_gs.to_f
        tot_depre_rs = tot_rateio_rs.to_f

        meses.to_i.times do
          if self.apre_depre.to_i == 0

            ComprasDepreApre.create(
                compra_id: self.compra_id,
                compras_produto_id: self.id,
                plano_de_conta_id: compra.plano_de_conta_id,
                moeda: self.moeda,
                anos:  self.anos,
                mes:   m,
                data:  compra.data.to_date.months_since(venc.to_i),
                :valor_mensal_us => tot_rateio_us.to_f,
                :valor_mensal_gs => tot_rateio_gs.to_f,
                :valor_mensal_rs => tot_rateio_rs.to_f,
                :depre_us => (self.total_dolar.to_f - tot_depre_us.to_f),
                :depre_gs => (self.total_guarani.to_f - tot_depre_gs.to_f),
                :depre_rs => (self.total_real.to_f - tot_depre_rs.to_f),
                :apre_us => 0,
                :apre_gs => 0,
                :apre_rs => 0
              )


            ComprasCusto.create(  
                    :compra_id       => self.compra_id,
                    :compras_produto_id => self.id,
                    :moeda           => compra.moeda,
                    :unidade_id      => compra.unidade_id,
                    :rodado_id      => compra.rodado_id,
                    :centro_custo_id => compra.centro_custo_id,
                    :plano_de_conta_id  => compra.plano_de_conta_id,
                    :valor_us        => tot_rateio_us,
                    :valor_gs        => tot_rateio_gs,
                    :valor_rs        => tot_rateio_rs,
                    :data            => compra.data.to_date.months_since(venc.to_i)

                  )

          else
            ComprasDepreApre.create(
                compra_id: self.compra_id,
                compras_produto_id: self.id,
                plano_de_conta_id: compra.plano_de_conta_id,
                moeda: self.moeda,
                anos:  self.anos,
                mes:   m,
                data:  compra.data.to_date.months_since(venc.to_i),
                :valor_mensal_us => tot_rateio_us.to_f,
                :valor_mensal_gs => tot_rateio_gs.to_f,
                :valor_mensal_rs => tot_rateio_rs.to_f,
                :depre_us => 0,
                :depre_gs => 0,
                :depre_rs => 0,
                :apre_us => (self.total_dolar.to_f + tot_depre_us.to_f),
                :apre_gs => (self.total_guarani.to_f + tot_depre_gs.to_f),
                :apre_rs => (self.total_real.to_f + tot_depre_rs.to_f)
              )

          end
        m    += 1
        venc += 1
        tot_depre_us += tot_rateio_us.to_f
        tot_depre_gs += tot_rateio_gs.to_f
        tot_depre_rs += tot_rateio_rs.to_f
        end
    end
  end

  def calcs
    self.produto_nome = produto.nome unless self.produto_id.blank?
    if compra.moeda == 0 #moeda dolar
      self.unitario_guarani   = self.unitario_dolar.to_f * compra.cotacao.to_i
      self.total_guarani      = self.total_dolar.to_f * compra.cotacao.to_i
      self.custo_guarani      = self.custo_dolar.to_f * compra.cotacao.to_i
      self.desconto_guarani   = self.desconto_dolar.to_f * compra.cotacao.to_i
      self.frete_guarani      = self.frete_dolar.to_f * compra.cotacao.to_i
      self.despacho_guarani   = self.despacho_dolar.to_f * compra.cotacao.to_i
      if compra.tipo_compra == 3
        self.valor_real_ben_gs    = self.valor_real_ben_us.to_f * compra.cotacao.to_i
      end
      self.unitario_real = self.unitario_dolar.to_f * compra.cotacao_rs_us.to_f
      self.total_real    = self.total_dolar.to_f * compra.cotacao_rs_us.to_f
      self.custo_real    = self.custo_dolar.to_f * compra.cotacao_rs_us.to_f
      if compra.tipo_compra == 3
        self.valor_real_ben_rs = self.valor_real_ben_us.to_f * compra.cotacao_rs_us.to_f
      end
    elsif compra.moeda == 1 #moeda guaranies
      self.unitario_dolar  = self.unitario_guarani.to_f / compra.cotacao.to_i
      self.custo_dolar     = self.custo_guarani.to_f / compra.cotacao.to_i
      self.total_dolar     = self.total_guarani.to_f / compra.cotacao.to_i
      self.desconto_dolar  = self.desconto_guarani.to_f / compra.cotacao.to_i
      self.frete_dolar     = self.frete_guarani.to_f / compra.cotacao.to_i

      if compra.tipo_compra == 3
        self.valor_real_ben_us   = self.valor_real_ben_gs.to_f / compra.cotacao.to_i
      end
      self.unitario_real = self.unitario_guarani.to_f / compra.cotacao_real.to_f
      self.total_real    = self.total_guarani.to_f / compra.cotacao_real.to_f
      self.custo_real    = self.custo_guarani.to_f / compra.cotacao_real.to_f
      if compra.tipo_compra == 3
        self.valor_real_ben_rs  = self.valor_real_gs.to_f / compra.cotacao_real.to_f
      end
    elsif compra.moeda == 2 #moeda guaranies
      self.custo_guarani    = self.custo_real.to_f * compra.cotacao_real.to_f
      self.total_guarani    = self.total_real.to_f * compra.cotacao_real.to_f
      self.unitario_guarani = self.unitario_real.to_f * compra.cotacao_real.to_f
      self.total_dolar      = self.total_real.to_f / compra.cotacao_rs_us.to_f
      if compra.tipo_compra == 3
        self.valor_real_ben_gs    = self.valor_real_rs.to_f * compra.cotacao_real.to_f
      end
      self.unitario_dolar   = self.unitario_real.to_f / compra.cotacao_rs_us.to_f
      self.custo_dolar      = self.custo_real.to_f / compra.cotacao_rs_us.to_f
      self.total_dolar      = self.total_real.to_f / compra.cotacao_rs_us.to_f
      if compra.tipo_compra == 3
        self.valor_real_ben_us = self.valor_real_ben_rs.to_f / compra.cotacao_rs_us.to_f
      end

    elsif compra.moeda == 4 #moeda euro
      self.custo_guarani    = self.custo_euro.to_f * compra.cotacao_eu_gs.to_f
      self.total_guarani    = self.total_euro.to_f * compra.cotacao_eu_gs.to_f
      self.unitario_guarani = self.unitario_euro.to_f * compra.cotacao_eu_gs.to_f
      self.unitario_dolar   = self.unitario_euro.to_f * compra.cotacao_eu_us.to_f
      self.custo_dolar      = self.custo_euro.to_f * compra.cotacao_eu_us.to_f
      self.total_dolar      = self.total_euro.to_f * compra.cotacao_eu_us.to_f
    end

  end

  def calc_promedio_update

    puts saldo = Stock.sum('entrada - saida',:conditions => ["deposito_id = ? and produto_id = ? AND data <= ?",self.deposito_id,self.produto_id, compra.data])
    puts promedio_anterior = Stock.where("status = 0 and deposito_id = ? and produto_id = ? AND data <= ?",self.deposito_id,self.produto_id, compra.data).last

    if saldo.to_f <= 0
      self.promedio_guarani = self.unitario_guarani.to_f
    else
      stock_financeiro_anterior_gs = (saldo.to_f * promedio_anterior.promedio_guarani.to_f)
      nova_entrada_gs              = (self.quantidade.to_f * self.unitario_guarani.to_f)
      calc_promedio_gs             = (stock_financeiro_anterior_gs.to_f + nova_entrada_gs.to_f) / (saldo.to_f + self.quantidade.to_f)

      self.promedio_guarani = calc_promedio_gs.to_f
    end
    puts "#{compra.data} |||| #{ self.promedio_guarani.to_f}"
  end



  def gera_tabela_de_preco
    if compra.tipo_compra.to_i == 0
      produto.produtos_tabela_preco.each do |tb|
        clase_tabela = ClaseTabelaPreco.find_by_clase_id_and_tabela_preco_id_and_unidade_id(produto.clase_id, tb.tabela_preco_id, compra.unidade_id)

        if clase_tabela.perc.to_f > 0
          if compra.unidade.moeda == 0
            tb.update_attributes(preco_1_us: self.unitario_dolar.to_f + (self.unitario_dolar.to_f * (clase_tabela.perc.to_f / 100)))
          elsif compra.unidade.moeda == 1
            tb.update_attributes(preco_1_gs: self.unitario_guarani.to_f + (self.unitario_guarani.to_f * (clase_tabela.perc.to_f / 100)))
          elsif  compra.unidade.moeda == 2
            tb.update_attributes(preco_1_rs: self.unitario_real.to_f + (self.unitario_real.to_f * (clase_tabela.perc.to_f / 100)))
          end
        end
      end
    end
  end

end

