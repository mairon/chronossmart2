class PersonaProduto < ActiveRecord::Base
	belongs_to :produto
  validates_presence_of :produto_id
  validates_uniqueness_of :produto_id, scope: [:persona_id], message: " ja cadastrado."
  validates :preco_gs, numericality:  { :greater_than => 0 }

end
