class NegocioProduto < ActiveRecord::Base
  belongs_to :produto
  belongs_to :negocio
end
