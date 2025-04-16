class ListaCarga < ActiveRecord::Base
	belongs_to :rodado
	belongs_to :cidade
	has_many :lista_carga_produtos, dependent: :destroy, order: 'id'
	validates_presence_of :rodado_id
	has_and_belongs_to_many :personas
	def self.veiculos_disponiveis
		sql = "SELECT ID,
		              PLACA
						FROM RODADOS R
						WHERE
						(SELECT COUNT(LC.ID) FROM LISTA_CARGAS LC WHERE LC.RODADO_ID = R.ID AND LC.STATUS = FALSE) = 0"
		Rodado.find_by_sql(sql)
	end

	def self.chofer_disponiveis
		sql = "SELECT P.ID,
		              P.NOME
						FROM PERSONAS P
						WHERE
						P.TIPO_CHOFER = 1"
		Persona.find_by_sql(sql)
	end

	def self.pedido_pendentes(params)

    if params[:tipo] == "CODIGO"
      tipo = "P.ID"
      cond =  " AND P.ID = #{params[:busca]} " unless params[:busca].blank?
    elsif params[:tipo] == "DOC"
      tipo = "CL.DOCUMENTO_NUMERO "
      cond =  " AND #{tipo} LIKE ? ","%#{params[:busca]}%" unless params[:busca].blank?
    elsif params[:tipo] == "CLIENTE"
      tipo = "CL.NOME"
      cond =  " AND #{tipo} LIKE '%#{params[:busca]}%' " unless params[:busca].blank?
    end
    data = "AND P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'" unless params[:inicio].blank?
		sql = "SELECT P.ID,
					       CL.NOME AS CLIENTE_NOME,
					       VD.NOME AS VENDEDOR_NOME,
					      P.DIRECAO,
					      P.ENTREGA,
					      PZ.CONDICAO AS PRAZO_NOME,
					      P.DESCONTO,
					      P.STATUS,
					      '' AS ORIGEM,
					      (SELECT SUM(PP.QUANTIDADE) FROM VENDAS_PRODUTOS PP WHERE PP.VENDA_ID = P.ID) AS QTD,
					      (SELECT COALESCE(SUM(LCP.QUANTIDADE),0) FROM LISTA_CARGA_PRODUTOS LCP WHERE LCP.VENDA_ID = P.ID) AS QTD_ENVIADO
					FROM VENDAS P
					INNER JOIN PERSONAS CL
					ON CL.ID = P.PERSONA_ID
					INNER JOIN PERSONAS VD
					ON VD.ID = P.VENDEDOR_ID
					LEFT JOIN PLANOS PZ
					ON PZ.ID = P.PLANO_ID
					WHERE P.UNIDADE_ID = #{params[:unidade_id]} AND P.ENTREGA = TRUE
					#{data} #{cond}
					ORDER BY  1 DESC"
		Presupuesto.find_by_sql(sql)
	end

	def self.pedido_produtos(params)
		sql = "SELECT PP.ID,
						      PP.VENDA_ID,
						      PD.NOME AS PRODUTO_NOME,
						      PD.ID AS PRODUTO_ID,
						      PD.PESO,
						      PP.QUANTIDADE,
						      (SELECT COALESCE(SUM(LCP.QUANTIDADE),0) FROM LISTA_CARGA_PRODUTOS LCP WHERE LCP.VENDAS_PRODUTO_ID = PP.ID) AS QTD_ENVIADO,
						      COALESCE((SELECT SUM(COALESCE(S.ENTRADA,0) - COALESCE(S.SAIDA,0)) FROM STOCKS S WHERE S.PRODUTO_ID = PD.ID AND S.DATA <= '#{params[:data]}'),0) AS STOCK,
						      (PP.QUANTIDADE - (SELECT COALESCE(SUM(LCP.QUANTIDADE),0) FROM LISTA_CARGA_PRODUTOS LCP WHERE LCP.VENDAS_PRODUTO_ID = PP.ID)) SALDO

					FROM VENDAS_PRODUTOS  PP
					INNER JOIN PRODUTOS PD
					ON PD.ID = PP.PRODUTO_ID
					WHERE PP.VENDA_ID = #{params[:presupuesto_id]}
					ORDER BY (PP.QUANTIDADE - (SELECT COALESCE(SUM(LCP.QUANTIDADE),0) FROM LISTA_CARGA_PRODUTOS LCP WHERE LCP.VENDAS_PRODUTO_ID = PP.ID)) DESC,
										COALESCE((SELECT SUM(COALESCE(S.ENTRADA,0) - COALESCE(S.SAIDA,0)) FROM STOCKS S WHERE S.PRODUTO_ID = PD.ID AND S.DATA <= '#{params[:data]}'),0) DESC"
		Presupuesto.find_by_sql(sql)
	end

	def self.rota(params) #agrupa itens
		sql = "SELECT LCP.LISTA_CARGA_ID,
									PD.PERSONA_ID AS PERSONA_ID,
									PP.NOME AS PERSONA_NOME,
		              LCP.PRODUTO_ID,
		              P.NOME AS PRODUTO_NOME,
		              LCP.QUANTIDADE

						FROM LISTA_CARGA_PRODUTOS LCP

						INNER JOIN PRODUTOS P
						ON P.ID = LCP.PRODUTO_ID

						INNER JOIN VENDAS PD
						ON PD.ID = LCP.VENDA_ID

						INNER JOIN PERSONAS PP
						ON PP.ID = PD.PERSONA_ID

						WHERE LCP.LISTA_CARGA_ID = #{params[:lista_carga_id]}"

		ListaCargaProduto.find_by_sql(sql)
	end

	def self.lista_carga_add(params) #lista pedidos adicionados na lista de Carga
		sql = "SELECT LCP.VENDA_ID AS PEDIDO_ID,
						      MAX(PE.NOME) AS PERSONA_NOME,
						      MAX(PS.PERSONA_ID) AS PERSONA_ID,
						      MAX(PS.VENDEDOR_ID) AS VENDEDOR_ID,
						      MAX(VD.NOME) AS VENDEDOR_NOME,
						      SUM(P.PESO * LCP.QUANTIDADE) AS PESO,
						      SUM(LCP.QUANTIDADE) AS QUANTIDADE,
						      (SELECT COUNT(V.ID) FROM VENDAS V WHERE V.LISTA_CARGA_ID = #{params[:id]} AND V.ID = LCP.VENDA_ID) AS FATURADO,
						      (SELECT V.ID FROM VENDAS V WHERE V.LISTA_CARGA_ID = #{params[:id]} AND V.ID = LCP.VENDA_ID LIMIT 1) AS NR_VENDA
						FROM LISTA_CARGA_PRODUTOS  LCP

					INNER JOIN PRODUTOS P
					ON P.ID = LCP.PRODUTO_ID

					INNER JOIN VENDAS PS
					ON PS.ID = LCP.VENDA_ID

					INNER JOIN PERSONAS PE
					ON PE.ID = PS.PERSONA_ID

					INNER JOIN PERSONAS VD
					ON VD.ID = PS.VENDEDOR_ID

					WHERE LCP.LISTA_CARGA_ID = #{params[:id]}
					GROUP BY 1"
		ListaCargaProduto.find_by_sql(sql)
	end

	def self.lista_carga_venda_add(params) #lista pedidos adicionados na lista de Carga
		sql = "SELECT LCP.VENDA_ID AS PEDIDO_ID,
						      MAX(PE.NOME) AS PERSONA_NOME,
						      MAX(PS.PERSONA_ID) AS PERSONA_ID,
						      MAX(PS.VENDEDOR_ID) AS VENDEDOR_ID,
						      MAX(VD.NOME) AS VENDEDOR_NOME,
						      SUM(P.PESO * LCP.QUANTIDADE) AS PESO,
						      SUM(LCP.QUANTIDADE) AS QUANTIDADE
						FROM LISTA_CARGA_PRODUTOS  LCP

					INNER JOIN PRODUTOS P
					ON P.ID = LCP.PRODUTO_ID

					INNER JOIN VENDAS PS
					ON PS.ID = LCP.VENDA_ID

					INNER JOIN PERSONAS PE
					ON PE.ID = PS.PERSONA_ID

					INNER JOIN PERSONAS VD
					ON VD.ID = PS.VENDEDOR_ID

					WHERE LCP.VENDA_ID = #{params[:id]}
					GROUP BY 1"

		ListaCargaProduto.find_by_sql(sql)
	end
end


