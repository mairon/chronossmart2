class Etapa < ActiveRecord::Base
	has_many :negocios
	belongs_to :pipeline
end
