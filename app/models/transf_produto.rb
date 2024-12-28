class TransfProduto < ActiveRecord::Base

  def self.filtro_busca(params)

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
                  V.MOEDA,
                  V.OBS,
                  PO.NOME AS PRODUTO_ORIGEM,
                  PI.NOME AS PRODUTO_DESTINO,
                  V.QTD_ORIGEM,
                  V.QTD_DESTINO
            FROM TRANSF_PRODUTOS V

            INNER JOIN PRODUTOS PO
            ON PO.ID = V.PRODUTO_ORIGEM_ID

            INNER JOIN PRODUTOS PI
            ON PI.ID = V.PRODUTO_DESTINO_ID

            WHERE  #{unidade} #{data} #{cond}
            ORDER BY V.DATA DESC, V.ID DESC"
      Viatico.paginate_by_sql(sql, page: params[:page], :per_page => 25)

  end

end
