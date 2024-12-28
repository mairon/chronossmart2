class ProdutosTribut < ActiveRecord::Base
  belongs_to :unidades
  belongs_to :regimes
  belongs_to :produtos

 
  
end
