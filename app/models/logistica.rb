class Logistica < ActiveRecord::Base

  def self.filtro_busca(params)
    sql = "SELECT LCP.VENDA_ID AS VENDA_ID,
                  MAX(V.PERSONA_NOME) AS PERSONA_NOME,
                  MAX(PV.NOME) AS VENDEDOR_NOME,
                  MAX(V.DIRECAO) AS DIRECION,
                  MAX(LCP.STATUS) AS STATUS,
                  SUM(LCP.QUANTIDADE) AS QTD,
                  COUNT(DISTINCT LCP.PRODUTO_ID) AS QTD_ITENS

              FROM LISTA_CARGA_PRODUTOS LCP
              INNER JOIN VENDAS V
              ON V.ID = LCP.VENDA_ID

              INNER JOIN PERSONAS PV
              ON PV.ID = V.VENDEDOR_ID

              WHERE LCP.STATUS = ?
              GROUP BY 1"
    ListaCargaProduto.find_by_sql([sql, params[:status_entrega]])
  end
end
