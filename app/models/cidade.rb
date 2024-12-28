class Cidade < ActiveRecord::Base
	belongs_to :estado
	belongs_to :paise
	belongs_to :distrito
	belongs_to :regiao
	has_many :cidade_areas
	validates_presence_of :nome
	validates_uniqueness_of :nome, scope: [:estado_id], message: " ja cadastrado."
end
