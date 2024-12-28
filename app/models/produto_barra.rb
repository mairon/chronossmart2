class ProdutoBarra < ActiveRecord::Base
	belongs_to :produto
	validates_uniqueness_of :barra, :scope=>[:produto_id], :message => " ja cadastrado."
end
