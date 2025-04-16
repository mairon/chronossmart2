class Financa < ActiveRecord::Base
  belongs_to :persona
  belongs_to :conta
  belongs_to :cartao_bandeira

  after_create :trigger_viatico_cliente
  after_destroy :trigger_viatico_cliente_destroy

  def trigger_viatico_cliente

    Cliente.create(
        tabela_id: self.id,
        tabela: 'VIATICO_DEV',
        documento_numero_01: self.documento_numero_01,
        documento_numero_02: self.documento_numero_02,
        documento_numero: self.documento_numero,
        cota: 1,
        divida_guarani: 0,
        divida_dolar: 0,
        divida_real: 0,
        cobro_guarani: self.entrada_guarani.to_f,
        cobro_dolar: self.entrada_dolar.to_f,
        cobro_real: self.entrada_real.to_f,
        liquidacao: 0,
        moeda: self.moeda,
        sigla_proc: self.sigla_proc,
        cod_proc: self.cod_proc,
        unidade_id: self.conta.unidade_id,
        data: self.data,
        descricao: self.concepto,
        vencimento: self.data,
        persona_id: self.persona_id,

      )

      extrato = Cliente.where(persona_id: self.persona_id, documento_numero_01: 'V00', documento_numero: self.documento_numero )
      if self.moeda == 0
         if extrato.sum('divida_dolar - cobro_dolar') == 0 
            extrato.update_all(liquidacao: 1)
         end

      elsif self.moeda == 1
         if extrato.sum('divida_guarani - cobro_guarani').to_f == 0 
            extrato.update_all(liquidacao: 1)
         end

      elsif self.moeda == 2
         if extrato.sum('divida_real - cobro_real').to_f == 0 
            extrato.update_all(liquidacao: 1)
         end
      end
  end

  def trigger_viatico_cliente_destroy

    Cliente.where(tabela_id: self.id, tabela: 'VIATICO_DEV' ).destroy_all
    extrato = Cliente.where(persona_id: self.persona_id, documento_numero_01: 'V00', documento_numero: self.documento_numero )
    extrato.update_all(liquidacao: 0)
  end

  def self.resultado_recebimentos(params)
    unidade = "AND C.UNIDADE_ID  = #{params[:unidade]}"
    conta  = "AND F.conta_id = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?
    persona  = "AND F.PERSONA_ID = #{params[:busca]["prov"]}" unless params[:busca]["prov"].blank?
    plano_de_conta  = "AND F.PLANO_DE_CONTA_ID = #{params[:busca]["clasif"]}" unless params[:busca]["clasif"].blank?

    sql = "SELECT  F.DATA,
                   P.NOME AS PERSONA_NOME,
                   C.NOME AS CONTA_NOME,
                   F.TITULO,
                   F.CONCEPTO,
                   F.PLANO_DE_CONTA_ID,
                   F.FORMA_PAGO_ID,
                   F.COD_PROC,
                   F.SIGLA_PROC,
                   F.ENTRADA_GUARANI,
                   F.ENTRADA_REAL,
                   F.ENTRADA_DOLAR,
                   PC.DESCRICAO AS PLANO_DE_CONTA_NOME,
                   FP.NOME AS FORMA_PAGO_NOME,
                   F.MOEDA
                FROM FINANCAS F 

                LEFT JOIN CONTAS C
                ON C.ID = F.CONTA_ID

                LEFT JOIN PERSONAS P
                ON P.ID = F.PERSONA_ID

                LEFT JOIN PLANO_DE_CONTAS PC
                ON PC.ID = F.PLANO_DE_CONTA_ID

                LEFT JOIN FORMA_PAGOS FP
                ON FP.ID = F.FORMA_PAGO_ID


                WHERE (COALESCE(F.ENTRADA_DOLAR,0) + COALESCE(F.ENTRADA_GUARANI,0) + COALESCE(F.ENTRADA_REAL,0) ) > 0 #{unidade} AND F.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
                #{persona} #{conta} #{plano_de_conta}"   

    Financa.find_by_sql(sql)

  end


  def self.resultado_pagamentos(params)
    unidade  = "AND C.UNIDADE_ID  = #{params[:unidade]}"
    conta    = "AND F.conta_id = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?
    persona  = "AND F.PERSONA_ID = #{params[:busca]["prov"]}" unless params[:busca]["prov"].blank?
    cc       = "AND F.CENTRO_CUSTO_ID = #{params[:busca]["cc"]}" unless params[:busca]["cc"].blank?
    plano_de_conta  = "AND F.PLANO_DE_CONTA_ID = #{params[:busca]["clasif"]}" unless params[:busca]["clasif"].blank?

    sql = "SELECT  F.DATA,
                   P.NOME AS PERSONA_NOME,
                   C.NOME AS CONTA_NOME,
                   F.TITULO,
                   F.CONCEPTO,
                   F.PLANO_DE_CONTA_ID,
                   F.FORMA_PAGO_ID,
                   F.COD_PROC,
                   F.SIGLA_PROC,
                   F.SAIDA_GUARANI,
                   F.SAIDA_REAL,
                   F.SAIDA_DOLAR,
                   PC.DESCRICAO AS PLANO_DE_CONTA_NOME,
                   FP.NOME AS FORMA_PAGO_NOME,
                   F.MOEDA,
                   CC.NOME AS CENTRO_CUSTO_NOME
                FROM FINANCAS F 

                LEFT JOIN CONTAS C
                ON C.ID = F.CONTA_ID

                LEFT JOIN PERSONAS P
                ON P.ID = F.PERSONA_ID

                LEFT JOIN PLANO_DE_CONTAS PC
                ON PC.ID = F.PLANO_DE_CONTA_ID

                LEFT JOIN FORMA_PAGOS FP
                ON FP.ID = F.FORMA_PAGO_ID

                LEFT JOIN CENTRO_CUSTOS CC
                ON CC.ID = F.CENTRO_CUSTO_ID


                WHERE (F.SAIDA_DOLAR + F.SAIDA_GUARANI + F.SAIDA_REAL) > 0 #{unidade} AND F.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
                #{persona} #{conta} #{plano_de_conta} #{cc}
                ORDER BY 1"   

    Financa.find_by_sql(sql)

  end

    def self.consolidado(params)

      sql = "SELECT CONTA_ID, MAX(CONTA_NOME) AS CONTA_NOME, SUM(ENTRADA_REAL) AS ENTRADA_REAL, SUM(SAIDA_REAL) AS SAIDA_REAL, SUM(ENTRADA_REAL_ANTERIOR) AS ENTRADA_REAL_ANTERIOR, SUM(SAIDA_REAL_ANTERIOR) AS SAIDA_REAL_ANTERIOR FROM (
                  SELECT  F.CONTA_ID,
                          MAX(C.NOME) AS CONTA_NOME,
                          SUM(F.ENTRADA_REAL) AS ENTRADA_REAL,
                          SUM(0) AS SAIDA_REAL,
                          SUM(0) AS ENTRADA_REAL_ANTERIOR,
                          SUM(0) AS SAIDA_REAL_ANTERIOR
                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  WHERE C.MODAL = FALSE
              AND C.TIPO = 1
              AND C.TESOURARIA = FALSE AND date_part('month', F.DATA ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA ) = '#{Time.now.strftime("%Y")}'
                  GROUP BY 1

                  UNION ALL

                  SELECT F.CONTA_ID,
                         MAX(C.NOME) AS CONTA_NOME,
                         SUM(0) AS ENTRADA_REAL,
                         SUM(F.SAIDA_REAL) AS SAIDA_REAL,
                        SUM(0) AS ENTRADA_REAL_ANTERIOR,
                        SUM(0) AS SAIDA_REAL_ANTERIOR

                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  WHERE C.MODAL = FALSE
              AND C.TIPO = 1
              AND C.TESOURARIA = FALSE AND date_part('month', F.DATA ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA ) = '#{Time.now.strftime("%Y")}'
                  GROUP BY 1




                UNION ALL

                SELECT  F.CONTA_ID,
                          MAX(C.NOME) AS CONTA_NOME,
                          SUM(0) AS ENTRADA_REAL,
                          SUM(0) AS SAIDA_REAL,
                          SUM(F.ENTRADA_REAL) AS ENTRADA_REAL_ANTERIOR,
                          SUM(0) AS SAIDA_REAL_ANTERIOR
                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  WHERE C.MODAL = FALSE
              AND C.TIPO = 1
              AND C.TESOURARIA = FALSE AND F.DATA <  '#{Time.now.strftime("%Y")}-#{Time.now.strftime("%m")}-01'
                  GROUP BY 1

                  UNION ALL

                  SELECT F.CONTA_ID,
                         MAX(C.NOME) AS CONTA_NOME,
                         SUM(0) AS ENTRADA_REAL,
                         SUM(0) AS SAIDA_REAL,
                        SUM(0) AS ENTRADA_REAL_ANTERIOR,
                        SUM(F.SAIDA_REAL) AS SAIDA_REAL_ANTERIOR

                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID


                  WHERE C.MODAL = FALSE
              AND C.TIPO = 1
              AND C.TESOURARIA = FALSE AND  F.DATA < '#{Time.now.strftime("%Y")}-#{Time.now.strftime("%m")}-01'

                  GROUP BY 1



                  ) AS FOO
                GROUP BY 1
                ORDER BY 2"


      Financa.find_by_sql(sql)
    end

    def self.relatorio_doacao(params)

      sql = "SELECT F.DATA,
                    C.NOME AS CONTA_NOME,
                    F.CONCEPTO,
                    F.PERSONA_NOME,
                    F.ENTRADA_DOLAR
              FROM FINANCAS F
              INNER JOIN CONTAS C
              ON C.ID = F.CONTA_ID
              WHERE F.TABELA NOT IN ('ADELANTOS', 'TRANSFERENCIA_CONTAS_DETALHES') AND F.ENTRADA_DOLAR > 0 AND F.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
              ORDER BY 1"

      Financa.find_by_sql(sql)

    end

    def self.resultado_extrato_tarjeta(params)
      find_moeda = Conta.find_by_id(params[:busca]["conta"])
      params[:moeda] = find_moeda.moeda.to_s
        if params[:moeda].to_s == "0"
            moeda   = " and F.moeda = 0"
            entrada = "F.entrada_dolar"
            saida   = "F.saida_dolar"
        elsif params[:moeda].to_s == "1"
            moeda   = " and F.moeda = 1"
            entrada = "F.entrada_guarani"
            saida   = "F.saida_guarani"
        else
            moeda   = " and F.moeda = 2"
            entrada = "F.entrada_real"
            saida   = "F.saida_real"
        end

        conta  = "AND F.CONTA_ID = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?

        sql = " SELECT F.DATA,
                      F.DOCUMENTO_NUMERO,
                      F.CHEQUE,ESTADO,
                      F.ENTRADA_DOLAR,
                      F.SAIDA_DOLAR,
                      F.ENTRADA_GUARANI,
                      F.SAIDA_GUARANI,
                      F.ENTRADA_REAL,
                      F.SAIDA_REAL,
                      F.PERSONA_ID,
                      F.PERSONA_NOME,
                      F.TABELA,
                      F.CONCEPTO,
                      F.COMPRA_ID,
                      F.CHEQUE_STATUS,
                      F.DIFERIDO,
                      F.BANCO,
                      F.TITULAR,
                      F.ID
                      CB.NOME AS D
                FROM FINANCAS F 
                LEFT JOIN CARTAO_BANDEIRAS CB
                ON F.CARTAO_BANDEIRA_ID = CB.ID
                WHERE F.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
                #{moeda} AND F.ESTADO = 0 #{conta}
                ORDER BY 1, 7"



      Financa.find_by_sql(sql)
    end


    def self.relatorio_financas_conciliacao(params)
      if params[:filtro] == '0'

        conta  = "AND F.conta_id = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?
        persona  = "AND F.PERSONA_ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?
        conciliacao = "AND F.CONCILIACAO = #{params[:conciliacao]}" unless params[:conciliacao].blank?

        if params[:conciliacao] == 'true'
            tipo_data = "F.DATA_CONCILIACAO"
            solo_conciliados = "AND F.CONCILIACAO = true"
        else
            tipo_data = "F.DATA"
        end

        if params[:solo].to_s == "0"
          s = "AND F.CHEQUE_STATUS IN (0,3) "
        elsif params[:solo].to_s == "1"
          s = "AND F.CHEQUE_STATUS BETWEEN 1 AND 2"
        elsif params[:solo].to_s == "2"
          s = "AND F.CHEQUE_STATUS = 3"
        else
          s = ""
        end

        unless params[:st].to_s == ""
            status = " and F.status = #{params[:st].to_i}"
        end

        unless params[:cheque].blank?
          find_cheque  = "F.cheque LIKE ? %#{params[:cheque]}%"
        end

        if params[:entrada_saida].to_s == "entrada"
          es = "AND COALESCE(F.ENTRADA_REAL,0) > 0 "
        elsif params[:entrada_saida].to_s == "saida"
          es = "AND COALESCE(F.SAIDA_REAL,0) > 0 "
        else
          es = ""
        end


        if params[:filtro_data] == 'data_conciliacao'

          data = "F.DATA_CONCILIACAO"
        else
          data = "F.DATA"
        end


        sql = " SELECT #{tipo_data} AS DATA,
                                  F.DOCUMENTO_NUMERO,
                                  F.CHEQUE,
                                  F.CONTA_ID,
                                  C.NOME AS CONTA_NOME,
                                  C.MOEDA,
                                  F.ESTADO,
                                  F.ENTRADA_DOLAR,
                                  F.SAIDA_DOLAR,
                                  F.ENTRADA_GUARANI,
                                  F.SAIDA_GUARANI,
                                  F.ENTRADA_REAL,
                                  F.SAIDA_REAL,
                                  F.PERSONA_ID,
                                  P.NOME AS PERSONA_NOME,
                                  F.TABELA,
                                  F.CONCEPTO,
                                  F.COMPRA_ID,
                                  F.CHEQUE_STATUS,
                                  F.DIFERIDO,
                                  F.BANCO,
                                  F.TITULAR,
                                  F.CONCILIACAO,
                                  F.DATA_CONCILIACAO,
                                  F.ID,
                                  F.COD_PROC,
                                  F.SIGLA_PROC,
                                  F.USUARIO_CREATED,
                                  U.USUARIO_NOME
                 FROM FINANCAS F
                 LEFT JOIN PERSONAS P
                 ON P.ID = F.PERSONA_ID

                 LEFT JOIN CONTAS C
                 ON C.ID = F.CONTA_ID

                 LEFT JOIN USUARIOS U
                 ON U.ID = F.USUARIO_CREATED

                 WHERE #{data} BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{conta} #{s} #{status} #{conciliacao} #{solo_conciliados} #{find_cheque} #{persona} #{es}
                 ORDER BY F.DATA,F.CONTA_NOME, F.PERSONA_NOME
        "

      Financa.find_by_sql(sql)
    else
        if params[:tipo_data] == '0'
          tipo_data = "DATA"
        elsif params[:tipo_data] == '1'
          tipo_data = "DATA_CONCILIACAO"
          solo_conciliados = "AND CONCILIACAO = true"
        end

        if params[:moeda].to_s == "0"
            moeda   = " and moeda = 0"
            entrada = "SUM(ENTRADA_DOLAR) AS ENTRADA_DOLAR"
            saida   = "SUM(SAIDA_DOLAR) AS SAIDA_DOLAR"
        elsif params[:moeda].to_s == "1"
            moeda   = " and moeda = 1"
            entrada = "SUM(ENTRADA_GUARANI) AS ENTRADA_GUARANI"
            saida   = "SUM(SAIDA_GUARANI) AS SAIDA_GUARANI"
        else
            moeda   = " and moeda = 2"
            entrada = "SUM(ENTRADA_REAL) AS ENTRADA_REAL"
            saida   = "SUM(SAIDA_REAL) AS SAIDA_REAL"
        end
      ch    =  "AND cheque LIKE ?","%#{params[:cheque]}%"  unless params[:cheque].blank?
      cond  = "#{moeda} AND ESTADO = 0 #{ch}"
      sql = "SELECT
                    CONTA_ID,
                    #{tipo_data} AS DATA,
                    DOCUMENTO_NUMERO,
                    MAX(CHEQUE) AS CHEQUE,
                    MAX(COMPRA_ID) AS COMPRA_ID,
                    MAX(CHEQUE_STATUS) AS CHEQUE_STATUS,
                    MAX(BANCO) AS BANCO,
                    MAX(TITULAR) AS TITULAR,
                    MAX(PERSONA_NOME) AS PERSONA_NOME,
                    MAX(OB_REF) AS OB_REF,
                    MAX(DIFERIDO) AS DIFERIDO,
                    MAX(TABELA) AS TABELA,
                    MAX(TABELA_ID) AS TABELA_ID,
                    MAX(CONCEPTO) AS CONCEPTO,
                    #{entrada},
                    #{saida}
              FROM
                    FINANCAS
              WHERE
                    #{tipo_data} BETWEEN '#{params[:inicio].split("/").reverse.join("-")}}' AND '#{params[:final].split("/").reverse.join("-")}}' AND conta_id = #{params[:busca]["conta"]} #{cond}  #{conciliacao} #{solo_conciliados}
              GROUP BY
                    1,2,3
              ORDER BY  2,3"
      Financa.find_by_sql(sql)
    end
    end


    def self.relatorio_financas(params)
    find_moeda = Conta.find_by_id(params[:busca]["conta"])
    params[:moeda] = find_moeda.moeda.to_s
    if params[:filtro] == '2'


        if params[:tipo_data] == '0'
          tipo_data = "DATA"
        elsif params[:tipo_data] == '1'
          tipo_data = "DATA_CONCILIACAO"
          solo_conciliados = "AND CONCILIACAO = true"
        end

        if params[:moeda].to_s == "0"
            moeda   = " and moeda = 0"
            entrada = "SUM(COALESCE(ENTRADA_DOLAR,0) ) AS ENTRADA_DOLAR"
            saida   = "SUM(COALESCE(SAIDA_DOLAR,0)) AS SAIDA_DOLAR"
        elsif params[:moeda].to_s == "1"
            moeda   = " and moeda = 1"
            entrada = "SUM(COALESCE(ENTRADA_GUARANI,0)) AS ENTRADA_GUARANI"
            saida   = "SUM(COALESCE(SAIDA_GUARANI,0)) AS SAIDA_GUARANI"
        else
            moeda   = " and moeda = 2"
            entrada = "SUM(COALESCE(ENTRADA_REAL,0)) AS ENTRADA_REAL"
            saida   = "SUM(COALESCE(SAIDA_REAL,0)) AS SAIDA_REAL"
        end
      ch    =  "AND cheque LIKE ?","%#{params[:cheque]}%"  unless params[:cheque].blank?
      cond  = "#{moeda} AND ESTADO = 0 #{ch}"
      sql = "SELECT
                    CONTA_ID,
                    #{tipo_data} AS DATA,
                    DOCUMENTO_NUMERO,
                    MAX(CHEQUE) AS CHEQUE,
                    MAX(COMPRA_ID) AS COMPRA_ID,
                    MAX(CHEQUE_STATUS) AS CHEQUE_STATUS,
                    MAX(BANCO) AS BANCO,
                    MAX(TITULAR) AS TITULAR,
                    MAX(PERSONA_NOME) AS PERSONA_NOME,
                    MAX(OB_REF) AS OB_REF,
                    MAX(DIFERIDO) AS DIFERIDO,
                    MAX(TABELA) AS TABELA,
                    MAX(TABELA_ID) AS TABELA_ID,
                    MAX(CONCEPTO) AS CONCEPTO,
                    #{entrada},
                    #{saida}
              FROM
                    FINANCAS
              WHERE
                    #{tipo_data} BETWEEN '#{params[:inicio].split("/").reverse.join("-")}}' AND '#{params[:final].split("/").reverse.join("-")}}' AND conta_id = #{params[:busca]["conta"]} #{cond}  #{conciliacao} #{solo_conciliados}
              GROUP BY
                    1,2,3
              ORDER BY  2,3"
      Financa.find_by_sql(sql)



    else
        if params[:moeda].to_s == "0"
            moeda   = " AND F.MOEDA = 0"
            entrada = "COALESCE(F.ENTRADA_DOLAR,0)"
            saida   = "COALESCE(F.SAIDA_DOLAR,0)"
        elsif params[:moeda].to_s == "1"
            moeda   = " AND F.MOEDA = 1"
            entrada = "COALESCE(F.ENTRADA_GUARANI,0)"
            saida   = "COALESCE(F.SAIDA_GUARANI,0)"
        else
            moeda   = " AND F.MOEDA = 2"
            entrada = "COALESCE(F.ENTRADA_REAL,0)"
            saida   = "COALESCE(F.SAIDA_REAL,0)"
        end

        conta  = "AND F.conta_id = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?
        conciliacao = "AND F.CONCILIACAO = #{params[:conciliacao]}" unless params[:conciliacao].blank?

        if params[:conciliacao] == 'true'
            tipo_data = "F.DATA_CONCILIACAO"
            solo_conciliados = "AND F.CONCILIACAO = true"
        else
            tipo_data = "F.DATA"
        end

        if params[:solo].to_s == "0"
          s = "AND F.CHEQUE_STATUS IN (0,3) "
        elsif params[:solo].to_s == "1"
          s = "AND F.CHEQUE_STATUS BETWEEN 1 AND 2"
        elsif params[:solo].to_s == "2"
          s = "AND F.CHEQUE_STATUS = 3"
        else
          s = ""
        end

        unless params[:st].to_s == ""
            status = " and F.status = #{params[:st].to_i}"
        end

        unless params[:cheque].blank?
          find_cheque  = "AND F.cheque LIKE ? %#{params[:cheque]}%"
        end



        sql = " SELECT #{tipo_data} AS DATA,
                                  F.DOCUMENTO_NUMERO,
                                  F.CHEQUE,
                                  F.ESTADO,
                                  COALESCE(F.ENTRADA_DOLAR,0) AS ENTRADA_DOLAR,
                                  COALESCE(F.SAIDA_DOLAR,0) AS SAIDA_DOLAR,
                                  COALESCE(F.ENTRADA_GUARANI,0) AS ENTRADA_GUARANI,
                                  COALESCE(F.SAIDA_GUARANI,0) AS SAIDA_GUARANI,
                                  COALESCE( F.ENTRADA_REAL,0) AS ENTRADA_REAL,
                                  COALESCE(F.SAIDA_REAL,0) AS SAIDA_REAL,
                                  F.PERSONA_ID,
                                  P.NOME AS PERSONA_NOME,
                                  F.TABELA,
                                  F.CONCEPTO,
                                  F.COMPRA_ID,
                                  F.CHEQUE_STATUS,
                                  F.DIFERIDO,
                                  F.BANCO,
                                  F.TITULAR,
                                  F.CONCILIACAO,
                                  F.DATA_CONCILIACAO,
                                  F.ID,
                                  F.COD_PROC,
                                  F.SIGLA_PROC
                 FROM FINANCAS F
                 LEFT JOIN PERSONAS P
                 ON P.ID = F.PERSONA_ID
                 WHERE #{tipo_data} BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{moeda} #{conta} #{s} #{status} #{conciliacao} #{solo_conciliados} #{find_cheque}
                 ORDER BY F.DATA,F,ID, F.CHEQUE
        "

      Financa.find_by_sql(sql)
    end
    end

    def self.relatorio_financas_saldo_anterior(params)

        if params[:moeda].to_s == "0"
            moeda   = " AND MOEDA = 0"
            entrada = "COALESCE(ENTRADA_DOLAR,0)"
            saida   = "COALESCE(SAIDA_DOLAR,0)"
        elsif params[:moeda].to_s == "1"
            moeda   = " AND MOEDA = 1"
            entrada = "COALESCE(ENTRADA_GUARANI,0)"
            saida   = "COALESCE(SAIDA_GUARANI,0)"
        else
            moeda   = " AND MOEDA = 2"
            entrada = "COALESCE(ENTRADA_REAL,0)"
            saida   = "COALESCE(SAIDA_REAL,0)"
        end

        conta  = "AND conta_id = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?
        conciliacao = "AND CONCILIACAO = #{params[:conciliacao]}" unless params[:conciliacao].blank?

        if params[:conciliacao] == 'true'
            tipo_data = "DATA_CONCILIACAO"
            solo_conciliados = "AND CONCILIACAO = true"
        else
            tipo_data = "DATA"
        end

        if params[:solo].to_s == "0"
          s = "AND CHEQUE_STATUS IN (0,3) "
        elsif params[:solo].to_s == "1"
          s = "AND CHEQUE_STATUS BETWEEN 1 AND 2"
        elsif params[:solo].to_s == "2"
          s = "AND CHEQUE_STATUS = 3"
        else
          s = ""
        end

        unless params[:st].to_s == ""
            status = " and status = #{params[:st].to_i}"
        end

        unless params[:cheque].blank?
          find_cheque  = "cheque LIKE ? %#{params[:cheque]}%"
        end

        unless params[:cheque].blank?
            cond  = "cheque LIKE ? #{moeda} AND  ESTADO = 0 AND #{entrada} + #{saida} != 0 #{conta} #{s} #{status}","%#{params[:cheque]}%"
        else
            cond  = "#{tipo_data} < '#{params[:inicio].split("/").reverse.join("-")}}' #{moeda} AND ESTADO = 0 AND #{entrada} + #{saida} != 0 #{moeda} #{conta} #{s} #{status} #{conciliacao} #{solo_conciliados} #{find_cheque}"
        end

        self.sum(" #{entrada} - #{saida}",:conditions => cond)
    end  





    def self.lanz_futuros_extr_bc(params)
           
        if params[:moeda].to_s == "0"
            moeda   = " and moeda = 0"
            entrada = "entrada_dolar"
            saida   = "saida_dolar"
        elsif params[:moeda].to_s == "1"
            moeda   = " and moeda = 1"
            entrada = "entrada_guarani"
            saida   = "saida_guarani"
        else
            moeda   = " and moeda = 2"
            entrada = "entrada_real"
            saida   = "saida_real"
        end

        conta = "AND conta_id = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?
        cond  = "DIFERIDO > '#{params[:final].split("/").reverse.join("-")}' #{moeda} #{conta}"        
        self.all(:conditions => cond, :order => 'data,id')
    end

    def self.resumo_contas_cajas(params)
        periodo  = "F.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' AND F.ESTADO = 0"
        cond  = "WHERE C.ID = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?
        sql = "SELECT 
                    C.ID, 
                    C.NOME,
                    C.TIPO,
                    C.MOEDA,
                    (SELECT COALESCE(SUM(F.ENTRADA_DOLAR - F.SAIDA_DOLAR),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID AND F.MOEDA = 0 AND F.DATA < '#{params[:inicio].split("/").reverse.join("-")}') AS ANTERIOR_US,
                    (SELECT COALESCE(SUM(F.ENTRADA_DOLAR),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID AND F.MOEDA = 0 AND #{periodo}) AS ENTRADA_US,
                    (SELECT COALESCE(SUM(F.ENTRADA_GUARANI),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID AND F.MOEDA = 1 AND #{periodo}) AS ENTRADA_GS,

                    (SELECT COALESCE(SUM(F.ENTRADA_GUARANI - F.SAIDA_GUARANI),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID AND F.MOEDA = 1 AND F.DATA < '#{params[:inicio].split("/").reverse.join("-")}') AS ANTERIOR_GS,
                    (SELECT COALESCE(SUM(F.SAIDA_DOLAR),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID  AND F.MOEDA = 0 AND #{periodo}) AS SAIDA_US,
                    (SELECT COALESCE(SUM(F.SAIDA_GUARANI),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID AND F.MOEDA = 1 AND #{periodo}) AS SAIDA_GS
              FROM CONTAS C #{cond}"

        Financa.find_by_sql(sql)
    end

    def self.resumo_contas_bancos(params)
        periodo  = "F.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}}' AND '#{params[:final].split("/").reverse.join("-")}}' AND F.ESTADO = 0"
        cond  = "WHERE C.ID = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?
        sql = "SELECT 
                    C.ID, 
                    C.NOME,
                    C.TIPO,
                    C.MOEDA,
                    (SELECT COALESCE(SUM(F.ENTRADA_DOLAR - F.SAIDA_DOLAR),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID AND F.MOEDA = 0 AND F.DATA < '#{params[:inicio].split("/").reverse.join("-")}') AS ANTERIOR_US,
                    (SELECT COALESCE(SUM(F.ENTRADA_DOLAR),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID AND F.MOEDA = 0 AND #{periodo}) AS ENTRADA_US,
                    (SELECT COALESCE(SUM(F.ENTRADA_GUARANI),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID AND F.MOEDA = 1 AND #{periodo}) AS ENTRADA_GS,

                    (SELECT COALESCE(SUM(F.ENTRADA_GUARANI - F.SAIDA_GUARANI),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID AND F.MOEDA = 1 AND F.DATA < '#{params[:inicio].split("/").reverse.join("-")}') AS ANTERIOR_GS,
                    (SELECT COALESCE(SUM(F.SAIDA_DOLAR),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID  AND F.MOEDA = 0 AND #{periodo}) AS SAIDA_US,
                    (SELECT COALESCE(SUM(F.SAIDA_GUARANI),0) FROM FINANCAS F WHERE F.CONTA_ID = C.ID AND F.MOEDA = 1 AND #{periodo}) AS SAIDA_GS
              FROM CONTAS C #{cond}"

        Financa.find_by_sql(sql)
    end
end
