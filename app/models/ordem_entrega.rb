class OrdemEntrega < ActiveRecord::Base
  has_many :ordem_entrega_produtos, dependent: :destroy
  belongs_to :persona
  belongs_to :venda
  belongs_to :rodado
  belongs_to :persona_locais_entrega

  def self.busca(params)

    vend = "AND V.VENDEDOR_ID = #{params[:filtro]["vendedor"]}" unless params[:filtro]["vendedor"].blank?
    status = "AND OE.STATUS = #{params[:status]}" unless params[:status].blank?
    cl = "AND V.PERSONA_NOME ILIKE '%#{params[:busca]}%'" unless params[:busca].blank?

    sql = "SELECT OE.ID,
                  OE.VENDA_ID,
                  OE.STATUS,
                  OE.CREATED_AT,
                  V.PERSONA_NOME,
                  V.OBS,
                  VD.NOME AS VENDEDOR_NOME,
                  OE.DIRECAO,
                  OE.LOCAL_RETIRADA,
                  (SELECT SUM(OEP.QUANTIDADE) FROM ORDEM_ENTREGA_PRODUTOS OEP WHERE OEP.ORDEM_ENTREGA_ID = OE.ID ) AS QTD
              FROM ORDEM_ENTREGAS OE
              INNER JOIN VENDAS V
              ON V.ID = OE.VENDA_ID
              LEFT JOIN PERSONAS VD
              ON VD.ID = V.VENDEDOR_ID

              WHERE exists (select 1 from ordem_entrega_produtos oep where oep.ordem_entrega_id = OE.id ) and exists (select 1 from vendas_financas vf where vf.venda_id = V.id )
              AND OE.CREATED_AT::DATE BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}'
              #{vend} #{status} #{cl}
                  "
    self.find_by_sql(sql)
  end

  def self.produtos_pendentes(params)
    sql = "SELECT PP.ID,
                  PP.VENDA_ID,
                  PD.NOME AS PRODUTO_NOME,
                  PD.ID AS PRODUTO_ID,
                  PD.PESO,
                  PP.QUANTIDADE,
                  (SELECT COALESCE(SUM(LCP.QUANTIDADE),0) FROM ORDEM_ENTREGA_PRODUTOS LCP WHERE LCP.VENDAS_PRODUTO_ID = PP.ID) AS QTD_ENVIADO,
                  COALESCE((SELECT SUM(COALESCE(S.ENTRADA,0) - COALESCE(S.SAIDA,0)) FROM STOCKS S WHERE S.PRODUTO_ID = PD.ID AND S.DATA <= '#{params[:data]}'),0) AS STOCK,
                  (PP.QUANTIDADE - (SELECT COALESCE(SUM(LCP.QUANTIDADE),0) FROM ORDEM_ENTREGA_PRODUTOS LCP WHERE LCP.VENDAS_PRODUTO_ID = PP.ID)) SALDO

          FROM VENDAS_PRODUTOS  PP
          INNER JOIN PRODUTOS PD
          ON PD.ID = PP.PRODUTO_ID
          WHERE PP.VENDA_ID = #{params[:venda_id]}
          ORDER BY (PP.QUANTIDADE - (SELECT COALESCE(SUM(LCP.QUANTIDADE),0) FROM ORDEM_ENTREGA_PRODUTOS LCP WHERE LCP.VENDAS_PRODUTO_ID = PP.ID)) DESC,
                    COALESCE((SELECT SUM(COALESCE(S.ENTRADA,0) - COALESCE(S.SAIDA,0)) FROM STOCKS S WHERE S.PRODUTO_ID = PD.ID AND S.DATA <= '#{params[:data]}'),0) DESC"
    VendasProduto.find_by_sql(sql)
  end

end
