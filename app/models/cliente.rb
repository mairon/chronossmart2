class Cliente < ActiveRecord::Base
  belongs_to :venda
  belongs_to :persona
  belongs_to :centro_custo
  belongs_to :conta
  belongs_to :rubro

  before_create :gera_cod, :add_recebimento
  after_create :pago_create
  before_destroy :delete_pagamento

  def delete_pagamento
    if self.finan == true

      list_titulo = Cliente.where(titulo: self.titulo)

      list_titulo.each do |lt|
        lt.update_attributes(liquidacao: 0)
      end
    end
  end

  def pago_create #baixa direto quando faz o lançamento 'Campo Recebido?'
    if self.liquidacao.to_i == 1 and self.sigla_proc == 'CL'
      Cliente.create( persona_id: self.persona_id,
            cota: self.cota,
            saldo_gs: self.divida_guarani,
            saldo_us: self.divida_dolar,
            saldo_rs: self.divida_real,
            moeda: self.moeda,
            liquidacao: self.liquidacao,
            divida_dolar: self.divida_dolar,
            divida_guarani: self.divida_guarani,
            divida_real: self.divida_real,
            data: self.data,
            documento_numero_01: self.documento_numero_01.to_s,
            documento_numero_02: self.documento_numero_02.to_s,
            documento_numero: self.documento_numero.to_s,
            tabela_id: self.id,
            tabela: 'CL',
            finan: true,
            cod_proc: self.id,
            sigla_proc: 'CLR',
            conta_id: self.conta_id,
            descricao: self.descricao,
            rubro_id: self.rubro_id,
            frequencia: self.frequencia,
            tot_cotas: self.tot_cotas.to_i,
            titulo: self.titulo,
            vencimento: self.vencimento)
    end
  end

  def gera_cod
    if self.finan == false
      if self.documento_numero == ''
        self.documento_numero = '999'<< Cliente.count(:id).to_s
        self.documento_numero_01 = '000'
        self.documento_numero_02 = '000'

        self.saldo_gs = self.divida_guarani
        self.saldo_rs = self.divida_real
        self.saldo_us = self.divida_dolar
      end

      if Cliente.last == nil
        self.titulo = 1
      else
        self.titulo = (Cliente.last.id.to_i + 1)
      end
    end
  end


  def add_recebimento
    if self.finan == true
      if self.moeda.to_i == 0

        if self.divida_dolar.to_f == self.saldo_us.to_f
          self.liquidacao = 1
          list_titulo = Cliente.where(titulo: self.titulo)

          list_titulo.each do |lt|
            lt.update_attributes(liquidacao: 1)
          end
        else
          self.liquidacao = 0
        end

      elsif self.moeda.to_i == 1
        if self.divida_guarani.to_f == self.saldo_gs.to_f
          self.liquidacao = 1
          list_titulo = Cliente.where(titulo: self.titulo)

          list_titulo.each do |lt|
            lt.update_attributes(liquidacao: 1)
          end
        else
          self.liquidacao = 0
        end
      elsif self.moeda.to_i == 2
        if self.divida_real.to_f == self.saldo_rs.to_f
          self.liquidacao = 1
          list_titulo = Cliente.where(titulo: self.titulo)

          list_titulo.each do |lt|
            lt.update_attributes(liquidacao: 1)
          end
        else
          self.liquidacao = 0
        end
      end

      self.divida_dolar = self.divida_dolar.to_f * -1
      self.divida_guarani = self.divida_guarani.to_f * -1
      self.divida_real = self.divida_real.to_f * -1
      self.tabela_id = self.id
      self.tabela = 'CL'
    end
  end



    def self.painel_receber(params)
      filtro = "AND to_tsvector(upper( CAST(P.TITULO AS VARCHAR) || ' ' ||  COALESCE(P.DOCUMENTO_NUMERO,' ') || ' ' || COALESCE(PD.NOME,' ') || ' ' || COALESCE(P.DESCRICAO,' ') || ' ' || COALESCE(R.DESCRICAO,' ')) ) @@ to_tsquery(upper('#{params[:filtro_receber].gsub(/\s/,'&')}:*'))" unless params[:filtro_receber].blank?
      if params[:liquidacao] == '0'
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


             WHERE P.UNIDADE_ID = #{params[:unidade]} AND P.LIQUIDACAO = 0
             AND P.VENCIMENTO BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
             #{filtro}
             GROUP BY 1
             ORDER BY 6, 1
             "
      elsif  params[:liquidacao] == '1'
        liqui = "P.LIQUIDACAO = 1"
        div = "AND (P.DIVIDA_REAL + P.DIVIDA_DOLAR + P.DIVIDA_GUARANI) >= 0"

      sql = "SELECT
                   P.TITULO,
                   P.DOCUMENTO_NUMERO_01 AS DOCUMENTO_NUMERO_01,
                   P.DOCUMENTO_NUMERO_02 AS DOCUMENTO_NUMERO_02,
                   P.DOCUMENTO_NUMERO AS DOCUMENTO_NUMERO,
                   P.COTA AS COTA,
                   P.VENCIMENTO AS VENCIMENTO,
                   P.ID AS ID,
                   P.DATA AS DATA,
                   PD.NOME AS PERSONA_NOME,
                   C.NOME AS CONTA_NOME,
                   P.MOEDA AS MOEDA,
                   P.COTA AS COTA,
                   P.COD_PROC AS COD_PROC,
                   P.PERSONA_ID AS PERSONA_ID,
                   P.DESCRICAO AS DESCRICAO,
                   P.TOT_COTAS AS TOT_COTAS,
                   P.CONTA_ID AS CONTA_ID,
                   P.RUBRO_ID AS RUBRO_ID,
                   R.DESCRICAO AS RUBRO_NOME,
                   DIVIDA_GUARANI AS DIVIDA_GUARANI,
                   DIVIDA_DOLAR AS DIVIDA_DOLAR,
                   DIVIDA_REAL AS DIVIDA_REAL


             FROM CLIENTES P

             LEFT JOIN PERSONAS PD
             ON PD.ID = P.PERSONA_ID

             LEFT JOIN CONTAS C
             ON C.ID = P.CONTA_ID

             LEFT JOIN RUBROS R
             ON R.ID = P.RUBRO_ID


             WHERE P.UNIDADE_ID = #{params[:unidade]} AND (P.DIVIDA_GUARANI + P.DIVIDA_REAL + P.DIVIDA_DOLAR) < 0
             AND P.VENCIMENTO BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
             #{filtro}
             ORDER BY 8 DESC, 1
             "
      end



      Cliente.find_by_sql(sql)
    end


  def self.titulo_historico(params)
        sql = "SELECT
                   P.TITULO,
                   P.DOCUMENTO_NUMERO_01 AS DOCUMENTO_NUMERO_01,
                   P.DOCUMENTO_NUMERO_02 AS DOCUMENTO_NUMERO_02,
                   P.DOCUMENTO_NUMERO AS DOCUMENTO_NUMERO,
                   P.COTA AS COTA,
                   P.VENCIMENTO AS VENCIMENTO,
                   P.ID AS ID,
                   P.DATA AS DATA,
                   PD.NOME AS PERSONA_NOME,
                   C.NOME AS CONTA_NOME,
                   P.MOEDA AS MOEDA,
                   P.COTA AS COTA,
                   P.COD_PROC AS COD_PROC,
                   P.PERSONA_ID AS PERSONA_ID,
                   P.DESCRICAO AS DESCRICAO,
                   P.TOT_COTAS AS TOT_COTAS,
                   P.CONTA_ID AS CONTA_ID,
                   P.RUBRO_ID AS RUBRO_ID,
                   P.SIGLA_PROC,
                   R.DESCRICAO AS RUBRO_NOME,
                   U.USUARIO_NOME AS USUARIO_NOME,
                   DIVIDA_GUARANI AS DIVIDA_GUARANI,
                   DIVIDA_DOLAR AS DIVIDA_DOLAR,
                   DIVIDA_REAL AS DIVIDA_REAL


             FROM CLIENTES P

             LEFT JOIN PERSONAS PD
             ON PD.ID = P.PERSONA_ID

             LEFT JOIN CONTAS C
             ON C.ID = P.CONTA_ID

             LEFT JOIN RUBROS R
             ON R.ID = P.RUBRO_ID

             LEFT JOIN USUARIOS U
             ON U.ID = P.USUARIO_CREATED

             WHERE P.TITULO = '#{params[:titulo]}'
             ORDER BY 8, 7
             "
    Cliente.find_by_sql(sql)
  end

    def self.relatorio_contas_receber(params)
        doc       = "AND C.DOCUMENTO_NUMERO = '#{params[:doc]}' " unless params[:doc].blank?
        unidade   = "C.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
        pers      = "AND C.PERSONA_ID = #{params[:persona_id]} " unless params[:persona_id].blank?
        regiao    = "AND P.REGIAO_ID = #{params[:busca]["regiao"]} " unless params[:busca]["regiao"].blank?
        cc        = "AND C.CENTRO_CUSTO_ID = #{params[:busca]["cc"]} " unless params[:busca]["cc"].blank?
        direcao   = "AND P.CIDADE_ID = #{params[:busca]["direcao"]} " unless params[:busca]["direcao"].blank?
        classif   = "AND P.CLASSIFICACAO = '#{params[:busca]["classif"]}' " unless params[:busca]["classif"].blank?
        andelanto = "AND COALESCE(C.DOCUMENTO_ID,0)  <> 9 " if params[:filtra_adelanto].to_s != "1"
        vend      = "AND P.vend_responsavel_id = #{params[:busca]["vendedor"]} " unless params[:busca]["vendedor"].blank?
        turma     = "AND V.TURMA_ID = #{params[:busca]["turma"]} " unless params[:busca]["turma"].blank?

        tutor      = "AND P.vend_responsavel_id = #{params[:busca]["tutor"]} " unless params[:busca]["tutor"].blank?
        setor     = "AND P.SETOR_ID = #{params[:busca]["setor"]} " unless params[:busca]["setor"].blank?
        liq_open  = "AND C.liquidacao = 0  #{vend}"                     if params[:filtro] == "0"  and params[:saldo_periodo] != '1'
        liq_close = "AND C.liquidacao = 1  #{vend}"                     if params[:filtro] == "1"
        liq_all   = " #{vend}"                                        if params[:filtro] == "2"
        cliente_status = "AND P.ESTADO = #{params[:cliente_status]}" unless params[:cliente_status].blank?
        consumo  = "AND C.TABELA = 'CHECK_POINTS' "                     if params[:solo_consumo] == "1"

        clase_produto  = "AND C.CLASE_PRODUTO = #{params[:busca]["clase_produto"]}" unless params[:busca]["clase_produto"].blank?
        filtro_saldo_periodo = "AND (SELECT SUM(SC.DIVIDA_GUARANI - SC.COBRO_GUARANI) FROM CLIENTES SC WHERE SC.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND SC.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND SC.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND SC.PERSONA_ID = C.PERSONA_ID AND SC.data   BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' ) <> 0 "  if params[:saldo_periodo] == '1'

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND C.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND C.moeda = 1"
            else
              moeda = "AND C.moeda = 2"
           end
        end

        if params[:tipo_persona] == "0"
            tipo_persona     = "AND P.TIPO_CLIENTE = 1"
        elsif params[:tipo_persona] == "1"
            tipo_persona     = "AND P.tipo_funcionario = 1"
        elsif params[:tipo_persona] == "2"
            tipo_persona     = "AND P.TIPO_ALUNO = 1"
        else
            tipo_persona     = ""
        end

         if params[:moeda] == "0"
            find_valor = "AND C.DIVIDA_DOLAR BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" unless params[:valor_min].blank?
         elsif params[:moeda] == "1"
            find_valor = "AND C.DIVIDA_GUARANI BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" unless params[:valor_min].blank?
          else
            find_valor = "AND C.DIVIDA_REAL BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" unless params[:valor_min].blank?
         end


        if params[:tipo_data].to_s == 'emicao'
            #FITRO POR DATA FATURACAO
            cond = "#{unidade} C.data  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'  #{liq_open} #{liq_close} #{liq_all} #{moeda} #{vend} #{cliente_status} #{clase_produto} #{filtro_saldo_periodo} #{setor} #{regiao} #{doc} #{direcao} #{classif} #{cc} #{find_valor} #{tipo_persona} #{consumo} #{tutor} #{turma}"
            orden = '4,19,13,14,1'
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "#{unidade}C.vencimento  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{vend} #{cliente_status} #{clase_produto} #{filtro_saldo_periodo} #{setor} #{regiao} #{doc} #{direcao} #{classif} #{cc} #{find_valor} #{tipo_persona} #{consumo} #{tutor} #{turma}"
            orden = '4,19,13,14,1'
        end


        Cliente.find_by_sql("SELECT
                                   C.id,
                                   C.data,
                                   P.id AS PERSONA_ID,
                                   P.NOME AS PERSONA_NOME,
                                   P.ruc,
                                   P.telefone,
                                   C.vendedor_id,
                                   C.vendedor_nome,
                                   C.local_pago,
                                   C.documento_numero_01,
                                   C.documento_numero_02,
                                   C.documento_numero,
                                   C.documento_nome,
                                   C.cota,
                                   C.tabela,
                                   C.liquidacao,
                                   C.venda_id,
                                   C.cheque,
                                   C.vencimento,
                                   C.divida_guarani,
                                   C.divida_dolar,
                                   C.divida_real,
                                   C.cobro_guarani,
                                   C.cobro_dolar,
                                   C.cobro_real,
                                   C.DOCUMENTO_ID,
                                   C.TABELA_ID,
                                   C.DESCRICAO,
                                   P.OBSERVACAO,
                                   P.CLASSIFICACAO,
                                   P.DIRECAO,
                                   CD.NOME AS CIDADE_NOME,
                                   C.TOT_COTAS,
                                   C.COD_PROC,
                                   C.sigla_proc,
                                   CC.NOME AS CENTRO_CUSTO_NOME

                              FROM CLIENTES C
                              LEFT JOIN PERSONAS P
                              ON  C.PERSONA_ID = P.ID

                              LEFT JOIN PERSONAS VD
                              ON  VD.ID = P.vend_responsavel_id

                              LEFT JOIN DOCUMENTOS D
                              ON D.ID = C.DOCUMENTO_ID

                              LEFT JOIN CENTRO_CUSTOS CC
                              ON CC.ID = C.CENTRO_CUSTO_ID

                              LEFT JOIN VENDAS V
                              ON C.VENDA_ID = V.ID

                              LEFT JOIN CIDADES CD
                              ON P.CIDADE_ID = CD.ID

                              WHERE #{cond} #{pers} ORDER BY #{orden}" )
    end

    def self.resultado_extracto_funcionario(params)
        doc       = "AND C.DOCUMENTO_NUMERO = '#{params[:doc]}' " unless params[:doc].blank?
        unidade   = "C.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
        pers      = "AND C.PERSONA_ID = #{params[:busca]["funcionario"]} " unless params[:busca]["funcionario"].blank?
        andelanto = "AND COALESCE(C.DOCUMENTO_ID,0)  <> 9 " if params[:filtra_adelanto].to_s != "1"
        liq_open  = "AND C.liquidacao = 0 #{pers}"                     if params[:filtro] == "0"  and params[:saldo_periodo] != '1'
        liq_close = "AND C.liquidacao = 1 #{pers}"                     if params[:filtro] == "1"
        liq_all   = "#{pers}"                                        if params[:filtro] == "2"
        cliente_status = "AND P.ESTADO = #{params[:cliente_status]}" unless params[:cliente_status].blank?
        filtro_saldo_periodo = "AND (SELECT SUM(SC.DIVIDA_GUARANI - SC.COBRO_GUARANI) FROM CLIENTES SC WHERE SC.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND SC.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND SC.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND SC.PERSONA_ID = C.PERSONA_ID AND SC.data   BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' ) <> 0 "  if params[:saldo_periodo] == '1'

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND C.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND C.moeda = 1"
            else
              moeda = "AND C.moeda = 2"
           end
        end

        if params[:tipo_data].to_s == 'emicao'
            #FITRO POR DATA FATURACAO
            cond = "#{unidade} P.TIPO_FUNCIONARIO = 1  AND C.data  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'  #{liq_open} #{liq_close} #{liq_all} #{moeda} #{cliente_status} #{filtro_saldo_periodo} #{doc}"
            orden = '4,2,13,14,1'
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "#{unidade} P.TIPO_FUNCIONARIO = 1 AND C.vencimento  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{cliente_status} #{filtro_saldo_periodo} #{doc}"
            orden = '4,19,13,14,1'
        end


        Cliente.find_by_sql("SELECT
                                   C.id,
                                   C.data,
                                   P.id AS PERSONA_ID,
                                   P.NOME AS PERSONA_NOME,
                                   P.ruc,
                                   P.telefone,
                                   C.vendedor_id,
                                   C.vendedor_nome,
                                   C.local_pago,
                                   C.documento_numero_01,
                                   C.documento_numero_02,
                                   C.documento_numero,
                                   C.documento_nome,
                                   C.cota,
                                   C.tabela,
                                   C.liquidacao,
                                   C.venda_id,
                                   C.cheque,
                                   C.vencimento,
                                   C.divida_guarani,
                                   C.divida_dolar,
                                   C.divida_real,
                                   C.cobro_guarani,
                                   C.cobro_dolar,
                                   C.cobro_real,
                                   D.SIGLA AS SIGLA_DOC,
                                   S.SIGLA AS SIGLA_SETOR,
                                   C.DOCUMENTO_ID,
                                   C.TABELA_ID,
                                   C.DESCRICAO,
                                   P.OBSERVACAO,
                                   P.CLASSIFICACAO,
                                   P.DIRECAO,
                                   C.cod_proc,
                                   C.SIGLA_PROC,
                                   CD.NOME AS CIDADE_NOME

                              FROM CLIENTES C
                              LEFT JOIN PERSONAS P
                              ON  C.PERSONA_ID = P.ID

                              LEFT JOIN PERSONAS VD
                              ON  VD.ID = P.vend_responsavel_id

                              LEFT JOIN DOCUMENTOS D
                              ON D.ID = C.DOCUMENTO_ID

                              LEFT JOIN SETORS S
                              ON S.ID = C.CLASE_PRODUTO

                              LEFT JOIN VENDAS V
                              ON C.VENDA_ID = V.ID

                              LEFT JOIN CIDADES CD
                              ON P.CIDADE_ID = CD.ID

                              WHERE #{cond} ORDER BY  #{orden}" )
    end


    def self.relatorio_contas_receber_detalhado_produto_funcionario(params)
        doc       = "AND C.DOCUMENTO_NUMERO = '#{params[:doc]}' " unless params[:doc].blank?
        unidade   = "C.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
        pers      = "AND C.PERSONA_ID = #{params[:busca]["funcionario"]} " unless params[:busca]["funcionario"].blank?
        regiao    = "AND P.REGIAO_ID = #{params[:busca]["regiao"]} " unless params[:busca]["regiao"].blank?
        direcao   = "AND P.CIDADE_ID = #{params[:busca]["direcao"]} " unless params[:busca]["direcao"].blank?
        classif   = "AND P.CLASSIFICACAO = '#{params[:busca]["classif"]}' " unless params[:busca]["classif"].blank?
        andelanto = "AND COALESCE(C.DOCUMENTO_ID,0)  <> 9 " if params[:filtra_adelanto].to_s != "1"
        vend      = "AND P.vend_responsavel_id = #{params[:busca]["vendedor"]} " unless params[:busca]["vendedor"].blank?
        setor     = "AND P.SETOR_ID = #{params[:busca]["setor"]} " unless params[:busca]["setor"].blank?
        liq_open  = "AND C.liquidacao = 0 #{pers} #{vend}"                     if params[:filtro] == "0"  and params[:saldo_periodo] != '1'
        liq_close = "AND C.liquidacao = 1 #{pers} #{vend}"                     if params[:filtro] == "1"
        liq_all   = "#{pers} #{vend}"                                        if params[:filtro] == "2"
        cliente_status = "AND P.ESTADO = #{params[:cliente_status]}" unless params[:cliente_status].blank?
        clase_produto  = "AND C.CLASE_PRODUTO = #{params[:busca]["clase_produto"]}" unless params[:busca]["clase_produto"].blank?
        filtro_saldo_periodo = "AND (SELECT SUM(SC.DIVIDA_GUARANI - SC.COBRO_GUARANI) FROM CLIENTES SC WHERE SC.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND SC.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND SC.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND SC.PERSONA_ID = C.PERSONA_ID AND SC.data   BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' ) <> 0 "  if params[:saldo_periodo] == '1'

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND C.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND C.moeda = 1"
            else
              moeda = "AND C.moeda = 2"
           end
        end

        if params[:tipo_data].to_s == 'emicao'
            #FITRO POR DATA FATURACAO
            cond = "#{unidade} (COALESCE(C.DIVIDA_GUARANI,0) + COALESCE(C.DIVIDA_DOLAR,0) ) > 0 AND P.TIPO_FUNCIONARIO = 1  AND C.data  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'  #{liq_open} #{liq_close} #{liq_all} #{moeda} #{vend} #{cliente_status} #{clase_produto} #{filtro_saldo_periodo} #{setor} #{regiao} #{doc} #{direcao} #{classif}"
            cond_ad = "#{unidade}  C.TABELA = 'ADELANTO_COTAS' AND P.TIPO_FUNCIONARIO = 1  AND C.data  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'  #{liq_open} #{liq_close} #{liq_all} #{moeda} #{vend} #{cliente_status} #{clase_produto} #{filtro_saldo_periodo} #{setor} #{regiao} #{doc} #{direcao} #{classif}"
            orden = '4,2,13,14,1'
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "#{unidade} (COALESCE(C.DIVIDA_GUARANI,0) + COALESCE(C.DIVIDA_DOLAR,0) ) > 0 AND  P.TIPO_FUNCIONARIO = 1 AND C.vencimento  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{vend} #{cliente_status} #{clase_produto} #{filtro_saldo_periodo} #{setor} #{regiao} #{doc} #{direcao} #{classif}"
            cond_ad = "#{unidade} C.TABELA = 'ADELANTO_COTAS' AND AND  P.TIPO_FUNCIONARIO = 1 AND C.vencimento  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{vend} #{cliente_status} #{clase_produto} #{filtro_saldo_periodo} #{setor} #{regiao} #{doc} #{direcao} #{classif}"
            orden = '4,19,13,14,1'
        end


        Cliente.find_by_sql("SELECT
                                   C.id,
                                   C.data,
                                   P.id AS PERSONA_ID,
                                   P.NOME AS PERSONA_NOME,
                                   P.ruc,
                                   P.telefone,
                                   C.vendedor_id,
                                   C.vendedor_nome,
                                   C.local_pago,
                                   C.documento_numero_01,
                                   C.documento_numero_02,
                                   C.documento_numero,
                                   C.documento_nome,
                                   C.cota,
                                   C.tabela,
                                   C.liquidacao,
                                   C.venda_id,
                                   C.cheque,
                                   C.vencimento,
                                   C.divida_guarani,
                                   C.divida_dolar,
                                   C.divida_real,
                                   D.SIGLA AS SIGLA_DOC,
                                   S.SIGLA AS SIGLA_SETOR,
                                   C.DOCUMENTO_ID,
                                   C.TABELA_ID,
                                   C.DESCRICAO,
                                   P.OBSERVACAO,
                                   P.CLASSIFICACAO,
                                   P.DIRECAO,
                                   CD.NOME AS CIDADE_NOME,
                                   (SELECT SUM(PG.COBRO_GUARANI) FROM CLIENTES PG WHERE PG.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND PG.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND PG.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND PG.COTA = C.COTA ) AS COBRO_GUARANI,
                                   (SELECT SUM(PG.COBRO_DOLAR) FROM CLIENTES PG WHERE PG.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND PG.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND PG.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND PG.COTA = C.COTA ) AS COBRO_DOLAR

                              FROM CLIENTES C
                              LEFT JOIN PERSONAS P
                              ON  C.PERSONA_ID = P.ID

                              LEFT JOIN PERSONAS VD
                              ON  VD.ID = P.vend_responsavel_id

                              LEFT JOIN DOCUMENTOS D
                              ON D.ID = C.DOCUMENTO_ID

                              LEFT JOIN SETORS S
                              ON S.ID = C.CLASE_PRODUTO

                              LEFT JOIN VENDAS V
                              ON C.VENDA_ID = V.ID

                              LEFT JOIN CIDADES CD
                              ON P.CIDADE_ID = CD.ID

                              WHERE #{cond} ORDER BY  #{orden}

                    " )
    end


    def self.relatorio_contas_receber_detalhado_produto(params)
        doc       = "AND C.DOCUMENTO_NUMERO = '#{params[:doc]}' " unless params[:doc].blank?
        cota      = "AND C.COTA = #{params[:cota]} " unless params[:cota].blank?
        unidade   = "C.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
        unidade_ant   = "AND AT.UNIDADE_ID = #{params[:unidade]} " unless params[:unidade].blank?
        pers      = "AND C.PERSONA_ID = #{params[:persona_id]} " unless params[:persona_id].blank?
        regiao    = "AND P.REGIAO_ID = #{params[:busca]["regiao"]} " unless params[:busca]["regiao"].blank?
        cc        = "AND C.CENTRO_CUSTO_ID = #{params[:busca]["cc"]} " unless params[:busca]["cc"].blank?
        direcao   = "AND P.CIDADE_ID = #{params[:busca]["direcao"]} " unless params[:busca]["direcao"].blank?
        classif   = "AND P.CLASSIFICACAO = '#{params[:busca]["classif"]}' " unless params[:busca]["classif"].blank?
        andelanto = "AND COALESCE(C.DOCUMENTO_ID,0)  <> 9 " if params[:filtra_adelanto].to_s != "1"
        vend      = "AND P.vend_responsavel_id = #{params[:busca]["vendedor"]} " unless params[:busca]["vendedor"].blank?
        consumo  = "AND C.TABELA = 'CHECK_POINTS' "                     if params[:solo_consumo] == "1"
        setor     = "AND P.SETOR_ID = #{params[:busca]["setor"]} " unless params[:busca]["setor"].blank?
        tutor     = "AND P.vend_responsavel_id = #{params[:busca]["tutor"]} " unless params[:busca]["tutor"].blank?
        turma     = "AND V.TURMA_ID = #{params[:busca]["turma"]} " unless params[:busca]["turma"].blank?
        liq_open  = "AND C.liquidacao = 0  #{vend}"                     if params[:filtro] == "0"  and params[:saldo_periodo] != '1'
        liq_close = "AND C.liquidacao = 1  #{vend}"                     if params[:filtro] == "1"
        liq_all   = " #{vend}"                                        if params[:filtro] == "2"
        cliente_status = "" unless params[:cliente_status].blank?
        clase_produto  = "AND C.CLASE_PRODUTO = #{params[:busca]["clase_produto"]}" unless params[:busca]["clase_produto"].blank?
        filtro_saldo_periodo = "AND (SELECT SUM(SC.DIVIDA_GUARANI - SC.COBRO_GUARANI) FROM CLIENTES SC WHERE SC.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND SC.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND SC.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND SC.PERSONA_ID = C.PERSONA_ID AND SC.data   BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' ) <> 0 "  if params[:saldo_periodo] == '1'

        if params[:lancamento].to_s != "1"
          if params[:moeda] == "0"
            moeda = "AND C.moeda = 0"
          elsif params[:moeda] == "1"
            moeda = "AND C.moeda = 1"
          else
            moeda = "AND C.moeda = 2"
          end
        end

        if params[:moeda] == "0"
          find_valor = "AND C.DIVIDA_DOLAR BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
        elsif params[:moeda] == "1"
          find_valor = "AND C.DIVIDA_GUARANI BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
        else
          find_valor = "AND C.DIVIDA_REAL BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
        end

        if params[:tipo_persona] == "0"
            tipo_persona     = "AND P.TIPO_CLIENTE = 1"
        elsif params[:tipo_persona] == "1"
            tipo_persona     = "AND P.tipo_funcionario = 1"
        elsif params[:tipo_persona] == "2"
            tipo_persona     = "AND P.TIPO_ALUNO = 1"
        else
            tipo_persona     = ""
        end

        if params[:tipo_data].to_s == 'emicao'
            #FITRO POR DATA FATURACAO
            cond = " AND #{unidade} C.data  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'  #{liq_open} #{liq_close} #{liq_all} #{moeda} #{vend} #{cliente_status} #{clase_produto} #{filtro_saldo_periodo} #{setor} #{regiao} #{doc} #{direcao} #{classif} #{cc} #{cota} #{find_valor} #{consumo} #{tutor} #{turma}" 
            orden = '3,11,1'
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "AND #{unidade} C.vencimento  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{vend} #{cliente_status} #{clase_produto} #{filtro_saldo_periodo} #{setor} #{regiao} #{doc} #{direcao} #{classif} #{cc} #{cota} #{find_valor} #{consumo} #{tutor} #{turma}"
            orden = '3,12,13,1'
        end



        Cliente.find_by_sql("SELECT C.ID,
                      C.PERSONA_ID,
                      P.NOME AS PERSONA_NOME,
                      C.VENDEDOR_ID,
                      C.VENDEDOR_NOME,
                      C.COD_PROC,
                      C.SIGLA_PROC,
                      C.LIQUIDACAO,
                      C.MOEDA,
                      C.TIPO,
                      C.DATA,
                      C.VENCIMENTO,
                      C.VENDA_ID,
                      C.DOCUMENTO_NOME,
                      C.DOCUMENTO_NUMERO,
                      C.COTA,
                      C.CLASE_PRODUTO,
                      C.ORIGINAL,
                      C.DIVIDA_DOLAR,
                      C.DIVIDA_GUARANI,
                      C.DIVIDA_REAL,
                      C.COBRO_DOLAR,
                      C.COBRO_GUARANI,
                      C.COBRO_REAL,
                      C.DESCRICAO,
                      C.DOCUMENTO_NUMERO_01,
                      C.documento_numero_02,
                      U.UNIDADE_NOME,
                      C.TOT_COTAS,
                      V.COTACAO AS COTACAO_VENDA,
                      CC.NOME AS CENTRO_CUSTO_NOME,
                      VD.NOME VEND_RESPONSAVEL_NOME,
                      ARRAY(SELECT (json_build_object('produto_nome', VP.PRODUTO_NOME)) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = C.VENDA_ID) AS array_venda_produtos,
                      (SELECT AT.DATA FROM CLIENTES AT WHERE  AT.COBRO_REAL > 0 AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA #{unidade_ant} ORDER BY DATA DESC LIMIT 1) AS PG_DATA,
                      (SELECT SUM(AT.COBRO_DOLAR) FROM CLIENTES AT WHERE AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA #{unidade_ant}) AS ANTERIOR_US,
                      (SELECT SUM(AT.COBRO_GUARANI) FROM CLIENTES AT WHERE AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA #{unidade_ant}) AS ANTERIOR_GS,
                      (SELECT SUM(AT.COBRO_REAL) FROM CLIENTES AT WHERE AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA #{unidade_ant}) AS ANTERIOR_RS
            FROM CLIENTES C
            LEFT JOIN VENDAS V
            ON C.VENDA_ID = V.ID
            LEFT JOIN UNIDADES U
            ON C.UNIDADE_ID = U.ID
            INNER JOIN PERSONAS P
            ON P.ID = C.PERSONA_ID
            LEFT JOIN CENTRO_CUSTOS CC
            ON CC.ID = C.CENTRO_CUSTO_ID

            LEFT JOIN PERSONAS VD
            ON VD.ID = P.VEND_RESPONSAVEL_ID

            WHERE (C.DIVIDA_GUARANI + C.DIVIDA_DOLAR + C.DIVIDA_REAL ) > 0 #{cond} #{pers} #{tipo_persona}
            ORDER BY #{orden}

            

            " )
    end



    def self.relatorio_contas_receber_detalhado_tutor_aluno(params)
        doc       = "AND C.DOCUMENTO_NUMERO = '#{params[:doc]}' " unless params[:doc].blank?
        cota      = "AND C.COTA = #{params[:cota]} " unless params[:cota].blank?
        unidade   = "C.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
        unidade_ant   = "AND AT.UNIDADE_ID = #{params[:unidade]} " unless params[:unidade].blank?
        pers      = "AND C.PERSONA_ID = #{params[:persona_id]} " unless params[:persona_id].blank?
        regiao    = "AND P.REGIAO_ID = #{params[:busca]["regiao"]} " unless params[:busca]["regiao"].blank?
        cc        = "AND C.CENTRO_CUSTO_ID = #{params[:busca]["cc"]} " unless params[:busca]["cc"].blank?
        direcao   = "AND P.CIDADE_ID = #{params[:busca]["direcao"]} " unless params[:busca]["direcao"].blank?
        classif   = "AND P.CLASSIFICACAO = '#{params[:busca]["classif"]}' " unless params[:busca]["classif"].blank?
        andelanto = "AND COALESCE(C.DOCUMENTO_ID,0)  <> 9 " if params[:filtra_adelanto].to_s != "1"
        vend      = "AND P.vend_responsavel_id = #{params[:busca]["vendedor"]} " unless params[:busca]["vendedor"].blank?
        consumo  = "AND C.TABELA = 'CHECK_POINTS' "                     if params[:solo_consumo] == "1"
        setor     = "AND P.SETOR_ID = #{params[:busca]["setor"]} " unless params[:busca]["setor"].blank?
        tutor     = "AND P.vend_responsavel_id = #{params[:busca]["tutor"]} " unless params[:busca]["tutor"].blank?
        liq_open  = "AND C.liquidacao = 0  #{vend}"                     if params[:filtro] == "0"  and params[:saldo_periodo] != '1'
        liq_close = "AND C.liquidacao = 1  #{vend}"                     if params[:filtro] == "1"
        liq_all   = " #{vend}"                                        if params[:filtro] == "2"
        cliente_status = "" unless params[:cliente_status].blank?
        clase_produto  = "AND C.CLASE_PRODUTO = #{params[:busca]["clase_produto"]}" unless params[:busca]["clase_produto"].blank?
        filtro_saldo_periodo = "AND (SELECT SUM(SC.DIVIDA_GUARANI - SC.COBRO_GUARANI) FROM CLIENTES SC WHERE SC.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND SC.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND SC.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND SC.PERSONA_ID = C.PERSONA_ID AND SC.data   BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' ) <> 0 "  if params[:saldo_periodo] == '1'

        if params[:lancamento].to_s != "1"
          if params[:moeda] == "0"
            moeda = "AND C.moeda = 0"
          elsif params[:moeda] == "1"
            moeda = "AND C.moeda = 1"
          else
            moeda = "AND C.moeda = 2"
          end
        end

        if params[:moeda] == "0"
          find_valor = "AND C.DIVIDA_DOLAR BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
        elsif params[:moeda] == "1"
          find_valor = "AND C.DIVIDA_GUARANI BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
        else
          find_valor = "AND C.DIVIDA_REAL BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
        end

        if params[:tipo_persona] == "0"
            tipo_persona     = "AND P.TIPO_CLIENTE = 1"
        elsif params[:tipo_persona] == "1"
            tipo_persona     = "AND P.tipo_funcionario = 1"
        elsif params[:tipo_persona] == "2"
            tipo_persona     = "AND P.TIPO_ALUNO = 1"
        else
            tipo_persona     = ""
        end

        if params[:tipo_data].to_s == 'emicao'
            #FITRO POR DATA FATURACAO
            cond = " AND #{unidade} C.data  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'  #{liq_open} #{liq_close} #{liq_all} #{moeda} #{vend} #{cliente_status} #{clase_produto} #{filtro_saldo_periodo} #{setor} #{regiao} #{doc} #{direcao} #{classif} #{cc} #{cota} #{find_valor} #{consumo} #{tutor}" 
            orden = '2,3,5,6'
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "AND #{unidade} C.vencimento  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{vend} #{cliente_status} #{clase_produto} #{filtro_saldo_periodo} #{setor} #{regiao} #{doc} #{direcao} #{classif} #{cc} #{cota} #{find_valor} #{consumo} #{tutor}"
            orden = '2,3,5,6'
        end



        Cliente.find_by_sql("SELECT 
                      C.PERSONA_ID,
                      MAX(P.NOME) AS PERSONA_NOME,
                      MIN(VD.NOME) VEND_RESPONSAVEL_NOME,
                      MAX(C.MOEDA) AS MOEDA,
                      MIN(C.DATA) AS DATA,
                      MIN(C.VENCIMENTO) AS VENCIMENTO,
                      C.DOCUMENTO_NUMERO,
                      C.COTA,
                      MIN(C.VENDA_ID) AS VENDA_ID,
                      MIN(C.DESCRICAO) AS DESCRICAO,
                      SUM(COALESCE(C.DIVIDA_DOLAR,0)) AS DIVIDA_DOLAR,
                      SUM(COALESCE(C.DIVIDA_GUARANI,0)) AS DIVIDA_GUARANI,
                      SUM(COALESCE(C.DIVIDA_REAL,0)) AS DIVIDA_REAL,
                      SUM(COALESCE(C.COBRO_DOLAR,0)) AS ANTERIOR_US,
                      SUM(COALESCE(C.COBRO_GUARANI,0) ) AS ANTERIOR_GS,
                      SUM(COALESCE(C.COBRO_REAL,0)) AS ANTERIOR_RS,
                      MAX(C.DOCUMENTO_NUMERO_01),
                      MAX(C.documento_numero_02),
                      MAX(U.UNIDADE_NOME),
                      MIN(C.TOT_COTAS) AS TOT_COTAS,
                      MIN(CC.NOME) AS CENTRO_CUSTO_NOME,
                      ARRAY(SELECT (json_build_object('produto_nome', VP.PRODUTO_NOME)) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = MIN(C.VENDA_ID) ) AS array_venda_produtos,
                      MAX(C.DATA) AS PG_DATA
            FROM CLIENTES C
            LEFT JOIN VENDAS V
            ON C.VENDA_ID = V.ID
            LEFT JOIN UNIDADES U
            ON C.UNIDADE_ID = U.ID
            INNER JOIN PERSONAS P
            ON P.ID = C.PERSONA_ID
            LEFT JOIN CENTRO_CUSTOS CC
            ON CC.ID = C.CENTRO_CUSTO_ID

            LEFT JOIN PERSONAS VD
            ON VD.ID = P.VEND_RESPONSAVEL_ID

            WHERE c.id > 0 #{cond} #{pers} #{tipo_persona}

            GROUP BY C.PERSONA_ID, C.DOCUMENTO_NUMERO, C.COTA
            ORDER BY #{orden}

            

            " )
    end



    def self.relatorio_contas_receber_saldo_anterior(params)
        unidade   = "clientes.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
        plano     = "AND clientes.PLANO_ID = #{params[:busca]["plano"]} " unless params[:busca]["plano"].blank?
        regiao    = "AND personas.REGIAO_ID = #{params[:busca]["regiao"]} " unless params[:busca]["regiao"].blank?
        direcao   = "AND personas.CIDADE_ID = #{params[:busca]["direcao"]} " unless params[:busca]["direcao"].blank?
        classif   = "AND personas.CLASSIFICACAO = '#{params[:busca]["classif"]}' " unless params[:busca]["classif"].blank?
        carteira  = "AND personas.CARTEIRA_ID = '#{params[:busca]["carteira"]}' " unless params[:busca]["carteira"].blank?
        pers      = "AND clientes.PERSONA_ID = #{params[:persona_id]} " unless params[:persona_id].blank?
        liq_open  = "AND clientes.liquidacao = 0 #{pers}"                     if params[:filtro] == "0"
        liq_close = "AND clientes.liquidacao = 1 #{pers}"                     if params[:filtro] == "1"
        tutor      = "AND personas.vend_responsavel_id = #{params[:busca]["tutor"]} " unless params[:busca]["tutor"].blank?
        vend      = "AND personas.vend_responsavel_id = #{params[:busca]["vendedor"]} " unless params[:busca]["vendedor"].blank?
        setor     = "AND PERSONAS.setor_id = #{params[:busca]["setor"]} " unless params[:busca]["setor"].blank?
        liq_all   = "#{pers}"                                        if params[:filtro] == "2"
        cliente_status = "AND PERSONAS.ESTADO = #{params[:cliente_status]}" unless params[:cliente_status].blank?
        clase_produto  = "AND clientes.CLASE_PRODUTO = #{params[:busca]["clase_produto"]}" unless params[:busca]["clase_produto"].blank?

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND clientes.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND clientes.moeda = 1"
            else
              moeda = "AND clientes.moeda = 2"
           end
        end

        if params[:moeda] == "0"
            valor = "clientes.divida_dolar - clientes.cobro_dolar"
        elsif params[:moeda] == "1"
            valor = "clientes.divida_guarani - clientes.cobro_guarani"
        else
            valor = "clientes.divida_real - clientes.cobro_real"
        end
        if params[:clase] == "0"
            clase     = "AND clientes.clase_produto = 0"
        elsif params[:clase] == "1"
            clase     = "AND clientes.clase_produto = 1"
        else
            clase     = ""
        end

        if params[:tipo_persona] == "0"
            tipo_persona     = "AND personas.TIPO_CLIENTE = 1"
        elsif params[:tipo_persona] == "1"
            tipo_persona     = "AND personas.tipo_funcionario = 1"
        elsif params[:tipo_persona] == "2"
            tipo_persona     = "AND personas.TIPO_ALUNO = 1"
        else
            tipo_persona     = ""
        end


        if params[:tipo_data].to_s == 'emicao'
            #FITRO POR DATA FATURACAO
            cond = "#{unidade} clientes.data < '#{params[:inicio].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{cliente_status} #{vend} #{setor} #{regiao} #{direcao} #{classif} #{tipo_persona} #{tutor}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "#{unidade} clientes.vencimento < '#{params[:inicio].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{cliente_status} #{vend} #{setor} #{regiao} #{direcao} #{classif} #{tipo_persona} #{tutor}"
        end

        Cliente.sum(valor,:conditions => cond, :joins=> 'INNER JOIN  personas on clientes.persona_id = personas.id INNER JOIN  personas vd on vd.id = personas.vend_responsavel_id' )
    end



    def self.relatorio_contas_receber_saldo_anterior_funcionario(params)
        unidade   = "clientes.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
        plano     = "AND clientes.PLANO_ID = #{params[:busca]["plano"]} " unless params[:busca]["plano"].blank?
        regiao    = "AND personas.REGIAO_ID = #{params[:busca]["regiao"]} " unless params[:busca]["regiao"].blank?
        direcao   = "AND personas.CIDADE_ID = #{params[:busca]["direcao"]} " unless params[:busca]["direcao"].blank?
        classif   = "AND personas.CLASSIFICACAO = '#{params[:busca]["classif"]}' " unless params[:busca]["classif"].blank?
        carteira  = "AND personas.CARTEIRA_ID = '#{params[:busca]["carteira"]}' " unless params[:busca]["carteira"].blank?
        pers      = "AND clientes.PERSONA_ID = #{params[:busca]["funcionario"]} " unless params[:busca]["funcionario"].blank?
        liq_open  = "AND clientes.liquidacao = 0 #{pers}"                     if params[:filtro] == "0"
        liq_close = "AND clientes.liquidacao = 1 #{pers}"                     if params[:filtro] == "1"
        vend      = "AND personas.vend_responsavel_id = #{params[:busca]["vendedor"]} " unless params[:busca]["vendedor"].blank?
        setor     = "AND PERSONAS.setor_id = #{params[:busca]["setor"]} " unless params[:busca]["setor"].blank?
        liq_all   = "#{pers}"                                        if params[:filtro] == "2"
        cliente_status = "AND PERSONAS.ESTADO = #{params[:cliente_status]}" unless params[:cliente_status].blank?
        clase_produto  = "AND clientes.CLASE_PRODUTO = #{params[:busca]["clase_produto"]}" unless params[:busca]["clase_produto"].blank?

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND clientes.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND clientes.moeda = 1"
            else
              moeda = "AND clientes.moeda = 2"
           end
        end

        if params[:moeda] == "0"
            valor = "clientes.divida_dolar - clientes.cobro_dolar"
        elsif params[:moeda] == "1"
            valor = "clientes.divida_guarani - clientes.cobro_guarani"
        else
            valor = "clientes.divida_real - clientes.cobro_real"
        end
        if params[:clase] == "0"
            clase     = "AND clientes.clase_produto = 0"
        elsif params[:clase] == "1"
            clase     = "AND clientes.clase_produto = 1"
        else
            clase     = ""
        end


        if params[:tipo_data].to_s == 'emicao'
            #FITRO POR DATA FATURACAO
            cond = "#{unidade} personas.TIPO_FUNCIONARIO = 1 and clientes.data < '#{params[:inicio].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{cliente_status} #{vend} #{setor} #{regiao} #{direcao} #{classif}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "#{unidade} personas.TIPO_FUNCIONARIO = 1 AND clientes.vencimento < '#{params[:inicio].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{cliente_status} #{vend} #{setor} #{regiao} #{direcao} #{classif}"
        end

        Cliente.sum(valor,:conditions => cond, :joins=> 'INNER JOIN  personas on clientes.persona_id = personas.id INNER JOIN  personas vd on vd.id = personas.vend_responsavel_id' )
    end



    def self.relatorio_por_fatura(params)
        #filtros
        carteira  = "AND P.CARTEIRA_ID = '#{params[:busca]["carteira"]}' " unless params[:busca]["carteira"].blank?
        unidade   = "C.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
        pers      = "AND C.PERSONA_ID = #{params[:persona_id]} " unless params[:persona_id].blank?
        doc       = "AND C.DOCUMENTO_NUMERO = '#{params[:doc]}'" unless params[:doc].blank?
        plano     = "AND C.PLANO_ID = #{params[:busca]["plano"]} " unless params[:busca]["plano"].blank?
        regiao    = "AND P.REGIAO_ID = #{params[:busca]["regiao"]} " unless params[:busca]["regiao"].blank?
        tutor     = "AND P.vend_responsavel_id = #{params[:busca]["tutor"]} " unless params[:busca]["tutor"].blank?

        liq_open  = "AND C.LIQUIDACAO = 0 #{pers} #{doc}"                     if params[:filtro] == "0"
        liq_close = "AND C.LIQUIDACAO = 1 #{pers} #{doc}"                     if params[:filtro] == "1"
        liq_all   = "#{pers} #{doc}"                                          if params[:filtro] == "2"
        city      = "AND P.cidade_id = #{params[:busca]["direcao"]}" unless params[:busca]["direcao"].blank?
        vend      = "AND C.vendedor_id = #{params[:busca]["vendedor"]}" unless params[:busca]["vendedor"].blank?
        cliente_status = "AND P.ESTADO = #{params[:cliente_status]}"  unless params[:cliente_status].blank?
        clase_produto  = "AND C.CLASE_PRODUTO = #{params[:busca]["clase_produto"]}" unless params[:busca]["clase_produto"].blank?
        cc        = "AND C.CENTRO_CUSTO_ID = #{params[:busca]["cc"]} " unless params[:busca]["cc"].blank?

        #moeda
        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND C.MOEDA = 0"
           elsif params[:moeda] == "1"
              moeda = "AND C.MOEDA = 1"
          else
              moeda = "AND C.MOEDA = 2"
           end
        end
        #setor
        if params[:clase] == "0"
            clase     = "AND C.CLASE_PRODUTO = 0"
        elsif params[:clase] == "1"
            clase     = "AND C.CLASE_PRODUTO = 1"
        else
            clase     = ""
        end

        if params[:tipo_persona] == "0"
            tipo_persona     = "AND P.TIPO_CLIENTE = 1"
        elsif params[:tipo_persona] == "1"
            tipo_persona     = "AND P.tipo_funcionario = 1"
        elsif params[:tipo_persona] == "2"
            tipo_persona     = "AND P.TIPO_ALUNO = 1"
        else
            tipo_persona     = ""
        end



        #data/vencimento
        if params[:tipo_data].to_s == 'emicao'
            #FITRO POR DATA FATURACAO
            cond = "#{unidade} C.data  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{sub_cons} #{city} #{vend} #{cliente_status} #{clase_produto} #{regiao} #{tipo_persona} #{tutor} #{cc}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "#{unidade} C.vencimento  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{sub_cons} #{city} #{vend} #{cliente_status} #{clase_produto} #{regiao} #{tipo_persona} #{tutor} #{cc}"
        end



    sql="SELECT
                  P.NOME_FATURA AS PERSONA_NOME,
                  C.DOCUMENTO_NUMERO,
                  C.COTA,
                  MIN(C.DATA) AS DATA_FAC,
                  MAX(P.RUC) AS RUC,
                  MAX(P.TELEFONE) AS TELEFONE,
                  MAX(P.CLASSIFICACAO) AS CLASSIFICACAO,
                  MAX(P.DIRECAO) AS DIRECAO,
                  MAX(P.CIDADE) AS CIDADE,
                  MAX(P.OBSERVACAO) AS OBSERVACAO,
                  MAX(P.ID) AS PERSONA_ID,
                  MAX(C.VENCIMENTO) AS VENCIMENTO,
                  MAX(C.LIQUIDACAO) AS LIQUIDACAO,
                  SUM(C.DIVIDA_DOLAR) AS SUM_DD,
                  SUM(C.COBRO_DOLAR) AS SUM_CD,
                  SUM(C.DIVIDA_GUARANI) AS SUM_DG,
                  SUM(C.COBRO_GUARANI) AS SUM_CG,
                  SUM(C.DIVIDA_REAL) AS SUM_DR,
                  SUM(C.COBRO_REAL) AS SUM_CR


          FROM
            CLIENTES C
          INNER JOIN
          PERSONAS P
          ON C.PERSONA_ID = P.ID

          LEFT JOIN PERSONAS VD
          ON  VD.ID = P.vend_responsavel_id

         WHERE
            #{cond}
         GROUP BY
                  1,2,3
           ORDER BY
                    1,4,2,3,14"
    Cliente.find_by_sql(sql)

    end


  def self.contas_receber_resumido(params) #LISTADO DE CLIENTE RESUMIDO POR CLIENTE
        unidade   = " C.UNIDADE_ID = #{params[:unidade]} AND" unless params[:unidade].blank?
        carteira  = "AND P.CARTEIRA_ID = '#{params[:busca]["carteira"]}' " unless params[:busca]["carteira"].blank?
        pers      = "AND C.PERSONA_ID = #{params[:persona_id]} " unless params[:persona_id].blank?
        plano     = "AND C.PLANO_ID = #{params[:busca]["plano"]} " unless params[:busca]["plano"].blank?
        regiao    = "AND P.REGIAO_ID = #{params[:busca]["regiao"]} " unless params[:busca]["regiao"].blank?
        direcao   = "AND P.CIDADE_ID = #{params[:busca]["direcao"]} " unless params[:busca]["direcao"].blank?
        classif   = "AND P.CLASSIFICACAO = '#{params[:busca]["classif"]}' " unless params[:busca]["classif"].blank?
        tutor     = "AND P.vend_responsavel_id = #{params[:busca]["tutor"]} " unless params[:busca]["tutor"].blank?

        andelanto = "AND COALESCE(C.DOCUMENTO_ID,0)  <> 9 " if params[:filtra_adelanto].to_s != "1"
        vend      = "AND P.vend_responsavel_id = #{params[:busca]["vendedor"]} " unless params[:busca]["vendedor"].blank?
        setor     = "AND P.setor_id = #{params[:busca]["setor"]} " unless params[:busca]["setor"].blank?
        liq_open  = "AND C.LIQUIDACAO = 0 #{pers}"                     if params[:filtro] == "0" and params[:saldo_periodo] != '1'
        liq_close = "AND C.LIQUIDACAO = 1 #{pers}"                     if params[:filtro] == "1"
        liq_all   = "#{pers}"                                          if params[:filtro] == "2"
        cliente_status = "AND P.ESTADO = #{params[:cliente_status]}"  unless params[:cliente_status].blank?
        clase_produto  = "AND C.CLASE_PRODUTO = #{params[:busca]["clase_produto"]}" unless params[:busca]["clase_produto"].blank?
        cc        = "AND C.CENTRO_CUSTO_ID = #{params[:busca]["cc"]} " unless params[:busca]["cc"].blank?

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND C.MOEDA = 0"
           elsif params[:moeda] == "1"
              moeda = "AND C.MOEDA = 1"
            else
              moeda = "AND C.MOEDA = 2"
           end
        end

        if params[:tipo_persona] == "0"
            tipo_persona     = "AND P.TIPO_CLIENTE = 1"
        elsif params[:tipo_persona] == "1"
            tipo_persona     = "AND P.tipo_funcionario = 1"
        elsif params[:tipo_persona] == "2"
            tipo_persona     = "AND P.TIPO_ALUNO = 1"
        else
            tipo_persona     = ""
        end


        if params[:tipo_data].to_s == 'emicao'
            #FITRO POR DATA FATURACAO
            cond = "#{unidade} C.data  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}'AND  '#{params[:final].split("/").reverse.join("-")}' AND P.ESTADO = 0  #{liq_open} #{liq_close} #{liq_all} #{moeda} #{cliente_status} #{clase_produto} #{vend} #{setor} #{regiao} #{direcao} #{classif} #{tipo_persona} #{tutor} #{cc}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "#{unidade} C.vencimento BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'  AND P.ESTADO = 0 #{liq_open} #{liq_close} #{liq_all} #{moeda} #{cliente_status} #{clase_produto} #{vend} #{setor} #{regiao} #{direcao} #{classif} #{tipo_persona} #{tutor} #{cc}"
        end

    sql="SELECT
            P.ID AS PERSONA_ID,
            MAX(P.NOME) AS NOME,
            MAX(P.TELEFONE) AS TELEFONE,
            SUM( C.DIVIDA_DOLAR ) AS DIV_US,
            SUM( C.COBRO_DOLAR ) AS COB_US,
            SUM( C.DIVIDA_GUARANI ) AS DIV_GS,
            SUM( C.COBRO_GUARANI ) AS COB_GS,
            SUM( C.DIVIDA_REAL ) AS DIV_RS,
            SUM( C.COBRO_REAl ) AS COB_RS,
            (SUM( C.DIVIDA_GUARANI ) - SUM( C.COBRO_GUARANI )) AS SALDO,
            MAX(C.VENCIMENTO) AS VENCI
          FROM CLIENTES C
          INNER JOIN PERSONAS P
          ON C.PERSONA_ID = P.ID

          LEFT JOIN PERSONAS VD
          ON  VD.ID = P.vend_responsavel_id

          WHERE #{cond}
          GROUP BY 1
          ORDER BY 2,11 DESC"
    Cliente.find_by_sql(sql)
  end


  def self.contas_receber_resumido_vencimento(params) #LISTADO DE CLIENTE RESUMIDO POR CLIENTE
        unidade   = "C.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
        carteira  = "AND P.CARTEIRA_ID = '#{params[:busca]["carteira"]}' " unless params[:busca]["carteira"].blank?
        pers      = "P.ID = #{params[:persona_id]} AND" unless params[:persona_id].blank?
        regiao    = "AND P.REGIAO_ID = #{params[:busca]["regiao"]} " unless params[:busca]["regiao"].blank?

        andelanto = " AND C.TIPO <> '0'" if params[:filtra_adelanto].to_s != "1"
        cliente_status = "AND P.ESTADO = #{params[:cliente_status]}"  unless params[:cliente_status].blank?
        clase_produto  = "AND C.CLASE_PRODUTO = #{params[:busca]["clase_produto"]}" unless params[:busca]["clase_produto"].blank?

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND MOEDA = 0"
           elsif params[:moeda] == "1"
              moeda = "AND MOEDA = 1"
          else
              moeda = "AND MOEDA = 2"
           end
        end



        if params[:tipo_data].to_s == 'emicao'


          sql="SELECT P.ID,
                      P.NOME,
                      P.TELEFONE,
                      (SELECT SUM(DIVIDA_DOLAR - COBRO_DOLAR) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{params[:final].split("/").reverse.join("-")}' #{clase} #{moeda} #{clase_produto} #{regiao}) AS VENCIDA_US,
                      (SELECT SUM(DIVIDA_DOLAR - COBRO_DOLAR) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO > '#{params[:final].split("/").reverse.join("-")}' #{clase} #{moeda} #{clase_produto} #{regiao}) AS A_VENCER_US,
                      (SELECT SUM(DIVIDA_GUARANI - COBRO_GUARANI) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{params[:final].split("/").reverse.join("-")}' #{clase} #{moeda} #{clase_produto} #{regiao}) AS VENCIDA_GS,
                      (SELECT SUM(DIVIDA_GUARANI - COBRO_GUARANI) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO > '#{params[:final].split("/").reverse.join("-")}' #{clase} #{moeda} #{clase_produto} #{regiao}) AS A_VENCER_GS,
                      (SELECT SUM(DIVIDA_REAL - COBRO_REAL) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{params[:final].split("/").reverse.join("-")}' #{clase} #{moeda} #{clase_produto} #{regiao}) AS VENCIDA_RS,
                      (SELECT SUM(DIVIDA_REAL - COBRO_REAL) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO > '#{params[:final].split("/").reverse.join("-")}' #{clase} #{moeda} #{clase_produto} #{regiao}) AS A_VENCER_RS,
                      (SELECT MIN(VENCIMENTO) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{params[:final].split("/").reverse.join("-")}' #{clase} #{moeda} #{clase_produto} #{regiao}) AS VENCIDO_DESDE
               FROM  PERSONAS P
               WHERE #{pers}  #{cliente_status} #{carteira}
                     ( (SELECT COALESCE(SUM(DIVIDA_DOLAR - COBRO_DOLAR),0) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{params[:final].split("/").reverse.join("-")}' #{clase} #{moeda} #{clase_produto} #{regiao}) +
                     (SELECT COALESCE(SUM(DIVIDA_DOLAR - COBRO_DOLAR),0) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO > '#{params[:final].split("/").reverse.join("-")}' #{clase} #{moeda} #{clase_produto} #{regiao})) > 0
                     ORDER BY 2"
        Cliente.find_by_sql(sql)


    end
  end
end
