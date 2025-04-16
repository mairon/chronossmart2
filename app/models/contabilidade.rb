#!/bin/env ruby
# encoding: utf-8

class Contabilidade < ActiveRecord::Base

  #RELATORIOS CONTABEIS==========================================================#
  def self.livro_compra(params)                    #
    unid = "CP.UNIDADE_ID = #{params[:busca]["unidade"]} AND" unless params[:busca]["unidade"].blank?

    if params[:busca]["unidade"].to_s == '1'
      doc = "NC.DOCUMENTO_NUMERO_01 = '001' AND"
    elsif params[:busca]["unidade"].to_s == '4'
      doc = "NC.DOCUMENTO_NUMERO_01 = '002' AND "
    else
      doc = ""
    end

    filtro = " #{unid} C.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' AND CP.FISCAL = 1"

    filtro_nc = " #{doc} NC.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' AND (NC.TOTAL_GUARANI + NC.TOTAL_DOLAR) > 0"
 
    sql = "SELECT 
                  C.ID,
                  C.COMPRA_ID,
                  C.DATA,
                  M.COTACAO_OFICIAL_VENDA AS COT_VD,
                  C.TIPO,
                  C.PERSONA_TIMBRADO  AS TIMBRADO,
                  CP.RUBRO_DESCRICAO AS RN,
                  C.TIPO_COMPRA,
                  C.DOCUMENTO_NUMERO_01 AS DN_01,
                  C.DOCUMENTO_NUMERO_02 AS DN_02,
                  C.DOCUMENTO_NUMERO    AS DN,
                  C.MOEDA,
                  C.DOCUMENTO_ID,
                  P.NOME_FATURA AS PERSONA_NOME,
                  C.PERSONA_ID,
                  P.RUC AS PERSONA_RUC,
                  C.EXENTAS_GUARANI AS EXG,
                  C.EXENTAS_DOLAR  AS EXD ,
                  C.GRAVADAS_05_GUARANI AS GV_05_G,
                  C.GRAVADAS_05_DOLAR  AS GV_05_D,
                  C.IMPOSTO_05_GUARANI AS IP_05_G,
                  C.IMPOSTO_05_DOLAR AS IP_05_D,
                  C.GRAVADAS_10_GUARANI AS GV_10_G,
                  C.GRAVADAS_10_DOLAR AS GV_10_D,
                  C.IMPOSTO_10_GUARANI AS IP_10_G,
                  C.IMPOSTO_10_DOLAR AS IP_10_D,       
                  C.TOTAL_GUARANI AS TOT_G,
                  C.TOTAL_DOLAR AS TOT_D,
                  (SELECT COUNT(CF.ID) FROM COMPRAS_FINANCAS CF WHERE CF.COMPRA_ID = C.COMPRA_ID) AS COTAS
           FROM   
                  COMPRAS_DOCUMENTOS C 
           LEFT JOIN 
                  MOEDAS M
           ON     C.DATA = M.DATA
           LEFT JOIN 
                  COMPRAS CP
           ON     C.COMPRA_ID = CP.ID

           RIGHT JOIN 
                  PERSONAS P
           ON     P.ID = CP.PERSONA_ID

           WHERE  #{filtro}

           UNION ALL
           
           SELECT
                 NC.ID,
                 CAST(0 AS INTEGER),                 
                 NC.DATA,
                 M.COTACAO_OFICIAL_VENDA AS COT_VD,                 
                 NC.TIPO,   
                 CAST('' AS VARCHAR) AS TIMBRADO,    
                 CAST('---' AS VARCHAR) AS RN,
                 CAST(4 AS INTEGER),                                                                              
                 NC.DOCUMENTO_NUMERO_01 AS DN_01,
                 NC.DOCUMENTO_NUMERO_02 AS DN_02,
                 NC.DOCUMENTO_NUMERO AS DN,
                 NC.MOEDA,                 
                 NC.DOCUMENTO_ID,
                 NC.PERSONA_NOME,
                 NC.PERSONA_ID,
                 NC.RUC AS PERSONA_RUC,     
                 NC.EXENTA_GUARANI AS EXG,
                 NC.EXENTA_DOLAR AS EXD,
                 NC.GRAVADA_05_GUARANI AS GV_05_G,
                 NC.GRAVADA_05_DOLAR AS GV_05_D,
                 NC.IMPOSTO_05_GUARANI AS IP_05_G,
                 NC.IMPOSTO_05_DOLAR AS IP_05_D,
                 NC.GRAVADA_10_GUARANI AS GV_10_G,
                 NC.GRAVADA_10_DOLAR AS  GV_10_D,
                 NC.IMPOSTO_10_GUARANI AS IP_10_G, 
                 NC.IMPOSTO_10_DOLAR AS IP_10_D,
                 NC.TOTAL_GUARANI AS TOT_G, 
                 NC.TOTAL_DOLAR AS TOT_D,
                 CAST(0 AS INTEGER) AS COTAS
           FROM 
                 NOTA_CREDITOS NC
           LEFT JOIN 
                  MOEDAS M
           ON    NC.DATA = M.DATA
                       
           WHERE #{filtro_nc}

           ORDER BY 3,1 "

     ComprasDocumento.find_by_sql(sql)
  end

  def self.livro_venda(params)
    filtro   = "DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'"
    filtro_v = "VFAT.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'"
    unidade = "AND VFAT.UNIDADE_ID= #{params[:busca]["unidade"]}"


    sql = "SELECT 
                  CAST(0 AS integer) AS def,
                  V.id,
                  CAST(0 AS integer) AS tabela_id,
                  VFAT.DOC_01 AS documento_numero_01,
                  VFAT.DOC_02 AS documento_numero_02,
                  VFAT.DOC AS documento_numero,
                  VFAT.TIMBRADO AS TIMBRADO,
                  VFAT.TIPO,
                  VFAT.CDC,
                  VFAT.VENCIMENTO,
                  VFAT.MOTIVO,
                  VFAT.TIPO_EMISSAO,
                  VFAT.SERIE,
                  CAST(0 AS integer) AS STATUS,
                  V.moeda,
                  VFAT.data,
                  VFAT.RUC AS ruc,
                  V.persona_id,
                  VFAT.PERSONA_NOME AS persona_nome,
                  (SELECT SUM(VP.TOTAL_GUARANI - VP.DESCONTO_GUARANI) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS TOTAL_GUARANI,
                  COALESCE((SELECT SUM((VP.QUANTIDADE * VP.UNITARIO_GUARANI) - VP.DESCONTO_GUARANI) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 0 ),0) + COALESCE((SELECT SUM(VP.TOTAL_GUARANI * 0.7843137) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 80 ),0) AS EXENTAS_GUARANI,
                  (SELECT SUM(VP.TOTAL_GUARANI - VP.DESCONTO_GUARANI) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 5 ) AS gravadas_05_guarani,
                  ((SELECT SUM(VP.TOTAL_GUARANI - VP.DESCONTO_GUARANI) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 5 ) / 21 ) AS imposto_05_guarani,
                  COALESCE((SELECT SUM(VP.TOTAL_GUARANI- VP.DESCONTO_GUARANI) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 10 ),0) + COALESCE((SELECT SUM(VP.TOTAL_GUARANI - (VP.TOTAL_GUARANI * 0.7843137)) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 80 ),0) AS gravadas_10_guarani,
                  ((SELECT SUM(VP.TOTAL_GUARANI - VP.DESCONTO_GUARANI) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 10 ) / 11)  + (COALESCE((SELECT SUM(VP.TOTAL_GUARANI - (VP.TOTAL_GUARANI * 0.7843137)) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 80 ),0) / 11) AS imposto_10_guarani,
                  V.total_dolar,
                  COALESCE((SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 0 ),0) + COALESCE((SELECT SUM(VP.TOTAL_DOLAR * 0.7843137) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 80 ),0) AS EXENTAS_dolar,
                  (SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 5 ) AS gravadas_05_dolar,
                  ((SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 5 ) / 21 ) AS imposto_05_dolar,
                  COALESCE((SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 10 ),0) + COALESCE((SELECT SUM(VP.TOTAL_DOLAR - (VP.TOTAL_DOLAR * 0.7843137)) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 80 ),0) AS gravadas_10_dolar,
                  ((SELECT SUM(VP.TOTAL_DOLAR) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 10 ) / 11)  + (COALESCE((SELECT SUM(VP.TOTAL_GUARANI - (VP.TOTAL_DOLAR * 0.7843137)) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID AND P.TAXA = 80 ),0) / 11) AS imposto_10_dolar,
                  (SELECT COUNT(VF.ID) FROM VENDAS_FINANCAS VF WHERE VF.VENDA_ID = V.ID AND VF.COTA <> 0) AS COTAS
         FROM FORM_FISCALS VFAT
         LEFT JOIN VENDAS V 
         ON V.ID = VFAT.COD_PROC
         WHERE  VFAT.STATUS = 1 AND #{filtro_v}
         AND  VFAT.TIPO_DOC  = 1 AND VFAT.SIGLA_PROC = 'VT'

         UNION ALL

          SELECT 
                  CAST(0 AS integer) AS def,
                  V.id,
                  CAST(0 AS integer) AS tabela_id,
                  VFAT.DOC_01 AS documento_numero_01,
                  VFAT.DOC_02 AS documento_numero_02,
                  VFAT.DOC AS documento_numero,
                  VFAT.TIMBRADO AS TIMBRADO,
                  VFAT.tipo,
                  VFAT.CDC,
                  VFAT.VENCIMENTO,
                  VFAT.MOTIVO,  
                  VFAT.TIPO_EMISSAO,                
                  VFAT.SERIE,
                  CAST(0 AS integer) AS STATUS,
                  V.moeda,
                  VFAT.data,
                  VFAT.RUC AS ruc,
                  V.persona_id,
                  VFAT.PERSONA_NOME AS persona_nome,
                  (SELECT SUM(VP.TOTAL_GS) FROM CONTRATO_SERVICOS VP WHERE VP.CONTRATO_ID = V.ID) AS TOTAL_GS,
                  COALESCE((SELECT SUM(VP.TOTAL_GS) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 0 ),0) + COALESCE((SELECT SUM(VP.TOTAL_GS * 0.7843137) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 80 ),0) AS EXENTAS_GUARANI,
                  (SELECT SUM(VP.TOTAL_GS) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 5 ) AS gravadas_05_guarani,
                  ((SELECT SUM(VP.TOTAL_GS) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 5 ) / 21 ) AS imposto_05_guarani,
                  COALESCE((SELECT SUM(VP.TOTAL_GS) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 10 ),0) + COALESCE((SELECT SUM(VP.TOTAL_GS - (VP.TOTAL_GS * 0.7843137)) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 80 ),0) AS gravadas_10_guarani,
                  ((SELECT SUM(VP.TOTAL_GS) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 10 ) / 11)  + (COALESCE((SELECT SUM(VP.TOTAL_GS - (VP.TOTAL_GS * 0.7843137)) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 80 ),0) / 11) AS imposto_10_guarani,
                  (SELECT SUM(VP.TOTAL_US) FROM CONTRATO_SERVICOS VP WHERE VP.CONTRATO_ID = V.ID) AS TOTAL_US,
                  COALESCE((SELECT SUM(VP.TOTAL_US) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 0 ),0) + COALESCE((SELECT SUM(VP.TOTAL_US * 0.7843137) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 80 ),0) AS EXENTAS_dolar,
                  (SELECT SUM(VP.TOTAL_US) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 5 ) AS gravadas_05_dolar,
                  ((SELECT SUM(VP.TOTAL_US) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 5 ) / 21 ) AS imposto_05_dolar,
                  COALESCE((SELECT SUM(VP.TOTAL_US) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 10 ),0) + COALESCE((SELECT SUM(VP.TOTAL_US - (VP.TOTAL_US * 0.7843137)) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 80 ),0) AS gravadas_10_dolar,
                  ((SELECT SUM(VP.TOTAL_US) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 10 ) / 11)  + (COALESCE((SELECT SUM(VP.TOTAL_GS - (VP.TOTAL_US * 0.7843137)) FROM CONTRATO_SERVICOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.CONTRATO_ID = V.ID AND P.TAXA = 80 ),0) / 11) AS imposto_10_dolar,
                  0 AS COTAS
         FROM FORM_FISCALS VFAT

         LEFT JOIN CLIENTES C 
         ON C.ID = VFAT.COD_PROC AND C.SIGLA_PROC = 'CT'

         LEFT JOIN CONTRATOS V 
         ON V.ID = C.COD_PROC

         WHERE  VFAT.STATUS = 1 AND #{filtro_v} AND V.MOEDA = 0
         AND  VFAT.TIPO_DOC  = 1 AND VFAT.SIGLA_PROC = 'CL'

         UNION ALL


        SELECT 
                  CAST(0 AS integer) AS def,
                  VFAT.id,
                  CAST(0 AS integer) AS tabela_id,
                  VFAT.DOC_01 AS documento_numero_01,
                  VFAT.DOC_02 AS documento_numero_02,
                  VFAT.DOC AS documento_numero,
                  VFAT.TIMBRADO AS TIMBRADO,
                  VFAT.tipo,
                  VFAT.CDC,
                  VFAT.VENCIMENTO,
                  VFAT.MOTIVO,                    
                  VFAT.TIPO_EMISSAO,                
                  VFAT.SERIE,
                  CAST(0 AS integer) AS STATUS,
                  VFAT.moeda,
                  VFAT.data,
                  VFAT.RUC AS ruc,
                  VFAT.persona_id,
                  VFAT.PERSONA_NOME AS persona_nome,
                  VFAT.TOT_GS AS TOTAL_GUARANI,
                  CAST(0 AS numeric(15,2)) AS EXENTAS_GUARANI,
                  CAST(0 AS numeric(15,2)) AS gravadas_05_guarani,
                  CAST(0 AS numeric(15,2)) AS imposto_05_guarani,
                  VFAT.TOT_GS AS gravadas_10_guarani,
                  (VFAT.TOT_GS / 11) AS imposto_10_guarani,
                  VFAT.TOT_US AS TOTAL_DOLAR,
                  CAST(0 AS numeric(15,2)) AS exentas_dolar,
                  CAST(0 AS numeric(15,2)) AS gravadas_05_dolar,
                  CAST(0 AS numeric(15,2)) AS imposto_05_dolar,
                  VFAT.TOT_US AS gravadas_10_dolar,
                  CAST(0 AS numeric(15,2)) AS imposto_10_dolar,
                  1 AS COTAS
         FROM FORM_FISCALS VFAT
         INNER JOIN COBROS C
         ON C.ID = VFAT.COD_PROC 
         WHERE  VFAT.STATUS = 1 AND #{filtro_v}

         AND  VFAT.TIPO_DOC  = 1 AND VFAT.SIGLA_PROC = 'CB'

         UNION ALL


        SELECT 
                  CAST(0 AS integer) AS def,
                  VFAT.id,
                  CAST(0 AS integer) AS tabela_id,
                  VFAT.DOC_01 AS documento_numero_01,
                  VFAT.DOC_02 AS documento_numero_02,
                  VFAT.DOC AS documento_numero,
                  VFAT.TIMBRADO AS TIMBRADO,
                  VFAT.tipo,
                  VFAT.CDC,
                  VFAT.VENCIMENTO,
                  VFAT.MOTIVO,    
                  VFAT.TIPO_EMISSAO,
                  VFAT.SERIE,
                  CAST(0 AS integer) AS STATUS,
                  VFAT.moeda,
                  VFAT.data,
                  VFAT.RUC AS ruc,
                  VFAT.persona_id,
                  VFAT.PERSONA_NOME AS persona_nome,
                  VFAT.TOT_GS AS TOTAL_GUARANI,
                  CAST(0 AS numeric(15,2))AS EXENTAS_GUARANI,
                  CAST(0 AS numeric(15,2)) AS gravadas_05_guarani,
                  CAST(0 AS numeric(15,2)) AS imposto_05_guarani,
                  VFAT.TOT_GS AS gravadas_10_guarani,
                  VFAT.TOT_GS AS imposto_10_guarani,
                  VFAT.TOT_US AS TOTAL_DOLAR,
                  CAST(0 AS numeric(15,2)) AS exentas_dolar,
                  CAST(0 AS numeric(15,2)) AS gravadas_05_dolar,
                  CAST(0 AS numeric(15,2)) AS imposto_05_dolar,
                  VFAT.TOT_US AS gravadas_10_dolar,
                  VFAT.TOT_US AS imposto_10_dolar,
                  1 AS COTAS
         FROM FORM_FISCALS VFAT
         WHERE  VFAT.STATUS = 1 AND #{filtro_v}
         AND  VFAT.TIPO_DOC  = 1 AND VFAT.SIGLA_PROC = 'VTI'
         ORDER BY 11,6"
                  
    Fatura.find_by_sql(sql)
  end

  def self.livro_diario(params)                    #

      if params[:lancamento].to_s != "1"
         if params[:moeda] == "0"
            moeda = "AND D.MOEDA = 0"
         elsif params[:moeda] == "1"
            moeda = "AND D.MOEDA = 1"
          else
            moeda = "AND D.MOEDA = 2"
         end
      end

    filtro = "D.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}}'  AND  '#{params[:final].split("/").reverse.join("-")}' #{moeda}"

    Diario.find_by_sql("SELECT
                                  D.ID,
                                  0 AS ORDEM,
                                  D.DATA,
                                  ( SELECT SIGLA FROM DOCUMENTOS WHERE NOME = D.DOCUMENTO_NOME ) AS SIGLA,
                                  D.TABELA_ID,
                                  D.DOCUMENTO_NUMERO_01,
                                  D.DOCUMENTO_NUMERO_02,
                                  D.DOCUMENTO_NUMERO,
                                  D.TABELA_NOME,
                                  CAST( DD.CONTABILIDADE AS VARCHAR(25) ) AS CONTABILIDADE,
                                  CAST( P.DESCRICAO AS VARCHAR(80) ) AS DESCRIPCION,
                                  DD.VALOR_GUARANI AS DEBE_GS,
                                  DD.VALOR_DOLAR AS DEBE_US,
                                  0.00 AS HABER_GS,
                                  0.00 AS HABER_US

                            FROM
                                  DIARIOS D
                            LEFT JOIN
                                  DIARIO_DEBES DD
                                  ON ( DD.DIARIO_ID=D.ID )
                            LEFT JOIN
                                  PLANO_DE_CONTAS P
                                  ON ( P.CODIGO=DD.CONTABILIDADE )
                            WHERE
                                 #{filtro}

                            UNION ALL

                            SELECT
                                  D.ID,
                                  1 AS ORDEM,
                                  D.DATA,
                                  ( SELECT SIGLA FROM DOCUMENTOS WHERE NOME = D.DOCUMENTO_NOME ) AS SIGLA,
                                  D.TABELA_ID,
                                  D.DOCUMENTO_NUMERO_01,
                                  D.DOCUMENTO_NUMERO_02,
                                  D.DOCUMENTO_NUMERO,
                                  D.TABELA_NOME,
                                  CAST( DH.CONTABILIDADE AS VARCHAR(25) ) AS CONTABILIDADE,
                                  CAST( P.DESCRICAO AS VARCHAR(80) ) AS DESCRIPCION,
                                  0.00 AS DEBE_GS,
                                  0.00 AS DEBE_US,
                                  DH.VALOR_GUARANI AS HABER_GS,
                                  DH.VALOR_DOLAR AS HABER_US

                            FROM
                                  DIARIOS D
                            LEFT JOIN
                                  DIARIO_HABERS DH
                                  ON ( DH.DIARIO_ID=D.ID )
                            LEFT JOIN
                                  PLANO_DE_CONTAS P
                                  ON ( P.CODIGO=DH.CONTABILIDADE )
                            WHERE
                                 #{filtro}

                            UNION ALL

                            SELECT
                                  D.ID,
                                  2 AS ORDEM,
                                  D.DATA,
                                  ( SELECT SIGLA FROM DOCUMENTOS WHERE NOME = D.DOCUMENTO_NOME ) AS SIGLA,
                                  D.TABELA_ID,
                                  D.DOCUMENTO_NUMERO_01,
                                  D.DOCUMENTO_NUMERO_02,
                                  D.DOCUMENTO_NUMERO,
                                  D.TABELA_NOME,
                                  CAST( ' ' AS VARCHAR(25) ) AS CONTABILIDADE,
                                  CAST( D.DESCRICAO AS VARCHAR(80) ) AS DESCRIPCION,
                                  (SELECT COALESCE(SUM(SDD.VALOR_GUARANI),0 ) FROM DIARIO_DEBES SDD WHERE SDD.DIARIO_ID = D.ID ) AS DEBE_GS,
                                  (SELECT COALESCE(SUM(SDD.VALOR_DOLAR),0 ) FROM DIARIO_DEBES SDD WHERE SDD.DIARIO_ID = D.ID ) AS DEBE_US,
                                  (SELECT COALESCE(SUM(SDH.VALOR_GUARANI),0 ) FROM DIARIO_HABERS SDH WHERE SDH.DIARIO_ID = D.ID ) AS HABER_GS,
                                  (SELECT COALESCE(SUM(SDH.VALOR_DOLAR),0 ) FROM DIARIO_HABERS SDH WHERE SDH.DIARIO_ID = D.ID ) AS HABER_US

                            FROM
                                  DIARIOS D
                            WHERE
                                 #{filtro}

                            ORDER BY
                                  3, 1, 2

            ")
  end

  def self.livro_mayor(params)
        
        if params[:lancamento].to_s != "1"
         if params[:moeda] == "0"
            moeda = "AND D.MOEDA = 0"
         elsif params[:moeda] == "1"
            moeda = "AND D.MOEDA = 1"
          else
            moeda = "AND D.MOEDA = 2"
         end
      end
    filtro  = "AND CONTABILIDADE  BETWEEN  '#{params[:codigo_inicio]}' AND '#{params[:codigo_final]}' #{moeda}" unless params[:codigo_inicio].blank?

    sql = "
        SELECT
              DD.DIARIO_ID,
              DD.CONTABILIDADE,
              P.DESCRICAO AS CONTABILIDADE_DESCRICAO,
              DD.DATA,
              D.TABELA_NOME,
              D.TABELA_ID AS PROCESO_NUMERO,
              D.DOCUMENTO_NOME,
              D.DOCUMENTO_NUMERO,
              D.DESCRICAO,
              DD.VALOR_GUARANI AS DEBE_GS,
              DD.VALOR_DOLAR AS DEBE_US,
              CAST( 0.00 AS NUMERIC(15,2) ) AS HABER_GS,
              CAST( 0.00 AS NUMERIC(15,2) ) AS HABER_US,
              D.ID
        FROM
              DIARIO_DEBES DD
        LEFT JOIN
              DIARIOS D
              ON ( D.ID=DD.DIARIO_ID )
        LEFT JOIN
              PLANO_DE_CONTAS P
              ON ( P.CODIGO=DD.CONTABILIDADE )
        WHERE
              D.UNIDADE_ID = #{params[:unidade]} AND D.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}}' AND '#{params[:final].split("/").reverse.join("-")}}'
              #{filtro}
        UNION ALL
        SELECT
              DH.DIARIO_ID,
              DH.CONTABILIDADE,
              P.DESCRICAO AS CONTABILIDADE_DESCRICAO,
              DH.DATA,
              D.TABELA_NOME,
              D.TABELA_ID AS PROCESO_NUMERO,
              D.DOCUMENTO_NOME,
              D.DOCUMENTO_NUMERO,
              D.DESCRICAO,
              CAST( 0.00 AS NUMERIC(15,2) ) AS DEBER_GS,
              CAST( 0.00 AS NUMERIC(15,2) ) AS DEBER_US,
              DH.VALOR_GUARANI AS HABER_GS,
              DH.VALOR_DOLAR AS HABER_US,
              D.ID
        FROM
              DIARIO_HABERS DH
        LEFT JOIN
              DIARIOS D
              ON ( D.ID=DH.DIARIO_ID )
        LEFT JOIN
              PLANO_DE_CONTAS P
              ON ( P.CODIGO=DH.CONTABILIDADE )
        WHERE
              D.UNIDADE_ID = #{params[:unidade]} AND D.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}}' AND '#{params[:final].split("/").reverse.join("-")}}'
              #{filtro}
        ORDER BY
              2, 3, 4, 6,11

        "
    Diario.find_by_sql(sql)
  end

  def self.livro_mayor_produtos(params)
    dd_prod  = " AND dd.produto_id  = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
    dd_clase = " AND dd.clase_id  = #{params[:busca]["clase"]}"  unless params[:busca]["clase"].blank?
    dd_grupo = " AND dd.grupo_id  = #{params[:busca]["grupo"]}"  unless params[:busca]["grupo"].blank?
    
    dh_prod  = " AND dh.produto_id  = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
    dh_clase = " AND dh.clase_id  = #{params[:busca]["clase"]}"  unless params[:busca]["clase"].blank?
    dh_grupo = " AND dh.grupo_id  = #{params[:busca]["grupo"]}"  unless params[:busca]["grupo"].blank?

    filtro  = "AND CONTABILIDADE  BETWEEN  '#{params[:codigo_inicio]}' AND '#{params[:codigo_final]}'" unless params[:codigo_inicio].blank?

    sql = "
        SELECT
              DD.DIARIO_ID,
              DD.CONTABILIDADE,
              P.DESCRICAO AS CONTABILIDADE_DESCRICAO,
              DD.DATA,
              D.TABELA_NOME,
              D.TABELA_ID AS PROCESO_NUMERO,
              D.DOCUMENTO_NOME,
              D.DOCUMENTO_NUMERO,
              D.DESCRICAO,
              DD.CLASE_ID,
              DD.GRUPO_ID,
              DD.PRODUTO_ID,
              DD.PRODUTO_NOME,
              DD.VALOR_GUARANI AS DEBE_GS,
              DD.VALOR_DOLAR AS DEBE_US,
              CAST( 0.00 AS NUMERIC(15,2) ) AS HABER_GS,
              CAST( 0.00 AS NUMERIC(15,2) ) AS HABER_US,
              D.ID
        FROM
              DIARIO_DEBES DD
        LEFT JOIN
              DIARIOS D
              ON ( D.ID=DD.DIARIO_ID )
        LEFT JOIN
              PLANO_DE_CONTAS P
              ON ( P.CODIGO=DD.CONTABILIDADE )
        WHERE
              D.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}}' AND '#{params[:final].split("/").reverse.join("-")}}'
              #{filtro} #{dd_prod} #{dd_clase} #{dd_grupo}
        UNION ALL
        SELECT
              DH.DIARIO_ID,
              DH.CONTABILIDADE,
              P.DESCRICAO AS CONTABILIDADE_DESCRICAO,
              DH.DATA,
              D.TABELA_NOME,
              D.TABELA_ID AS PROCESO_NUMERO,
              D.DOCUMENTO_NOME,
              D.DOCUMENTO_NUMERO,
              D.DESCRICAO,
              DH.CLASE_ID,
              DH.GRUPO_ID,
              DH.PRODUTO_ID,
              DH.PRODUTO_NOME,
              CAST( 0.00 AS NUMERIC(15,2) ) AS DEBER_GS,
              CAST( 0.00 AS NUMERIC(15,2) ) AS DEBER_US,
              DH.VALOR_GUARANI AS HABER_GS,
              DH.VALOR_DOLAR AS HABER_US,
              D.ID
        FROM
              DIARIO_HABERS DH
        LEFT JOIN
              DIARIOS D
              ON ( D.ID=DH.DIARIO_ID )
        LEFT JOIN
              PLANO_DE_CONTAS P
              ON ( P.CODIGO=DH.CONTABILIDADE )
        WHERE
              D.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}}' AND '#{params[:final].split("/").reverse.join("-")}}'
              #{filtro} #{dh_prod} #{dh_clase} #{dh_grupo}
        ORDER BY
              2, 3, 4, 5,11

        "
    Diario.find_by_sql(sql)
  end


  def self.balance(params)
    filtro = "data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}}' AND '#{params[:final].split("/").reverse.join("-")}}'"

    PlanoDeConta.all(:order => 'codigo')

  end

  def self.balance_general(params)                 #

    filtro = "data BETWEEN '#{params[:inicio].split("/").reverse.join("-")}}' AND '#{params[:final].split("/").reverse.join("-")}}'"

    PlanoDeConta.all(:order => 'codigo')

  end

  def self.resumo_compra(params)                          #

    filtro = "date_part('month', C.DATA) = '#{params[:mes]}'  AND  date_part('year', C.DATA) = '#{params[:ano]}' AND C.DOCUMENTO_ID > 1 AND C.DOCUMENTO_ID < 4 OR date_part('month', C.DATA) = '#{params[:mes]}'  AND  date_part('year', C.DATA) = '#{params[:ano]}' AND C.DOCUMENTO_ID = 11"

    filtro_mq_usado = "date_part('month', C.DATA_EMICAO) = '#{params[:mes]}'  AND  date_part('year', C.DATA_EMICAO) = '#{params[:ano]}' AND C.DOCUMENTO_ID > 1 AND C.DOCUMENTO_ID < 4 OR date_part('month', C.DATA) = '#{params[:mes]}'  AND  date_part('year', C.DATA) = '#{params[:ano]}' AND C.DOCUMENTO_ID = 11"

    filtro_nc = "date_part('month', NC.DATA) = '#{params[:mes]}'  AND  date_part('year', NC.DATA) = '#{params[:ano]}'"
 
    sql = "SELECT 
                  C.ID,
                  C.COMPRA_ID,
                  C.RUBRO_ID,
                  C.RUBRO_NOME,
                  C.DATA,
                  M.COTACAO_OFICIAL_VENDA AS COT_VD,
                  C.TIPO,
                  C.PERSONA_TIMBRADO  AS TIMBRADO,
                  CP.RUBRO_DESCRICAO AS RN,
                  C.TIPO_COMPRA,
                  C.DOCUMENTO_NUMERO_01 AS DN_01,
                  C.DOCUMENTO_NUMERO_02 AS DN_02,
                  C.DOCUMENTO_NUMERO    AS DN,
                  C.MOEDA,
                  C.DOCUMENTO_ID,
                  C.PERSONA_NOME,
                  C.PERSONA_RUC,
                  C.EXENTAS_GUARANI AS EXG,
                  C.EXENTAS_DOLAR  AS EXD ,
                  C.GRAVADAS_05_GUARANI AS GV_05_G,
                  C.GRAVADAS_05_DOLAR  AS GV_05_D,
                  C.IMPOSTO_05_GUARANI AS IP_05_G,
                  C.IMPOSTO_05_DOLAR AS IP_05_D,
                  C.GRAVADAS_10_GUARANI AS GV_10_G,
                  C.GRAVADAS_10_DOLAR AS GV_10_D,
                  C.IMPOSTO_10_GUARANI AS IP_10_G,
                  C.IMPOSTO_10_DOLAR AS IP_10_D,       
                  C.TOTAL_GUARANI AS TOT_G,
                  C.TOTAL_DOLAR AS TOT_D
           FROM   
                  COMPRAS_DOCUMENTOS C 
           INNER JOIN 
                  MOEDAS M
           ON     C.DATA = M.DATA
           LEFT JOIN 
                  COMPRAS CP
           ON     C.COMPRA_ID = CP.ID

           WHERE  #{filtro}

           UNION ALL 

           SELECT C.ID,
                  CAST(0 AS INTEGER),
                  CAST(0 AS INTEGER),
                  CAST('COMPRAS' AS VARCHAR),
                  C.DATA_EMICAO,
                  M.COTACAO_OFICIAL_VENDA AS COT_VD,
                  CAST(0 AS INTEGER),
                  C.DOCUMENTO_TIMBRADO AS TIMBRADO,
                  CAST('---' AS VARCHAR) AS RN,
                  CAST(0 AS INTEGER),
                  C.DOCUMENTO_NUMERO_01 AS DN_01,
                  C.DOCUMENTO_NUMERO_02 AS DN_02,
                  C.DOCUMENTO_NUMERO    AS DN,
                  C.MOEDA,
                  C.DOCUMENTO_ID,
                  C.PERSONA_NOME,
                  CAST('--' AS VARCHAR),
                  C.EXENTAS_GUARANI AS EXG,
                  C.EXENTAS_DOLAR  AS EXD ,
                  C.GRAVADAS_05_GUARANI AS GV_05_G,
                  C.GRAVADAS_05_DOLAR  AS GV_05_D,
                  C.IMPOSTO_05_GUARANI AS IP_05_G,
                  C.IMPOSTO_05_DOLAR AS IP_05_D,
                  C.GRAVADAS_10_GUARANI AS GV_10_G,
                  C.GRAVADAS_10_DOLAR AS GV_10_D,
                  C.IMPOSTO_10_GUARANI AS IP_10_G,
                  C.IMPOSTO_10_DOLAR AS IP_10_D,       
                  C.TOTAL_GUARANI AS TOT_G,
                  C.TOTAL_DOLAR AS TOT_D
           FROM   
                  VENDAS_ENTRADA_PRODUTOS C 
           LEFT JOIN 
                  MOEDAS M
           ON     C.DATA_EMICAO = M.DATA
           WHERE  #{filtro_mq_usado}


           UNION ALL
           
           SELECT
                 NC.ID,
                 CAST(0 AS INTEGER),  
                 CAST(0 AS INTEGER),   
                 CAST('COMPRAS' AS VARCHAR),                             
                 NC.DATA,
                 M.COTACAO_OFICIAL_VENDA AS COT_VD,                 
                 NC.TIPO,   
                 CAST('--' AS VARCHAR),    
                 CAST('---' AS VARCHAR) AS RN,
                 CAST(4 AS INTEGER),                                                                              
                 NC.DOCUMENTO_NUMERO_01 AS DN_01,
                 NC.DOCUMENTO_NUMERO_02 AS DN_02,
                 NC.DOCUMENTO_NUMERO AS DN,
                 NC.MOEDA,                 
                 NC.DOCUMENTO_ID,
                 NC.PERSONA_NOME,
                 CAST('--' AS VARCHAR),     
                 ( SELECT SUM(TOTAL_GUARANI) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 0 AND NOTA_CREDITO_ID = NC.ID) AS EXG,
                 ( SELECT SUM(TOTAL_DOLAR) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 0 AND NOTA_CREDITO_ID = NC.ID) AS EXD,
                 ( SELECT SUM(TOTAL_GUARANI) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 5 AND NOTA_CREDITO_ID = NC.ID) AS GV_05_G,
                 ( SELECT SUM(TOTAL_DOLAR) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 5 AND NOTA_CREDITO_ID = NC.ID) AS GV_05_D,
                 ( SELECT SUM(TOTAL_GUARANI / 11) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 5 AND NOTA_CREDITO_ID = NC.ID) AS IP_05_G,
                 ( SELECT SUM(TOTAL_DOLAR / 11) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 5 AND NOTA_CREDITO_ID = NC.ID) AS IP_05_D,
                 ( SELECT SUM(TOTAL_GUARANI) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS GV_10_G,
                 ( SELECT SUM(TOTAL_DOLAR) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS  GV_10_D,
                 ( SELECT SUM(TOTAL_GUARANI  / 11 ) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS IP_10_G, 
                 ( SELECT SUM(TOTAL_DOLAR / 11 ) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS IP_10_D,
                 ( SELECT SUM(TOTAL_GUARANI ) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS TOT_G, 
                 ( SELECT SUM(TOTAL_DOLAR ) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS TOT_D
           FROM 
                 NOTA_CREDITOS NC
           LEFT JOIN 
                  MOEDAS M
           ON    NC.DATA = M.DATA
                       
           WHERE #{filtro_nc}

           ORDER BY 3,1 "

     ComprasDocumento.find_by_sql(sql)  
  end
  
  def self.resumo_vendas(params)                     #

    filtro = "DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}}' AND '#{params[:final].split("/").reverse.join("-")}}'"

   sql = "SELECT 
                  CAST(0 AS integer) AS def,
                  id,
                  tabela_id,
                  documento_numero_01,
                  documento_numero_02,
                  documento_numero,
                  tipo,
                  status,
                  moeda,
                  data,
                  ruc,
                  persona_id,
                  persona_nome,
                  total_guarani,
                  exentas_guarani,
                  gravadas_05_guarani,
                  imposto_05_guarani,
                  gravadas_10_guarani,
                  imposto_10_guarani,
                  total_dolar,
                  exentas_dolar,
                  gravadas_05_dolar,
                  imposto_05_dolar,
                  gravadas_10_dolar,
                  imposto_10_dolar
         FROM FATURAS
         WHERE  #{filtro}  
                         
         UNION ALL
         
         SELECT
               CAST(1 AS integer) AS def,         
               id,
               CAST(0 AS integer) AS tabela_id,
               documento_numero_01,
               documento_numero_02,
               documento_numero,
               tipo,
               CAST(0 AS INTEGER) AS status,
               moeda,
               data,
               CAST('---' AS VARCHAR) AS ruc,
               persona_id,
               persona_nome,
               TOTAL_GUARANI AS total_guarani,
               CAST(0 AS INTEGER) AS exentas_guarani,
               CAST(0 AS INTEGER) AS gravadas_05_guarani,
               CAST(0 AS INTEGER) AS imposto_05_guarani,
               TOTAL_GUARANI AS gravadas_10_guarani,
               CAST(0 AS INTEGER) AS imposto_10_guarani,
               TOTAL_DOLAR AS total_dolar,
               CAST(0 AS INTEGER) AS exentas_dolar,
               CAST(0 AS INTEGER) AS gravadas_05_dolar,
               CAST(0 AS INTEGER) As imposto_05_dolar,
               TOTAL_DOLAR AS gravadas_10_dolar,
               CAST(0 AS INTEGER) AS imposto_10_dolar
         FROM NOTA_CREDITO_PROVEEDORS         
         WHERE  #{filtro}
         ORDER BY 10,6"

    Fatura.find_by_sql(sql)
  end
  def self.generar_acientos_contables(params)
    #FILTRO MES ANO
    filtro = "  DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'"
    #ELIMINA LANCAMENTOS QUANDO TABELA_ID FOR NULL
    Diario.destroy_all("#{filtro}      AND TABELA_ID IS NOT NULL" )

    #gastos
    compras_gasto = Compra.where(filtro << 'and tipo_compra = 1')
    compras_gasto.each do |g|
      diario =  Diario.create(
                  unidade_id:          g.unidade_id,
                  documento_id:        g.documento_id,
                  data:                g.data,
                  cotacao:             g.total_dolar,
                  descricao:           g.descricao,
                  documento_numero:    g.documento_numero,
                  documento_numero_01: g.documento_numero_01,
                  documento_numero_02: g.documento_numero_02,
                  sigla:               'CG',
                  moeda:               g.moeda,
                  tabela_nome:        'COMPRAS',
                  tabela_id:           g.id )

        DiarioDebe.create( :tabela_id        => g.id.to_i,
                           :tabela_nome      => 'COMPRAS_GASTOS',
                           :diario_id        => diario.id,
                           :data             => g.data,
                           :persona_id       => g.persona_id,
                           :persona_nome     => g.persona_nome,
                           :contabilidade    => g.rubro_cod_contabil,
                           :descricao        => g.rubro_descricao,
                           :cotacao          => g.cotacao.to_f,
                           :valor_dolar      => g.total_dolar.to_f,
                           :valor_guarani    => g.total_guarani.to_f)


        #CREDITO FINANZAS/CLIENTE
        compra_finacas = ComprasFinanca.all( :conditions => ["compra_id = ?", g.id.to_i] )

          compra_finacas.each do |cf|
            DiarioHaber.create( :tabela_id       => cf.id.to_i,
                               :tabela_nome      => 'COMPRAS_FINANCAS',
                               :diario_id        => diario.id,
                               :data             => g.data,
                               :persona_id       => g.persona_id,
                               :persona_nome     => g.persona_nome,
                               :contabilidade    => '2.01.01.002',
                               :descricao        => 'CUENTAS A PAGAR PROVEEDORES SERVICIOS',
                               :cotacao          => g.cotacao.to_f,
                               :valor_dolar      => cf.valor_dolar,
                               :valor_guarani    => cf.valor_guarani )

          end
      end

    #compras
    filtro = "  DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'"
    
    compras_mercadoria = Compra.where(filtro << ' and tipo_compra = 0 ')
    compras_mercadoria.each do |c|
      diario =  Diario.create(
                  unidade_id:          c.unidade_id,
                  documento_id:        c.documento_id,
                  data:                c.data,
                  cotacao:             c.cotacao,
                  descricao:           c.descricao,
                  documento_numero:    c.documento_numero,
                  documento_numero_01: c.documento_numero_01,
                  documento_numero_02: c.documento_numero_02,
                  sigla:               'CG',
                  moeda:               c.moeda,
                  tabela_nome:        'COMPRAS',
                  tabela_id:           c.id )
      compra_produtos = ComprasProduto.all( :conditions => ["compra_id = ?", c.id.to_i] )
      compra_produtos.each do |cp|
        DiarioDebe.create( :tabela_id        => cp.id.to_i,
                           :tabela_nome      => 'COMPRAS_PRODUTOS',
                           :diario_id        => diario.id,
                           :data             => c.data,
                           :persona_id       => c.persona_id,
                           :persona_nome     => c.persona_nome,
                           :contabilidade    => '1.03.01.001',
                           :descricao        => 'STOCK',
                           :cotacao          => c.cotacao.to_f,
                           :valor_dolar      => cp.total_dolar.to_f,
                           :valor_guarani    => cp.total_guarani.to_f)
      end

        #CREDITO FINANZAS/CLIENTE
        compra_finacas = ComprasFinanca.all( :conditions => ["compra_id = ?", c.id.to_i] )

          compra_finacas.each do |cf|
            DiarioHaber.create( :tabela_id       => cf.id.to_i,
                               :tabela_nome      => 'COMPRAS_FINANCAS',
                               :diario_id        => diario.id,
                               :data             => c.data,
                               :persona_id       => c.persona_id,
                               :persona_nome     => c.persona_nome,
                               :contabilidade    => '2.01.01.002',
                               :descricao        => 'CUENTAS A PAGAR PROVEEDORES SERVICIOS',
                               :cotacao          => c.cotacao.to_f,
                               :valor_dolar      => cf.valor_dolar,
                               :valor_guarani    => cf.valor_guarani )

          end
      end


    filtro = "  DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'"
    #lancamento contabil pagos
    pagos = Pago.all( :conditions =>  filtro + 'AND ADELANTO <> 1' )
  
    pagos.each do |p|

      pagos_fin = PagosFinanca.last(:conditions => ["pago_id = ?", p.id])
      if pagos_fin != nil
      diario =  Diario.create( :tabela_id        => p.id.to_i,
                               :unidade_id       =>  p.unidade_id,
                               :tabela_nome      => 'PAGOS',
                               :data             => p.data,
                               :cotacao          => p.cotacao.to_f,
                               :moeda            => p.moeda,
                               :descricao        => 'PAGO  ' + p.persona_nome.to_s + ' doc. ' + pagos_fin.numero_recibo.to_s,
                               :documento_id     => pagos_fin.documento_id,
                               :documento_nome   => pagos_fin.documento_nome,
                               :documento_numero => pagos_fin.numero_recibo )
      else

      diario =  Diario.create( :tabela_id        => p.id.to_i,
                               :tabela_nome      => 'PAGOS',
                               :data             => p.data,
                               :cotacao          => p.cotacao.to_f,
                               :moeda            => p.moeda,
                               :descricao        => 'PAGO  ' + p.persona_nome.to_s + ' doc. ')
      end

        #CREDITO FINANCAS
        pagos_financa = PagosFinanca.all( :conditions => ["pago_id = ?", p.id.to_i] )

          pagos_financa.each do |pf|

            cod_contabil_conta     = Conta.find_by_id( pf.conta_id,:select => 'id,cod_contabil,rubro_nome' )

            DiarioHaber.create( :tabela_id        => pf.id.to_i,
                               :tabela_nome      => 'PAGOS_FINANCAS',
                               :diario_id        => diario.id,
                               :data             => p.data,
                               :contabilidade    => cod_contabil_conta.cod_contabil,
                               :descricao        => cod_contabil_conta.rubro_nome,
                               :cotacao          => p.cotacao.to_f,
                               :valor_dolar      => pf.valor_dolar,
                               :valor_guarani    => pf.valor_guarani )
        end

        #DEBITO PROV
        pagos_detalhe = PagosDetalhe.all( :conditions => ["pago_id = ?", p.id.to_i] )

        pagos_detalhe.each do |pd|

          if p.clase_produto == 0
            cod = '2.01.01.001'
            desc_cod = 'Proveedores repuestos'
          else
            cod = '2.01.01.002'
            desc_cod = 'Proveedores Máquinas'
          end


          DiarioDebe.create( :tabela_id        => pd.id.to_i,
                              :tabela_nome      => 'PAGOS_DETALHES',
                              :diario_id        => diario.id,
                              :data             => p.data,
                              :contabilidade    => cod,
                              :descricao        => desc_cod,
                              :cotacao          => p.cotacao.to_f,
                              :valor_dolar      => pd.pago_dolar,
                              :valor_guarani    => pd.pago_guarani )

        end
    end 

  end
end
