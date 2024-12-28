class AjustePrecoDetalhe < ActiveRecord::Base
  belongs_to :ajuste_preco
  belongs_to :produto
end
