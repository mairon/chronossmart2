class BocaCxProduto < ActiveRecord::Base
  belongs_to :boca_cxes
  belongs_to :produto
end
