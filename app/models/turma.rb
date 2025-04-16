class Turma < ActiveRecord::Base
	has_many :turma_personas
	has_many :turma_responsavels

	def self.filtro_busca(params)
    busca = "AND T.NOME ILIKE %?%" unless params[:busca].blank?
    sql =  "SELECT T.ID,
									T.NOME,
									T.STATUS,
									(SELECT COUNT(TP.ID) FROM TURMA_PERSONAS TP WHERE TP.TURMA_ID = T.ID) AS COUNT_PERSONAS
						FROM TURMAS T
						WHERE T.UNIDADE_ID = ? AND T.STATUS = ? AND T.NOME ILIKE ?"
      Turma.find_by_sql([sql, params[:unidade], params[:status],"%#{params[:busca]}%"])
	end
end
