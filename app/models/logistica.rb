class Logistica < ActiveRecord::Base

  def self.filtro_busca(params)
    lista_carga = "AND VD.LISTA_CARGA_ID = #{params[:lista_carga_id]}" unless params[:lista_carga_id].blank?
    unidade   = "P.UNIDADE_ID = #{params[:unidade]}"
    st = "AND P.STATUS = #{params[:status]}" unless params[:status].blank?
    unless params[:inicio].blank?
      cond =  " #{unidade} AND P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    else
      cond =  " #{unidade}"
    end
    if params[:tipo] == "CODIGO"
      tipo = "P.ID"
      cond =  " #{unidade} AND #{tipo} = #{params[:busca]} " unless params[:busca].blank?
    elsif params[:tipo] == "NOMBRE"
      tipo = "P.PERSONA_NOME"
      cond =  " #{unidade} AND  #{tipo} LIKE '%#{params[:busca]}%'" unless params[:busca].blank?
    elsif params[:tipo] == "VENDEDOR"
      tipo = "V.NOME"
      cond =  " #{unidade} AND  #{tipo} LIKE '%#{params[:busca]}%'" unless params[:busca].blank?

    end
    sql = "SELECT  P.ID,
                   P.ORIGEM,
                   P.DATA,
                   V.NOME AS VENDEDOR,
                   I.ID AS INDICADOR,
                   V.ID AS VENDEDOR_ID,
                   P.PERSONA_NOME,
                   P.PERSONA_ID,
                   P.DOCUMENTO_NUMERO,
                   P.STATUS,
                   P.TABELA_PRECO_ID,
                   TP.NOME AS TABELA_PRECO_NOME,
                   VD.LISTA_CARGA_ID,
                   VD.ID AS VENDA_ID,
                   COALESCE((SELECT SUM(PP.QUANTIDADE) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.PRESUPUESTO_ID = P.ID),0) QTD,
                   COALESCE((SELECT SUM(PP.TOTAL_GUARANI) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.PRESUPUESTO_ID = P.ID),0) TOTAL_GS,
                   COALESCE((SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.PRESUPUESTO_ID = P.ID),0) FACT,
                   COALESCE((SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE PRODUTO_ID IN (SELECT PP.PRODUTO_ID FROM PRESUPUESTO_PRODUTOS PP WHERE PP.STATUS = 0 AND PP.PRESUPUESTO_ID = P.ID)),0) AS DISP
                  FROM PRESUPUESTOS P
                  LEFT JOIN PERSONAS V
                  ON P.VENDEDOR_ID = V.ID

                  LEFT JOIN TABELA_PRECOS TP
                  ON P.TABELA_PRECO_ID = TP.ID

                  LEFT JOIN PERSONAS I
                  ON P.INDICADOR_ID = I.ID
                  LEFT JOIN VENDAS VD
                  ON P.ID = VD.PRESUPUESTO_ID
                  WHERE #{cond} #{st} #{lista_carga}
                  ORDER BY P.DATA DESC, P.ID DESC"
    Presupuesto.find_by_sql(sql)
  end	
end
