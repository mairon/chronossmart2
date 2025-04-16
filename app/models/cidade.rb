class Cidade < ActiveRecord::Base
	belongs_to :estado
	belongs_to :paise
	belongs_to :distrito
	belongs_to :regiao
	has_many :cidade_areas
	validates_presence_of :nome
	validates_uniqueness_of :nome, scope: [:estado_id], message: " ja cadastrado."

	def self.lista_cidade
		sql = "SELECT C.ID, (E.NOME || ' > ' ||  C.NOME || ' > ' || D.NOME) AS NOME FROM CIDADES C
            INNER JOIN DISTRITOS D
            ON D.ID = C.DISTRITO_ID

            INNER JOIN ESTADOS E
            ON E.ID = D.ESTADO_ID

            ORDER BY 2"
            self.find_by_sql(sql)
	end
end
