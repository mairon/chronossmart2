class OrdemEntregaProduto < ActiveRecord::Base
	belongs_to :produto
	belongs_to :ordem_entrega
	validates :quantidade, numericality:  { :greater_than => 0 }  
end
