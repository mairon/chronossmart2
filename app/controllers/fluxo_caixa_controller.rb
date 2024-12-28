class FluxoCaixaController < ApplicationController
  def main
    unless params[:busca_centro_custos].blank?
      cc = "AND P.CENTRO_CUSTO_ID = #{params[:busca_centro_custos]}"
    end

    unless params[:busca_centro_custos].blank?
      cliente_cc = "AND CL.CENTRO_CUSTO_ID = #{params[:busca_centro_custos]}"
    end
    sql ="


    SELECT 0 AS RUBRO_ID,
          MAX('0') AS CODIGO,
          MAX('RECEBER') AS RUBRO_NOME,

          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '01'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_01,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '02'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_02,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '03'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_03,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '04'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_04,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '05'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_05,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '06'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_06,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '07'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_07,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '08'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_08,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '09'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_09,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '10'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_10,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '11'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_11,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '12'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_12
    FROM CLIENTES P
    WHERE date_part('year', P.VENCIMENTO) = '2022'
    #{cc}

    UNION ALL

    SELECT P.RUBRO_ID,
           MAX(R.CODIGO) AS CODIGO,
           MAX(R.DESCRICAO) AS RUBRO_NOME,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '01'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_01,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '02'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_02,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '03'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_03,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '04'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_04,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '05'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_05,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '06'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_06,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '07'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_07,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '08'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_08,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '09'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_09,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '10'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_10,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '11'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_11,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE CL.RUBRO_ID = P.RUBRO_ID and date_part('month', CL.VENCIMENTO) = '12'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_12

    FROM PROVEEDORES P
    INNER JOIN RUBROS R
    ON R.ID = P.RUBRO_ID
    WHERE date_part('year', P.VENCIMENTO) = '2022'
     #{cc}

    GROUP BY 1

    "

    @plano_contas = PlanoDeConta.find_by_sql(sql)


    sqlsaldo ="

    SELECT RUBRO_ID, MAX(0) AS CODIGO, MAX('SALDO') AS RUBRO_NOME, SUM(PROV_01) AS PROV_01, SUM(PROV_02) AS PROV_02, SUM(PROV_03) AS PROV_03, SUM(PROV_04) AS PROV_04, SUM(PROV_05) AS PROV_05, SUM(PROV_06) AS PROV_06, SUM(PROV_07) AS PROV_07, SUM(PROV_08) AS PROV_08, SUM(PROV_09) AS PROV_09, SUM(PROV_10) AS PROV_10, SUM(PROV_11) AS PROV_11,  SUM(PROV_12) AS PROV_12 FROM (

    SELECT 0 AS RUBRO_ID,
          MAX('0') AS CODIGO,
          MAX('SALDO') AS RUBRO_NOME,

          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '01'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_01,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '02'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_02,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '03'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_03,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '04'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_04,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '05'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_05,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '06'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_06,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '07'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_07,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '08'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_08,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '09'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_09,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '10'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_10,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '11'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_11,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM CLIENTES CL WHERE CL.LIQUIDACAO = 0 AND  date_part('month', CL.VENCIMENTO) = '12'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc} ),0)) AS PROV_12
    FROM CLIENTES P
    WHERE date_part('year', P.VENCIMENTO) = '2022'
    #{cc}

    UNION ALL

    SELECT 0 AS RUBRO_ID,
           MAX('0') AS CODIGO,
          MAX('SALDO') AS RUBRO_NOME,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '01'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_01,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '02'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_02,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '03'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_03,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '04'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_04,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '05'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_05,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '06'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_06,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '07'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_07,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '08'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_08,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '09'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_09,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '10'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_10,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '11'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_11,
          (COALESCE((SELECT SUM(CL.DIVIDA_GUARANI) FROM PROVEEDORES CL WHERE date_part('month', CL.VENCIMENTO) = '12'  AND  date_part('year', CL.VENCIMENTO) = '2022' #{cliente_cc}),0) * -1) AS PROV_12

    FROM PROVEEDORES P
    WHERE date_part('year', P.VENCIMENTO) = '2022'
     #{cc}

    GROUP BY 1) X

    GROUP BY 1
    "

    @plano_contas_saldo = PlanoDeConta.find_by_sql(sqlsaldo)

  end


  def movimentos

    sql = "SELECT C.ID,
                 'C' AS TAG,
                 C.DATA,
                 C.VENCIMENTO,
                 R.CODIGO,
                 R.DESCRICAO AS RUBRO_NOME,
                 C.CENTRO_CUSTO_ID,
                 C.DESCRICAO,
                 C.MOEDA,
                 C.LIQUIDACAO,
                 C.CONTA_ID,
                 C.DIVIDA_GUARANI,
                 C.DIVIDA_DOLAR,
                 C.DIVIDA_REAL,
                 C.COBRO_GUARANI AS COBRO_GUARANI,
                 C.COBRO_DOLAR AS COBRO_DOLAR,
                 C.COBRO_REAL AS COBRO_REAL,
                 C.COTA,
                 C.TOT_COTAS,
                 CT.NOME AS CONTA_NOME
          FROM CLIENTES C

          LEFT JOIN RUBROS R
          ON R.ID = C.RUBRO_ID

          LEFT JOIN CONTAS CT
          ON CT.ID = C.CONTA_ID

          UNION ALL

          SELECT C.ID,
                 'P' AS TAG,
                 C.DATA,
                 C.VENCIMENTO,
                 R.CODIGO,
                 R.DESCRICAO AS RUBRO_NOME,
                 C.CENTRO_CUSTO_ID,
                 C.DESCRICAO,
                 C.MOEDA,
                 C.LIQUIDACAO,
                 C.CONTA_ID,
                 C.DIVIDA_GUARANI,
                 C.DIVIDA_DOLAR,
                 C.DIVIDA_REAL,
                 C.PAGO_GUARANI AS COBRO_GUARANI,
                 C.PAGO_DOLAR AS COBRO_DOLAR,
                 C.PAGO_REAL AS COBRO_REAL,
                 C.COTA,
                 C.TOT_COTAS,
                 CT.NOME AS CONTA_NOME
          FROM PROVEEDORES C

          LEFT JOIN RUBROS R
          ON R.ID = C.RUBRO_ID

          LEFT JOIN CONTAS CT
          ON CT.ID = C.CONTA_ID

          ORDER BY 1 DESC"


    @movimentos = Cliente.paginate_by_sql(sql, :page => params[:page], :per_page => 50)

    render layout: 'chart'
  end
end
