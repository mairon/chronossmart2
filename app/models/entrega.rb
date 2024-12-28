class Entrega < ActiveRecord::Base
	belongs_to :persona
	belongs_to :rodado
	validates_presence_of :persona_id

	def self.busca(params)
    unidade = "E.UNIDADE_ID = #{params[:unidade]}"
    st = " AND E.STATUS = #{params[:status]}"
    unless params[:inicio].blank?
      cond = "#{unidade} #{st} AND E.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    else
      cond = "#{unidade} #{st}"
    end
    if params[:tipo] == "CODIGO"
      tipo = "E.ID"
      cond = "#{unidade} #{st} AND E.ID = #{params[:busca]} " unless params[:busca].blank?
    elsif params[:tipo] == "RESPONSABLE"
      tipo = "P.NOME"
      cond = "#{unidade} #{st} AND #{tipo} LIKE '%#{params[:busca]}%' " unless params[:busca].blank?
    end

		sql = "SELECT E.ID,
						      E.DATA,
						      E.TIPO,
						      E.STATUS,
						      P.NOME AS PERSONA_NOME,
						      R.PLACA AS RODADO_PLACA
						FROM ENTREGAS E
						INNER JOIN PERSONAS P
						ON P.ID = E.PERSONA_ID
						INNER JOIN RODADOS R
						ON R.ID = E.RODADO_ID
						WHERE #{cond} 
						ORDER BY 2 DESC, 1 DESC"

    Entrega.paginate_by_sql(sql, page: params[:page], :per_page => 25)
	end
end
