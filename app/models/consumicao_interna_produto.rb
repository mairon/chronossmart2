class ConsumicaoInternaProduto < ActiveRecord::Base
  belongs_to :consumicao_interna
  belongs_to :produto
  belongs_to :deposito

  validates_presence_of :produto_id,:quantidade
  #validate :valid_stock

  before_save :find_cmv

  def valid_stock
    saldo = Stock.sum('entrada - saida',:conditions => ["produto_id = ? and deposito_id = ? AND data <= ?",self.produto_id,self.deposito_id, consumicao_interna.data])
    if ( saldo.to_f <= 0   )
      errors.add( :produto_id, "No tiene saldo Disponible" )
    end

    if ( self.quantidade > saldo.to_f   )
      errors.add( :produto_id, "La quantidade es Mayor que su Saldo" )
    end
  end

  def find_cmv

    cmv = Stock.last(:conditions => ["status = 0 and deposito_id = ? and produto_id = ? AND data < ?",self.deposito_id, self.produto_id, self.data], select: 'produto_id,promedio_guarani,promedio_dolar', order: 'data,id')
    unless cmv.nil?
      self.unitario_dolar = cmv.promedio_dolar.to_f
      self.total_dolar = cmv.promedio_dolar.to_f.to_f * self.quantidade.to_f

      self.unitario_guarani = cmv.promedio_guarani.to_f
      self.total_guarani = cmv.promedio_guarani.to_f * self.quantidade.to_f
    end
  end
end
