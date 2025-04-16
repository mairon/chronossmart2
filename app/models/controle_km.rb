class ControleKm < ActiveRecord::Base
	belongs_to :persona
	belongs_to :rodado

  def self.filtro_busca(params)

    unidade = "CK.UNIDADE_ID = #{params[:unidade]}"
    unless params[:inicio].blank?
      data = "AND CK.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    end

    unless params[:busca].blank?
      if params[:tipo] == "CODIGO"
        tipo = "CK.ID"
        cond = "AND #{tipo} = #{params[:busca]} "     
      else
        tipo = "CK.PERSONA_NOME"
        cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%'"
      end
    end

    sql = "SELECT CK.ID,
                  CK.DATA,
                  R.PLACA AS RODADO_NOME,
                  P.NOME AS PERSONA_NOME,
                  CK.OBS,
                  CK.KM
            FROM CONTROLE_KMS CK

            LEFT JOIN PERSONAS P
            ON P.ID = CK.PERSONA_ID

            LEFT JOIN RODADOS R
            ON R.ID = CK.RODADO_ID

            WHERE  #{unidade} #{data} #{cond}
            ORDER BY CK.DATA DESC, CK.ID DESC"
      self.paginate_by_sql(sql, page: params[:page], :per_page => 25)

  end
end
