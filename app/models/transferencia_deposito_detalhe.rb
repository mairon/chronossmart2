class TransferenciaDepositoDetalhe < ActiveRecord::Base
  belongs_to :transferencia_deposito	

  validates_presence_of :produto_id, :quantidade

  #before_save :calc_promedio_update
  #validate :valid_stock

  def valid_stock      
    saldo = Stock.sum('entrada - saida',:conditions => ["produto_id = ? AND data <= ? and deposito_id = ?",self.produto_id, transferencia_deposito.data,transferencia_deposito.deposito_origem_id])
    if ( saldo.to_f  <= 0 )
      errors[:base] << ( "No tiene saldo Disponible" )
    end

    #VERIFICA SE SALDO E MAIOR QUE A QUANTIDADE DA VENDA
    if ( self.quantidade > saldo.to_f   )
      errors[:base] << ("La quantidade es Mayor que su Saldo" )
    end

  end

  def calc_promedio_update

    puts saldo = Stock.sum('entrada - saida',:conditions => ["deposito_id = ? and produto_id = ? AND data <= ?",self.deposito_origem_id,self.produto_id, self.data])
    puts promedio_anterior = Stock.where("status = 0 and deposito_id = ? and produto_id = ? AND data <= ?",self.deposito_origem_id,self.produto_id, self.data).last

    if saldo.to_f <= 0
      self.custo_guarani = 0
    else     
      self.custo_guarani = promedio_anterior.promedio_guarani
    end
    puts "#{self.data} |||| #{ self.custo_guarani.to_f}"
  end

end
