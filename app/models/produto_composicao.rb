class ProdutoComposicao < ActiveRecord::Base	
	belongs_to :produto
	validates_presence_of :componente_id, :quantidade

	before_save :calc
	def calc
		prod = Produto.find_by_id(self.componente_id);
    	self.componente_nome = prod.nome
	end
end
