class Plano < ActiveRecord::Base
	has_many :plano_regras, dependent: :restrict
	validates_presence_of :condicao
	validates_uniqueness_of :condicao, message: " ja cadastrado."
end
