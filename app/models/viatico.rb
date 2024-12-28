class Viatico < ActiveRecord::Base
  belongs_to :persona
  belongs_to :conta

  def self.filtro_busca_viatico(params)

    unidade = "V.UNIDADE_ID = #{params[:unidade]}"
    unless params[:inicio].blank?
      data = "AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    end

    unless params[:busca].blank?
      if params[:tipo] == "CODIGO"
        tipo = "V.ID"
        cond = "AND #{tipo} = #{params[:busca]} "     
      else
        tipo = "V.PERSONA_NOME"
        cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%'"
      end
    end

    sql = "SELECT V.ID,
                  V.USUARIO_CREATED,
                  V.DATA,
                  V.PERSONA_NOME,
                  V.MOEDA,
                  V.OBS,
                  V.VALOR_GS,
                  V.VALOR_RS,
                  V.VALOR_RS,
                  C.NOME AS CONTA_NOME
            FROM VIATICOS V
            INNER JOIN CONTAS C
            ON C.ID = V.CONTA_ID

            WHERE  #{unidade} #{data} #{cond}
            ORDER BY V.DATA DESC, V.ID DESC"
      Viatico.paginate_by_sql(sql, page: params[:page], :per_page => 25)

  end
end
