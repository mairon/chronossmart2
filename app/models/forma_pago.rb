class FormaPago < ActiveRecord::Base
	has_and_belongs_to_many :personas
	has_and_belongs_to_many :contas
	validates_presence_of :nome
end
