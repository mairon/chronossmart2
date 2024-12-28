class Metodo < ActiveRecord::Base
	has_many :conj_ensaio_metodos
	has_many :amostra_ensaio

end
