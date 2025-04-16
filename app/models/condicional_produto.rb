class CondicionalProduto < ActiveRecord::Base
  #audit(:create, :update, :destroy) { |model, user, action| "|#{model.condicional_id.to_s.rjust(8,'0')}| Hecho por #{user.usuario_nome}" }
  belongs_to :condicional
  belongs_to :produto
  belongs_to :deposito

  validates_presence_of :produto_id
end


