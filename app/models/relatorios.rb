class Relatorios < ActiveRecord::Base

	def self.consumicao_interna(params)
		rod = "AND CI.RODADO_ID = #{params[:busca]["rodado"]}" unless params[:busca]["rodado"].blank?
		per = "AND CI.PERSONA_ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?
		mot = "AND CI.MOTIVO_ID = #{params[:busca]["motivo"]}" unless params[:busca]["motivo"].blank?
		cc = "AND CI.CENTRO_CUSTO_ID = #{params[:busca]["cc"]}" unless params[:busca]["cc"].blank?

		if params[:lancamento].to_s != "1"
			if params[:moeda] == "0"
				moeda = "AND CI.MOEDA = 0"
			elsif params[:moeda] == "1"
				moeda = "AND CI.MOEDA = 1"
			else
				moeda = "AND CI.MOEDA = 2"
			end
		end

 					sql = "SELECT CI.ID,
 									CI.DATA,
                  M.NOME AS MOTIVO_NOME,
                  CC.NOME AS CENTRO_CUSTO_NOME,
                  R.PLACA AS RODADO_NOME,
                  P.NOME AS PRODUTO_NOME,
                  CIP.QUANTIDADE,
                  CIP.UNITARIO_GUARANI,
                  CIP.TOTAL_GUARANI,
                  CIP.UNITARIO_DOLAR,
                  CIP.TOTAL_DOLAR,
                  CI.MOEDA
              FROM CONSUMICAO_INTERNA_PRODUTOS CIP

              INNER JOIN CONSUMICAO_INTERNAS CI
              ON CI.ID = CIP.CONSUMICAO_INTERNA_ID

              LEFT JOIN MOTIVOS M
              ON M.ID = CI.MOTIVO_ID

              LEFT JOIN CENTRO_CUSTOS CC
              ON CC.ID = CI.CENTRO_CUSTO_ID

              LEFT JOIN RODADOS R
              ON R.ID = CI.RODADO_ID

              LEFT JOIN PRODUTOS P
              ON P.ID = CIP.PRODUTO_ID
              WHERE CI.UNIDADE_ID = #{params[:unidade]} and CI.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}'
              #{rod} #{per} #{mot} #{cc} #{moeda}
              ORDER BY 2,1
              "
      ConsumicaoInterna.find_by_sql(sql)
	end

	def self.controle_km(params)

		rod = "AND CK.RODADO_ID = #{params[:busca]["rodado"]}" unless params[:busca]["rodado"].blank?
		per = "AND CK.PERSONA_ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?

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

            WHERE CK.UNIDADE_ID = #{params[:unidade]} and CK.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}' #{rod} #{per}
            ORDER BY CK.DATA, CK.ID"

		ControleKm.find_by_sql(sql)

	end

def self.detalhe_sueldo(params)
  per  = "AND SS.PERSONA_ID = #{params[:busca]["empregado"]}" unless params[:busca]["empregado"].blank?
  if params[:tipo_detalhe]  == 'SUELDO Y COMISION'
    tipo = "AND SS.TIPO IN ('SUELDO','COMISION')" unless params[:tipo_detalhe].blank?
    tipo_adeanto = ""
  else
    tipo = "AND SS.TIPO = '#{params[:tipo_detalhe]}'" unless params[:tipo_detalhe].blank?
    tipo_adeanto = "AND SS.ID = 0" unless params[:tipo_detalhe].blank?
  end
  sql = "SELECT SS.DATA,
                SS.PERSONA_ID,
                SS.PERSONA_NOME,
                SS.DESCRICAO,
                SS.TIPO,
                SS.CREDITO_GS,
                SS.CREDITO_US,
                SS.CREDITO_RS,
                SS.DEBITO_GS,
                SS.DEBITO_US,
                SS.DEBITO_RS,
                SS.MOEDA,
                SS.SUELDO_ID
            FROM SUELDOS_DETALHES SS
            WHERE SS.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{per} #{tipo}
            UNION ALL

            SELECT SS.DATA,
            			 SS.PERSONA_ID,
            			 P.NOME AS PERSONA_NOME,
            			 SS.CONCEPTO AS DESCRICAO,
            			 'PAGO DE ANTECIPO' AS TIPO,
            			 SS.VALOR_GUARANI AS CREDITO_GS,
            			 SS.VALOR_DOLAR AS CREDITO_US,
            			 SS.VALOR_REAL AS CREDITO_RS,
            			 0 AS DEBITO_GS,
            			 0 AS DEBITO_US,
            			 0 AS DEBITO_RS,
            			 SS.MOEDA,
            			 SS.ID AS SUELDO_ID

            FROM ADELANTOS SS
            INNER JOIN PERSONAS P
            ON P.ID = SS.PERSONA_ID
            WHERE SS.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{per} #{tipo_adeanto}


            UNION ALL

            SELECT SS.DATA,
            			 SS.PERSONA_ID,
            			 P.NOME AS PERSONA_NOME,
            			 'IPS PAGO ANTECIPADO' AS DESCRICAO,
            			 'IPS' AS TIPO,
            			 0 AS CREDITO_GS,
            			 0 AS CREDITO_US,
            			 0 AS CREDITO_RS,
            			 SS.IPS_GS AS DEBITO_GS,
            			 0 AS DEBITO_US,
            			 0 AS DEBITO_RS,
            			 SS.MOEDA,
            			 SS.ID AS SUELDO_ID

            FROM ADELANTOS SS

            INNER JOIN PERSONAS P
            ON P.ID = SS.PERSONA_ID
            WHERE SS.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{per} #{tipo_adeanto}




            ORDER BY 3,1,5
            "
    Sueldo.find_by_sql(sql)
end

def self.resultado_contratos(params)
	if params[:tipo_data] == 'Assinatura'
		data = "AND C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}' " unless params[:inicio].blank?
	else
		data = "AND C.DATA_FINAL BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}' " unless params[:inicio].blank?
	end
	persona   = "AND C.PERSONA_ID  = #{params[:persona_id]}" unless params[:persona_id].blank?
	produto   = "AND CS.PRODUTO_ID  =  #{params[:busca]["produto"]}" unless  params[:busca]["produto"].blank?
	vendedor  = "AND C.VENDEDOR_ID = #{params[:busca]["vendedor"]}" unless params[:busca]["vendedor"].blank?
	doc       = "AND C.DOCUMENTO_NUMERO = '#{params[:doc]}' " unless params[:doc].blank?
	cota      = "AND C.COMPETENCIA = '#{params[:cota]}' " unless params[:cota].blank?
	cc        = "AND C.CENTRO_CUSTO_ID =  #{params[:busca]["centro_custo"]} " unless params[:busca]["centro_custo"].blank?
	pl        = "AND C.PLANO_ID =  #{params[:busca]["plano"]} " unless params[:busca]["plano"].blank?
	tipo_contrato = "AND C.TIPO = '#{params[:tipo_contrato]}' " unless params[:tipo_contrato].blank?

	if params[:moeda].to_s == "0"
		valor = "AND C.VALOR_US BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
	elsif params[:moeda] == "1"
		valor = "AND C.VALOR_GS BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
	else
		valor = "AND C.VALOR_RS BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
	end

	if params[:detalhe] == '0'
		sql = "SELECT C.ID,
					        C.PERSONA_ID,
						      P.NOME AS PERSONA_NOME,
						      VD.NOME AS VENDEDOR_NOME,
						      C.DIA_VENC,
						      C.COMPETENCIA,
						      (SELECT SUM(CS.TOTAL_US) FROM CONTRATO_SERVICOS CS WHERE CS.CONTRATO_ID = C.ID ) AS VALOR_US,
						      (SELECT SUM(CS.TOTAL_RS) FROM CONTRATO_SERVICOS CS WHERE CS.CONTRATO_ID = C.ID ) AS VALOR_RS,
						      (SELECT SUM(CS.TOTAL_GS) FROM CONTRATO_SERVICOS CS WHERE CS.CONTRATO_ID = C.ID ) AS VALOR_GS,
						      C.OBS,
						      C.DOCUMENTO_NUMERO,
						      C.DATA_FINAL,
						      C.DATA,
						      C.TIPO,
						      C.MOEDA,
						      C.STATUS,
						      CC.NOME AS CENTRO_CUSTO_NOME
					FROM CONTRATOS C
					INNER JOIN PERSONAS P
					ON P.ID = C.PERSONA_ID

					LEFT JOIN PERSONAS VD
					ON VD.ID = C.VENDEDOR_ID

					LEFT JOIN CENTRO_CUSTOS CC
					ON CC.ID = C.CENTRO_CUSTO_ID


					WHERE C.ID > 0 AND C.MOEDA = #{params[:moeda]} #{data} #{persona} #{vendedor} #{doc} #{tipo_contrato} #{cc} #{valor} #{cota} #{pl}
					ORDER BY C.DATA"
				elsif params[:detalhe] == '1'
					sql = "SELECT  C.ID,
												C.PERSONA_ID,
												P.NOME AS PERSONA_NOME,
												VD.NOME AS VENDEDOR_NOME,
												C.DOCUMENTO_NUMERO,
												C.DATA_FINAL,
												C.DATA,
												C.TIPO,
												C.MOEDA,
												C.STATUS,
												PD.NOME AS PRODUTO_NOME,
												CS.QUANTIDADE,
												CS.UNITARIO_GS,
												CS.UNITARIO_RS,
												CS.UNITARIO_US,
												CC.NOME AS CENTRO_CUSTO_NOME

										FROM CONTRATO_SERVICOS CS

										INNER JOIN CONTRATOS C
										ON C.ID = CS.CONTRATO_ID

										INNER JOIN PERSONAS P
										ON P.ID = C.PERSONA_ID

										INNER JOIN PRODUTOS PD
										ON PD.ID = CS.PRODUTO_ID

										LEFT JOIN CENTRO_CUSTOS CC
										ON CC.ID = C.CENTRO_CUSTO_ID

										LEFT JOIN PERSONAS VD
										ON VD.ID = C.VENDEDOR_ID
										WHERE C.ID > 0 AND C.MOEDA = #{params[:moeda]} #{data} #{persona} #{vendedor} #{doc} #{tipo_contrato} #{cc} #{produto} #{pl}
										ORDER BY C.DATA
										"
				end

			Contrato.find_by_sql(sql)
end

def self.resultado_control_obra(params)
    cod_serv = "AND S.ID = '#{params[:busca]["servico"]}'" unless params[:busca]["servico"].blank?
    if params[:status].to_s == '0'
      st = ""
    elsif params[:status].to_s == '1'
      st = ""
    else
      st = ""
    end

    persona = "AND S.PERSONA_ID = '#{params[:busca]["persona"]}'" unless params[:busca]["persona"].blank?
    sql = "SELECT CAST(1 AS INTEGER) OD,
                  S.ID,
                  CAST('201-01-01' AS DATE) AS DATA,
                  'Cliente : ' ||  ' -Serv.: ' || S.NOME  || ' -Descrip.: ' || S.OBS AS NOME,
                  CAST('' AS CHARACTER VARYING) AS RUBRO,
                  CAST('' AS CHARACTER VARYING) AS DOCUMENTO,
                  CAST( 0 AS NUMERIC) AS MOEDA,
                  S.VALOR AS VALOR_DOLAR,
                  CAST( 0 AS NUMERIC) AS VALOR_GUARANI
           FROM SERVICOS S
           WHERE S.NOME IS NOT NULL #{cod_serv} #{persona}

           UNION ALL

           SELECT CAST(2 AS INTEGER) OD,
                  V.OB_REF,
                  V.DATA,
                  V.PERSONA_NOME,
                  CAST('VENTA' AS CHARACTER VARYING) AS RUBRO,
                  V.DOCUMENTO_NUMERO,
                  V.MOEDA,
                  V.TOTAL_DOLAR,
                  V.TOTAL_GUARANI
           FROM VENDAS V


           LEFT JOIN
                 SETORS S
          ON     V.OB_REF = S.ID

          WHERE V.OB_REF IS NOT NULL AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}'

          UNION ALL

          SELECT
                 CAST(2 AS INTEGER) OD,
                 A.SERVICO_ID,
                 A.DATA,
                 A.PERSONA_NOME,
                 CAST('ADELANTO' AS CHARACTER VARYING) AS RUBRO,
                 A.DOCUMENTO_NUMERO,
                 A.MOEDA,
                 A.VALOR_DOLAR,
                 A.VALOR_GUARANI
           FROM ADELANTOS A


           LEFT JOIN
                 SETORS S
          ON     A.SERVICO_ID = S.ID

          WHERE A.SERVICO_ID IS NOT NULL AND A.TIPO = 1 AND A.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}'

          UNION ALL

           SELECT
                 CAST( 3 AS INTEGER) OD,
                 '1' as OB_REF,
                 G.DATA,
                 G.PERSONA_NOME,
                 G.RUBRO_DESCRICAO AS RUBRO,
                 G.DOCUMENTO_NUMERO AS DOCUMENTO,
                 G.MOEDA,
                 G.TOTAL_DOLAR,
                 G.TOTAL_GUARANI
           FROM COMPRAS G


          WHERE G.OB_REF IS NOT NULL
          AND TIPO_COMPRA = 1
          AND G.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}'

          UNION ALL

          SELECT
                 CAST(3 AS INTEGER) OD,
                 A.SERVICO_ID,
                 A.DATA,
                 A.PERSONA_NOME,
                 CAST('ADELANTO' AS CHARACTER VARYING) AS RUBRO,
                 A.DOCUMENTO_NUMERO,
                 A.MOEDA,
                 A.VALOR_DOLAR,
                 A.VALOR_GUARANI
           FROM ADELANTOS A
           LEFT JOIN
                 SETORS S
          ON     A.SERVICO_ID = S.ID

          WHERE A.SERVICO_ID IS NOT NULL AND A.TIPO = 2 AND A.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}'

          ORDER BY 2,1,3"

    Servico.find_by_sql(sql)


  end


	def self.nota_creditos(params)
		if params[:lancamento].to_s != "1"
			if params[:moeda] == "0"
				moeda = "AND NC.MOEDA = 0"
			elsif params[:moeda] == "1"
				moeda = "AND NC.MOEDA = 1"
			else
				moeda = "AND NC.MOEDA = 2"
			end
		end

		persona = "AND NC.PERSONA_ID = #{params[:busca]["cliente"]}" unless params[:busca]["cliente"].blank?
		op = "AND NC.OPERACAO = #{params[:operacao]}" unless params[:operacao].blank?

		sql = "SELECT NC.ID,
		    					NC.DATA,
						      NC.PERSONA_NOME,
							    NC.OPERACAO,
							    (SELECT SUM(NCD.VALOR_DOLAR) FROM NOTA_CREDITOS_DOCS NCD WHERE NCD.NOTA_CREDITO_ID = NC.ID) AS TOT_US,
							    (SELECT SUM(NCD.VALOR_GUARANI) FROM NOTA_CREDITOS_DOCS NCD WHERE NCD.NOTA_CREDITO_ID = NC.ID) AS TOT_GS
						FROM NOTA_CREDITOS NC
						WHERE NC.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{persona} #{op}
						ORDER BY 2,1
						"
			NotaCredito.find_by_sql(sql)
	end

	def self.antecipo_empleado(params)
		unidade = "UNIDADE_ID = #{params[:unidade]} AND "
		if params[:lancamento].to_s != "1"
			if params[:moeda] == "0"
				moeda = "AND moeda = 0"
			elsif params[:moeda] == "1"
				moeda = "AND moeda = 1"
			else
				moeda = "AND moeda = 2"
			end
		end

		persona_p = "AND PE.ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?
		liq = "AND P.LIQUIDACAO = #{params[:liquidacao]}" unless params[:liquidacao] == '2'

		sqlp = "SELECT
									 A.ADELANTO_ID AS ID,
									 PE.NOME AS PERSONA_NOME,
									 P.TABELA_ID,
									 P.DATA,
									 P.MOEDA,
									 P.LIQUIDACAO,
									 P.VENCIMENTO,
									 P.DOCUMENTO_NUMERO_01 || '-' || P.DOCUMENTO_NUMERO_02 || '-' || P.DOCUMENTO_NUMERO AS DOC,
									 P.COTA,
									 (SELECT SUM(PP.COBRO_DOLAR) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS PAGO_US,
									 (SELECT SUM(PP.COBRO_GUARANI) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS PAGO_GS,
									 (SELECT SUM(PP.COBRO_REAL) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS PAGO_RS,
									 (SELECT SUM(PP.DIVIDA_DOLAR) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS DIV_US,
									 (SELECT SUM(PP.DIVIDA_GUARANI) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS DIV_GS,
									 (SELECT SUM(PP.DIVIDA_REAL) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS DIV_RS

						FROM CLIENTES P
						INNER JOIN PERSONAS PE
						ON PE.ID = P.PERSONA_ID
						LEFT JOIN ADELANTO_COTAS A
						ON A.ID = P.TABELA_ID
						LEFT JOIN ADELANTOS AD
						ON AD.ID = A.ADELANTO_ID

						WHERE AD.tipo_adelanto = 2 AND PE.TIPO_FUNCIONARIO = 1 AND P.MOEDA = #{params[:moeda]} AND P.TABELA = 'ADELANTO_COTAS' AND P.UNIDADE_ID = #{params[:unidade]} AND
							P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
							#{persona_p} #{liq}
						ORDER BY 1,7,8,3
					"

		Cliente.find_by_sql(sqlp)
	end

	def self.pago_antecipado(params)
		sql = "SELECT
						 P.NOME AS PERSONA_NOME,
						 C.DATA,
						 C.COBRO_GUARANI,
						 C.DIVIDA_GUARANI,
						 C.LIQUIDACAO,
						 TABELA
			FROM CLIENTES C
			LEFT JOIN PERSONAS P
			ON C.PERSONA_ID = P.ID
			WHERE C.PERSONA_ID = #{params[:busca]["persona"]} AND TABELA = 'ADELANTO_COTAS' AND COBRO_GUARANI > 0 OR C.PERSONA_ID = #{params[:busca]["persona"]} AND TABELA IS NULL AND COBRO_GUARANI > 0

			UNION ALL
			SELECT P.NOME AS PERSONA_NOME,
						 C.DATA,
						 C.COBRO_GUARANI,
						 C.DIVIDA_GUARANI,
						 C.LIQUIDACAO,
						 TABELA
			FROM CLIENTES C
			LEFT JOIN VENDAS_FINANCAS VF
			ON C.TABELA_ID = VF.ID
			LEFT JOIN PERSONAS P
			ON C.PERSONA_ID = P.ID
			WHERE C.PERSONA_ID = #{params[:busca]["persona"]} AND TABELA = 'VENDAS_FINANCAS' AND VF.FORMA_PAGO_ID = 12 AND C.DIVIDA_GUARANI > 0

			ORDER BY 1,2"
			Cliente.find_by_sql(sql)
	end

	def self.carros(params)
		sql = "SELECT
								 MARCA.NOME, C.NOME, COR, MOTOR, CHASSI, VALOR
					FROM CARROS C
					INNER JOIN MARCA ON MARCA.ID = C.MARCA_ID
					ON MARCA.ID =#{params[:busca]["marca"]}"

					Carro.find_by_sql(sql)
	end

	def self.vendas_produto(params)
		unidade     = "AND V.UNIDADE_ID = #{params[:unidade]}" unless params[:unidade].blank?
		persona     = "AND V.PERSONA_ID = #{params[:persona_id]}" unless params[:persona_id].blank?
		sub_grupo   = "AND P.SUB_GRUPO_ID in (#{params[:grupos].join(',')})"  unless params[:grupos].blank?
		grupo       = "AND P.GRUPO_ID = (#{params[:busca]["grupo"]})" unless params[:busca]["grupo"].blank?
		produto     = "AND P.ID = (#{params[:busca]["produto"]})" unless params[:busca]["produto"].blank?

		p_unidade   = "AND PV.UNIDADE_ID = #{params[:unidade]}" unless params[:unidade].blank?
		p_sub_grupo = "AND PD.SUB_GRUPO_ID in (#{params[:grupos].join(',')})"  unless params[:grupos].blank?
		p_grupo     = "AND PD.GRUPO_ID = (#{params[:busca]["grupo"]})" unless params[:busca]["grupo"].blank?
		p_persona   = "AND PV.PERSONA_ID = #{params[:busca]["cliente"]}" unless params[:busca]["cliente"].blank?
		p_produto   = "AND VP.PRODUTO_ID = #{params[:busca]["produto"]}" unless params[:busca]["produto"].blank?

		if params[:lancamento].to_s != "1"
			if params[:moeda] == "0"
				moeda = "AND v.moeda = 0"
			elsif params[:moeda] == "1"
				moeda = "AND v.moeda = 1"
			else
				moeda = "AND v.moeda = 2"
			end
		end



		if params["status"] == '0'
			#agrupado por produto
			sql = "SELECT
									 VP.PRODUTO_ID,
									 MAX(P.NOME) AS PRODUTO_NOME,
									 MAX(GP.DESCRICAO) AS GRUPO_NOME,
									 MAX(SG.DESCRICAO) AS SUB_GRUPO_NOME,
									 MAX(C.DESCRICAO) AS CLASE_NOME,
									 MAX(V.PERSONA_NOME),
									 SUM(VP.QUANTIDADE) AS QTD,
									 SUM(VP.QUANTIDADE * VP.UNITARIO_GUARANI) AS TOT_GS,
									 SUM(VP.QUANTIDADE * VP.UNITARIO_DOLAR) AS TOT_US,
									 COALESCE(( SELECT SUM(PVP.QUANTIDADE)
										 FROM VENDAS_PRODUTOS PVP

										 INNER JOIN VENDAS PV
										 ON PVP.VENDA_ID = PV.ID

										 LEFT JOIN PERSONAS PE
										 ON PE.ID = PV.PERSONA_ID

										 LEFT JOIN PRODUTOS PD
										 ON PD.ID = PVP.PRODUTO_ID

										 WHERE PVP.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
										 #{p_unidade} #{p_sub_grupo} #{p_grupo} #{p_persona} ),0) AS QTD_TOT
						FROM VENDAS_PRODUTOS VP
						LEFT JOIN PRODUTOS P
						ON P.ID = VP.PRODUTO_ID
						INNER JOIN VENDAS V
						ON V.ID = VP.VENDA_ID

					 	LEFT JOIN CLASES C
					 	ON C.ID = P.CLASE_ID

					 	LEFT JOIN GRUPOS GP
					 	ON GP.ID = P.GRUPO_ID

					 	LEFT JOIN SUB_GRUPOS SG
					 	ON SG.ID = P.SUB_GRUPO_ID

						WHERE VP.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
						#{unidade} #{sub_grupo} #{grupo} #{persona} #{produto} #{moeda}
						GROUP BY 1
						ORDER BY 7 DESC
						"
		elsif  params["status"] == '1'
			#agrupado por sub-grupo
			sql = "SELECT
									 P.SUB_GRUPO_ID,
									 MAX(SG.DESCRICAO) AS SUB_GRUPO_NOME,
									 SUM(VP.QUANTIDADE) AS QTD,
									 SUM(VP.QUANTIDADE * VP.UNITARIO_GUARANI) AS TOT_GS,
									 SUM(VP.QUANTIDADE * VP.UNITARIO_DOLAR) AS TOT_US
						FROM VENDAS_PRODUTOS VP
						INNER JOIN PRODUTOS P
						ON P.ID = VP.PRODUTO_ID
						LEFT JOIN VENDAS V
						ON V.ID = VP.VENDA_ID
						LEFT JOIN SUB_GRUPOS SG
						ON SG.ID = P.SUB_GRUPO_ID
						WHERE VP.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
						#{unidade}  #{moeda}
						GROUP BY 1
						ORDER BY 3 DESC
						"
		elsif  params["status"] == '2'
			#agrupado por grupo
			sql = "SELECT
								 P.GRUPO_ID,
								 MAX(SG.DESCRICAO) AS GRUPO_NOME,
								 SUM(VP.QUANTIDADE) AS QTD,
								 SUM(VP.QUANTIDADE * VP.UNITARIO_GUARANI) AS TOT_GS,
								 SUM(VP.QUANTIDADE * VP.UNITARIO_DOLAR) AS TOT_US
					FROM VENDAS_PRODUTOS VP
					INNER JOIN PRODUTOS P
					ON P.ID = VP.PRODUTO_ID
					LEFT JOIN VENDAS V
					ON V.ID = VP.VENDA_ID
					LEFT JOIN GRUPOS SG
					ON SG.ID = P.GRUPO_ID
					WHERE VP.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
					#{unidade}  #{moeda}
					GROUP BY 1
					ORDER BY 3 DESC
					"

		elsif  params["status"] == '3'

			sql = "SELECT
									 P.ID AS PRODUTO_ID,
									 MAX(P.NOME) AS PRODUTO_NOME,
									 MAX(SG.DESCRICAO) AS SUB_GRUPO_NOME,
									 MAX(G.DESCRICAO) AS GRUPO_NOME,
									 SUM(VP.QUANTIDADE) AS QTD,
									 SUM(VP.QUANTIDADE * VP.UNITARIO_GUARANI) AS TOT_GS,
									 COALESCE(( SELECT SUM(PVP.QUANTIDADE  * PVP.UNITARIO_GUARANI)
										 FROM VENDAS_PRODUTOS PVP

										 INNER JOIN VENDAS PV
										 ON PVP.VENDA_ID = PV.ID

										 LEFT JOIN PERSONAS PE
										 ON PE.ID = PV.PERSONA_ID

										 LEFT JOIN PRODUTOS PD
										 ON PD.ID = PVP.PRODUTO_ID

										 WHERE PVP.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
										 #{p_unidade} #{p_sub_grupo} #{p_grupo}  #{p_produto} ),0) AS SUM_TOT
						FROM VENDAS_PRODUTOS VP

						INNER JOIN PRODUTOS P
						ON P.ID = VP.PRODUTO_ID

						LEFT JOIN VENDAS V
						ON V.ID = VP.VENDA_ID

						LEFT JOIN GRUPOS G
						ON G.ID = P.GRUPO_ID

						LEFT JOIN SUB_GRUPOS SG
						ON SG.ID = P.SUB_GRUPO_ID

						WHERE V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
						#{unidade} #{sub_grupo} #{grupo} #{moeda}
						GROUP BY  2
						ORDER BY 1, 5
						"

		elsif params["status"] == "4"
			#agrupado por produto
			sql = "SELECT
							VD.NOME AS VENDEDOR_NOME,
							VP.PRODUTO_ID,
							P.NOME AS PRODUTO_NOME,
							V.PERSONA_NOME,
							SUM(VP.QUANTIDADE) AS QTD,
							SUM(VP.QUANTIDADE * VP.UNITARIO_GUARANI) AS TOT_GS,
							SUM(VP.QUANTIDADE * VP.UNITARIO_DOLAR) AS TOT_US,
							SUM(VP.QUANTIDADE * VP.UNITARIO_REAL) AS TOT_RS
						FROM VENDAS_PRODUTOS VP
						LEFT JOIN PRODUTOS P
						ON P.ID = VP.PRODUTO_ID

						INNER JOIN VENDAS V
						ON V.ID = VP.VENDA_ID

						LEFT JOIN PERSONAS VD
						ON V.VENDEDOR_ID = VD.ID


						WHERE VP.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
						#{unidade} #{sub_grupo} #{grupo} #{persona} #{produto}  #{moeda}
						GROUP BY 1, 2
						ORDER BY 4
						"
		elsif params["status"] == "5"
			#detalhado por produto
			sql = "SELECT
			        'VT' AS ORIGEM,
							VD.NOME AS VENDEDOR_NOME,
							VP.PRODUTO_ID,
							V.DATA,
							P.NOME AS PRODUTO_NOME,
							V.PERSONA_NOME,
							VP.QUANTIDADE AS QTD,
							(VP.QUANTIDADE * VP.UNITARIO_GUARANI) AS TOT_GS,
							(VP.QUANTIDADE * VP.UNITARIO_DOLAR) AS TOT_US,
							(VP.QUANTIDADE * VP.UNITARIO_REAL) AS TOT_RS
						FROM VENDAS_PRODUTOS VP
						LEFT JOIN PRODUTOS P
						ON P.ID = VP.PRODUTO_ID

						INNER JOIN VENDAS V
						ON V.ID = VP.VENDA_ID

						LEFT JOIN PERSONAS VD
						ON V.VENDEDOR_ID = VD.ID

						WHERE VP.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
						#{unidade} #{sub_grupo} #{grupo} #{persona} #{produto} #{moeda}


						UNION ALL


						SELECT			  'CT' ORIGEM,
													VD.NOME AS VENDEDOR_NOME,
													VP.PRODUTO_ID,
													V.DATA,
													P.NOME AS PRODUTO_NOME,
													CL.NOME AS PERSONA_NOME,
													VP.QUANTIDADE AS QTD,
													(VP.QUANTIDADE * VP.UNITARIO_GS) AS TOT_GS,
													(VP.QUANTIDADE * VP.UNITARIO_US) AS TOT_US,
													(VP.QUANTIDADE * VP.UNITARIO_RS) AS TOT_RS

												FROM CONTRATO_SERVICOS VP

												LEFT JOIN PRODUTOS P
												ON P.ID = VP.PRODUTO_ID

												INNER JOIN CONTRATOS V
												ON V.ID = VP.CONTRATO_ID

												LEFT JOIN PERSONAS VD
												ON V.VENDEDOR_ID = VD.ID

												LEFT JOIN PERSONAS CL
												ON V.PERSONA_ID = CL.ID

												WHERE V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
												#{unidade} #{sub_grupo} #{grupo} #{persona} #{produto} #{moeda}
						ORDER BY 4
						"

		end
		VendasProduto.find_by_sql(sql)
	end




	def self.fopag(params)
		ordem = "1" if params["order"] == '0'
		ordem = "5" if params["order"] == '1'
		ordem = "2" if params["order"] == '2'
		ordem = "1" if params["order"].blank?

		cc  = "AND P.UNIDADE_ID = '#{params[:busca]["cc"]}'" unless params[:busca]["cc"].blank?
		sql = "SELECT P.NOME,
									P.DEPARTAMENTO,
									P.CARGO,
									P.SALARIO,
									P.DATA_ENTRADA,
									P.FOLHA_PAGAMENTO_MOEDA
					FROM PERSONAS P WHERE P.TIPO_FUNCIONARIO = 1 AND ESTADO = 0 #{cc}
					ORDER BY #{ordem}"
					Persona.find_by_sql(sql)
	end


	def self.condicional(params)

		if params[:lancamento].to_s != "1"
			 if params[:moeda] == "0"
					moeda = "AND C.MOEDA = 0"
			 elsif params[:moeda] == "1"
					moeda = "AND C.MOEDA = 1"
				else
					moeda = "AND C.MOEDA = 2"
			 end
		end

		if params[:status].to_s != '2'
			st = "AND C.STATUS = #{params[:status]}"
		else
			st = ""
		end
		unidade = "AND C.UNIDADE_ID  = #{params[:unidade]}"
		cliente = "AND C.PERSONA_ID  = '#{params[:busca]["persona"]}'" unless params[:busca]["persona"].blank?
		vend    = "AND C.VENDEDOR_ID = '#{params[:busca]["vendedor"]}'" unless params[:busca]["vendedor"].blank?
		cond    = "C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{unidade} #{st} #{cliente} #{vend} #{moeda}"

		sql = "SELECT C.ID,
								 C.DATA,
								 C.VENDEDOR_ID,
								 C.PERSONA_ID,
								 C.STATUS,
								 C.MOEDA,
								 PC.NOME AS CLIENTE,
								 PV.NOME AS VENDEDOR,
								 coalesce((SELECT SUM(CP.QUANTIDADE) FROM CONDICIONAL_PRODUTOS CP WHERE CP.CONDICIONAL_ID = C.ID),0) AS QTD_CONDICIONAL,
								 coalesce((SELECT SUM(CP.QUANTIDADE) FROM COND_LIQ_PRODUTOS CP WHERE CP.CONDICIONAL_ID = C.ID),0) AS DEVOLVIDO,
								 coalesce((SELECT SUM(CP.QUANTIDADE) FROM COND_LIQ_VENDIDOS CP WHERE CP.CONDICIONAL_ID = C.ID),0) AS VENDIDO,
								 coalesce((SELECT SUM(CP.QUANTIDADE) FROM VENDAS_PRODUTOS CP WHERE CP.VENDA_ID = VCL.VENDA_ID),0) AS FATURADO,
								 coalesce((SELECT SUM(CP.TOTAL_US) FROM COND_LIQ_VENDIDOS CP WHERE CP.CONDICIONAL_ID = C.ID),0) AS TOT_US,
								 coalesce((SELECT SUM(CP.TOTAL_GS) FROM COND_LIQ_VENDIDOS CP WHERE CP.CONDICIONAL_ID = C.ID),0) AS TOT_GS,
								 CLD.COND_LIQ_ID AS LIQUIDACAO,
								 VCL.VENDA_ID

					 FROM CONDICIONALS C

					 INNER JOIN PERSONAS PC
					 ON PC.ID = C.PERSONA_ID

					 LEFT JOIN PERSONAS PV
					 ON PV.ID = C.VENDEDOR_ID

					 LEFT JOIN COND_LIQ_DOCS CLD
					 ON C.ID = CLD.CONDICIONAL_ID

					 LEFT JOIN VENDAS_COND_LIQS VCL
					 ON CLD.ID = VCL.COND_LIQ_ID


					 WHERE #{cond}
					 ORDER BY 2,1
					 "
						Condicional.find_by_sql(sql)
	end

	def self.fechamento_caixa(params)

		sql = "SELECT
								 C.NOME,
								 C.ID,
								 C.MOEDA
						FROM CONTAS C
						WHERE C.UNIDADE_ID = #{params[:unidade]}
						ORDER BY 1,2"
						Financa.find_by_sql(sql)
	end

	def self.historico_precos(params)

		TabelaPrecoProduto.all(:conditions => [" data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' AND tipo = #{params[:filtro]} "],:order => 'data')
	end

	def self.tabela_preco(params)
		unidade   = "TB.UNIDADE_ID = #{params[:unidade]}"
		clase     = "AND P.CLASE_ID = #{params[:busca]["clase"]}" unless params[:busca]["clase"].blank?
		grupo     = "AND P.GRUPO_ID = #{params[:busca]["grupo"]}" unless params[:busca]["grupo"].blank?
		sub_grupo = "AND P.SUB_GRUPO_ID = #{params[:busca]["sub_grupo"]}" unless params[:busca]["sub_grupo"].blank?
		tabela    = "AND TB.TABELA_PRECO_ID = #{params[:busca]["tabela"]}" unless params[:busca]["tabela"].blank?
		stock_0 = "AND (SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.PRODUTO_ID = P.ID ) > 0" if params[:stok_0] == '1'

		if params[:solo_precio_0] == '1'
			if params[:moeda] == '0'
				preco_0 = "AND TB.PRECO_1_US = 0"
			elsif params[:moeda] == '1'
				preco_0 = "AND TB.PRECO_1_GS = 0"
			elsif params[:moeda] == '2'
				preco_0 = "AND TB.PRECO_1_RS = 0"
			end
		end



		sql = "
				SELECT
							 P.ID AS PRODUTO_ID,
							 P.NOME AS NOME,
							 P.CLASE_ID AS CLASE_ID,
							 P.GRUPO_ID AS GRUPO_ID,
							 P.SUB_GRUPO_ID AS SUB_GRUPO_ID,
							 P.FABRICANTE_COD AS REFERENCIA,
							 (SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.PRODUTO_ID = P.ID AND S.DEPOSITO_ID = #{params[:busca]["deposito"]} ) AS SALDO ,
							 (SELECT SS.UNITARIO_GUARANI FROM STOCKS SS WHERE SS.DEPOSITO_ID = #{params[:busca]["deposito"]} AND SS.STATUS = 0 AND SS.PRODUTO_ID = P.ID  ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) CUSTO_MEDIO_GS,
							 TB.PRECO_1_US,
							 TB.PRECO_1_GS,
							 TB.PRECO_1_RS
				FROM PRODUTOS P
				LEFT JOIN PRODUTOS_TABELA_PRECOS TB
				ON P.ID = TB.PRODUTO_ID
				WHERE  #{unidade}
				#{stock_0} #{preco_0}

				#{clase} #{grupo} #{sub_grupo} #{tabela}
				ORDER BY 2
				"
		Produto.find_by_sql(sql)
	end

	def self.remicao(params)
		#CONDICOES
		unidade = "AND destino_unidade_id  = #{params[:busca]["unidade"]}" unless params[:busca]["unidade"].blank?
		cond    = "data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{unidade}"

		NotaRemicao.all( :select     => ' id,
																			 data,
																			 origem_unidade_nome,
																			 destino_unidade_nome',
		:conditions =>   cond,
		:order      => 'data,id' )

	end

  def self.cheque_diferido(params)
    conta   = "and F.conta_id = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?
    cliente = "and F.PERSONA_ID = #{params[:persona_id]}" unless params[:persona_id].blank?
    #CONDICOES
    if params[:moeda].to_s == "0"
      moeda = " AND F.moeda = 0"
    else
      moeda = "AND F.moeda = 1"
    end

    cheque = " AND F.cheque_status = #{params[:cheque]}" unless params[:cheque].blank?
    if params[:tipodt] == '0'
      data   = "AND F.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'" unless params[:inicio].blank?
      ord = 'DATA'
    else
      diferido = "AND F.DIFERIDO BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'" unless params[:inicio].blank?
      ord = 'DIFERIDO'
    end
    numero = "AND F.cheque ILIKE '%#{params[:numero]}%'" unless params[:numero].blank?

    if params[:emitidos_recebidos].to_s == '1'
      em_r = "AND F.CHEQUE_STATUS BETWEEN 1 AND 2"
    else
      em_r = "AND TABELA IN ('COMPRAS_FINANCAS', 'PAGOS', 'ADELANTOS', 'EGRESSOS', 'SUELDO_PAGOS') AND  F.CHEQUE <> '' AND (F.SAIDA_DOLAR + F.SAIDA_GUARANI + F.SAIDA_REAL) > 0"
    end

    sql = "SELECT F.TABELA,
                  F.CONTA_NOME,
                  F.DATA,
                  F.DIFERIDO,
                  F.ORIGINAL,
                  F.CHEQUE_STATUS,
                  F.PERSONA_NOME,
                  F.MOEDA,
                  F.CHEQUE,
                  F.TITULAR,
                  F.BANCO,
                  F.ENTRADA_DOLAR,
                  F.SAIDA_DOLAR,
                  F.ENTRADA_GUARANI,
                  F.SAIDA_GUARANI,
                  F.CONCEPTO,
                  F.COD_PROC,
                  F.SIGLA_PROC
            FROM FINANCAS F
            INNER JOIN CONTAS C
            ON C.ID = F.CONTA_ID
            WHERE C.UNIDADE_ID = #{params[:unidade]} AND F.CHEQUE_STATUS IS NOT NULL #{em_r} #{moeda} #{data} #{diferido} #{cheque} #{numero} #{conta} #{cliente} ORDER BY F.DIFERIDO,F.CHEQUE, F.ID, F.SAIDA_GUARANI
"

    Financa.find_by_sql( sql )

  end

	def self.gastos(params)

		#filtros
		rodado        = "AND CC.RODADO_ID = '#{params[:busca]["rodado"]}'" unless params[:busca]["rodado"].blank?
		centro_custo  = "AND CC.CENTRO_CUSTO_ID = '#{params[:busca]["centro_custo"]}'" unless params[:busca]["centro_custo"].blank?
		persona       = "AND C.PERSONA_ID = #{params[:busca]["prov"]}" unless params[:busca]["prov"].blank?
		forma_pago    = "AND C.FORMA_PAGO_ID = #{params[:busca]["forma_pago"]}" unless params[:busca]["persona"].blank?
		safra         = "AND C.SAFRA_ID = #{params[:busca]["safra"]}" unless params[:busca]["safra"].blank?
		plano_contas  = "AND CC.PLANO_DE_CONTA_ID = #{params[:busca]["plano_de_conta"]}" unless params[:busca]["plano_de_conta"].blank?
		referencia    = "AND C.OB_REF ILIKE  '%#{params[:referencia]}%'" unless params[:referencia].blank?

		fiscal    = "AND C.FISCAL = #{params[:tipo_fiscal]}" if params[:tipo_fiscal] != '2'
		tipo_doc  = "AND C.TIPO = #{params[:tipo_doc]}" if params[:tipo_doc] != '2'

		if params[:lancamento].to_s != "1"
			 if params[:moeda] == "0"
					moeda = "AND C.MOEDA = 0"

			 elsif params[:moeda] == "1"
					moeda = "AND C.MOEDA = 1"
				else
					moeda = "AND C.MOEDA = 2"
			 end
		end
		if params[:tp] == '0' #analitico
			sql = "SELECT C.ID,
								    C.DATA,
								    P.NOME AS PERSONA_NOME,
								    C.TIPO,
								    C.MOEDA,
								    (C.DOCUMENTO_NUMERO_01 || '-' || C.DOCUMENTO_NUMERO_02 || '-' || C.DOCUMENTO_NUMERO) AS DOC,
								    C.TOTAL_DOLAR,
								    C.TOTAL_GUARANI,
								    C.TOTAL_REAL,
								    C.DESCRICAO,
								    R.PLACA AS RODADO_NOME,
								    CC.NOME AS CENTRO_CUSTO_NOME,
								    FP.NOME AS FORMA_PAGO_NOME,
								    S.NOME AS SAFRA,
								    PC.DESCRICAO AS PLANO_DE_CONTA_NOME,
								    C.DESCRICAO,
								    C.OB_REF,
								    ARRAY(SELECT CC.NOME FROM COMPRAS_CUSTOS CP INNER JOIN CENTRO_CUSTOS CC ON CC.ID = CP.CENTRO_CUSTO_ID WHERE CP.COMPRA_ID = C.ID) AS array_centro_custos,
								    ARRAY(SELECT CC.DESCRICAO FROM COMPRAS_CUSTOS CP INNER JOIN PLANO_DE_CONTAS CC ON CC.ID = CP.PLANO_DE_CONTA_ID WHERE CP.COMPRA_ID = C.ID) AS array_plano_contas
							FROM COMPRAS C
							INNER JOIN PERSONAS P
							ON P.ID = C.PERSONA_ID

							LEFT JOIN RODADOS R
							ON R.ID = C.RODADO_ID

							LEFT JOIN CENTRO_CUSTOS CC
							ON CC.ID = C.CENTRO_CUSTO_ID

							LEFT JOIN PLANO_DE_CONTAS PC
							ON PC.ID = C.PLANO_DE_CONTA_ID


							LEFT JOIN FORMA_PAGOS FP
							ON FP.ID = C.FORMA_PAGO_ID

							LEFT JOIN SAFRAS S
							ON S.ID = C.SAFRA_ID

							WHERE C.TIPO_COMPRA = 1 AND C.TABELA IS NULL
							AND C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
							AND C.UNIDADE_ID = #{params[:unidade]} #{rodado} #{centro_custo} #{persona} #{forma_pago} #{safra} #{moeda} #{plano_contas} #{fiscal} #{tipo_doc} #{referencia}
							"

		elsif params[:tp].to_s == "1" #analitico de custo
			if params[:data_f] == '1'
					f_data = 'CC.DATA'
			else
					f_data = 'C.DATA'
			end

			sql = "SELECT C.DATA AS DATA,
										CC.DATA AS COMPETENCIA,
										CC.COMPRA_ID AS COMPRA_ID,
										C.MOEDA,
										C.PERSONA_NOME,
										(SELECT PG.DESCRICAO FROM PLANO_DE_CONTAS PG WHERE PG.CODIGO =  SUBSTRING(PC.CODIGO, 1, 8) LIMIT 1) AS GRUPO_RUBRO,
										PC.DESCRICAO AS RUBRO_NOME,
										CC.VALOR_US AS VALOR_US,
										CC.VALOR_GS AS VALOR_GS,
										CC.VALOR_RS AS VALOR_RS,
										C.DESCRICAO AS COMPRA_DESCRICAO,
										R.PLACA AS RODADO_NOME,
										P.NOME AS FUNCIONARIO_NOME,
										CEC.NOME AS CENTRO_CUSTO_NOME,
										C.OB_REF
						FROM COMPRAS_CUSTOS CC

						INNER JOIN COMPRAS C
						ON C.ID = CC.COMPRA_ID

						LEFT JOIN PLANO_DE_CONTAS PC
						ON PC.ID = CC.PLANO_DE_CONTA_ID

						LEFT JOIN CENTRO_CUSTOS CEC
						ON CEC.ID = CC.CENTRO_CUSTO_ID

						LEFT JOIN RODADOS R
						ON R.ID = CC.RODADO_ID

						LEFT JOIN PERSONAS P
						ON P.ID = CC.FUNCIONARIO_ID

						WHERE #{f_data} BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
						#{rodado} #{centro_custo} #{persona} #{forma_pago} #{safra} #{moeda} #{plano_contas} #{fiscal} #{tipo_doc} #{referencia}
						ORDER BY C.DATA, C.ID
						"
			ComprasCusto.find_by_sql(sql)

		elsif params[:tp] == '3' #sintetico
			sql = "SELECT PC.DESCRICAO AS PLANO_DE_CONTA_NOME,
							 			SUM(C.TOTAL_DOLAR) AS TOTAL_DOLAR,
							 			SUM(C.TOTAL_GUARANI) AS TOTAL_GUARANI,
							 			SUM(C.TOTAL_REAL) AS TOTAL_REAL

										FROM COMPRAS C
										INNER JOIN PERSONAS P
										ON P.ID = C.PERSONA_ID

										LEFT JOIN RODADOS R
										ON R.ID = C.RODADO_ID

										LEFT JOIN CENTRO_CUSTOS CC
										ON CC.ID = C.CENTRO_CUSTO_ID

										LEFT JOIN PLANO_DE_CONTAS PC
										ON PC.ID = C.PLANO_DE_CONTA_ID


										LEFT JOIN FORMA_PAGOS FP
										ON FP.ID = C.FORMA_PAGO_ID

										LEFT JOIN SAFRAS S
										ON S.ID = C.SAFRA_ID

										WHERE C.TIPO_COMPRA = 1  AND C.TABELA IS NULL
										AND C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
										AND C.UNIDADE_ID = #{params[:unidade]} #{rodado} #{centro_custo} #{persona} #{forma_pago} #{safra} #{moeda} #{plano_contas}  #{fiscal} #{tipo_doc} #{referencia}
										GROUP BY 1
										"
		end

		Compra.find_by_sql(sql)

	end

	def self.compras(params)
		if params[:lancamento].to_s != "1"
			 if params[:moeda] == "0"
					moeda = "AND moeda = 0"
			 elsif params[:moeda] == "1"
					moeda = "AND moeda = 1"
				else
					moeda = "AND moeda = 2"
			 end
		end
		sub_grupo     = " AND C.SUB_GRUPO_ID    = #{params[:busca]["sub_grupo"]}"    unless params[:busca]["sub_grupo"].blank?
		unidade       = "C.UNIDADE_ID = #{params[:unidade]} AND "
		proveedor     = "AND C.persona_id = '#{params[:busca]["proveedor"]}'" unless params[:busca]["proveedor"].blank?
		centro_custo  = "AND C.centro_custo_id = '#{params[:busca]["centro_custo"]}'" unless params[:busca]["centro_custo"].blank?
		clase_produto = "AND C.clase_produto = '#{params[:busca]["clase_produto"]}'" unless params[:busca]["clase_produto"].blank?
		tipo_compra   = "AND C.tipo_compra = '#{params[:tipo_compra]}'" unless params[:tipo_compra] == '4'
		doc_tipo      = "AND C.TIPO = #{params[:status]}" unless  params[:status].blank?
		sql ="SELECT C.ID,
								 C.DATA,
								 C.TIPO_COMPRA,
								 C.TIPO,
								 C.PERSONA_ID,
								 C.PERSONA_NOME,
								 C.TOTAL_DOLAR,
								 C.TOTAL_GUARANI,
								 C.TOTAL_REAL,
								 C.DESCONTO_DOLAR,
								 C.DESCONTO_GUARANI,
								 C.DESCONTO_REAL,
								 C.AJUSTE_US,
								 C.AJUSTE_GS,
								 C.AJUSTE_RS,
								 CC.NOME AS CENTRO_CUSTO_NOME,
								 (SELECT SUM(CP.QUANTIDADE) FROM COMPRAS_PRODUTOS CP WHERE CP.COMPRA_ID = C.ID) AS QTD,
								 C.DOCUMENTO_NUMERO_01 || '-'|| C.DOCUMENTO_NUMERO_02||'-'|| C.DOCUMENTO_NUMERO AS DOC,
								 SG.DESCRICAO AS MARCA
					FROM COMPRAS C
					LEFT JOIN SUB_GRUPOS SG
					ON SG.ID = C.SUB_GRUPO_ID

					LEFT JOIN CENTRO_CUSTOS CC 
					ON CC.ID = C.CENTRO_CUSTO_ID

					WHERE #{unidade} C.TIPO_COMPRA != 1
					AND C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{moeda} #{proveedor}  #{clase_produto} #{tipo_compra} #{doc_tipo} #{sub_grupo} #{centro_custo}
					ORDER BY 2,1"
	Compra.find_by_sql(sql)
	end

	def self.vendas(params)

		if params[:lancamento].to_s != "1"
			 if params[:moeda] == "0"
					moeda = "AND v.moeda = 0"
			 elsif params[:moeda] == "1"
					moeda = "AND v.moeda = 1"
				else
					moeda = "AND v.moeda = 2"
			 end
		end

		find_pedido   = "AND PEDIDO = #{params[:pedido]}" unless params[:pedido].blank?
		find_condic   = "AND condicional =  #{params[:condicional]}" unless params[:condicional].blank?
		vendedor      = "AND V.VENDEDOR_ID = #{params[:busca]['vendedor']}" unless params[:busca]['vendedor'].blank?
		setor         = "AND V.SETOR_ID = #{params[:busca]['setor']}" unless params[:busca]['setor'].blank?
		indicador     = "AND V.INDICADOR_ID = #{params[:busca]['indicador']}" unless params[:busca]['indicador'].blank?
		persona       = "AND V.PERSONA_ID = #{params[:persona_id]}" unless params[:persona_id].blank?
		produto       = "AND VP.PRODUTO_ID = #{params[:busca]['produto']}" unless params[:busca]['produto'].blank?
		doc_tipo      = "AND V.TIPO = #{params[:status]}" unless params[:status].blank?
		regiao        = "AND P.regiao_id = #{params[:regiao]}" unless params[:regiao].blank?
		n_faturado    = "AND ((SELECT COUNT(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID ) = 0)" if params[:n_faturado].to_s == "1"

		if params["detalhe"] == '4' #Vendedor/Cliente
					sql ="SELECT V.ID,
											 V.DATA,
											 V.VENDEDOR_ID,
											 V.DESCONTO_GS,
											 P.NOME AS VENDEDOR_NOME,
											 C.NOME AS PERSONA_NOME,
											 V.terminal_id,
											 V.USUARIO_ID,
											 V.DOCUMENTO_NUMERO_01 || '-' || V.DOCUMENTO_NUMERO_02 || '-' || V.DOCUMENTO_NUMERO AS DOC,
											 V.TIPO,
											 S.NOME AS SETOR_NOME,
											 (SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID ) AS QTD,
											 (SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID ) AS TOTAL_DOLAR,
											 (SELECT SUM(VP.TOTAL_REAL) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID ) AS TOTAL_REAL,
											 (SELECT SUM(VP.TOTAL_GUARANI) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID ) AS TOTAL_GUARANI

								FROM
								VENDAS V
								LEFT JOIN EMPAQUES E
								ON E.VENDA_ID = V.ID

								LEFT JOIN SUB_GRUPOS SG
								ON SG.ID = V.SUB_GRUPO_ID

								LEFT JOIN PERSONAS C
								ON V.PERSONA_ID = C.ID

								LEFT JOIN SETORS S
								ON V.SETOR_ID = S.ID

								LEFT JOIN PERSONAS P
								ON V.VENDEDOR_ID = P.ID

								WHERE (SELECT COUNT(VF) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID ) > 0 AND V.UNIDADE_ID = #{params[:unidade]} AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{n_faturado} #{regiao} #{find_pedido} #{find_condic} #{moeda} #{persona} #{doc_tipo} #{vendedor} #{indicador} #{setor} #{setor}
								ORDER BY 3,2, 10"

		elsif params["detalhe"] == '7' #Vendedor/Agrupado Cliente
					sql ="SELECT
											 V.VENDEDOR_ID,
											 V.PERSONA_ID,
											 MAX(P.NOME) AS VENDEDOR_NOME,
											 MAX(C.NOME) AS PERSONA_NOME,
											 SUM(VP.QUANTIDADE) AS QTD,
											 SUM(V.DESCONTO_GS) AS DESCONTO_GS,
											 SUM(VP.TOTAL_DOLAR) AS TOTAL_DOLAR,
											 SUM(VP.TOTAL_GUARANI) AS TOTAL_GUARANI

								FROM VENDAS_PRODUTOS VP
								INNER JOIN VENDAS V
								ON V.ID = VP.VENDA_ID

								LEFT JOIN PERSONAS C
								ON V.PERSONA_ID = C.ID

								LEFT JOIN SETORS S
								ON V.SETOR_ID = S.ID

								LEFT JOIN PERSONAS P
								ON V.VENDEDOR_ID = P.ID

								WHERE (SELECT COUNT(VF) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID ) > 0 AND V.UNIDADE_ID = #{params[:unidade]} AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{n_faturado} #{regiao} #{find_pedido} #{find_condic} #{moeda} #{persona} #{doc_tipo} #{vendedor} #{indicador} #{setor} #{setor}
								GROUP BY 1, 2
								ORDER BY 3,4"

		elsif params["detalhe"] == '6' #Vendedor/produtos
					sql ="SELECT V.ID,
											 V.DATA,
											 V.VENDEDOR_ID,
											 P.NOME AS VENDEDOR_NOME,
											 C.NOME AS PERSONA_NOME,
											 PD.NOME AS PRODUTO_NOME,
											 V.terminal_id,
											 V.USUARIO_ID,
											 V.DOCUMENTO_NUMERO_01 || '-' || V.DOCUMENTO_NUMERO_02 || '-' || V.DOCUMENTO_NUMERO AS DOC,
											 V.TIPO,
											 VP.QUANTIDADE AS QTD,
											 VP.TOTAL_DOLAR AS TOTAL_DOLAR,
											 VP.TOTAL_GUARANI AS TOTAL_GUARANI

								FROM
								VENDAS_PRODUTOS VP

								INNER JOIN VENDAS V
								ON V.ID = VP.VENDA_ID

								LEFT JOIN SUB_GRUPOS SG
								ON SG.ID = V.SUB_GRUPO_ID

								LEFT JOIN PERSONAS C
								ON V.PERSONA_ID = C.ID

								LEFT JOIN PERSONAS P
								ON V.VENDEDOR_ID = P.ID

								LEFT JOIN PRODUTOS PD
								ON VP.PRODUTO_ID = PD.ID

								WHERE V.UNIDADE_ID = #{params[:unidade]}
								AND (SELECT COUNT(VF) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID ) > 0
								AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{n_faturado} #{regiao}
								#{find_pedido} #{find_condic} #{moeda} #{persona} #{doc_tipo} #{vendedor} #{indicador} #{produto}
								ORDER BY 3,2, 10"

				elsif params["detalhe"] == '7' #resumen tickets

					find_pedido   = "AND PEDIDO = #{params[:pedido]}" unless params[:pedido].blank?
					find_condic   = "AND condicional =  #{params[:condicional]}" unless params[:condicional].blank?
					persona_t     = "AND V.PERSONA_ID = #{params[:persona_id]}" unless params[:persona_id].blank?
					produto       = "AND VP.PRODUTO_ID = #{params[:busca]['produto']}" unless params[:busca]['produto'].blank?
					doc_tipo      = "AND V.TIPO = #{params[:status]}" unless params[:status].blank?
					regiao        = "AND P.regiao_id = #{params[:regiao]}" unless params[:regiao].blank?
					n_faturado    = "AND ((SELECT COUNT(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID ) = 0)" if params[:n_faturado].to_s == "1"

					sql ="SELECT P.ID AS PERSONA_ID,
														   PD.NOME AS PRODUTO_NOME,
														   MAX(P.NOME) AS PERSONA_NOME,
														   MAX(P.ESCOLARIDADE) AS ESCOLARIDADE,
														   MAX((SELECT COUNT(C.ID) FROM EVENTO_CONVIDADOS C WHERE C.PERSONA_ID = EC.PERSONA_ID )),
														   MAX((SELECT COUNT(C.ID) FROM EVENTO_CONVIDADOS C WHERE C.PERSONA_ID = EC.PERSONA_ID AND C.PRESENTE = TRUE))

													FROM EVENTO_CONVIDADOS EC
													INNER JOIN PERSONAS P
													ON P.ID = EC.PERSONA_ID

													INNER JOIN VENDAS_PRODUTOS VP
													ON VP.ID = EC.VENDAS_PRODUTO_ID

													INNER JOIN PRODUTOS PD
													ON PD.ID = VP.PRODUTO_ID
													WHERE
													GROUP BY 1,2"

			elsif  params["detalhe"] == '5' #Resumen por Vendedor
				sql = "SELECT V.VENDEDOR_ID AS VENDEDOR,
											 MAX(P.NOME) AS VENDEDOR,
											 SUM(VP.QUANTIDADE) AS QTD_VD,
											 SUM(VP.TOTAL_GUARANI) AS TOT_VD_GS,
											 SUM(VP.TOTAL_DOLAR) AS TOT_VD_US,
											 SUM(VP.DESCONTO_GUARANI) AS DESC_GS,
											 SUM(0) AS QTD_NC,
											 SUM(0) AS TOT_NC_GS,
											 SUM(0) AS TOT_NC_US

										FROM VENDAS_PRODUTOS VP

										INNER JOIN VENDAS V
										ON V.ID = VP.VENDA_ID

										INNER JOIN PERSONAS P
										ON P.ID = V.VENDEDOR_ID

										WHERE   V.FINALIDADE = 0
										AND (SELECT COUNT(VF) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID ) > 0
										AND V.UNIDADE_ID = #{params[:unidade]} AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{n_faturado} #{regiao} #{find_pedido} #{find_condic} #{moeda} #{persona} #{doc_tipo} #{vendedor} #{setor}
										GROUP BY 1

										UNION ALL

										SELECT V.VENDEDOR_ID AS VENDEDOR,
											 MAX(P.NOME) AS VENDEDOR,
											 SUM(0) AS QTD_VD,
											 SUM(0) AS TOT_VD_GS,
											 SUM(0) AS TOT_VD_US,
											 SUM(0) AS DESC_GS,
											 SUM(NCP.QUANTIDADE) * -1 AS QTD_NC,
											 SUM(NCP.TOTAL_GUARANI) * -1 AS TOT_NC_GS,
											 SUM(NCP.TOTAL_DOLAR) * -1 AS TOT_NC_US

										FROM NOTA_CREDITOS_DETALHES NCP

										INNER JOIN NOTA_CREDITOS V
										ON V.ID = NCP.NOTA_CREDITO_ID

										INNER JOIN PERSONAS P
										ON P.ID = V.VENDEDOR_ID
										WHERE V.OPERACAO = 0 AND V.UNIDADE_ID = #{params[:unidade]} AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{n_faturado} #{regiao} #{find_pedido} #{find_condic} #{moeda} #{persona} #{doc_tipo} #{vendedor}
										GROUP BY 1"

			else
				if params[:devolvidos] == '1'
					dev = "AND VP.QUANTIDADE < 0 "

				end
					sql ="SELECT V.ID,
											 V.DATA,
											 V.DESCONTO_GS,
											 V.CONTROLE_CAIXA,
											 VD.NOME AS VENDEDOR_NOME,
											 P.NOME AS PERSONA_NOME,
											 V.DOCUMENTO_NUMERO_01 || '-' || V.DOCUMENTO_NUMERO_02 || '-' || V.DOCUMENTO_NUMERO AS DOC,
											 V.TIPO,
											 S.NOME AS SETOR_NOME,
											 (SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID #{dev} ) AS QTD,
											 (SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID  #{dev}) AS TOTAL_DOLAR,
											 (SELECT SUM(VP.TOTAL_GUARANI) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID #{dev} ) AS TOTAL_GUARANI,
											 (SELECT SUM(VP.TOTAL_REAL) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID #{dev} ) AS TOTAL_REAL
								FROM
								VENDAS V
								LEFT JOIN PERSONAS P
								ON V.PERSONA_ID = P.ID
								LEFT JOIN PERSONAS VD
								ON V.VENDEDOR_ID = VD.ID
								LEFT JOIN SETORS S
								ON V.SETOR_ID = S.ID

								WHERE V.FINALIDADE = 0
								AND (SELECT COUNT(VF) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID ) > 0
								AND V.UNIDADE_ID = #{params[:unidade]} AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{n_faturado} #{regiao} #{find_pedido} #{find_condic} #{moeda} #{persona} #{doc_tipo} #{vendedor} #{setor}

								ORDER BY 2,1, 10"
				end

		Venda.find_by_sql(sql)
	end

	def self.cobros(params)
		if params[:detalhe].to_s == '0'

				if params[:lancamento].to_s != "1"
						if params[:moeda] == "0"
							moeda = "AND C.moeda = 0"
						elsif params[:moeda] == "1"
							moeda = "AND C.moeda = 1"
						else
							moeda = "AND C.moeda = 2"
						end
					end
					unidade  = "C.UNIDADE_ID = #{params[:unidade]} AND "

					vend = "AND C.PERSONA_ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?
					cc   = "AND CD.CENTRO_CUSTO_ID = #{params[:busca]["cc"]} " unless params[:busca]["cc"].blank?

					rec = "AND C.DOCUMENTO_NUMERO <> ''" unless params[:recibo].blank?
					if params[:adelanto].to_s == '0'
						ant = "AND ADELANTO = 0"
					elsif params[:adelanto].to_s == '1'
						ant = "AND ADELANTO = 1"
					else
						ant = ""
					end
					sql ="SELECT CD.COBRO_ID,
											 CD.DATA,
											 CD.COTA,
											 CD.CLASE_PRODUTO,
											 C.DOCUMENTO_NUMERO AS RECIBO,
											 CD.VENDEDOR_ID,
											 CD.DOCUMENTO_NUMERO_01 || '-' || CD.DOCUMENTO_NUMERO_02 || '-' || CD.DOCUMENTO_NUMERO AS DOC,
											 CD.PERSONA_ID,
											 P.NOME AS PERSONA_NOME,
											 CD.COBRO_DOLAR,
											 CD.COBRO_GUARANI,
											 CD.VALOR_DOLAR,
											 CD.VALOR_GUARANI,
											 CD.ESTADO,
											 CD.TOT_COTAS
								FROM COBROS_DETALHES CD
								INNER JOIN COBROS C
								ON CD.COBRO_ID = C.ID
                INNER JOIN PERSONAS P
                ON P.ID = C.PERSONA_ID
								WHERE #{unidade} CD.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{moeda} #{vend} #{rec} #{cc}
								ORDER BY 4,2,1,3"
					Cobro.find_by_sql(sql)

		elsif params[:detalhe].to_s == '3' #RENDICION

				if params[:lancamento].to_s != "1"
						if params[:moeda] == "0"
							moeda = "AND C.moeda = 0"
						elsif params[:moeda] == "1"
							moeda = "AND C.moeda = 1"
						else
							moeda = "AND C.moeda = 2"
						end
					end
					unidade  = "C.UNIDADE_ID = #{params[:unidade]} AND "

					vend = "AND C.PERSONA_ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?
					cc   = "AND CD.CENTRO_CUSTO_ID = #{params[:busca]["cc"]} " unless params[:busca]["cc"].blank?

					rec = "AND C.DOCUMENTO_NUMERO <> ''" unless params[:recibo].blank?
					if params[:adelanto].to_s == '0'
						ant = "AND ADELANTO = 0"
					elsif params[:adelanto].to_s == '1'
						ant = "AND ADELANTO = 1"
					else
						ant = ""
					end
					sql ="SELECT CD.COBRO_ID,
											 CD.DATA,
											 CD.COTA,
											 C.DOCUMENTO_NUMERO AS RECIBO,
											 CD.VENDEDOR_ID,
											 CD.DOCUMENTO_NUMERO_01 || '-' || CD.DOCUMENTO_NUMERO_02 || '-' || CD.DOCUMENTO_NUMERO AS DOC,
											 CD.PERSONA_ID,
											 P.NOME AS PERSONA_NOME,
											 CD.COBRO_DOLAR,
											 CD.COBRO_GUARANI,
											 CD.VALOR_DOLAR,
											 CD.VALOR_GUARANI,
											 CD.INTERES_DOLAR,
											 CD.INTERES_GUARANI,
											 CD.ESTADO,
											 CD.TOT_COTAS,
											 CD.VENCIMENTO,
											 CD.MOEDA
								FROM COBROS_DETALHES CD
								INNER JOIN COBROS C
								ON CD.COBRO_ID = C.ID
                INNER JOIN PERSONAS P
                ON P.ID = C.PERSONA_ID
								WHERE #{unidade} CD.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{vend} #{rec} #{cc}
								ORDER BY 4,2,1,3"
					Cobro.find_by_sql(sql)

		elsif params[:detalhe] == '2'
			if params[:moeda] == "0"
				moeda = "AND moeda = 0"
				valor_titulo = "PF.PAGO_DOLAR"
				find_valor = "AND CD.COBRO_DOLAR BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')} " if params[:valor_max].to_f > 0
			elsif params[:moeda] == "1"
				moeda = "AND moeda = 1"
				valor_titulo = "PF.PAGO_GUARANI"
				find_valor = "AND CD.COBRO_GUARANI BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')} " if params[:valor_max].to_f > 0
			else
				moeda = "AND moeda = 2"
				valor_titulo = "PF.PAGO_REAL"
				find_valor = "AND CD.COBRO_REAL BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')} " if params[:valor_max].to_f > 0
			end

			unidade = "P.UNIDADE_ID = #{params[:unidade]} AND "
			per = "AND P.PERSONA_ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?
			cc  = "AND CD.CENTRO_CUSTO_ID = #{params[:busca]["cc"]} " unless params[:busca]["cc"].blank?
			doc = "AND CD.DOCUMENTO_NUMERO = '#{params[:doc]}' " unless params[:doc].blank?
			cota = "AND CD.COTA = #{params[:cota]} " unless params[:cota].blank?


		if params[:od] == '0'
			od = 'PF.DATA, PF.ID'
		elsif params[:od] == '1'
			od = 'PR.NOME, PF.DATA, PF.ID'
		else
			od = 'FP.NOME, PF.DATA, PF.ID'
		end

			sql = "SELECT PF.COBRO_ID AS PAGO_ID,
							  	  P.DATA,
								    PR.NOME AS PERSONA_NOME,
								    PF.DESCRICAO,
								    ( (CD.COBRO_DOLAR + CD.INTERES_DOLAR) - CD.DESCONTO_DOLAR) AS COBRO_DOLAR,
								    ( (CD.COBRO_GUARANI + CD.INTERES_GUARANI)  - CD.DESCONTO_GUARANI) AS COBRO_GUARANI,
								    ( (CD.COBRO_REAL + CD.INTERES_REAL) - CD.DESCONTO_REAL) AS COBRO_REAL,
								    PF.CHEQUE,
								    C.NOME AS CONTA_NOME,
								    FP.NOME AS FORMA_PAGO_NOME,
								    CD.DOCUMENTO_NUMERO AS DOC,
								    CD.VENCIMENTO,
								    CD.COTA,
								    F.TOT_COTAS,
								    CC.NOME AS CENTRO_CUSTO_NOME

							FROM COBROS_FINANCAS PF

							LEFT JOIN CONTAS C
							ON C.ID = PF.CONTA_ID

							LEFT JOIN COBROS P
							ON P.ID = PF.COBRO_ID

							INNER JOIN COBROS_DETALHES CD
							ON CD.COBRO_ID = PF.COBRO_ID

							LEFT JOIN CLIENTES F
							ON F.TABELA_ID = CD.ID AND F.TABELA = 'COBROS_DETALHE'

              LEFT JOIN CENTRO_CUSTOS CC
              ON CC.ID = F.CENTRO_CUSTO_ID

							LEFT JOIN PERSONAS PR
							ON PR.ID = P.PERSONA_ID

							LEFT JOIN FORMA_PAGOS FP
							ON FP.ID = PF.FORMA_PAGO_ID

							WHERE #{unidade} P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{per} #{cc} #{find_valor} #{doc} #{cota}
							ORDER BY #{od}"
							Cobro.find_by_sql(sql)
		else
			if params[:lancamento].to_s != "1"
			 if params[:moeda] == "0"
					moeda = "AND moeda = 0"
				elsif params[:moeda] == "1"
					moeda = "AND moeda = 1"
				else
					moeda = "AND moeda = 2"
				end
			end
			unidade       = "UNIDADE_ID = #{params[:unidade]} AND "
			clase_produto = "AND CLASE_PRODUTO = #{params[:busca]["clase_produto"]}" unless params[:busca]["clase_produto"].blank?

			vend = "AND VENDEDOR_ID = #{params[:busca]["empregado"]}" unless params[:busca]["empregado"].blank?

			rec = "AND DOCUMENTO_NUMERO <> ''" unless params[:recibo].blank?
			if params[:adelanto].to_s == '0'
					ant = "AND ADELANTO = 0"
			elsif params[:adelanto].to_s == '1'
					ant = "AND ADELANTO = 1"
			else
					ant = ""
			end

			Cobro.all( :conditions => ["#{unidade} data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{moeda} #{clase_produto} #{vend} #{rec} #{ant}"],
			:order      => 'data' )
		end
	end

	def self.pagos(params)


			if params[:moeda] == "0"
				moeda = "AND moeda = 0"
				valor_titulo = "PF.PAGO_DOLAR"
				find_valor = "AND PF.VALOR_DOLAR BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')} " if params[:valor_max].to_f > 0
			elsif params[:moeda] == "1"
				moeda = "AND moeda = 1"
				valor_titulo = "PF.PAGO_GUARANI"
				find_valor = "AND PF.VALOR_GUARANI BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')} " if params[:valor_max].to_f > 0
			else
				moeda = "AND moeda = 2"
				valor_titulo = "PF.PAGO_REAL"
				find_valor = "AND PF.VALOR_REAL BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')} " if params[:valor_max].to_f > 0
			end
		unidade = "P.UNIDADE_ID = #{params[:unidade]} AND "
		per = "AND P.PERSONA_ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?
    cc    = "AND (SELECT PD.CENTRO_CUSTO_ID FROM PAGOS_DETALHES PD WHERE PD.PAGO_ID = PF.PAGO_ID LIMIT 1) = #{params[:busca]["cc"]} " unless params[:busca]["cc"].blank?
    rubro = "AND (SELECT PD.RUBRO_ID FROM PAGOS_DETALHES PD WHERE PD.PAGO_ID = PF.PAGO_ID LIMIT 1) = #{params[:compras_custo]["rubro_id"]} " unless params[:compras_custo]["rubro_id"].blank?
    doc   = "AND (SELECT PD.DOCUMENTO_NUMETO FROM PAGOS_DETALHES PD WHERE PD.PAGO_ID = PF.PAGO_ID LIMIT 1) = '#{params[:doc]}' " unless params[:doc].blank?
    cota  = "AND (SELECT PD.COTA FROM PAGOS_DETALHES PD WHERE PD.PAGO_ID = PF.PAGO_ID LIMIT 1) = #{params[:cota]} " unless params[:cota].blank?


		if params[:od] == '0'
			od = 'PF.DATA, PF.ID'
		elsif params[:od] == '1'
			od = 'PR.NOME, PF.DATA, PF.ID'
		else
			od = 'FP.NOME, PF.DATA, PF.ID'
		end


		if params[:detalhe] == '2'


			sql = "SELECT PF.PAGO_ID,
							  	  P.DATA,
								    PR.NOME AS PERSONA_NOME,
								    PF.DESCRICAO,
								    PF.VALOR_DOLAR AS PAGO_DOLAR,
								    PF.VALOR_GUARANI AS PAGO_GUARANI,
								    PF.VALOR_REAL AS PAGO_REAL,
								    PF.CHEQUE,
								    C.NOME AS CONTA_NOME,
								    FP.NOME AS FORMA_PAGO_NOME

							FROM PAGOS_FINANCAS PF

							LEFT JOIN CONTAS C
							ON C.ID = PF.CONTA_ID

							LEFT JOIN PAGOS P
							ON P.ID = PF.PAGO_ID

							LEFT JOIN PERSONAS PR
							ON PR.ID = P.PERSONA_ID

							LEFT JOIN FORMA_PAGOS FP
							ON FP.ID = PF.FORMA_PAGO_ID

							LEFT JOIN PAGOS_DETALHES PD
							ON PD.PAGO_ID = C.ID


							WHERE #{unidade} P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{per} #{cc} #{rubro} #{doc} #{cota} #{find_valor}
							ORDER BY #{od}"
		else

			sql = "SELECT P.ID,
									P.DATA,
									P.PERSONA_ID,
									P.PERSONA_NOME,
									P.MOEDA,
									P.COTACAO,
									P.COTACAO_REAL,
									P.COTACAO_RS_US,
									(SELECT coalesce(SUM(#{valor_titulo}),0) FROM PAGOS_DETALHES PF WHERE PF.PAGO_ID = P.ID) TITULO,
									(SELECT coalesce(SUM(PF.PAGO_DOLAR),0) FROM PAGOS_DETALHES PF WHERE PF.PAGO_ID = P.ID AND PF.MOEDA = 0) PAGO_US,
									(SELECT coalesce(SUM(PF.PAGO_GUARANI),0) FROM PAGOS_DETALHES PF WHERE PF.PAGO_ID = P.ID AND PF.MOEDA = 1) PAGO_GS,
									(SELECT coalesce(SUM(PF.PAGO_REAL),0) FROM PAGOS_DETALHES PF WHERE PF.PAGO_ID = P.ID AND PF.MOEDA = 2) PAGO_RS,
									(SELECT coalesce(SUM(PF.DESCONTO_DOLAR),0) FROM PAGOS_DETALHES PF WHERE PF.PAGO_ID = P.ID AND PF.MOEDA = 0) DESC_US,
									(SELECT coalesce(SUM(PF.DESCONTO_GUARANI),0) FROM PAGOS_DETALHES PF WHERE PF.PAGO_ID = P.ID AND PF.MOEDA = 1) DESC_GS,
									(SELECT coalesce(SUM(PF.DESCONTO_REAL),0) FROM PAGOS_DETALHES PF WHERE PF.PAGO_ID = P.ID AND PF.MOEDA = 2) DESC_RS,
									(SELECT coalesce(SUM(PF.INTERES_DOLAR),0) FROM PAGOS_DETALHES PF WHERE PF.PAGO_ID = P.ID AND PF.MOEDA = 0) INT_US,
									(SELECT coalesce(SUM(PF.INTERES_GUARANI),0) FROM PAGOS_DETALHES PF WHERE PF.PAGO_ID = P.ID AND PF.MOEDA = 1) INT_GS,
									(SELECT coalesce(SUM(PF.INTERES_REAL),0) FROM PAGOS_DETALHES PF WHERE PF.PAGO_ID = P.ID AND PF.MOEDA = 2) INT_RS
					FROM PAGOS P
					WHERE #{unidade} P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{per}
					ORDER BY DATA"
		end

		Pago.find_by_sql(sql)
	end




	def self.comissao(params)
			unless params[:busca]["vendedor"].blank?
			vendedor = "AND V.VENDEDOR_ID = #{params[:busca]["vendedor"]}"
		else
			vendedor = ''
		end

		Persona.find_by_sql([Form.last.sql_comissao.to_s.gsub!("#F_VENDEDOR", vendedor), params[:unidade], params[:inicio].split("/").reverse.join("-"), params[:final].split("/").reverse.join("-"), params[:unidade], params[:inicio].split("/").reverse.join("-"), params[:final].split("/").reverse.join("-")])
	end

	def self.sueldo(params)
		empregado  = "AND P.ID = '#{params[:busca]["empregado"]}'" unless params[:busca]["empregado"].blank?
		unidade  = "AND P.UNIDADE_ID = '#{params[:busca]['unidade']}'" unless params[:busca]['unidade'].blank?
		chofer  = "AND P.tipo_chofer = #{params[:tipo_chofer]}" unless params[:tipo_chofer].blank?
		dias  = "AND S.DIAS = #{params[:dias]}" unless params[:dias].blank?

		sql = "SELECT P.ID,
								 P.NOME,
								 P.DEPARTAMENTO,
								 P.UNIDADE_ID,
								 (SELECT SUM(S.CREDITO_GS) FROM SUELDOS_DETALHES S WHERE MOEDA = 1 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'SUELDO' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_SUELDO,
								 (SELECT SUM(S.CREDITO_GS) FROM SUELDOS_DETALHES S WHERE MOEDA = 1 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'BONIFICACION' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_BONIF,
								 (SELECT SUM(S.CREDITO_GS) FROM SUELDOS_DETALHES S WHERE MOEDA = 1 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'COMISION' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_COMIS,
								 (SELECT SUM(S.CREDITO_GS) FROM SUELDOS_DETALHES S WHERE MOEDA = 1 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'EXTRA' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_EXTR,
								 (SELECT SUM(S.CREDITO_GS) FROM SUELDOS_DETALHES S WHERE MOEDA = 1 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'OTROS' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_OTROS_CRED,
								 (SELECT SUM(S.DEBITO_GS) FROM SUELDOS_DETALHES S WHERE MOEDA = 1 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'OTROS' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_OTROS_DEB,
								 (SELECT SUM(S.DEBITO_GS) FROM SUELDOS_DETALHES S WHERE MOEDA = 1 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'BAJA DEUDA' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_ADEL,
								 (SELECT SUM(S.DEBITO_GS) FROM SUELDOS_DETALHES S WHERE MOEDA = 1 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'PRESTAMO' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_PREST,
								 (SELECT SUM(S.DEBITO_GS) FROM SUELDOS_DETALHES S WHERE MOEDA = 1 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'IPS' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_IPS,
								 (SELECT SUM(S.CREDITO_GS) FROM SUELDOS_DETALHES S WHERE MOEDA = 1 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'VACACIONES' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_VACA,
								 (SELECT SUM(S.CREDITO_GS) FROM SUELDOS_DETALHES S WHERE MOEDA = 1 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'AGUINALDO' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_AGUI,
								 (SELECT SUM(S.VALOR_GUARANI) FROM ADELANTOS S WHERE MOEDA = 1 AND PERSONA_ID = P.ID AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS GS_PG_ADEL,

								 (SELECT SUM(S.CREDITO_RS) FROM SUELDOS_DETALHES S WHERE MOEDA = 2 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'SUELDO' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS RS_SUELDO,
								 (SELECT SUM(S.CREDITO_RS) FROM SUELDOS_DETALHES S WHERE MOEDA = 2 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'BONIFICACION' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS RS_BONIF,
								 (SELECT SUM(S.CREDITO_RS) FROM SUELDOS_DETALHES S WHERE MOEDA = 2 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'COMISION' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS RS_COMIS,
								 (SELECT SUM(S.CREDITO_RS) FROM SUELDOS_DETALHES S WHERE MOEDA = 2 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'EXTRA' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS RS_EXTR,
								 (SELECT SUM(S.CREDITO_RS) FROM SUELDOS_DETALHES S WHERE MOEDA = 2 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'OTROS' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS RS_OTROS_CRED,
								 (SELECT SUM(S.DEBITO_RS) FROM SUELDOS_DETALHES S WHERE MOEDA = 2 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'OTROS' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS RS_OTROS_DEB,
								 (SELECT SUM(S.DEBITO_RS) FROM SUELDOS_DETALHES S WHERE MOEDA = 2 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'ADELANTO' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS RS_ADEL,
								 (SELECT SUM(S.DEBITO_RS) FROM SUELDOS_DETALHES S WHERE MOEDA = 2 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'PRESTAMO' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS RS_PREST,
								 (SELECT SUM(S.CREDITO_RS) FROM SUELDOS_DETALHES S WHERE MOEDA = 2 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'VACACIONES' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS RS_VACA,
								 (SELECT SUM(S.CREDITO_RS) FROM SUELDOS_DETALHES S WHERE MOEDA = 2 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'AGUINALDO' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS RS_AGUI,


								 (SELECT SUM(S.CREDITO_US) FROM SUELDOS_DETALHES S WHERE MOEDA = 0 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'SUELDO' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS US_SUELDO,
								 (SELECT SUM(S.CREDITO_US) FROM SUELDOS_DETALHES S WHERE MOEDA = 0 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'BONIFICACION' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS US_BONIF,
								 (SELECT SUM(S.CREDITO_US) FROM SUELDOS_DETALHES S WHERE MOEDA = 0 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'COMISION' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS US_COMIS,
								 (SELECT SUM(S.CREDITO_US) FROM SUELDOS_DETALHES S WHERE MOEDA = 0 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'EXTRA' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS US_EXTR,
								 (SELECT SUM(S.CREDITO_US) FROM SUELDOS_DETALHES S WHERE MOEDA = 0 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'OTROS' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS US_OTROS_CRED,
								 (SELECT SUM(S.DEBITO_US) FROM SUELDOS_DETALHES S WHERE MOEDA = 0 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'OTROS' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS US_OTROS_DEB,
								 (SELECT SUM(S.DEBITO_US) FROM SUELDOS_DETALHES S WHERE MOEDA = 0 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'ADELANTO' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS US_ADEL,
								 (SELECT SUM(S.DEBITO_US) FROM SUELDOS_DETALHES S WHERE MOEDA = 0 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'PRESTAMO' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS US_PREST,
								 (SELECT SUM(S.CREDITO_US) FROM SUELDOS_DETALHES S WHERE MOEDA = 0 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'VACACIONES' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS US_VACA,
								 (SELECT SUM(S.CREDITO_US) FROM SUELDOS_DETALHES S WHERE MOEDA = 0 #{dias} AND PERSONA_ID = P.ID AND S.TIPO = 'AGUINALDO' AND date_part('month', DATA) = '#{params[:mes]}'  AND  date_part('year', DATA) = '#{params[:ano]}') AS US_AGUI
					FROM
						PERSONAS P
					WHERE
					  P.TIPO_FUNCIONARIO = 1
					  AND ((SELECT COUNT(S.ID) FROM SUELDOS_DETALHES S WHERE PERSONA_ID = P.ID #{dias} AND date_part('month', DATA) = '#{params[:mes]}' AND date_part('year', DATA) = '#{params[:ano]}')  ) > 0
	          #{empregado} #{unidade} #{chofer}

					 ORDER BY 2,1
					"
					Persona.find_by_sql(sql)


	end

	def self.adelantos(params)
		unidade = "UNIDADE_ID = #{params[:unidade]} AND "
		status  = "AND tipo = '#{params[:status]}'" unless params[:status] == "3"
		persona = "AND ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?

		if params[:tipo_d] == '0'
			tipo_adelanto = "AND AD.RUBRO_DESCRICAO ILIKE '%PRES%'"
		elsif params[:tipo_d] == '1'
			tipo_adelanto = "AND AD.RUBRO_DESCRICAO  ILIKE '%ANT%'"
		else
			tipo_adelanto = ""
		end

		if params[:lancamento].to_s != "1"

			if params[:moeda] == "0"
				moeda = "AND moeda = 0"
			elsif params[:moeda] == "1"
				moeda = "AND moeda = 1"
			else
				moeda = "AND moeda = 2"
			end
		end

		if params[:tipo_adelanto].to_s == '1'
			if params[:status].to_s != '0'
				persona_p = "AND PE.ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?
				liq = "AND P.LIQUIDACAO = #{params[:liquidacao]}" unless params[:liquidacao] == '2'

				sqlp = "SELECT
											 A.ADELANTO_ID AS ID,
											 PE.NOME AS PERSONA_NOME,
											 P.TABELA_ID,
											 P.DATA,
											 P.MOEDA,
											 P.LIQUIDACAO,
											 P.VENCIMENTO,
											 P.DOCUMENTO_NUMERO_01 || '-' || P.DOCUMENTO_NUMERO_02 || '-' || P.DOCUMENTO_NUMERO AS DOC,
											 P.COTA,
											 P.DESCRICAO AS CONCEPTO,
											 (SELECT SUM(PP.COBRO_DOLAR) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS PAGO_US,
											 (SELECT SUM(PP.COBRO_GUARANI) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS PAGO_GS,
											 (SELECT SUM(PP.COBRO_REAL) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS PAGO_RS,
											 (SELECT SUM(PP.DIVIDA_DOLAR) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS DIV_US,
											 (SELECT SUM(PP.DIVIDA_GUARANI) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS DIV_GS,
											 (SELECT SUM(PP.DIVIDA_REAL) FROM CLIENTES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS DIV_RS

								FROM CLIENTES P
								INNER JOIN PERSONAS PE
								ON PE.ID = P.PERSONA_ID
								LEFT JOIN ADELANTO_COTAS A
								ON A.ID = P.TABELA_ID
								LEFT JOIN ADELANTOS AD
								ON AD.ID = A.ADELANTO_ID

								WHERE P.MOEDA = #{params[:moeda]} AND P.TABELA = 'ADELANTO_COTAS' AND P.UNIDADE_ID = #{params[:unidade]} AND
									P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
									#{persona_p} #{liq} #{tipo_adelanto}
								ORDER BY 1,7,8,3
							"

				Cliente.find_by_sql(sqlp)

			else
				persona_p = "AND PE.ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?

				liq = "AND P.LIQUIDACAO = #{params[:liquidacao]}" unless params[:liquidacao] == '2'

				sqlp = "SELECT
											 A.ADELANTO_ID AS ID,
											 PE.NOME,
											 P.TABELA_ID,
											 P.DATA,
											 P.MOEDA,
											 P.LIQUIDACAO,
											 P.VENCIMENTO,
											 P.DOCUMENTO_NUMERO_01 || '-' || P.DOCUMENTO_NUMERO_02 || '-' || P.DOCUMENTO_NUMERO AS DOC,
											 P.COTA,
											 (SELECT SUM(PP.PAGO_DOLAR) FROM PROVEEDORES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS PAGO_US,
											 (SELECT SUM(PP.PAGO_GUARANI) FROM PROVEEDORES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS PAGO_GS,
											 (SELECT SUM(PP.PAGO_REAL) FROM PROVEEDORES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS PAGO_RS,
											 (SELECT SUM(PP.DIVIDA_DOLAR) FROM PROVEEDORES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS DIV_US,
											 (SELECT SUM(PP.DIVIDA_GUARANI) FROM PROVEEDORES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS DIV_GS,
											 (SELECT SUM(PP.DIVIDA_REAL) FROM PROVEEDORES PP WHERE PP.PERSONA_ID = P.PERSONA_ID AND PP.COTA = P.COTA AND PP.DOCUMENTO_NUMERO_01 = P.DOCUMENTO_NUMERO_01 AND PP.DOCUMENTO_NUMERO_02 = P.DOCUMENTO_NUMERO_02 AND PP.DOCUMENTO_NUMERO = P.DOCUMENTO_NUMERO) AS DIV_RS

								FROM PROVEEDORES P
								INNER JOIN PERSONAS PE
								ON PE.ID = P.PERSONA_ID
								LEFT JOIN ADELANTO_COTAS A
								ON A.ID = P.TABELA_ID
								LEFT JOIN ADELANTOS AD
								ON AD.ID = A.ADELANTO_ID

								WHERE P.MOEDA = #{params[:moeda]} AND P.TABELA = 'ADELANTO_COTAS' AND P.UNIDADE_ID = #{params[:unidade]} AND
									P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
									#{persona_p} #{liq} #{tipo_adelanto}
								ORDER BY 1,7,8,3
							"

				Proveedore.find_by_sql(sqlp)
			end
		end
	end


	def self.controle_func(params)

		persona = "AND persona_id = '#{params[:busca]["persona"]}'" unless params[:busca]["persona"].blank?
		ob  = "AND ob_ref = '#{params[:busca]["obra"]}'" unless params[:busca]["obra"].blank?

		sql = "SELECT
									ENTRADA_SAIDA_FUNC_ID AS ID,
									DATA,
									RESPONSAVEL_NOME,
									OB_REF,
									PERSONA_NOME,
									STATUS,
									DESCRICAO
					 FROM ENTRADA_SAIDA_FUNC_DETALHES
					 WHERE
								 DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{persona} #{ob}
								 ORDER BY 6,2,1 "

		EntradaSaidaFunc.find_by_sql(sql)
	end


	def self.pedidos_vendas(params)

		persona = "AND P.PERSONA_ID  = '#{params[:busca]["persona"]}'" unless params[:busca]["persona"].blank?
		cidade  = "AND P.CIDADE_ID   = '#{params[:busca]["cidade"]}'" unless params[:busca]["cidade"].blank?
		vend    = "AND P.VENDEDOR_ID = '#{params[:busca]["vendedor"]}'" unless params[:busca]["vendedor"].blank?
		status  = "AND P.STATUS = '#{params[:status]}'" unless params[:status].blank?
		marca   = "AND P.SUB_GRUPO_ID = '#{params[:busca]["sub_grupo"]}'" unless params[:busca]["sub_grupo"].blank?
		colecao = "AND P.COLECAO_ID = '#{params[:busca]["colecao"]}'" unless params[:busca]["colecao"].blank?
		regiao  = "AND PS.regiao_id = #{params[:regiao]}" unless  params[:regiao].blank?

		if params[:lancamento].to_s != "1"
			if params[:moeda] == "0"
				moeda = "AND P.MOEDA = 0"
			elsif params[:moeda] == "1"
				moeda = "AND P.MOEDA = 1"
			else
				moeda = "AND P.MOEDA = 2"
			end
		end

		sql = "SELECT
									P.ID,
									P.DATA,
									P.PRAZO_ENTREGA,
									P.PERSONA_ID,
									PS.NOME AS PERSONA_NOME,
									P.VENDEDOR_ID,
									P.VENDEDOR_NOME,
									P.MOEDA,
									P.SUB_GRUPO_ID,
									P.COLECAO_ID,
									P.DOCUMENTO_NUMERO,
									(SELECT SUM(QUANTIDADE) FROM PRESUPUESTO_PRODUTOS WHERE PRESUPUESTO_ID = P.ID ) AS QTD,
									(SELECT SUM(TOTAL_DOLAR) FROM PRESUPUESTO_PRODUTOS WHERE PRESUPUESTO_ID = P.ID ) AS TOT_US,
									(SELECT SUM(TOTAL_GUARANI) FROM PRESUPUESTO_PRODUTOS WHERE PRESUPUESTO_ID = P.ID ) AS TOT_GS,
									(SELECT SUM(TOTAL_REAL) FROM PRESUPUESTO_PRODUTOS WHERE PRESUPUESTO_ID = P.ID ) AS TOT_RS
					 FROM PRESUPUESTOS P
					 LEFT JOIN PERSONAS PS
					 ON P.PERSONA_ID = PS.ID

					 WHERE
								P.UNIDADE_ID = #{params[:busca]['unidade']} AND
								P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{regiao} #{persona} #{vend} #{status} #{marca} #{colecao} #{cidade}
								ORDER BY 2,4,7"
		Presupuesto.find_by_sql(sql)
	end



	def self.pedidos_compras(params)

		persona = "AND P.PERSONA_ID  = '#{params[:busca]["persona"]}'" unless params[:busca]["persona"].blank?
		cidade  = "AND P.CIDADE_ID   = '#{params[:busca]["cidade"]}'" unless params[:busca]["cidade"].blank?
		vend    = "AND P.VENDEDOR_ID = '#{params[:busca]["vendedor"]}'" unless params[:busca]["vendedor"].blank?
		status  = "AND P.STATUS = '#{params[:status]}'" unless params[:status].blank?
		marca   = "AND P.SUB_GRUPO_ID = '#{params[:busca]["sub_grupo"]}'" unless params[:busca]["sub_grupo"].blank?
		colecao = "AND P.COLECAO_ID = '#{params[:busca]["colecao"]}'" unless params[:busca]["colecao"].blank?
		regiao  = "AND PS.regiao_id = #{params[:regiao]}" unless  params[:regiao].blank?

		if params[:lancamento].to_s != "1"
			if params[:moeda] == "0"
				moeda = "AND P.MOEDA = 0"
			elsif params[:moeda] == "1"
				moeda = "AND P.MOEDA = 1"
			else
				moeda = "AND P.MOEDA = 2"
			end
		end

		sql = "SELECT
									P.ID,
									P.DATA,
									P.PERSONA_ID,
									PS.NOME AS PERSONA_NOME,
									P.MOEDA,
									P.SUB_GRUPO_ID,
									P.COLECAO_ID,
									(SELECT SUM(QUANTIDADE) FROM PEDIDO_COMPRA_PRODUTOS WHERE PEDIDO_COMPRA_ID = P.ID ) AS QTD,
									(SELECT SUM(TOTAL_DOLAR) FROM PEDIDO_COMPRA_PRODUTOS WHERE PEDIDO_COMPRA_ID = P.ID ) AS TOT_US,
									(SELECT SUM(TOTAL_GUARANI) FROM PEDIDO_COMPRA_PRODUTOS WHERE PEDIDO_COMPRA_ID = P.ID ) AS TOT_GS,
									(SELECT SUM(TOTAL_REAL) FROM PEDIDO_COMPRA_PRODUTOS WHERE PEDIDO_COMPRA_ID = P.ID ) AS TOT_RS
					 FROM PEDIDO_COMPRAS P
					 LEFT JOIN PERSONAS PS
					 ON P.PERSONA_ID = PS.ID

					 WHERE
								 P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{regiao} #{persona} #{vend} #{status} #{marca} #{colecao} #{cidade}
								 ORDER BY 2,4,7"
		PedidoCompra.find_by_sql(sql)
	end


	def self.pedido_venda_agrupado_cliente(params)
		persona = "AND P.PERSONA_ID = '#{params[:busca]["persona"]}'" unless params[:busca]["persona"].blank?
		vend    = "AND P.VENDEDOR_ID = '#{params[:busca]["vendedor"]}'" unless params[:busca]["vendedor"].blank?
		status  = "AND P.STATUS = '#{params[:status]}'" unless params[:status].blank?
		marca   = "AND P.SUB_GRUPO_ID = '#{params[:busca]["sub_grupo"]}'" unless params[:busca]["sub_grupo"].blank?
		colecao = "AND P.COLECAO_ID = '#{params[:busca]["colecao"]}'" unless params[:busca]["colecao"].blank?
		regiao  = "AND PS.regiao_id = #{params[:regiao]}" unless  params[:regiao].blank?

		if params[:lancamento].to_s != "1"
			if params[:moeda] == "0"
				moeda = "AND P.MOEDA = 0"
			elsif params[:moeda] == "1"
				moeda = "AND P.MOEDA = 1"
			else
				moeda = "AND P.MOEDA = 2"
			end
		end

		sql = "SELECT P.ID,
									P.DATA,
									PS.NOME AS NOME,
									PS.ID AS PERSONA_ID,
									PS.NOME_FATURA AS NOME_FATURA,
									coalesce((SELECT SUM(PP.QUANTIDADE) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.PRESUPUESTO_ID = P.ID),0) AS TOT_PEDIDO,
									coalesce((SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.PRESUPUESTO_ID = P.ID),0) AS TOT_FATURADO,
									coalesce((SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP WHERE VP.PRESUPUESTO_ID = P.ID),0) AS VALOR_FATURADO_US,
									coalesce((SELECT SUM(VP.TOTAL_GUARANI) FROM VENDAS_PRODUTOS VP WHERE VP.PRESUPUESTO_ID = P.ID),0) AS VALOR_FATURADO_GS,
									coalesce((SELECT SUM(VP.TOTAL_REAL) FROM VENDAS_PRODUTOS VP WHERE VP.PRESUPUESTO_ID = P.ID),0) AS VALOR_FATURADO_RS,
									coalesce((SELECT SUM(PP.TOTAL_DOLAR) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.PRESUPUESTO_ID = P.ID),0) AS VALOR_PEDIDO_US,
									coalesce((SELECT SUM(PP.TOTAL_GUARANI) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.PRESUPUESTO_ID = P.ID),0) AS VALOR_PEDIDO_GS,
									coalesce((SELECT SUM(PP.TOTAL_REAL) FROM PRESUPUESTO_PRODUTOS PP WHERE PP.PRESUPUESTO_ID = P.ID),0) AS VALOR_PEDIDO_RS
					 FROM PRESUPUESTOS P
					 LEFT JOIN PERSONAS PS
					 ON P.PERSONA_ID = PS.ID
					 WHERE
							P.UNIDADE_ID = #{params[:busca]["unidade"]} AND
								 P.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{regiao} #{persona} #{vend} #{status} #{marca} #{colecao}
								 ORDER BY 2,4,7"
		Presupuesto.find_by_sql(sql)
	end

def self.egressos(params)

		rubro = "AND E.RUBRO_ID = '#{params[:busca]["rubro"]}'" unless params[:busca]["rubro"].blank?
		conta = "AND E.CONTA_ID = '#{params[:busca]["contas"]}'" unless params[:busca]["contas"].blank?
		st    = "AND E.CLASE_PRODUTO in (#{params[:setores].join(',')})"  unless params[:setores].blank?


		if params[:lancamento].to_s != "1"
			if params[:moeda] == "0"
				moeda = "AND E.MOEDA = 0"
			elsif params[:moeda] == "1"
				moeda = "AND E.MOEDA = 1"
			else
				moeda = "AND E.MOEDA = 2"
			end
		end

		sql = "SELECT
									E.ID,
									E.DATA,
									E.CLASE_PRODUTO,
									S.SIGLA,
									E.MOEDA,
									E.RUBRO_NOME,
									E.CONTA_NOME,
									E.VALOR_GUARANI,
									E.VALOR_DOLAR,
									E.VALOR_REAL,
									E.CONCEPTO
					 FROM EGRESSOS E
					 INNER JOIN SETORS S
					 ON E.CLASE_PRODUTO = S.ID
					 WHERE
								 E.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{rubro} #{conta} #{moeda} #{st}
								 ORDER BY 2,1"

		Egresso.find_by_sql(sql)
	end

def self.ingressos(params)

		rubro = "AND E.RUBRO_ID = '#{params[:busca]["rubro"]}'" unless params[:busca]["rubro"].blank?
		conta = "AND E.CONTA_ID = '#{params[:busca]["contas"]}'" unless params[:busca]["contas"].blank?
		st    = "AND E.CLASE_PRODUTO in (#{params[:setores].join(',')})"  unless params[:setores].blank?


		if params[:lancamento].to_s != "1"
			if params[:moeda] == "0"
				moeda = "AND E.MOEDA = 0"
			elsif params[:moeda] == "1"
				moeda = "AND E.MOEDA = 1"
			else
				moeda = "AND E.MOEDA = 2"
			end
		end

		sql = "SELECT
									E.ID,
									E.DATA,
									E.CLASE_PRODUTO,
									S.SIGLA,
									E.MOEDA,
									E.RUBRO_NOME,
									E.CONTA_NOME,
									E.VALOR_GUARANI,
									E.VALOR_DOLAR,
									E.VALOR_REAL,
									E.CONCEPTO
					 FROM INGRESSOS E
					 INNER JOIN SETORS S
					 ON E.CLASE_PRODUTO = S.ID
					 WHERE
								 E.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{rubro} #{conta} #{moeda} #{st}
								 ORDER BY 2,1"

		Ingresso.find_by_sql(sql)
	end

	def self.demonstr_resultados_vt(params)
		cond    = "AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'"

		sql = "
						-- VENDAS AO CONTADO
						SELECT S.ID AS SETOR,
									CAST(0 AS INTEGER) AS RUBRO_ID,
									CAST('VENTAS AO CONTADO' AS CHARACTER VARYING) AS RUBRO_DESCR,
									(SELECT SUM(VF.TOTAL_DOLAR) FROM VENDAS VF WHERE VF.CLASE_PRODUTO = S.ID AND VF.TIPO = 0 AND VF.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}') AS CREDITO_US,
									CAST(0 AS NUMERIC) AS DEBITO_US,
									CAST(0 AS NUMERIC(15,2)) AS PROJETADO_CREDITO_US,
									CAST(0 AS NUMERIC(15,2)) AS PROJETADO_DEBITO_US
						FROM SETORS S

						UNION ALL

						-- CLIENTES VENCIDOS
						SELECT S.ID AS SETOR,
									CAST(0 AS INTEGER) AS RUBRO_ID,
									CAST('SALDO A COBRAR VENCIDO' AS CHARACTER VARYING) AS RUBRO_DESCR,
									CAST(0 AS NUMERIC) AS CREDITO_US,
									CAST(0 AS NUMERIC) AS DEBITO_US,
									(SELECT SUM(C.DIVIDA_DOLAR - C.COBRO_DOLAR) FROM CLIENTES C WHERE C.CLASE_PRODUTO = S.ID AND C.VENCIMENTO <= '#{params[:final].split("/").reverse.join("-")}') AS PROJETADO_CREDITO_US,
									CAST(0 AS NUMERIC(15,2)) AS PROJETADO_DEBITO_US
						FROM SETORS S

						UNION ALL

						-- CLIENTES VENCIDOS
						SELECT S.ID AS SETOR,
									CAST(0 AS INTEGER) AS RUBRO_ID,
									CAST('SALDO COBRAR A VENCER' AS CHARACTER VARYING) AS RUBRO_DESCR,
									CAST(0 AS NUMERIC) AS CREDITO_US,
									CAST(0 AS NUMERIC) AS DEBITO_US,
									(SELECT SUM(C.DIVIDA_DOLAR - C.COBRO_DOLAR) FROM CLIENTES C WHERE C.CLASE_PRODUTO = S.ID AND C.VENCIMENTO > '#{params[:final].split("/").reverse.join("-")}') AS PROJETADO_CREDITO_US,
									CAST(0 AS NUMERIC(15,2)) AS PROJETADO_DEBITO_US
						FROM SETORS S

						UNION ALL

						-- PROVEEDOR VENCIDOS
						SELECT S.ID AS SETOR,
									CAST(0 AS INTEGER) AS RUBRO_ID,
									CAST('SALDO A PAGAR VENCIDO' AS CHARACTER VARYING) AS RUBRO_DESCR,
									CAST(0 AS NUMERIC) AS CREDITO_US,
									CAST(0 AS NUMERIC) AS DEBITO_US,
									CAST(0 AS NUMERIC(15,2)) AS PROJETADO_CREDITO_US,
									(SELECT SUM(C.DIVIDA_DOLAR - C.PAGO_DOLAR) FROM PROVEEDORES C WHERE C.CLASE_PRODUTO = S.ID AND C.VENCIMENTO <= '#{params[:final].split("/").reverse.join("-")}') AS PROJETADO_DEBITO_US

						FROM SETORS S

						UNION ALL

						-- PROVEEDORES VENCIDOS
						SELECT S.ID AS SETOR,
									CAST(0 AS INTEGER) AS RUBRO_ID,
									CAST('SALDO PAGAR A VENCER' AS CHARACTER VARYING) AS RUBRO_DESCR,
									CAST(0 AS NUMERIC) AS CREDITO_US,
									CAST(0 AS NUMERIC) AS DEBITO_US,
									CAST(0 AS NUMERIC(15,2)) AS PROJETADO_CREDITO_US,
									(SELECT SUM(C.DIVIDA_DOLAR - C.PAGO_DOLAR) FROM PROVEEDORES C WHERE C.CLASE_PRODUTO = S.ID AND C.VENCIMENTO > '#{params[:final].split("/").reverse.join("-")}') AS PROJETADO_DEBITO_US
						FROM SETORS S

						UNION ALL

						-- GASTOS
						SELECT
									C.CLASE_PRODUTO AS SETOR,
									CAST(0 AS INTEGER) AS RUBRO_ID,
									MAX(CAST('GASTOS' AS CHARACTER VARYING)) AS RUBRO_DESCR,
									CAST(0 AS NUMERIC) AS CREDITO_US,
									(SUM(C.TOTAL_DOLAR)) AS DEBITO_US,

									CAST(0 AS NUMERIC(15,2)) AS PROJETADO_CREDITO_US,
									CAST(0 AS NUMERIC(15,2)) AS PROJETADO_DEBITO_US
					 FROM COMPRAS C
					 WHERE C.TIPO_COMPRA = 1 AND C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
					 GROUP BY 1,2

					 UNION ALL

					 -- COBROS
					 SELECT
								 S.ID AS SETOR,
								 CAST(0 AS INTEGER) AS RUBRO_ID,
								 CAST('COBRO DE CLIENTES' AS CHARACTER VARYING) AS RUBRO_DESCR,
								 (SELECT SUM(CD.COBRO_DOLAR) FROM COBROS_DETALHES CD WHERE CD.CLASE_PRODUTO = S.ID AND CD.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}') AS CREDITO_US,
								 CAST(0 AS NUMERIC) AS DEBITO_US,
								 CAST(0 AS NUMERIC(15,2)) AS PROJETADO_CREDITO_US,
								 CAST(0 AS NUMERIC(15,2)) AS PROJETADO_DEBITO_US

					 FROM SETORS S

					 UNION ALL

					 -- PAGOS
					 SELECT
								 S.ID AS SETOR,
								 CAST(0 AS INTEGER) AS RUBRO_ID,
								 CAST('PAGO DE PROVEEDORES' AS CHARACTER VARYING) AS RUBRO_DESCR,
									CAST(0 AS NUMERIC) AS CREDITO_US,
								 (SELECT SUM(CD.PAGO_DOLAR) FROM PAGOS_DETALHES CD WHERE CD.CLASE_PRODUTO = S.ID  AND CD.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}') AS DEBITO_US,
								 CAST(0 AS NUMERIC(15,2)) AS PROJETADO_CREDITO_US,
								 CAST(0 AS NUMERIC(15,2)) AS PROJETADO_DEBITO_US
					 FROM SETORS S
					 ORDER BY 1,4 DESC,2"
		Venda.find_by_sql(sql)
	end



=begin
def self.demonstr_resultados_vt(params)
		cond    = "AND V.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' AND "

		sql = "SELECT S.SIGLA ||'-'||S.NOME as DESC,
									(SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP INNER JOIN VENDAS V ON VP.VENDA_ID = V.ID WHERE VP.CLASE_ID = S.ID #{cond} V.TIPO = 0 AND V.MOEDA = 0) AS credito_US_C,
									(SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP INNER JOIN VENDAS V ON VP.VENDA_ID = V.ID WHERE VP.CLASE_ID = S.ID #{cond} V.TIPO = 1 AND V.MOEDA = 0) AS VP_US_CR,

									(SELECT SUM(VP.TOTAL_GUARANI) FROM VENDAS_PRODUTOS VP INNER JOIN VENDAS V ON VP.VENDA_ID = V.ID WHERE VP.CLASE_ID = S.ID #{cond} V.TIPO = 0 AND V.MOEDA = 1) AS VP_GS_C,
									(SELECT SUM(VP.TOTAL_GUARANI) FROM VENDAS_PRODUTOS VP INNER JOIN VENDAS V ON VP.VENDA_ID = V.ID WHERE VP.CLASE_ID = S.ID #{cond} V.TIPO = 1 AND V.MOEDA = 1) AS VP_GS_CR,

									(SELECT SUM(ST.PROMEDIO_DOLAR * ST.SAIDA) FROM STOCKS ST  INNER JOIN VENDAS V ON ST.COD_PROCESSO = V.ID WHERE ST.CLASE_ID = S.ID #{cond} V.MOEDA = 0 AND ST.TABELA = 'VENDAS_PRODUTOS' AND V.TIPO = 0 ) AS CTM_US_C,
									(SELECT SUM(ST.PROMEDIO_DOLAR * ST.SAIDA) FROM STOCKS ST  INNER JOIN VENDAS V ON ST.COD_PROCESSO = V.ID WHERE ST.CLASE_ID = S.ID #{cond} V.MOEDA = 0 AND ST.TABELA = 'VENDAS_PRODUTOS' AND V.TIPO = 1 ) AS CTM_US_CR,

									(SELECT SUM(ST.PROMEDIO_GUARANI * ST.SAIDA) FROM STOCKS ST  INNER JOIN VENDAS V ON ST.COD_PROCESSO = V.ID WHERE ST.CLASE_ID = S.ID #{cond} V.MOEDA = 0 AND ST.TABELA = 'VENDAS_PRODUTOS' AND V.TIPO = 0 ) AS CTM_GS_C,
									(SELECT SUM(ST.PROMEDIO_GUARANI * ST.SAIDA) FROM STOCKS ST  INNER JOIN VENDAS V ON ST.COD_PROCESSO = V.ID WHERE ST.CLASE_ID = S.ID #{cond} V.MOEDA = 0 AND ST.TABELA = 'VENDAS_PRODUTOS' AND V.TIPO = 1 ) AS CTM_GS_CR
						FROM SETORS S"
		Venda.find_by_sql(sql)
	end


def self.demonstr_resultados_gs(params)
		cond    = "C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'"

		sql = "SELECT
									C.CLASE_PRODUTO AS SETOR,
									C.RUBRO_ID,
									MAX(C.RUBRO_DESCRICAO) AS DESC,
									(SUM(C.TOTAL_DOLAR)) AS TOTAL_US,
									(SUM(C.TOTAL_GUARANI)) AS TOTAL_GS
					 FROM COMPRAS C
					 WHERE C.TIPO_COMPRA = 1 AND
					 #{cond}
					 GROUP BY 1,2

					 UNION ALL

					 SELECT C.SETOR_ID AS SETOR,
									C.RUBRO_ID,
									MAX(C.RUBRO_DESCRICAO) AS DESC,
									(SUM(C.VALOR_DOLAR)) AS TOTAL_US,
									(SUM(C.VALOR_GUARANI)) AS TOTAL_GS
					 FROM ADELANTOS C
					 WHERE #{cond}
					 GROUP BY 1,2
					 ORDER BY 1,3
"
		Compra.find_by_sql(sql)
	end

def self.demonstr_resultados_cd(params)
		cond    = "AND CD.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'"

		sql = "SELECT
								 S.SIGLA ||'-'||S.NOME as DESC,
								 (SELECT SUM(CD.COBRO_DOLAR) FROM COBROS_DETALHES CD WHERE CD.CLASE_PRODUTO = S.ID #{cond}) AS CD_US,
								 (SELECT SUM(CD.COBRO_GUARANI) FROM COBROS_DETALHES CD WHERE CD.CLASE_PRODUTO = S.ID #{cond}) AS CD_GS
					 FROM SETORS S"
		Venda.find_by_sql(sql)
	end


def self.demonstr_resultados_pg(params)
		cond    = "AND CD.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'"

		sql = "SELECT
								 S.SIGLA ||'-'||S.NOME as DESC,
								 (SELECT SUM(CD.PAGO_DOLAR) FROM PAGOS_DETALHES CD WHERE CD.CLASE_PRODUTO = S.ID #{cond}) AS CD_US,
								 (SELECT SUM(CD.PAGO_GUARANI) FROM PAGOS_DETALHES CD WHERE CD.CLASE_PRODUTO = S.ID #{cond}) AS CD_GS
					 FROM SETORS S"
		Venda.find_by_sql(sql)
	end
=end
end
