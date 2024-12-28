class PersonaLocaisEntrega < ActiveRecord::Base
	belongs_to :persona
	belongs_to :paise
	belongs_to :estado
	belongs_to :cidade
	belongs_to :regiao
end
