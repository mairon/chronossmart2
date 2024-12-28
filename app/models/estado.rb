class Estado < ActiveRecord::Base
	belongs_to :paise
	has_many :regiaos
	validates_presence_of :nome
	validates_uniqueness_of :nome, scope: [:paise_id], message: " ja cadastrado."
end
