class Stock < ActiveRecord::Base
  belongs_to :persona

  def self.resultado_registro_consumo(params)
    deposito = " AND S.deposito_id = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?
    produto  = " AND S.PRODUTO_ID = #{params[:produto_id]}"  unless params[:produto_id].blank?
    persona  = " AND S.PERSONA_ID = #{params[:persona_id]}"  unless params[:persona_id].blank?
    sql = "SELECT S.DATA,
                  S.ID,
                 S.PRODUTO_ID,
                 S.SAIDA,
                 P.NOME AS PRODUTO_NOME,
                 PS.NOME AS PERSONA_NOME,
                 (SELECT PTB.PRECO_1_GS FROM PRODUTOS_TABELA_PRECOS PTB WHERE PTB.PRODUTO_ID = S.PRODUTO_ID AND PTB.TABELA_PRECO_ID = PS.TABELA_PRECO_ID LIMIT 1) AS PRECO_PERSONA

                FROM STOCKS S

                LEFT JOIN PRODUTOS P
                ON P.ID = S.PRODUTO_ID

                LEFT JOIN PERSONAS PS
                ON PS.ID = S.PERSONA_ID

                WHERE P.status = TRUE AND S.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' AND TABELA = 'CHECK_POINTS' #{deposito} #{produto} #{persona}
                "
      Stock.find_by_sql(sql)
  end


  def self.resultado_registro_consumo_agrupado(params)

    deposito = " AND S.deposito_id = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?
    produto  = " AND S.PRODUTO_ID = #{params[:produto_id]}"  unless params[:produto_id].blank?
    persona  = " AND S.PERSONA_ID = #{params[:persona_id]}"  unless params[:persona_id].blank?

    sql = "SELECT P.NOME AS PRODUTO_NOME,
                  SUM(S.SAIDA) AS TOT

                FROM STOCKS S

                LEFT JOIN PRODUTOS P
                ON P.ID = S.PRODUTO_ID

                LEFT JOIN PERSONAS PS
                ON PS.ID = S.PERSONA_ID

                WHERE S.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' AND TABELA = 'CHECK_POINTS' #{deposito} #{produto} #{persona}
                GROUP BY 1
                "
      Stock.find_by_sql(sql)
  end

  def self.resultado_registro_consumo_agrupado_preco(params)

    deposito = " AND S.deposito_id = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?
    produto  = " AND S.PRODUTO_ID = #{params[:produto_id]}"  unless params[:produto_id].blank?
    persona  = " AND S.PERSONA_ID = #{params[:persona_id]}"  unless params[:persona_id].blank?

    sql = "SELECT P.NOME AS PRODUTO_NOME,
                  (SELECT PTB.PRECO_1_GS FROM PRODUTOS_TABELA_PRECOS PTB WHERE PTB.PRODUTO_ID = S.PRODUTO_ID AND PTB.TABELA_PRECO_ID = PS.TABELA_PRECO_ID LIMIT 1) AS PRECO_PERSONA,
                  SUM(S.SAIDA) AS TOT

                FROM STOCKS S

                LEFT JOIN PRODUTOS P
                ON P.ID = S.PRODUTO_ID

                LEFT JOIN PERSONAS PS
                ON PS.ID = S.PERSONA_ID

                WHERE S.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' AND TABELA = 'CHECK_POINTS' #{deposito} #{produto} #{persona}
                GROUP BY 1,2
                "
      Stock.find_by_sql(sql)
  end
  def self.resultado_curva_abc(params)
    unidade     = "AND V.UNIDADE_ID = #{params[:busca]["unidade"]}" unless params[:busca]["unidade"].blank?
    persona     = "AND V.PERSONA_ID = #{params[:busca]["cliente"]}" unless params[:busca]["cliente"].blank?
    sub_grupo   = "AND P.SUB_GRUPO_ID in (#{params[:grupos].join(',')})"  unless params[:grupos].blank?
    grupo       = "AND P.GRUPO_ID = (#{params[:busca]["grupo"]})" unless params[:busca]["grupo"].blank?

    p_unidade   = "AND PV.UNIDADE_ID = #{params[:busca]["unidade"]}" unless params[:busca]["unidade"].blank?
    p_sub_grupo = "AND PD.SUB_GRUPO_ID in (#{params[:grupos].join(',')})"  unless params[:grupos].blank?
    p_grupo     = "AND PD.GRUPO_ID = (#{params[:busca]["grupo"]})" unless params[:busca]["grupo"].blank?
    p_persona   = "AND PV.PERSONA_ID = #{params[:busca]["cliente"]}" unless params[:busca]["cliente"].blank?


      #curva ABC
      if params[:moeda].to_s == "0"
        ordem = "10 DESC"
      elsif params[:moeda].to_s == "1"
        ordem = "9 DESC"
      end

      sql = " SELECT
					        VP.PRODUTO_ID,
					        MAX(CL.DESCRICAO) AS CLASE_NOME,
					        MAX(G.DESCRICAO) AS GRUPO_NOME,
					        MAX(SG.DESCRICAO) AS SUB_GRUPO_NOME,
					        MAX(P.NOME) AS PRODUTO_NOME,
									SUM(VP.QUANTIDADE) AS QTD,
									SUM( VP.QUANTIDADE * (SELECT SS.PROMEDIO_GUARANI FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.ENTRADA > 0 AND SS.PRODUTO_ID = VP.PRODUTO_ID AND SS.DATA <= VP.DATA ORDER BY SS.DATA DESC, SS.TABELA_ID DESC LIMIT 1)) CUSTO_MEDIO_GS,
									SUM( VP.QUANTIDADE * (SELECT SS.PROMEDIO_DOLAR FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.ENTRADA > 0 AND SS.PRODUTO_ID = VP.PRODUTO_ID AND SS.DATA <= VP.DATA ORDER BY SS.DATA DESC, SS.TABELA_ID DESC LIMIT 1)) CUSTO_MEDIO_US,
									SUM(VP.TOTAL_GUARANI) AS TOT_GS,
									SUM(VP.TOTAL_DOLAR) AS TOT_US,
									COALESCE(( SELECT SUM(PVP.QUANTIDADE  * PVP.UNITARIO_GUARANI)
                     FROM VENDAS_PRODUTOS PVP

                     INNER JOIN VENDAS PV
                     ON PVP.VENDA_ID = PV.ID

                     LEFT JOIN PERSONAS PE
                     ON PE.ID = PV.PERSONA_ID

                     LEFT JOIN PRODUTOS PD
                     ON PD.ID = PVP.PRODUTO_ID

                     WHERE PVP.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
                     #{p_unidade} #{p_sub_grupo} #{p_grupo} ),0) AS SUM_TOT_GS,

									COALESCE(( SELECT SUM(PVP.QUANTIDADE  * PVP.UNITARIO_DOLAR)
                     FROM VENDAS_PRODUTOS PVP

                     INNER JOIN VENDAS PV
                     ON PVP.VENDA_ID = PV.ID

                     LEFT JOIN PERSONAS PE
                     ON PE.ID = PV.PERSONA_ID

                     LEFT JOIN PRODUTOS PD
                     ON PD.ID = PVP.PRODUTO_ID

                     WHERE PVP.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
                     #{p_unidade} #{p_sub_grupo} #{p_grupo} ),0) AS SUM_TOT_US

							FROM VENDAS_PRODUTOS VP

							INNER JOIN VENDAS V
							ON V.ID = VP.VENDA_ID

							INNER JOIN PRODUTOS P
							ON P.ID = VP.PRODUTO_ID

							LEFT JOIN GRUPOS G
							ON P.GRUPO_ID = G.ID

							LEFT JOIN SUB_GRUPOS SG
							ON P.SUB_GRUPO_ID = SG.ID

							LEFT JOIN CLASES CL
							ON P.CLASE_ID = CL.ID

							WHERE P.TIPO_PRODUTO <> 2
							AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
							GROUP BY 1

        UNION ALL

				SELECT
				        VP.PRODUTO_ID,
				        MAX(CL.DESCRICAO) AS CLASE_NOME,
				        MAX(G.DESCRICAO) AS GRUPO_NOME,
				        MAX(SG.DESCRICAO) AS SUB_GRUPO_NOME,
				        MAX(P.NOME) AS PRODUTO_NOME,
								SUM(VP.QUANTIDADE) AS QTD,
		 						SUM( VP.QUANTIDADE * (SELECT sum(PC.QUANTIDADE * (SELECT SS.PROMEDIO_GUARANI FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.ENTRADA > 0 AND SS.PRODUTO_ID = PC.COMPONENTE_ID AND SS.DATA <= VP.DATA ORDER BY SS.DATA DESC, SS.TABELA_ID DESC LIMIT 1))
		 									FROM PRODUTO_COMPOSICAOS PC
		 									WHERE PC.PRODUTO_ID = VP.PRODUTO_ID)) AS CUSTO_MEDIO_GS,

		 						SUM( VP.QUANTIDADE * (SELECT sum(PC.QUANTIDADE * (SELECT SS.PROMEDIO_DOLAR FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.ENTRADA > 0 AND SS.PRODUTO_ID = PC.COMPONENTE_ID AND SS.DATA <= VP.DATA ORDER BY SS.DATA DESC, SS.TABELA_ID DESC LIMIT 1))
		 									FROM PRODUTO_COMPOSICAOS PC
		 									WHERE PC.PRODUTO_ID = VP.PRODUTO_ID)) AS CUSTO_MEDIO_US,
								SUM(VP.TOTAL_GUARANI) AS TOT_GS,
								SUM(VP.TOTAL_DOLAR) AS TOT_US,
								COALESCE(( SELECT SUM(PVP.QUANTIDADE  * PVP.UNITARIO_GUARANI)
                     FROM VENDAS_PRODUTOS PVP

                     INNER JOIN VENDAS PV
                     ON PVP.VENDA_ID = PV.ID

                     LEFT JOIN PERSONAS PE
                     ON PE.ID = PV.PERSONA_ID

                     LEFT JOIN PRODUTOS PD
                     ON PD.ID = PVP.PRODUTO_ID

                     WHERE PVP.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
                     #{p_unidade} #{p_sub_grupo} #{p_grupo} ),0) AS SUM_TOT_GS,

									COALESCE(( SELECT SUM(PVP.QUANTIDADE  * PVP.UNITARIO_DOLAR)
                     FROM VENDAS_PRODUTOS PVP

                     INNER JOIN VENDAS PV
                     ON PVP.VENDA_ID = PV.ID

                     LEFT JOIN PERSONAS PE
                     ON PE.ID = PV.PERSONA_ID

                     LEFT JOIN PRODUTOS PD
                     ON PD.ID = PVP.PRODUTO_ID

                     WHERE PVP.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
                     #{p_unidade} #{p_sub_grupo} #{p_grupo} ),0) AS SUM_TOT_US

				FROM VENDAS_PRODUTOS VP

				INNER JOIN VENDAS V
		 		ON V.ID = VP.VENDA_ID

				INNER JOIN PRODUTOS P
				ON P.ID = VP.PRODUTO_ID

				LEFT JOIN GRUPOS G
				ON P.GRUPO_ID = G.ID

				LEFT JOIN SUB_GRUPOS SG
				ON P.SUB_GRUPO_ID = SG.ID

				LEFT JOIN CLASES CL
				ON P.CLASE_ID = CL.ID

				WHERE P.TIPO_PRODUTO = 2
				AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
				GROUP BY 1
				ORDER BY #{ordem}"

    VendasProduto.find_by_sql(sql)

  end

  def self.resultado_abastecidas(params)
    pl = "AND P.ID = #{params[:busca]["responsavel"]}" unless params[:busca]["responsavel"].blank?
    if params[:agrupar_plajero].to_i == 0
      ord = "9,10,2"
    else
      ord = "2,9,10"
    end

    sql = "SELECT
                A.ID AS ID,
                P.NOME AS FRENTISTA,
                B.NOME AS BICO,
                DP.PRODUTO_ID AS PRODUTO_ID,
                B.DEPOSITO_ID AS DEPOSITO_ID,
                (A.LITROS * 10) AS LITROS,
                (A.PRECO * 100) AS PRECO,
                B.ID AS BICO_ID,
                A.DATA,
                A.HORA,
                A.CHAVE,
                PD.NOME AS PRODUTO_NOME,
                (A.PRECO * A.LITROS) AS TOTAL
                 FROM ABASTECIDAS A
                 INNER JOIN BICOS B
                 ON A.BICO = BICO_AUTO
                 LEFT JOIN DEPOSITO_PRODUTOS DP
                 ON B.DEPOSITO_ID = DP.DEPOSITO_ID
                 LEFT JOIN CHAVES C
                 ON C.NOME = A.CHAVE
                 LEFT JOIN PRODUTOS PD
                 ON PD.ID = DP.PRODUTO_ID
                 LEFT JOIN PERSONAS P
                 ON P.ID = C.PERSONA_ID
                 WHERE A.STATUS = 1
                 AND A.LITROS > 0
                 AND B.UNIDADE_ID = #{params[:busca][:unidade]}
                 #{pl}
                 AND A.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'

                 ORDER BY #{ord}"
      Abastecida.find_by_sql(sql)
  end

  def self.resultado_afericao(params)
    sql = "SELECT  A.ID,
                   A.DATA,
                   A.ABASTECIDA_ID,
                   P.NOME AS RESPOSAVEL_NOME,
                   B.NOME AS BICO_NOME,
                   PD.NOME AS PRODUTO_NOME,
                   DOI.NOME AS DEPOSITO_ORIGEM_NOME,
                   DD.NOME AS DEPOSITO_DESTINO_NOME,
                   A.QUANTIDADE

            FROM AFERICAOS A

            INNER JOIN PERSONAS P
            ON P.ID = A.PERSONA_ID

            INNER JOIN BICOS B
            ON B.ID = A.BICO_ID

            INNER JOIN DEPOSITOS DOI
            ON DOI.ID = A.DEPOSITO_ORIGEM_ID

            INNER JOIN DEPOSITOS DD
            ON DD.ID = A.DEPOSITO_ID

            INNER JOIN PRODUTOS PD
            ON PD.ID = A.PRODUTO_ID
            WHERE A.UNIDADE_ID = #{params[:busca][:unidade]}
            AND A.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
            ORDER BY 2, 1"
      Afericao.find_by_sql(sql)
  end
  def self.resumo_cmv(params)
    grupo     = " AND p.grupo_id  = #{params[:busca]["grupo"]}"    unless params[:busca]["grupo"].blank?
    sub_grupo = " AND p.sub_grupo_id  = #{params[:busca]["sub-grupo"]}"  unless params[:busca]["sub-grupo"].blank?
    produto   = " AND VP.PRODUTO_ID = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?

    sql = "SELECT V.ID,
                  V.DATA,
                  V.PERSONA_NOME,
                  VP.PRODUTO_NOME,
                  VP.QUANTIDADE,
                  VP.PRODUTO_ID,
                  (SELECT SS.PROMEDIO_GUARANI FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.PRODUTO_ID = VP.PRODUTO_ID AND SS.DATA <= V.DATA  ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) CUSTO_MEDIO_GS,
                  (SELECT SS.PROMEDIO_DOLAR FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.PRODUTO_ID = VP.PRODUTO_ID AND SS.DATA <= V.DATA  ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) CUSTO_MEDIO_US,
                  VP.UNITARIO_GUARANI,
                  VP.UNITARIO_DOLAR,
                  VP.TOTAL_GUARANI,
                  VP.TOTAL_DOLAR,
                  P.TIPO_PRODUTO
            FROM VENDAS_PRODUTOS VP
            INNER JOIN VENDAS  V
            ON V.ID = VP.VENDA_ID
            INNER JOIN PRODUTOS  P
            ON P.ID = VP.PRODUTO_ID

            WHERE  (SELECT COUNT(VF) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID ) > 0 AND P.TIPO_PRODUTO = 0 AND V.UNIDADE_ID = #{params[:busca]["unidade"]}
            AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
            #{grupo} #{sub_grupo} #{produto}

          UNION ALL

          SELECT V.ID,
                  V.DATA,
                  V.PERSONA_NOME,
                  VP.PRODUTO_NOME,
                  VP.QUANTIDADE,
                  VP.PRODUTO_ID,
                  (COALESCE((SELECT sum(PC.QUANTIDADE * ((SELECT (SS.UNITARIO_GUARANI / PV.PESO) FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.ENTRADA > 0 AND SS.PRODUTO_ID = PC.COMPONENTE_ID AND SS.DATA <= VP.DATA ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) ) )
                    FROM PRODUTO_COMPOSICAOS PC
                    INNER JOIN PRODUTOS PV
                    ON PV.ID = PC.COMPONENTE_ID
                    WHERE PC.PRODUTO_ID = VP.PRODUTO_ID),0) + P.custo_base_gs) AS CUSTO_MEDIO_GS,
                    (COALESCE((SELECT sum(PC.QUANTIDADE * ((SELECT (SS.UNITARIO_DOLAR / PV.PESO) FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.ENTRADA > 0 AND SS.PRODUTO_ID = PC.COMPONENTE_ID AND SS.DATA <= VP.DATA ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) ) )
                    FROM PRODUTO_COMPOSICAOS PC
                    INNER JOIN PRODUTOS PV
                    ON PV.ID = PC.COMPONENTE_ID
                    WHERE PC.PRODUTO_ID = VP.PRODUTO_ID),0) + P.custo_base_Us) AS CUSTO_MEDIO_US,
                  VP.UNITARIO_GUARANI,
                  VP.UNITARIO_DOLAR,
                  VP.TOTAL_GUARANI,
                  VP.TOTAL_DOLAR,
                  P.TIPO_PRODUTO
            FROM VENDAS_PRODUTOS VP
            INNER JOIN VENDAS  V
            ON V.ID = VP.VENDA_ID
            INNER JOIN PRODUTOS  P
            ON P.ID = VP.PRODUTO_ID

            WHERE  (SELECT COUNT(VF) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID ) > 0 AND P.TIPO_PRODUTO = 2 AND V.UNIDADE_ID = #{params[:busca]["unidade"]}
            AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
            #{grupo} #{sub_grupo} #{produto}


          UNION ALL

          SELECT V.ID,
                  V.DATA,
                  V.PERSONA_NOME,
                  VP.PRODUTO_NOME,
                  VP.QUANTIDADE,
                  VP.PRODUTO_ID,
                  P.custo_base_gs CUSTO_MEDIO_GS,
                  P.custo_base_US CUSTO_MEDIO_US,
                  VP.UNITARIO_GUARANI,
                  VP.UNITARIO_DOLAR,
                  VP.TOTAL_GUARANI,
                  VP.TOTAL_DOLAR,
                  P.TIPO_PRODUTO
            FROM VENDAS_PRODUTOS VP
            INNER JOIN VENDAS  V
            ON V.ID = VP.VENDA_ID
            INNER JOIN PRODUTOS  P
            ON P.ID = VP.PRODUTO_ID

            WHERE V.OP = TRUE AND P.TIPO_PRODUTO = 1 AND V.UNIDADE_ID = #{params[:busca]["unidade"]}
            AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
            #{grupo} #{sub_grupo} #{produto}
            ORDER BY 2,3"
    Venda.find_by_sql(sql)
  end
  def self.resumo_deposito( params )
    dp    = " AND D.ID    = #{params[:busca]["deposito"]}"    unless params[:busca]["deposito"].blank?
    data  = " AND S.DATA    <= '#{params[:final].split("/").reverse.join("-")}'"    unless params[:final].blank?
    uni   = " AND U.ID    = #{params[:busca]["unidade"]}"    unless params[:busca]["unidade"].blank?
    sql = "SELECT
                 S.DEPOSITO_ID,
                 MAX(D.UNIDADE_ID) AS UNIDADE_ID,
                 MAX(U.UNIDADE_NOME) AS UNIDADE_NOME,
                 MAX(D.NOME) AS DP,
                 MAX(P.NOME) AS PRODUTO_NOME,
                 MAX(U.UNIDADE_NOME) AS UNIDADE_NOME,
                 SUM(S.ENTRADA - S.SAIDA) AS SALDO
          FROM STOCKS S
          LEFT JOIN DEPOSITOS D
          ON S.DEPOSITO_ID = D.ID

          LEFT JOIN PRODUTOS P
          ON S.PRODUTO_ID = P.ID

          LEFT JOIN UNIDADES U
          ON U.ID = D.UNIDADE_ID

          WHERE D.SETA_PRODUTO = 1
          #{dp} #{data} #{uni}
          GROUP BY 1
          ORDER BY 2, 4, 5"
          Deposito.find_by_sql(sql)
  end
    def self.ficha_stock_resumido( params )
        #FILTRO
        if params[:filtro].to_s == '0'
         filtro  = "AND ENTRADA > 0"
        elsif params[:filtro].to_s == '1'
          filtro = "AND SAIDA > 0"
        else
         filtro  = ""
        end

        #CLASE
        clase    = " AND p.clase_id    = #{params[:busca]["clase"]}"    unless params[:busca]["clase"].blank?
        #GRUPO
        grupo    = " AND p.grupo_id    = #{params[:busca]["grupo"]}"    unless params[:busca]["grupo"].blank?

        sub_grupo = " AND p.sub_grupo_id  = #{params[:busca]["sub_grupo"]}"  unless params[:busca]["sub_grupo"].blank?
        colecao   = " AND p.colecao_id    = #{params[:busca]["colecao"]}"    unless params[:busca]["colecao"].blank?

        #PRODUTO
        produto  = " AND p.id  = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
        #DEPOSITO
        deposito = " AND S.deposito_id = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?

        persona = " AND s.persona_id = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?

        cond = " s.data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{filtro} #{clase}
          #{grupo} #{produto} #{deposito} #{persona} #{sub_grupo} #{colecao} #{produto}"

        if params[:orden] == '0'
          order = 'S.PRODUTO_ID, S.DATA,S.ID,S.STATUS'
        elsif params[:orden] == '1'
          order = '6,1'
        elsif params[:orden] == '2'
          order = '7,8,9,2,1'
        end
        sql ="SELECT
                s.id,
                s.data,
                s.status,
                s.venda_id,
                p.id as produto_id,
                p.nome as produto_nome,
                p.fabricante_cod,
                s.persona_nome,
                s.deposito_id,
                s.entrada,
                s.cod_processo,
                s.persona_nome,
                s.unitario_dolar,
                s.unitario_guarani,
                s.promedio_guarani,
                s.saida,
                s.tabela_id,
                s.tabela as tab
            FROM STOCKS s
            LEFT JOIN PRODUTOS P
            ON S.PRODUTO_ID = P.ID

            WHERE #{cond}
            ORDER BY #{order}"

      Produto.find_by_sql(sql)
    end

  #FICHA STOCK
  def self.relatorio_ficha_stock( params )
    #FILTRO
    filtro   = " AND S.STATUS = #{params[:filtro]} "  unless params[:filtro].blank?
    #CLASE
    clase    = " AND S.CLASE_ID  = #{params[:busca]["clase"]}"    unless params[:busca]["clase"].blank?
    #GRUPO
    grupo    = " AND S.GRUPO_ID = #{params[:busca]["grupo"]}"    unless params[:busca]["grupo"].blank?
    #SUB-GRUPO
    sub_grupo = " AND P.SUB_GRUPO_ID = #{params[:busca]["sub_grupo"]}"  unless params[:busca]["sub_grupo"].blank?
    #PRODUTO
    produto  = " AND S.PRODUTO_ID  = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
    #DEPOSITO
    deposito = " AND S.DEPOSITO_ID = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?

    persona = " AND S.PERSONA_ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?


    sql = " SELECT
                 S.PRODUTO_ID,
                 S.DATA,
                 S.STATUS,
                 S.ID,
                 S.COD_PROCESSO,
                 P.NOME,
                 P.FABRICANTE_COD,
                 S.PERSONA_NOME,
                 S.DEPOSITO_NOME,
                 S.ENTRADA,
                 S.SAIDA,
                 S.UNITARIO_DOLAR,
                 S.UNITARIO_GUARANI,
                 S.SALDO_DOLAR,
                 S.SALDO_GUARANI,
                 S.PROMEDIO_GUARANI,
                 S.PROMEDIO_DOLAR,
                 S.SALDO,
                 S.DEPOSITO_ID,
                 S.TABELA
              FROM STOCKS S
              LEFT JOIN PRODUTOS P ON S.PRODUTO_ID = P.ID
              WHERE P.TIPO_PRODUTO = 0
              AND S.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'  #{filtro} #{clase} #{grupo} #{produto} #{deposito} #{persona}  #{sub_grupo}
              ORDER BY S.PRODUTO_ID, S.DATA,S.ID,S.STATUS"

     Stock.find_by_sql(sql)
  end

  def self.ficha_stock_sintetico(params)
    #CLASE
    clase    = " AND P.CLASE_ID  = #{params[:busca]["clase"]}"    unless params[:busca]["clase"].blank?
    #GRUPO
    grupo    = " AND P.GRUPO_ID = #{params[:busca]["grupo"]}"    unless params[:busca]["grupo"].blank?
    #SUB-GRUPO
    sub_grupo = " AND P.SUB_GRUPO_ID = #{params[:busca]["sub_grupo"]}"  unless params[:busca]["sub_grupo"].blank?
    #PRODUTO
    produto  = " AND S.PRODUTO_ID  = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
    #DEPOSITO
    deposito = " AND S.DEPOSITO_ID = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?

    sql = "SELECT S.PRODUTO_ID,
                  MAX(P.NOME) AS PRODUTO_NOME,
                  (SELECT COALESCE(SUM(SS.ENTRADA - SS.SAIDA),0) FROM STOCKS SS WHERE SS.PRODUTO_ID = S.PRODUTO_ID AND SS.DATA < '#{params[:inicio].split("/").reverse.join("-")}' AND SS.DEPOSITO_ID = #{params[:busca]["deposito"]}) AS SALDO,
                  COALESCE(SUM(S.ENTRADA),0) AS ENTRADA,
                  COALESCE(SUM(S.SAIDA),0) AS SAIDA
            FROM STOCKS S
            INNER JOIN PRODUTOS P
            ON P.ID = S.PRODUTO_ID
            WHERE P.TIPO_PRODUTO = 0 AND S.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
             #{clase} #{grupo} #{produto} #{deposito} #{sub_grupo}
            GROUP BY 1"
    Stock.find_by_sql(sql)
  end

    def self.relatorio_ficha_stock_saldo_anterio( params )
        #FILTRO
        filtro   = " AND status      = #{params[:filtro]} "  unless params[:filtro].blank?
        #CLASE
        clase    = " AND clase_id    = #{params[:busca]["clase"]}"    unless params[:busca]["clase"].blank?
        #GRUPO
        grupo    = " AND grupo_id    = #{params[:busca]["grupo"]}"    unless params[:busca]["grupo"].blank?
        #PRODUTO
        produto  = " AND produto_id  = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
        #DEPOSITO
        deposito = " AND deposito_id = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?

        cond = " data < '#{params[:inicio].split("/").reverse.join("-")}' #{filtro} #{clase} #{grupo} #{produto} #{deposito} "

        Stock.sum( 'entrada - saida',:conditions => cond )

    end
    #IVENTARIO
    def self.resultado_iventario(params)
        #CONDICOES
        clase     = " AND P.CLASE_ID = #{params[:busca]["clase"]}"    unless params[:busca]["clase"].blank?
        grupo     = " AND P.GRUPO_ID = #{params[:busca]["grupo"]}"    unless params[:busca]["grupo"].blank?
        sub_grupo = " AND P.SUB_GRUPO_ID = #{params[:busca]["sub_grupo"]}"    unless params[:busca]["sub_grupo"].blank?
        produto   = " AND P.ID = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
        deposito  = " AND S.DEPOSITO_ID = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?

        if params[:agrupar] == 'clase'
        	order = '4,3,8,10'
      	elsif params[:agrupar] == 'grupo'
      		order = '5,3,8,10'
      	elsif params[:agrupar] == 'subgrupo'
      		order = '6,3,8,10'
        end
        sql = "SELECT S.PRODUTO_ID,
											S.DEPOSITO_ID,
											MAX(P.NOME) AS PRODUTO_NOME,
											MAX(C.DESCRICAO) AS CLASE_NOME,
											MAX(G.DESCRICAO) AS GRUPO_NOME,
											MAX(SG.DESCRICAO) AS SUBGRUPO_NOME,
											MAX(D.NOME) AS DEPOSITO_NOME,
                      MAX(P.FABRICANTE_COD) AS FABRICANTE_COD,
                      (SELECT PTB.PRECO_1_US FROM  PRODUTOS_TABELA_PRECOS PTB WHERE PTB.PRODUTO_ID = S.PRODUTO_ID LIMIT 1) AS PRECO_VENDA_US,
                      (SELECT PTB.PRECO_1_GS FROM  PRODUTOS_TABELA_PRECOS PTB WHERE PTB.PRODUTO_ID = S.PRODUTO_ID LIMIT 1) AS PRECO_VENDA_GS,
											(SELECT SS.PROMEDIO_GUARANI FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.PRODUTO_ID = S.PRODUTO_ID  ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) CUSTO_MEDIO_GS,
											(SELECT SS.PROMEDIO_DOLAR FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.PRODUTO_ID = S.PRODUTO_ID  ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) CUSTO_MEDIO_US,
											SUM(S.ENTRADA - S.SAIDA) STOCK
											FROM STOCKS S
											INNER JOIN PRODUTOS P
											ON P.ID = S.PRODUTO_ID
											LEFT JOIN CLASES C
											ON C.ID = P.CLASE_ID
											LEFT JOIN GRUPOS G
											ON G.ID = P.GRUPO_ID
											LEFT JOIN SUB_GRUPOS SG
											ON SG.ID = P.SUB_GRUPO_ID


											INNER JOIN DEPOSITOS D
											ON D.ID = S.DEPOSITO_ID

											WHERE P.TIPO_PRODUTO = 0 AND S.DATA <= '#{params[:final].split("/").reverse.join("-")}'
											#{deposito} #{clase} #{grupo} #{sub_grupo} #{produto}
                      and (SELECT SS.PROMEDIO_GUARANI FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.PRODUTO_ID = S.PRODUTO_ID  ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) = 0

											GROUP BY 1,2

											ORDER BY #{order}"

        Produto.find_by_sql(sql)
    end

    def self.resultaro_stock_inicial( params )
        params[:unidade]

        if params[:tipo] == "CODIGO"
            cond =  "AND S.PRODUTO_ID = #{params[:busca]}" unless params[:busca].blank?
        else
            tipo = "produto_nome"
            cond =  "AND P.NOME ILIKE '%#{params[:busca]}%'" unless params[:busca].blank?
        end

        sql = "SELECT S.ID,
                      S.DATA,
                      S.DEPOSITO_ID,
                      S.ENTRADA,
                      P.NOME AS PRODUTO_NOME,
                      S.UNITARIO_GUARANI
                FROM STOCKS S
                INNER JOIN PRODUTOS P
                ON P.ID = S.PRODUTO_ID
                WHERE S.UNIDADE_ID = #{params[:unidade]} AND S.TABELA = 'ENTRADA_DIRETA' #{cond}

                ORDER BY 1 DESC"

        Stock.paginate_by_sql(sql, :page => params[:page], :per_page => 20)

    end

    #RENTABILIDAD
    def self.rentabilidade( params )                                     #
        #CONDICOES
        vend = "AND V.VENDEDOR_ID = #{params[:busca]["vendedor"]}" unless params[:busca]["vendedor"].blank?
        cc = "AND C.CENTRO_CUSTO_ID = #{params[:busca]["cc"]}" unless params[:busca]["cc"].blank?
        persona       = "AND V.PERSONA_ID = #{params[:persona_id]}" unless params[:persona_id].blank?
        clase       = "AND P.CLASE_ID = (#{params[:busca]["clase"]})" unless params[:busca]["clase"].blank?
        #PRODUTO
        produto  = "AND P.id = #{params[:produto_id]}" unless params[:produto_id].blank?
        terminal = "AND V.TERMINAL_ID = #{params[:busca]['terminal']}" unless params[:busca]['terminal'].blank?
        colecao  = "AND P.COLECAO_ID = #{params[:busca]["colecao"]}" unless params[:busca]["colecao"].blank?
        grupo    = "AND P.grupo_id = #{params[:busca]["grupo"]}" unless params[:busca]["grupo"].blank?



        sql = " SELECT
                     P.ID AS PRODUTO_ID,
                     V.PERSONA_ID,
                     MAX(P.NOME) AS PRODUTO_NOME,
                     MAX(V.ID) AS COD_PROC,
                     MAX(G.DESCRICAO) AS GRUPO_NOME,
                     MAX(SG.DESCRICAO) AS SUB_GRUPO_NOME,
                     MAX(P.FABRICANTE_COD) AS REFERENCIA,
                     MAX(V.PERSONA_NOME) AS PERSONA_NOME,
                     SUM(VP.QUANTIDADE) AS QUANTIDADE,
                     MAX((SELECT SS.PROMEDIO_GUARANI FROM STOCKS SS WHERE SS.DATA <= VP.DATA AND SS.STATUS = 0 AND SS.DEPOSITO_ID = VP.DEPOSITO_ID AND SS.PRODUTO_ID = VP.PRODUTO_ID ORDER BY SS.DATA DESC, SS.TABELA_ID DESC LIMIT 1)) CUSTO_MEDIO_GS,
                     SUM( (VP.TOTAL_GUARANI - COALESCE(VP.DESCONTO_GUARANI,0))) / SUM(VP.QUANTIDADE) AS UNITARIO_GUARANI,
                     SUM(VP.TOTAL_GUARANI - COALESCE(VP.DESCONTO_GUARANI,0)) AS TOTAL_GUARANI,
                     MAX((SELECT SS.PROMEDIO_DOLAR FROM STOCKS SS WHERE SS.DATA <= VP.DATA AND SS.STATUS = 0 AND SS.DEPOSITO_ID = VP.DEPOSITO_ID AND SS.PRODUTO_ID = VP.PRODUTO_ID ORDER BY SS.DATA DESC, SS.TABELA_ID DESC LIMIT 1)) CUSTO_MEDIO_US,
                     SUM( (VP.TOTAL_DOLAR)) / SUM(VP.QUANTIDADE) AS UNITARIO_DOLAR,
                     SUM(VP.TOTAL_DOLAR) AS TOTAL_DOLAR

                     FROM VENDAS_PRODUTOS VP

                     INNER JOIN VENDAS V
                     ON V.ID = VP.VENDA_ID

                     INNER JOIN PRODUTOS P
                     ON P.ID = VP.PRODUTO_ID

                     LEFT JOIN GRUPOS G
                     ON P.GRUPO_ID = G.ID

                     LEFT JOIN SUB_GRUPOS SG
                     ON P.SUB_GRUPO_ID = SG.ID

                     WHERE V.UNIDADE_ID = #{params[:unidade]}
                     AND exists (SELECT 1 FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID )
                     AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
                     #{vend} #{cc} #{produto} #{terminal} #{persona} #{clase} #{colecao} #{grupo}
                     GROUP BY 1,2

                UNION ALL

                SELECT
                     P.ID AS PRODUTO_ID,
                     V.PERSONA_ID,
                     MAX(P.NOME) AS PRODUTO_NOME,
                     MAX(V.ID) AS COD_PROC,
                     MAX(G.DESCRICAO) AS GRUPO_NOME,
                     MAX(SG.DESCRICAO) AS SUB_GRUPO_NOME,
                     MAX(P.FABRICANTE_COD) AS REFERENCIA,
                     MAX(V.PERSONA_NOME) AS PERSONA_NOME,
                     SUM(VP.QUANTIDADE) * -1 AS QUANTIDADE,
                     (SUM((SELECT SS.PROMEDIO_GUARANI FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.DEPOSITO_ID =  VP.DEPOSITO_ID AND SS.PRODUTO_ID = VP.PRODUTO_ID ORDER BY SS.DATA DESC, SS.TABELA_ID DESC LIMIT 1)) / SUM(VP.QUANTIDADE)) * -1 CUSTO_MEDIO_GS,
                     (SUM(VP.TOTAL_GUARANI) / SUM(VP.QUANTIDADE)) * -1 AS UNITARIO_GUARANI,
                     SUM(VP.TOTAL_GUARANI) * -1 AS TOTAL_GUARANI,
                     (SUM((SELECT SS.PROMEDIO_DOLAR FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.DEPOSITO_ID =  VP.DEPOSITO_ID AND SS.PRODUTO_ID = VP.PRODUTO_ID ORDER BY SS.DATA DESC, SS.TABELA_ID DESC LIMIT 1)) / SUM(VP.QUANTIDADE)) * -1 CUSTO_MEDIO_US,
                     (SUM(VP.TOTAL_DOLAR) / SUM(VP.QUANTIDADE)) * -1 AS UNITARIO_DOLAR,
                     SUM(VP.TOTAL_DOLAR) * -1 AS TOTAL_DOLAR

                     FROM NOTA_CREDITOS_DETALHES VP
                     INNER JOIN NOTA_CREDITOS V
                     ON V.ID = VP.NOTA_CREDITO_ID
                     INNER JOIN PRODUTOS P
                     ON P.ID = VP.PRODUTO_ID
                     LEFT JOIN GRUPOS G
                     ON P.GRUPO_ID = G.ID

                     LEFT JOIN SUB_GRUPOS SG
                     ON P.SUB_GRUPO_ID = SG.ID

                     WHERE V.UNIDADE_ID = #{params[:unidade]} AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
                     #{vend} #{cc} #{produto} #{persona} #{clase} #{colecao} #{grupo}
                     GROUP BY 1,2


                     UNION ALL

                    SELECT
                     P.ID AS PRODUTO_ID,
                     V.PERSONA_ID,
                     MAX(P.NOME) AS PRODUTO_NOME,
                     MAX(V.ID) AS COD_PROC,
                     MAX(G.DESCRICAO) AS GRUPO_NOME,
                     MAX(SG.DESCRICAO) AS SUB_GRUPO_NOME,
                     MAX(P.FABRICANTE_COD) AS REFERENCIA,
                     MAX(V.PERSONA_NOME) AS PERSONA_NOME,
                     SUM(VP.QUANTIDADE) AS QUANTIDADE,
                     SUM((SELECT sum(PC.QUANTIDADE * ((SELECT (SS.UNITARIO_GUARANI / PV.PESO) FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.ENTRADA > 0 AND SS.PRODUTO_ID = PC.COMPONENTE_ID AND SS.DATA <= VP.DATA ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) ) )
                                        FROM PRODUTO_COMPOSICAOS PC
                                        INNER JOIN PRODUTOS PV
                                        ON PV.ID = PC.COMPONENTE_ID
                                        WHERE PC.PRODUTO_ID = VP.PRODUTO_ID)) / SUM(VP.QUANTIDADE) CUSTO_MEDIO_GS,

                     SUM(VP.TOTAL_GUARANI) / SUM(VP.QUANTIDADE) AS UNITARIO_GUARANI,
                     SUM(VP.TOTAL_GUARANI) AS TOTAL_GUARANI,

                     SUM((SELECT sum(PC.QUANTIDADE * ((SELECT (SS.UNITARIO_DOLAR / PV.PESO) FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.ENTRADA > 0 AND SS.PRODUTO_ID = PC.COMPONENTE_ID AND SS.DATA <= VP.DATA ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) ) )
                                        FROM PRODUTO_COMPOSICAOS PC
                                        INNER JOIN PRODUTOS PV
                                        ON PV.ID = PC.COMPONENTE_ID
                                        WHERE PC.PRODUTO_ID = VP.PRODUTO_ID)) / SUM(VP.QUANTIDADE) CUSTO_MEDIO_US,
                     SUM(VP.TOTAL_DOLAR) / SUM(VP.QUANTIDADE) AS UNITARIO_DOLAR,
                     SUM(VP.TOTAL_DOLAR) AS TOTAL_DOLAR

                     FROM VENDAS_PRODUTOS VP
                     INNER JOIN VENDAS V
                     ON V.ID = VP.VENDA_ID

                     INNER JOIN PRODUTOS P
                     ON P.ID = VP.PRODUTO_ID
                     LEFT JOIN GRUPOS G
                     ON P.GRUPO_ID = G.ID

                     LEFT JOIN SUB_GRUPOS SG
                     ON P.SUB_GRUPO_ID = SG.ID

                     WHERE  P.TIPO_PRODUTO = 2 AND  V.UNIDADE_ID = #{params[:unidade]}
                     AND exists (SELECT 1 FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID )
                     AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
                     #{vend} #{cc} #{produto} #{terminal} #{persona} #{clase} #{colecao} #{grupo}
                     GROUP BY 1,2
                     ORDER BY 9 DESC
        "

        Produto.find_by_sql( sql )

    end

    def self.rentabilidade_detalhado( params )
        #CONDICOES
        #CLASE
        #CLASE
        clase   = "AND P.CLASE_ID = #{params[:busca_clase]}" unless params[:busca_clase].blank?
        #GRUPO
        grupo   = "AND P.GRUPO_ID = #{params[:busca_grupo]}" unless params[:busca_grupo].blank?

        #PRODUTO
        sub_grupo = " AND P.SUB_GRUPO_ID    = #{params[:busca_sub_grupo]}" unless params[:busca_sub_grupo].blank?
        #PRODUTO
        produto  = " AND P.ID  = #{params[:busca_produto]}"  unless params[:busca_produto].blank?
        #DEPOSITO
        deposito = " AND S.DEPOSITO_ID = #{params[:busca_deposito]}" unless params[:busca_deposito].blank?

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND VP.MOEDA = 0"
           else
              moeda = "AND VP.MOEDA = 1"
           end
        end

        if params[:legal].to_s == "1"
              fatura = "AND V.FATURA = 1"
        end

        if params[:prod].to_s == "0"
             prod = "AND P.TIPO_PRODUTO = 0"
        elsif params[:prod].to_s == "1"
             prod = "AND P.TIPO_PRODUTO = 1"
		else
			 prod = ""
        end


        sql = "SELECT
                    V.DATA,
								    VP.PRODUTO_ID,
       							VP.CLASE_ID,
						        VP.GRUPO_ID,
						        VP.PRODUTO_NOME,
                    P.fabricante_cod,
                    V.ID AS VENDA_ID,
						        VP.QUANTIDADE,
						        VP.UNITARIO_DOLAR,
						        VP.UNITARIO_GUARANI,
                    (SELECT S.PROMEDIO_DOLAR FROM STOCKS S WHERE S.PRODUTO_ID = VP.PRODUTO_ID  AND S.DATA <= V.DATA #{deposito} AND S.ENTRADA > 0 ORDER BY DATA DESC LIMIT 1)  AS CUSTO_PROMED_US,
                    (SELECT S.PROMEDIO_GUARANI FROM STOCKS S WHERE S.PRODUTO_ID = VP.PRODUTO_ID  AND S.DATA <= V.DATA #{deposito} AND S.ENTRADA > 0 ORDER BY DATA DESC LIMIT 1)  AS CUSTO_PROMED_GS
				  FROM
						VENDAS_PRODUTOS VP
				  INNER JOIN
						PRODUTOS P
				  ON VP.PRODUTO_ID = P.ID
				  INNER JOIN
						VENDAS V
				  ON VP.VENDA_ID = V.ID
				  WHERE
          VP.DEPOSITO_ID = #{params[:busca]["deposito"]} AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
  				#{clase} #{grupo} #{produto} #{moeda}  #{sub_grupo}
					#{prod}
				  ORDER BY 1,7"

        Produto.find_by_sql( sql )

    end
    def self.rentabilidade_agrupado_setor(params)
      sql ="SELECT VP.CLASE_ID,
                   C.DESCRICAO,
                   SUM(VP.QUANTIDADE) AS  SUM_QTD,
                   SUM(VP.TOTAL_DOLAR) AS SUM_US,
                   SUM(VP.TOTAL_GUARANI) AS SUM_GS,
                   SUM(VP.TOTAL_REAL) AS SUM_RS
            FROM VENDAS_PRODUTOS VP
            INNER JOIN CLASES C
            ON VP.CLASE_ID = C.ID
            GROUP BY 1,2"
            Produto.find_by_sql( sql )
    end

  def self.projecao_compras(params)
   #CONDICOES
    #CLASE
    clase   = "AND P.clase_id = #{params[:busca]["clase"]}" unless params[:busca]["clase"].blank?
    #GRUPO
    grupo   = "AND P.grupo_id = #{params[:busca]["grupo"]}" unless params[:busca]["grupo"].blank?

    #GRUPO
    sub_grupo   = "AND P.sub_grupo_id = #{params[:busca]["sub_grupo"]}" unless params[:busca]["sub_grupo"].blank?

    #PRODUTO
    produto = "AND P.id = #{params[:busca]["produto"]}"    unless params[:busca]["produto"].blank?
    #VENDEDOR

    if params[:lancamento].to_s != "1"
       if params[:moeda] == "0"
          moeda = "AND VP.MOEDA = 0"
       else
          moeda = "AND VP.MOEDA = 1"
       end
    end

    sql = "SELECT
                P.CLASE_ID,
                P.GRUPO_ID,
                P.ID,
                P.NOME,
                P.EMBALAGEM,
                (SELECT coalesce(SUM(ENTRADA - SAIDA), 0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND DATA < '#{params[:inicio].split("/").reverse.join("-")}') AS ANTERIOR,
                (SELECT coalesce(SUM(ENTRADA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND TABELA <> 'NOTA_CREDITOS_DETALHES' AND DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}') AS ENTRADA,
                (SELECT coalesce(SUM(SAIDA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND TABELA = 'NOTA_CREDITOS_PROVEEDOR_PRODUTOS' AND DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}') AS ENTRADA_NC_PROV,
                (SELECT coalesce(SUM(SAIDA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND  TABELA <> 'NOTA_CREDITOS_PROVEEDOR_PRODUTOS' AND  DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}') AS SAIDA,
                (SELECT coalesce(SUM(ENTRADA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND TABELA = 'NOTA_CREDITOS_DETALHES' AND DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}') AS SAIDA_NC_CLI,
                ( (SELECT coalesce(SUM(ENTRADA - SAIDA), 0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND DATA < '#{params[:inicio].split("/").reverse.join("-")}') + (SELECT coalesce(SUM(ENTRADA - SAIDA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND  DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}') ) AS SALDO_PERIODO,
                (SELECT coalesce(SUM(ENTRADA - SAIDA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID) AS SALDO_STOCK

          FROM PRODUTOS P
          WHERE   (SELECT coalesce(COUNT(ID),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND DATA < '#{params[:final].split("/").reverse.join("-")}') > 0 #{clase} #{grupo} #{produto}
          ORDER BY 11 DESC, 3"

          Produto.find_by_sql( sql )
  end

def self.disponibilidade_stock(params)
    #GRUPO
    sub_grupo = "AND P.sub_grupo_id = #{params[:busca]["sub_grupo"]}" unless params[:busca]["sub_grupo"].blank?
    #COLECAO
    colecao = "AND P.colecao_id = #{params[:busca]["colecao"]}" unless params[:busca]["colecao"].blank?
    #DEPOSITO
    deposito = "AND S.deposito_id = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?
    st  = "COALESCE((SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.PRODUTO_ID = S.PRODUTO_ID AND S.PRODUTOS_GRADE_ID = PG.ID #{deposito}),0)"
    p_v = "COALESCE((SELECT SUM(PP.QUANTIDADE) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.PRODUTO_ID = PG.PRODUTO_ID AND PP.PRODUTOS_GRADE_ID = PG.ID),0)"
    p_c = "COALESCE((SELECT SUM(PC.QUANTIDADE) FROM PEDIDO_COMPRA_PRODUTOS PC WHERE PC.PRODUTO_ID = PG.PRODUTO_ID AND PC.PRODUTOS_GRADE_ID = PG.ID),0)"
    if params[:status] == '0'
      status = "AND (((#{st} + #{p_c}) - #{p_v}) < 0)"
    elsif params[:status] == '1'
      status = "AND ((#{st} + #{p_c}) - #{p_v}) > 0"
    elsif params[:status] == '2'
      status = "AND (((#{st} + #{p_c}) - #{p_v}) = 0)"
    elsif params[:status] == '3'
      status = ""
    end

    sql = "SELECT PG.ID AS PRODUTOS_GRADE_ID,
                   P.ID AS PRODUTO_ID,
                   P.FABRICANTE_COD,
                   P.NOME AS PRODUTO_NOME,
                   C.NOME AS COR,
                   T.NOME AS TAMANHO,
                   COALESCE((SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.PRODUTO_ID = S.PRODUTO_ID AND S.PRODUTOS_GRADE_ID = PG.ID #{deposito}),0) AS STOCK,
                   COALESCE((SELECT SUM(PP.QUANTIDADE) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.PRODUTO_ID = PG.PRODUTO_ID AND PP.PRODUTOS_GRADE_ID = PG.ID),0) AS P_VENDA,
                   COALESCE((SELECT SUM(PC.QUANTIDADE) FROM PEDIDO_COMPRA_PRODUTOS PC WHERE PC.PRODUTO_ID = PG.PRODUTO_ID AND PC.PRODUTOS_GRADE_ID = PG.ID),0) AS P_COMPRA
             FROM PRODUTOS_GRADES PG
             INNER JOIN PRODUTOS P
             ON PG.PRODUTO_ID = P.ID

             LEFT JOIN CORS C
             ON PG.COR_ID = C.ID

             LEFT JOIN TAMANHOS T
             ON PG.TAMANHO_ID = T.ID

             WHERE PG.ID > 0  #{sub_grupo} #{colecao} #{status}
             ORDER BY 3, 5, 6
             "

    Produto.find_by_sql( sql )
  end

end
