class CondicionalProduto < ActiveRecord::Base
  audit(:create, :update, :destroy) { |model, user, action| "|#{model.condicional_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
  belongs_to :condicional
  belongs_to :produto
  validates_presence_of :produto_id,:quantidade
  #validate :valid_stock
  before_save :calcs


  def valid_stock
    if produto.tipo_produto == 0
      #VERIFICA SALDO EM STOCK DISPONIVEL
       saldo = Stock.sum('entrada - saida',:conditions => ["produto_id = ? AND data <= ? and deposito_id = ?",self.produto_id, condicional.data, self.deposito_id])
      if ( saldo.to_f  <= 0 )
        errors[:base] << ( "No tiene saldo Disponible" )
      end

      #VERIFICA SE SALDO E MAIOR QUE A QUANTIDADE DA VENDA
      if ( self.quantidade > saldo.to_f   )
        errors[:base] << ("La quantidade es Mayor que su Saldo" )
      end
    end

    if self.moeda == 0
      if ( self.unitario_us <= 0   )
        errors[:base] << ("Agrege lo Unitario" )
      end
      if ( self.total_us <= 0   )
        errors[:base] << ("Agrege lo Total" )
      end
    else
      if ( self.unitario_gs <= 0   )
        errors[:base] << ("Agrege lo Unitario" )
      end
      if ( self.total_gs <= 0   )
        errors[:base] << ("Agrege lo Total" )
      end
    end
  end

  def calcs
    if self.moeda.to_i == 0
      self.unitario_gs = unitario_us * condicional.cotacao.to_i
      self.total_gs = total_us * condicional.cotacao.to_i
    else
      self.unitario_us = unitario_gs / condicional.cotacao.to_i
      self.total_us = total_gs / condicional.cotacao.to_i
    end
  end
end


