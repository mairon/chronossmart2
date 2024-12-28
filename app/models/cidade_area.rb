class CidadeArea < ActiveRecord::Base
	belongs_to :cidade
  validates_presence_of :nome
  validates_uniqueness_of :nome, scope: [:cidade_id], message: " ja cadastrado."
end
