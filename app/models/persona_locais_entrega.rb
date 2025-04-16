class PersonaLocaisEntrega < ActiveRecord::Base
	belongs_to :persona
	belongs_to :paise
	belongs_to :estado
	belongs_to :cidade
	belongs_to :regiao


	def self.list_locais(params)
		sql = "SELECT PLE.ID,
									(C.NOME || ' - Direcion: '|| PLE.DIRECAO || ' - Obs.:' || PLE.OBS) AS DIRECAO
						FROM PERSONA_LOCAIS_ENTREGAS PLE

						LEFT JOIN CIDADES C
						ON C.ID = PLE.CIDADE_ID
						WHERE  PLE.PERSONA_ID = ?"
			self.find_by_sql([sql, params[:persona_id]])
	end
end
