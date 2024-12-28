class MainController < ApplicationController
  before_filter :authenticate

  def fc_detalhe
    if params[:tipo] == 'receber'

      if params[:visao] == 'mes'
        data = "date_part('month', P.VENCIMENTO) = '#{params[:vencimento].to_date.strftime("%m")}' "
      else
        data = "P.VENCIMENTO = '#{params[:vencimento]}' "
      end
      sql = "SELECT
                   P.TITULO,
                   MIN(P.DOCUMENTO_NUMERO_01) AS DOCUMENTO_NUMERO_01,
                   MIN(P.DOCUMENTO_NUMERO_02) AS DOCUMENTO_NUMERO_02,
                   MIN(P.DOCUMENTO_NUMERO) AS DOCUMENTO_NUMERO,
                   MIN(P.COTA) AS COTA,
                   MAX(P.VENCIMENTO) AS VENCIMENTO,
                   MIN(P.ID) AS ID,
                   MAX(P.DATA) AS DATA,
                   MAX(PD.NOME) AS PERSONA_NOME,
                   MAX(C.NOME) AS CONTA_NOME,
                   MAX(P.MOEDA) AS MOEDA,
                   MAX(P.COTA) AS COTA,
                   MAX(P.COD_PROC) AS COD_PROC,
                   MAX(P.PERSONA_ID) AS PERSONA_ID,
                   MAX(P.DESCRICAO) AS DESCRICAO,
                   MAX(P.TOT_COTAS) AS TOT_COTAS,
                   MAX(P.CONTA_ID) AS CONTA_ID,
                   MAX(P.RUBRO_ID) AS RUBRO_ID,
                   MAX(R.DESCRICAO) AS RUBRO_NOME,
                   SUM(DIVIDA_GUARANI) AS DIVIDA_GUARANI,
                   SUM(DIVIDA_DOLAR) AS DIVIDA_DOLAR,
                   SUM(DIVIDA_REAL) AS DIVIDA_REAL


             FROM CLIENTES P

             LEFT JOIN PERSONAS PD
             ON PD.ID = P.PERSONA_ID

             LEFT JOIN CONTAS C
             ON C.ID = P.CONTA_ID

             LEFT JOIN RUBROS R
             ON R.ID = P.RUBRO_ID

             WHERE P.LIQUIDACAO = 0
             AND #{data}
             GROUP BY 1
             ORDER BY 6 DESC, 1
             "
    else

      if params[:visao] == 'mes'
        data = "date_part('month', P.VENCIMENTO) = '#{params[:vencimento].to_date.strftime("%m")}' "
      else
        data = "P.VENCIMENTO = '#{params[:vencimento]}' "
      end

    sql = "SELECT
                 P.TITULO,
                 MIN(P.DOCUMENTO_NUMERO_01) AS DOCUMENTO_NUMERO_01,
                 MIN(P.DOCUMENTO_NUMERO_02) AS DOCUMENTO_NUMERO_02,
                 MIN(P.DOCUMENTO_NUMERO) AS DOCUMENTO_NUMERO,
                 MIN(P.COTA) AS COTA,
                 MAX(P.VENCIMENTO) AS VENCIMENTO,
                 MIN(P.ID) AS ID,
                 MAX(P.DATA) AS DATA,
                 MAX(PD.NOME) AS PERSONA_NOME,
                 MAX(C.NOME) AS CONTA_NOME,
                 MAX(P.MOEDA) AS MOEDA,
                 MAX(P.COTA) AS COTA,
                 MAX(P.COD_PROC) AS COD_PROC,
                 MAX(P.PERSONA_ID) AS PERSONA_ID,
                 MAX(P.DESCRICAO) AS DESCRICAO,
                 MAX(P.TOT_COTAS) AS TOT_COTAS,
                 MAX(P.CONTA_ID) AS CONTA_ID,
                 MAX(P.RUBRO_ID) AS RUBRO_ID,
                 MAX(R.DESCRICAO) AS RUBRO_NOME,
                 SUM(DIVIDA_GUARANI) AS DIVIDA_GUARANI,
                 SUM(DIVIDA_DOLAR) AS DIVIDA_DOLAR,
                 SUM(DIVIDA_REAL) AS DIVIDA_REAL


           FROM PROVEEDORES P

           LEFT JOIN PERSONAS PD
           ON PD.ID = P.PERSONA_ID

           LEFT JOIN CONTAS C
           ON C.ID = P.CONTA_ID

           LEFT JOIN RUBROS R
           ON R.ID = P.RUBRO_ID


           WHERE P.LIQUIDACAO = 0
           AND #{data}
           GROUP BY 1
           ORDER BY 6 DESC, 1
           "
    end
    @clientes = Cliente.find_by_sql(sql)
    render layout: false
  end

  def result_main_fluxo_caixa
    @ctz = Moeda.order('data').last
    @saldo_us = Financa.joins(:conta).where("financas.moeda = 0 and contas.tesouraria = false").sum("financas.entrada_dolar - financas.saida_dolar")
    @saldo_gs = Financa.joins(:conta).where("financas.moeda = 1 and contas.tesouraria = false").sum("financas.entrada_guarani - financas.saida_guarani")
    @saldo_rs = Financa.joins(:conta).where("financas.moeda = 2 and contas.tesouraria = false").sum("financas.entrada_real - financas.saida_real")

    sql_cl = "SELECT DATA, SUM(DIVIDA_GS) AS DIVIDA_GS, SUM(DIVIDA_US) AS DIVIDA_US, SUM(DIVIDA_RS) AS DIVIDA_RS FROM (
                SELECT DAY::DATE AS DATA,
                   0 AS DIVIDA_GS,
                   0 AS DIVIDA_US,
                   0 AS DIVIDA_RS
                FROM   GENERATE_SERIES(TIMESTAMP '#{Time.now.to_date}', '#{Time.now.to_date + 7.day}', '1 DAY') DAY
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(0) AS DIVIDA_GS,
                  SUM(C.DIVIDA_DOLAR) AS DIVIDA_US,
                  SUM(0) AS DIVIDA_RS
                FROM CLIENTES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 0
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(C.DIVIDA_GUARANI) AS DIVIDA_GS,
                  SUM(0) AS DIVIDA_US,
                  SUM(0) AS DIVIDA_RS
                FROM CLIENTES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 1
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(0) AS DIVIDA_GS,
                  SUM(0) AS DIVIDA_US,
                  SUM(C.DIVIDA_REAL) AS DIVIDA_RS
                FROM CLIENTES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 2
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                  ) AS FOO
                GROUP BY 1
                ORDER BY 1"

    sql_prov = "
    SELECT DATA, SUM(DIVIDA_GS) AS DIVIDA_GS, SUM(DIVIDA_US) AS DIVIDA_US, SUM(DIVIDA_RS) AS DIVIDA_RS FROM (
                SELECT DAY::DATE AS DATA,
                   0 AS DIVIDA_GS,
                   0 AS DIVIDA_US,
                   0 AS DIVIDA_RS
                FROM   GENERATE_SERIES(TIMESTAMP '#{Time.now.to_date}', '#{Time.now.to_date + 7.day}', '1 DAY') DAY
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(0) AS DIVIDA_GS,
                  SUM(C.DIVIDA_DOLAR) AS DIVIDA_US,
                  SUM(0) AS DIVIDA_RS
                FROM PROVEEDORES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 0
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(C.DIVIDA_GUARANI) AS DIVIDA_GS,
                  SUM(0) AS DIVIDA_US,
                  SUM(0) AS DIVIDA_RS
                FROM PROVEEDORES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 1
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(0) AS DIVIDA_GS,
                  SUM(0) AS DIVIDA_US,
                  SUM(C.DIVIDA_REAL) AS DIVIDA_RS
                FROM PROVEEDORES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 2
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                  ) AS FOO
                GROUP BY 1
                ORDER BY 1"


    sql_saldo = "
    SELECT DATA, SUM(DIVIDA_GS) AS DIVIDA_GS, SUM(DIVIDA_US) AS DIVIDA_US, SUM(DIVIDA_RS) AS DIVIDA_RS FROM (
                SELECT DAY::DATE AS DATA,
                   0 AS DIVIDA_GS,
                   0 AS DIVIDA_US,
                   0 AS DIVIDA_RS
                FROM   GENERATE_SERIES(TIMESTAMP '#{Time.now.to_date}', '#{Time.now.to_date + 7.day}', '1 DAY') DAY
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(0) AS DIVIDA_GS,
                  SUM(C.DIVIDA_DOLAR * -1) AS DIVIDA_US,
                  SUM(0) AS DIVIDA_RS
                FROM PROVEEDORES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 0
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(C.DIVIDA_GUARANI * -1) AS DIVIDA_GS,
                  SUM(0) AS DIVIDA_US,
                  SUM(0) AS DIVIDA_RS
                FROM PROVEEDORES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 1
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(0) AS DIVIDA_GS,
                  SUM(0) AS DIVIDA_US,
                  SUM(C.DIVIDA_REAL * -1) AS DIVIDA_RS
                FROM PROVEEDORES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 2
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(0) AS DIVIDA_GS,
                  SUM(C.DIVIDA_DOLAR) AS DIVIDA_US,
                  SUM(0) AS DIVIDA_RS
                FROM CLIENTES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 0
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(C.DIVIDA_GUARANI) AS DIVIDA_GS,
                  SUM(0) AS DIVIDA_US,
                  SUM(0) AS DIVIDA_RS
                FROM CLIENTES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 1
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                UNION ALL

                SELECT C.VENCIMENTO AS DATA,
                  SUM(0) AS DIVIDA_GS,
                  SUM(0) AS DIVIDA_US,
                  SUM(C.DIVIDA_REAL) AS DIVIDA_RS
                FROM CLIENTES C
                LEFT JOIN CONTAS CT
                ON CT.ID = C.CONTA_ID

                WHERE CT.TESOURARIA = FALSE
                AND C.LIQUIDACAO = 0
                AND C.MOEDA = 2
                AND C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                GROUP BY 1

                  ) AS FOO
                GROUP BY 1
                ORDER BY 1"

    @fluxo_caixa_cl = Cliente.find_by_sql(sql_cl)

    @fluxo_caixa_prov = Cliente.find_by_sql(sql_prov)

    @fluxo_caixa_saldo = Cliente.find_by_sql(sql_saldo)

    render layout: false
  end

  def index



    @ctz = Moeda.order('data').last
    @unidade = Unidade.last
    @total_pagar_hoje_us = Proveedore.where("liquidacao = 0 and moeda = 0 and vencimento = '#{Date.current}'").sum(:divida_dolar)
    @total_pagar_hoje_gs = Proveedore.where("liquidacao = 0 and moeda = 1 and vencimento = '#{Date.current}'").sum(:divida_guarani)
    @total_pagar_hoje_rs = Proveedore.where("liquidacao = 0 and moeda = 2 and vencimento = '#{Date.current}'").sum(:divida_real)

    @total_receber_hoje_us = Cliente.where("liquidacao = 0 and moeda = 0 and vencimento = '#{Date.current}'").sum(:divida_dolar)
    @total_receber_hoje_gs = Cliente.where("liquidacao = 0 and moeda = 1 and vencimento = '#{Date.current}'").sum(:divida_guarani)
    @total_receber_hoje_rs = Cliente.where("liquidacao = 0 and moeda = 2 and vencimento = '#{Date.current}'").sum(:divida_real)

    @pagar_hoje = Proveedore.where("liquidacao = 0 and vencimento = '#{Date.current}'")
    @receber_hoje = Cliente.where("liquidacao = 0 and vencimento = '#{Date.current}'")

    @saldo_us = Financa.joins(:conta).where("financas.moeda = 0 and contas.tesouraria = false").sum("financas.entrada_dolar - financas.saida_dolar")
    @saldo_gs = Financa.joins(:conta).where("financas.moeda = 1 and contas.tesouraria = false").sum("financas.entrada_guarani - financas.saida_guarani")
    @saldo_rs = Financa.joins(:conta).where("financas.moeda = 2 and contas.tesouraria = false").sum("financas.entrada_real - financas.saida_real")


    @saldo_caixa_us = Financa.joins(:conta).where("financas.moeda = 0 and contas.tesouraria = false and contas.tipo = 0").sum("financas.entrada_dolar - financas.saida_dolar")
    @saldo_caixa_gs = Financa.joins(:conta).where("financas.moeda = 1 and contas.tesouraria = false and contas.tipo = 0").sum("financas.entrada_guarani - financas.saida_guarani")
    @saldo_caixa_rs = Financa.joins(:conta).where("financas.moeda = 2 and contas.tesouraria = false and contas.tipo = 0").sum("financas.entrada_real - financas.saida_real")

    @saldo_banco_us = Financa.joins(:conta).where("financas.moeda = 0 and contas.tesouraria = false and contas.tipo = 1").sum("financas.entrada_dolar - financas.saida_dolar")
    @saldo_banco_gs = Financa.joins(:conta).where("financas.moeda = 1 and contas.tesouraria = false and contas.tipo = 1").sum("financas.entrada_guarani - financas.saida_guarani")
    @saldo_banco_rs = Financa.joins(:conta).where("financas.moeda = 2 and contas.tesouraria = false and contas.tipo = 1").sum("financas.entrada_real - financas.saida_real")


    sql = "SELECT VENCIMENTO, SUM(PAGAR_GS) AS PAGAR_GS, SUM(RECEBER_GS) AS RECEBER_GS from (
                  (SELECT day::date AS VENCIMENTO,
                       SUM(0) AS PAGAR_GS,
                       SUM(0) AS RECEBER_GS
                  FROM   generate_series(timestamp '#{Date.current}', '#{Date.current + 7} ', '1 day') day
                  group by 1)

                  UNION ALL
                  (
                  SELECT VENCIMENTO AS VENCIMENTO,
                       SUM(DIVIDA_GUARANI) AS PAGAR_GS,
                       SUM(0) AS RECEBER_GS

                  FROM  PROVEEDORES P
                  WHERE P.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                    group by 1
                  )
                  UNION ALL
                  (
                  SELECT VENCIMENTO AS VENCIMENTO,
                       SUM(0) AS PAGAR_GS,
                       SUM(DIVIDA_GUARANI) AS RECEBER_GS

                  FROM  CLIENTES C
                  WHERE C.VENCIMENTO BETWEEN '#{Time.now.to_date}' AND '#{Time.now.to_date + 7.day}'
                    group by 1
                  )) AS foo GROUP BY 1 ORDER BY 1"

      @chart_venc_week = Cliente.find_by_sql(sql)
    render layout: 'chart'
  end
end
