class Regiao < ActiveRecord::Base
	belongs_to :paise
	belongs_to :estado
	has_many :cidades
  validates_presence_of :nome
  validates_uniqueness_of :nome, scope: [:estado_id], message: " ja cadastrado."
  has_many :personas, dependent: :restrict

end
