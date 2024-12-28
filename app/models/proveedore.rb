class Proveedore < ActiveRecord::Base
  belongs_to :persona
  belongs_to :rubro
  belongs_to :conta
  before_create :gera_cod, :add_pagamento
  before_save :finds
  before_update :update_gasto_prov
  before_destroy :delete_pagamento

    def self.import(file, params)

      CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8', :header_converters => :symbol, :row_sep => :auto, :col_sep => ";") do |row|
          company_hash = Proveedore.new
          company_hash.data = Time.now
          company_hash.vencimento = Time.now
          company_hash.moeda = 2
          company_hash.documento_numero_01 = '000'
          company_hash.documento_numero_02 = '000'
          company_hash.titulo = (Proveedore.last.id.to_i + 1)
          company_hash.documento_numero = '999'<< Proveedore.count(:id).to_s
          company_hash.liquidacao = 0
          company_hash.persona_id = row[0]
          company_hash.favorecido = row[1]
          company_hash.ruc = row[2]
          company_hash.banco_nome = row[3]
          company_hash.bc_agencia = row[4]
          company_hash.bc_conta = row[5]
          company_hash.tipo_conta = row[6]
          company_hash.divida_real = row[8].to_s.gsub('.', '').gsub(',', '.').to_f
          company_hash.import = true
          company_hash.descricao = row[7]

          company_hash.save
      end

  end


  def update_gasto_prov
    if self.tabela == 'PROV_GASTOS'
      gt  = Compra.where(prov_gasto_id: self.tabela_id, persona_id: self.persona_id, cota: self.cota).last

      gt.update_attributes(total_guarani: self.divida_guarani,
                           total_dolar: self.divida_dolar,
                           total_real: self.divida_real,
                           documento_numero_01: self.documento_numero_01,
                           documento_numero_02: self.documento_numero_02,
                           documento_numero: self.documento_numero)

      gt_custos = ComprasCusto.where(compra_id: gt.id)

      gt_custos.each do |c|
        c.update_attributes(valor_gs: (gt.total_guarani.to_f - gt.desconto_guarani.to_f) / c.plano_de_conta.competencia.to_i)
        c.update_attributes(valor_rs: (gt.total_real.to_f - gt.desconto_real.to_f) / c.plano_de_conta.competencia.to_i)
      end
    end
  end

  def gera_cod
    if self.documento_numero == ''
      self.documento_numero_01 = '000'
      self.documento_numero_02 = '000'
      self.documento_numero = '999'<< Proveedore.count(:id).to_s
      if Proveedore.last == nil
        self.titulo = 1
      else
        self.titulo = (Proveedore.last.id.to_i + 1)
      end

    end
  end

    def add_pagamento
    if self.sigla_proc == 'CLR'
      if self.moeda.to_i == 0

        if self.divida_dolar.to_f == self.saldo_us.to_f
          self.liquidacao = 1
          list_titulo = Proveedore.where(titulo: self.titulo)

          list_titulo.each do |lt|
            lt.update_attributes(liquidacao: 1)
          end
        end

      elsif self.moeda.to_i == 1
        if self.divida_guarani.to_f == self.saldo_gs.to_f
          self.liquidacao = 1
          list_titulo = Proveedore.where(titulo: self.titulo)

          list_titulo.each do |lt|
            lt.update_attributes(liquidacao: 1)
          end
        end
      elsif self.moeda.to_i == 2
        if self.divida_real.to_f == self.saldo_rs.to_f
          self.liquidacao = 1
          list_titulo = Proveedore.where(titulo: self.titulo)

          list_titulo.each do |lt|
            lt.update_attributes(liquidacao: 1)
          end
        end
      end

      self.divida_dolar = self.divida_dolar.to_f * -1
      self.divida_guarani = self.divida_guarani.to_f * -1
      self.divida_real = self.divida_real.to_f * -1
      self.tabela_id = self.id
      self.tabela = 'CL'
    end
  end


  def delete_pagamento
    if self.finan == true

      list_titulo = Proveedore.where(titulo: self.titulo)

      list_titulo.each do |lt|
        lt.update_attributes(liquidacao: 0)
      end
    end
  end

  def finds
    persona = Persona.find_by_id(self.persona_id);
    self.persona_nome = persona.nome.to_s unless self.persona_id.blank?

    rb = Rubro.find_by_id(self.rubro_id);
    self.plano_de_conta_id = rb.plano_de_conta_id.to_s unless self.rubro_id.blank?
  end

  def self.consolidado(params)
    sql = "SELECT PERSONA_ID, MAX(PERSONA_NOME) AS PERSONA_NOME, SUM(ENTRADA_REAL) AS ENTRADA_REAL, SUM(SAIDA_REAL) AS SAIDA_REAL, SUM(ENTRADA_REAL_ANTERIOR) AS ENTRADA_REAL_ANTERIOR, SUM(SAIDA_REAL_ANTERIOR) AS SAIDA_REAL_ANTERIOR FROM (
                  SELECT  F.PERSONA_ID,
                          MAX(P.NOME) AS PERSONA_NOME,
                          SUM(F.ENTRADA_REAL) AS ENTRADA_REAL,
                          SUM(0) AS SAIDA_REAL,
                          SUM(0) AS ENTRADA_REAL_ANTERIOR,
                          SUM(0) AS SAIDA_REAL_ANTERIOR
                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE date_part('month', F.DATA_CONCILIACAO ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA_CONCILIACAO ) = '#{Time.now.strftime("%Y")}'
                  AND F.TABELA = 'INGRESSOS'
                  AND F.ENTRADA_REAL > 0
                  AND F.SIGLA_PROC != 'IGM'
                  AND P.TIPO_CLIENTE = 1
                  AND P.TIPO_VENDEDOR = 0
                  GROUP BY 1

                  UNION ALL

                  SELECT F.PERSONA_ID,
                         MAX(P.NOME) AS PERSONA_NOME,
                         SUM(0) AS ENTRADA_REAL,
                         SUM(F.SAIDA_REAL) AS SAIDA_REAL,
                        SUM(0) AS ENTRADA_REAL_ANTERIOR,
                        SUM(0) AS SAIDA_REAL_ANTERIOR

                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE date_part('month', F.DATA ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA ) = '#{Time.now.strftime("%Y")}'
                  AND F.SIGLA_PROC IN ('PGR   ', 'EG    ', 'IGMC   ')
                  AND P.TIPO_CLIENTE = 1
                  AND P.TIPO_VENDEDOR = 0

                  GROUP BY 1


                UNION ALL

                    SELECT F.PERSONA_ID,
                           MAX(P.NOME) AS PERSONA_NOME,
                           SUM(0) AS ENTRADA_REAL,
                           SUM(F.VALOR_REAL) AS SAIDA_REAL,
                           SUM(0) AS ENTRADA_REAL_ANTERIOR,
                           SUM(0) AS SAIDA_REAL_ANTERIOR
                      FROM INGRESSOS F
                      INNER JOIN CONTAS C
                      ON C.ID = F.CONTA_ID

                      INNER JOIN PERSONAS P
                      ON P.ID = F.PERSONA_ID

                      WHERE F.OPERACAO = 1
                      AND P.TIPO_CLIENTE = 1
                      AND P.TIPO_VENDEDOR = 0

                      AND date_part('month', F.DATA ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA ) = '#{Time.now.strftime("%Y")}'

                  GROUP BY 1

                UNION ALL

                SELECT  F.PERSONA_ID,
                          MAX(P.NOME) AS PERSONA_NOME,
                          SUM(0) AS ENTRADA_REAL,
                          SUM(0) AS SAIDA_REAL,
                          SUM(F.ENTRADA_REAL) AS ENTRADA_REAL_ANTERIOR,
                          SUM(0) AS SAIDA_REAL_ANTERIOR
                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE F.DATA_CONCILIACAO < '#{Time.now.strftime("%Y")}-#{Time.now.strftime("%m")}-01'
                  AND F.TABELA = 'INGRESSOS'
                  AND F.ENTRADA_REAL > 0
                  AND F.SIGLA_PROC != 'IGM'
                  AND P.TIPO_CLIENTE = 1
                  AND P.TIPO_VENDEDOR = 0
                  GROUP BY 1

                  UNION ALL

                  SELECT F.PERSONA_ID,
                         MAX(P.NOME) AS PERSONA_NOME,
                         SUM(0) AS ENTRADA_REAL,
                         SUM(0) AS SAIDA_REAL,
                        SUM(0) AS ENTRADA_REAL_ANTERIOR,
                        SUM(F.SAIDA_REAL) AS SAIDA_REAL_ANTERIOR

                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE F.DATA < '#{Time.now.strftime("%Y")}-#{Time.now.strftime("%m")}-01'
                  AND F.SIGLA_PROC IN ('PGR   ', 'EG    ', 'IGMC   ')
                  AND P.TIPO_CLIENTE = 1
                  AND P.TIPO_VENDEDOR = 0
                  GROUP BY 1


                  UNION ALL

                        SELECT F.PERSONA_ID,
                        MAX(P.NOME) AS PERSONA_NOME,
                         SUM(0) AS ENTRADA_REAL,
                         SUM(0) AS SAIDA_REAL,
                         SUM(0) AS ENTRADA_REAL_ANTERIOR,
                         SUM(F.VALOR_REAL) AS SAIDA_REAL_ANTERIOR

                          FROM INGRESSOS F
                          INNER JOIN CONTAS C
                          ON C.ID = F.CONTA_ID

                          INNER JOIN PERSONAS P
                          ON P.ID = F.PERSONA_ID


                          WHERE F.OPERACAO = 1 AND F.DATA < '#{Time.now.strftime("%Y")}-#{Time.now.strftime("%m")}-01'
                            AND P.TIPO_CLIENTE = 1
                            AND P.TIPO_VENDEDOR = 0

                  GROUP BY 1
                  ) AS FOO
                GROUP BY 1
                ORDER BY 2"
    Proveedore.find_by_sql(sql)
  end


  def self.consolidado_modal(params)
    sql = "SELECT PERSONA_ID, MAX(PERSONA_NOME) AS PERSONA_NOME, SUM(ENTRADA_REAL) AS ENTRADA_REAL, SUM(SAIDA_REAL) AS SAIDA_REAL, SUM(ENTRADA_REAL_ANTERIOR) AS ENTRADA_REAL_ANTERIOR, SUM(SAIDA_REAL_ANTERIOR) AS SAIDA_REAL_ANTERIOR FROM (
                  SELECT  F.PERSONA_ID,
                          MAX(P.NOME) AS PERSONA_NOME,
                          SUM(F.ENTRADA_REAL) AS ENTRADA_REAL,
                          SUM(0) AS SAIDA_REAL,
                          SUM(0) AS ENTRADA_REAL_ANTERIOR,
                          SUM(0) AS SAIDA_REAL_ANTERIOR
                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE date_part('month', F.DATA_CONCILIACAO ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA_CONCILIACAO ) = '#{Time.now.strftime("%Y")}'
                  AND F.TABELA = 'INGRESSOS'
                  AND F.ENTRADA_REAL > 0
                  AND P.TIPO_CLIENTE = 1
                  AND P.TIPO_VENDEDOR = 1
                  AND P.TIPO_INDICADOR = 1
                  AND P.ID NOT IN (5,29)
                  GROUP BY 1

                  UNION ALL

                  SELECT F.PERSONA_ID,
                         MAX(P.NOME) AS PERSONA_NOME,
                         SUM(0) AS ENTRADA_REAL,
                         SUM(F.SAIDA_REAL) AS SAIDA_REAL,
                        SUM(0) AS ENTRADA_REAL_ANTERIOR,
                        SUM(0) AS SAIDA_REAL_ANTERIOR

                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE date_part('month', F.DATA ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA ) = '#{Time.now.strftime("%Y")}'
                  AND F.SIGLA_PROC IN ('PGR   ', 'EG    ', 'IGMC   ')
                  AND P.TIPO_CLIENTE = 1
                  AND P.TIPO_VENDEDOR = 1
                  AND P.TIPO_INDICADOR = 1
                  AND P.ID NOT IN (5,29)

                  GROUP BY 1


                UNION ALL

                    SELECT F.PERSONA_ID,
                           MAX(P.NOME) AS PERSONA_NOME,
                           SUM(0) AS ENTRADA_REAL,
                           SUM(F.VALOR_REAL) AS SAIDA_REAL,
                           SUM(0) AS ENTRADA_REAL_ANTERIOR,
                           SUM(0) AS SAIDA_REAL_ANTERIOR
                      FROM INGRESSOS F
                      INNER JOIN CONTAS C
                      ON C.ID = F.CONTA_ID

                      INNER JOIN PERSONAS P
                      ON P.ID = F.PERSONA_ID

                      WHERE F.OPERACAO = 1
                      AND P.TIPO_CLIENTE = 1
                      AND P.TIPO_VENDEDOR = 1
                      AND P.TIPO_INDICADOR = 1
                      AND P.ID NOT IN (5,29)

                      AND date_part('month', F.DATA ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA ) = '#{Time.now.strftime("%Y")}'

                  GROUP BY 1

                UNION ALL

                SELECT  F.PERSONA_ID,
                          MAX(P.NOME) AS PERSONA_NOME,
                          SUM(0) AS ENTRADA_REAL,
                          SUM(0) AS SAIDA_REAL,
                          SUM(F.ENTRADA_REAL) AS ENTRADA_REAL_ANTERIOR,
                          SUM(0) AS SAIDA_REAL_ANTERIOR
                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE F.DATA_CONCILIACAO < '#{Time.now.strftime("%Y")}-#{Time.now.strftime("%m")}-01'
                  AND F.TABELA = 'INGRESSOS'
                  AND F.ENTRADA_REAL > 0
                  AND F.SIGLA_PROC != 'IGM'
                  AND P.TIPO_CLIENTE = 1
                  AND P.TIPO_VENDEDOR = 1
                  AND P.TIPO_INDICADOR = 1
                  AND P.ID NOT IN (5,29)
                  GROUP BY 1

                  UNION ALL

                  SELECT F.PERSONA_ID,
                         MAX(P.NOME) AS PERSONA_NOME,
                         SUM(0) AS ENTRADA_REAL,
                         SUM(0) AS SAIDA_REAL,
                        SUM(0) AS ENTRADA_REAL_ANTERIOR,
                        SUM(F.SAIDA_REAL) AS SAIDA_REAL_ANTERIOR

                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE F.DATA < '#{Time.now.strftime("%Y")}-#{Time.now.strftime("%m")}-01'
                  AND F.SIGLA_PROC IN ('PGR   ', 'EG    ', 'IGMC   ')
                  AND P.TIPO_CLIENTE = 1
                  AND P.TIPO_VENDEDOR = 1
                  AND P.TIPO_INDICADOR = 1
                  AND P.ID NOT IN (5,29)
                  GROUP BY 1


                  UNION ALL

                        SELECT F.PERSONA_ID,
                        MAX(P.NOME) AS PERSONA_NOME,
                         SUM(0) AS ENTRADA_REAL,
                         SUM(0) AS SAIDA_REAL,
                         SUM(0) AS ENTRADA_REAL_ANTERIOR,
                         SUM(F.VALOR_REAL) AS SAIDA_REAL_ANTERIOR

                          FROM INGRESSOS F
                          INNER JOIN CONTAS C
                          ON C.ID = F.CONTA_ID

                          INNER JOIN PERSONAS P
                          ON P.ID = F.PERSONA_ID


                          WHERE F.OPERACAO = 1 AND F.DATA < '#{Time.now.strftime("%Y")}-#{Time.now.strftime("%m")}-01'
                            AND P.TIPO_CLIENTE = 1
                            AND P.TIPO_VENDEDOR = 1
                            AND P.TIPO_INDICADOR = 1
                            AND P.ID NOT IN (5,29)

                  GROUP BY 1

                  UNION ALL
--EXEÇAO

                  SELECT  F.PERSONA_ID,
                          MAX(P.NOME) AS PERSONA_NOME,
                          SUM(F.ENTRADA_REAL) AS ENTRADA_REAL,
                          SUM(0) AS SAIDA_REAL,
                          SUM(0) AS ENTRADA_REAL_ANTERIOR,
                          SUM(0) AS SAIDA_REAL_ANTERIOR
                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE date_part('month', F.DATA ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA ) = '#{Time.now.strftime("%Y")}'
                  AND F.TABELA = 'INGRESSOS'
                  AND F.ENTRADA_REAL > 0
                  AND P.ID IN (5,29)
                  GROUP BY 1


                  UNION ALL

                  SELECT C.PERSONA_ID,
                          MAX(P.NOME) AS PERSONA_NOME,
                          SUM(F.VALOR_REAL) AS ENTRADA_REAL,
                          SUM(0) AS SAIDA_REAL,
                          SUM(0) AS ENTRADA_REAL_ANTERIOR,
                          SUM(0) AS SAIDA_REAL_ANTERIOR

                          FROM TRANSFERENCIA_CONTAS F

                          INNER JOIN CONTAS C
                          ON C.ID = F.DESTINO_ID

                          INNER JOIN PERSONAS P
                          ON P.ID = C.PERSONA_ID

                          WHERE date_part('month', F.DATA ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA ) = '#{Time.now.strftime("%Y")}'

                  GROUP BY 1

                  UNION ALL

                  SELECT F.PERSONA_ID,
                         MAX(P.NOME) AS PERSONA_NOME,
                         SUM(0) AS ENTRADA_REAL,
                         SUM(F.SAIDA_REAL) AS SAIDA_REAL,
                        SUM(0) AS ENTRADA_REAL_ANTERIOR,
                        SUM(0) AS SAIDA_REAL_ANTERIOR

                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE date_part('month', F.DATA ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA ) = '#{Time.now.strftime("%Y")}'
                  AND F.SIGLA_PROC IN ('PGR   ', 'EG    ', 'IGMC   ')
                  AND P.ID IN (5,29)

                  GROUP BY 1


                UNION ALL

                    SELECT F.PERSONA_ID,
                           MAX(P.NOME) AS PERSONA_NOME,
                           SUM(0) AS ENTRADA_REAL,
                           SUM(F.VALOR_REAL) AS SAIDA_REAL,
                           SUM(0) AS ENTRADA_REAL_ANTERIOR,
                           SUM(0) AS SAIDA_REAL_ANTERIOR
                      FROM INGRESSOS F
                      INNER JOIN CONTAS C
                      ON C.ID = F.CONTA_ID

                      INNER JOIN PERSONAS P
                      ON P.ID = F.PERSONA_ID

                      WHERE F.OPERACAO = 1
                      AND P.ID IN (5,29)

                      AND date_part('month', F.DATA ) = '#{Time.now.strftime("%m")}'  AND  date_part('year', F.DATA ) = '#{Time.now.strftime("%Y")}'

                  GROUP BY 1

                UNION ALL

                SELECT  F.PERSONA_ID,
                          MAX(P.NOME) AS PERSONA_NOME,
                          SUM(0) AS ENTRADA_REAL,
                          SUM(0) AS SAIDA_REAL,
                          SUM(F.ENTRADA_REAL) AS ENTRADA_REAL_ANTERIOR,
                          SUM(0) AS SAIDA_REAL_ANTERIOR
                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE F.DATA < '#{Time.now.strftime("%Y")}-#{Time.now.strftime("%m")}-01'
                  AND F.TABELA = 'INGRESSOS'
                  AND F.ENTRADA_REAL > 0
                  AND P.ID IN (5,29)
                  GROUP BY 1

                  UNION ALL

                  SELECT F.PERSONA_ID,
                         MAX(P.NOME) AS PERSONA_NOME,
                         SUM(0) AS ENTRADA_REAL,
                         SUM(0) AS SAIDA_REAL,
                        SUM(0) AS ENTRADA_REAL_ANTERIOR,
                        SUM(F.SAIDA_REAL) AS SAIDA_REAL_ANTERIOR

                  FROM FINANCAS F

                  INNER JOIN CONTAS C
                  ON C.ID = F.CONTA_ID

                  INNER JOIN PERSONAS P
                  ON P.ID = F.PERSONA_ID

                  WHERE F.DATA < '#{Time.now.strftime("%Y")}-#{Time.now.strftime("%m")}-01'
                  AND F.SIGLA_PROC IN ('PGR   ', 'EG    ', 'IGMC   ')
                  AND P.ID IN (5,29)
                  GROUP BY 1


                  UNION ALL

                        SELECT F.PERSONA_ID,
                        MAX(P.NOME) AS PERSONA_NOME,
                         SUM(0) AS ENTRADA_REAL,
                         SUM(0) AS SAIDA_REAL,
                         SUM(0) AS ENTRADA_REAL_ANTERIOR,
                         SUM(F.VALOR_REAL) AS SAIDA_REAL_ANTERIOR

                          FROM INGRESSOS F
                          INNER JOIN CONTAS C
                          ON C.ID = F.CONTA_ID

                          INNER JOIN PERSONAS P
                          ON P.ID = F.PERSONA_ID


                          WHERE F.OPERACAO = 1 AND F.DATA < '#{Time.now.strftime("%Y")}-#{Time.now.strftime("%m")}-01'
                            AND P.ID IN (5,29)

                  GROUP BY 1

                  ) AS FOO
                GROUP BY 1
                ORDER BY 2"
    Proveedore.find_by_sql(sql)
  end

  def self.painel_pagar(params)
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
                 MAX(P.PLANO_DE_CONTA_ID) AS PLANO_DE_CONTA_ID,
                 MAX(P.CENTRO_CUSTO_ID) AS CENTRO_CUSTO_ID,
                 MAX(R.DESCRICAO) AS RUBRO_NOME,
                 SUM(DIVIDA_GUARANI) AS DIVIDA_GUARANI,
                 SUM(DIVIDA_DOLAR) AS DIVIDA_DOLAR,
                 SUM(DIVIDA_REAL) AS DIVIDA_REAL


           FROM PROVEEDORES P

           LEFT JOIN PERSONAS PD
           ON PD.ID = P.PERSONA_ID

           LEFT JOIN CONTAS C
           ON C.ID = P.CONTA_ID

           LEFT JOIN PLANO_DE_CONTAS R
           ON R.ID = P.PLANO_DE_CONTA_ID


           WHERE P.LIQUIDACAO = 0
           AND date_part('month', P.VENCIMENTO) = '#{params[:mes]}'
           AND date_part('year', P.VENCIMENTO) = '#{params[:ano]}'
           #{filtro}
           GROUP BY 1
           ORDER BY 6, 1
           "
    elsif  params[:liquidacao] == '1'
      liqui = "P.LIQUIDACAO = 1"

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
                 P.PLANO_DE_CONTA_ID AS PLANO_DE_CONTA_ID,
                 P.CENTRO_CUSTO_ID AS CENTRO_CUSTO_ID,
                 R.DESCRICAO AS RUBRO_NOME,
                 DIVIDA_GUARANI AS DIVIDA_GUARANI,
                 DIVIDA_DOLAR AS DIVIDA_DOLAR,
                 DIVIDA_REAL AS DIVIDA_REAL


           FROM PROVEEDORES P

           LEFT JOIN PERSONAS PD
           ON PD.ID = P.PERSONA_ID

           LEFT JOIN CONTAS C
           ON C.ID = P.CONTA_ID

           LEFT JOIN PLANO_DE_CONTAS R
           ON R.ID = P.PLANO_DE_CONTA_ID


           WHERE (P.DIVIDA_GUARANI + P.DIVIDA_REAL + P.DIVIDA_DOLAR) < 0
           AND date_part('month', P.DATA) = '#{params[:mes]}'
           AND date_part('year', P.DATA) = '#{params[:ano]}'
           #{filtro}
           ORDER BY 8 DESC, 1
           "
    end



    Proveedore.find_by_sql(sql)
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
                   P.PLANO_DE_CONTA_ID AS PLANO_DE_CONTA_ID,
                   P.CENTRO_CUSTO_ID AS CENTRO_CUSTO_ID,
                   P.FAVORECIDO AS FAVORECIDO,
                   P.RUC AS RUC,
                   P.BC_AGENCIA AS BC_AGENCIA,
                   P.SIGLA_PROC,
                   P.BC_CONTA AS BC_CONTA,
                   P.TIPO_CONTA AS TIPO_CONTA,
                   (BC.NOME || P.BANCO_NOME) AS BANCO_NOME,
                   R.DESCRICAO AS RUBRO_NOME,
                   U.USUARIO_NOME AS USUARIO_NOME,
                   DIVIDA_GUARANI AS DIVIDA_GUARANI,
                   DIVIDA_DOLAR AS DIVIDA_DOLAR,
                   DIVIDA_REAL AS DIVIDA_REAL


             FROM PROVEEDORES P

             LEFT JOIN PERSONAS PD
             ON PD.ID = P.PERSONA_ID

             LEFT JOIN CONTAS C
             ON C.ID = P.CONTA_ID

             LEFT JOIN PLANO_DE_CONTAS R
             ON R.ID = P.PLANO_DE_CONTA_ID

             LEFT JOIN PERSONAS BC
             ON BC.ID = P.BANCO_ID

             LEFT JOIN USUARIOS U
             ON U.ID = P.USUARIO_CREATED

             WHERE P.TITULO = '#{params[:titulo]}'
             ORDER BY 8, 7
             "
    Proveedore.find_by_sql(sql)
  end

  def self.extrato_proveedor(params)
        pers      = "AND  C.PERSONA_ID = #{params[:persona_id]} " unless params[:persona_id].blank?
        cc        = "AND C.CENTRO_CUSTO_ID = #{params[:busca]["cc"]} " unless params[:busca]["cc"].blank?
        clasif    = "AND  C.PLANO_DE_CONTA_ID = #{params[:busca]["clasif"]} " unless params[:busca]["clasif"].blank?

        liq_open  = "AND  C.liquidacao = 0 #{pers}" if params[:filtro] == "0"
        liq_close = "AND  C.liquidacao = 1 #{pers}" if params[:filtro] == "1"
        liq_all   = "#{pers}"                        if params[:filtro] == "2"
        doc       = "AND C.DOCUMENTO_NUMERO ILIKE '#{params[:doc]}%'"  unless params[:doc] == ""
        desc      = "AND C.DESCRICAO ILIKE '%#{params[:desc]}%'"  unless params[:desc] == ""
        cota      = "AND C.COTA = #{params[:cota]} " unless params[:cota].blank?

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND  C.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND  C.moeda = 1"
           elsif params[:moeda] == "2"
              moeda = "AND  C.moeda = 2"
           elsif params[:moeda] == "4"
              moeda = "AND  C.moeda = 4"
           end
        end

        if params[:moeda] == "0"
          find_valor = "AND C.DIVIDA_DOLAR BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
        elsif params[:moeda] == "1"
          find_valor = "AND C.DIVIDA_GUARANI BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
        else
          find_valor = "AND C.DIVIDA_REAL BETWEEN #{params[:valor_min].gsub('.','').gsub(',','.')} AND #{params[:valor_max].gsub('.','').gsub(',','.')}" if params[:valor_max].to_f > 0
        end



        #FITRO POR DATA FATURACAO
        if params[:tipo_data].to_s == 'emicao'
            cond = "AND C.data  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{doc} #{cc} #{clasif} #{cota} #{find_valor} #{desc}"
            od = "6,13,7,8,9,12,15 DESC"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "AND C.vencimento  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{doc} #{cc} #{clasif} #{cota} #{find_valor} #{desc}"
            od = "3,10,1"
        end
  	sql = "SELECT C.ID,
                      C.PERSONA_ID,
                      P.NOME AS PERSONA_NOME,
                      C.COD_PROC,
                      C.SIGLA_PROC,
                      C.LIQUIDACAO,
                      C.MOEDA,
                      C.TIPO,
                      C.DATA,
                      C.VENCIMENTO,
                      C.DOCUMENTO_NOME,
                      C.DOCUMENTO_NUMERO,
                      C.COTA,
                      C.DIVIDA_DOLAR,
                      C.DIVIDA_GUARANI,
                      C.DIVIDA_REAL,
                      C.PAGO_DOLAR,
                      C.PAGO_GUARANI,
                      C.PAGO_REAL,
                      C.DESCRICAO,
                      C.DOCUMENTO_NUMERO_01,
                      C.documento_numero_02,
                      U.UNIDADE_NOME,
                      C.TOT_COTAS,
                      CC.NOME AS CENTRO_CUSTO_NOME,
                      R.DESCRICAO AS RUBRO_NOME,
                      (SELECT AT.DATA FROM PROVEEDORES AT WHERE  AT.PAGO_REAL > 0 AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA ORDER BY DATA DESC LIMIT 1) AS PG_DATA,
                      COALESCE((SELECT SUM(AT.PAGO_DOLAR) FROM PROVEEDORES AT WHERE AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA),0) + COALESCE((SELECT SUM(AT.DIVIDA_DOLAR * -1) FROM PROVEEDORES AT WHERE AT.FINAN = TRUE AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA),0) AS ANTERIOR_US,
                      COALESCE((SELECT SUM(AT.PAGO_GUARANI) FROM PROVEEDORES AT WHERE AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA),0) + COALESCE((SELECT SUM(AT.DIVIDA_GUARANI * -1) FROM PROVEEDORES AT WHERE AT.FINAN = TRUE AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA),0) AS ANTERIOR_GS,
                      COALESCE((SELECT SUM(AT.PAGO_REAL) FROM PROVEEDORES AT WHERE AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA),0) + COALESCE((SELECT SUM(AT.DIVIDA_REAL * -1) FROM PROVEEDORES AT WHERE AT.FINAN = TRUE AND AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA),0) AS ANTERIOR_RS
            FROM PROVEEDORES C
            LEFT JOIN UNIDADES U
            ON C.UNIDADE_ID = U.ID
            INNER JOIN PERSONAS P
            ON P.ID = C.PERSONA_ID
            LEFT JOIN CENTRO_CUSTOS CC
            ON CC.ID = C.CENTRO_CUSTO_ID
            LEFT JOIN RUBROS R
            ON R.ID = C.RUBRO_ID

            WHERE (C.DIVIDA_GUARANI + C.DIVIDA_DOLAR + C.DIVIDA_REAL ) > 0 AND C.UNIDADE_ID = #{params[:unidade]}  #{cond} ORDER BY #{od}"
			Proveedore.find_by_sql(sql)
  end
	def self.contas_pagar_resumido(params) #LISTADO DE PROVEEDOR RESUMIDO POR PROVEEDOR

    #FILTRO ESTADO DO LANCAMENTO
    pers      = "AND PV.PERSONA_ID = #{params[:persona_id]} " unless params[:persona_id].blank?
    unidade   = "PV.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
    liq_open  = "AND PV.liquidacao = 0 #{pers}"                     if params[:filtro] == "0"
    liq_close = "AND PV.liquidacao = 1 #{pers}"                     if params[:filtro] == "1"
    liq_all   = "#{pers}"                                        if params[:filtro] == "2"

    #FILTRO MOEDA
    if params[:lancamento].to_s != "1"
       if params[:moeda] == "0"
          moeda = "AND PV.moeda = 0"
        elsif params[:moeda] == "1"
          moeda = "AND PV.moeda = 1"
        elsif params[:moeda] == "2"
          moeda = "AND PV.moeda = 2"
        elsif params[:moeda] == "4"
          moeda = "AND PV.moeda = 4"
       end
    end

    #FILTRO PROVEEDOR LOCAL OU EXTERIOR
    if params[:tipo_prov] =="0"
			tipo_prov = " AND P.PER_INTER_EXTER = 0"
		elsif params[:tipo_prov] == "1"
			tipo_prov = "AND P.PER_INTER_EXTER = 1"
		else
			tipo_prov = ""
		end

    #FITRO POR DATA FATURACAO
    if params[:tipo_data].to_s == 'emicao'

        cond = "#{unidade} PV.data  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda}"
    else
        #FITRO POR DATA FATURACAO VENCIMENTO

        cond = "#{unidade} PV.vencimento  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda}"
    end

		sql="SELECT
              P.ID AS PERSONA_ID,
              MAX(PV.CLASE_PRODUTO) AS CLASE_PRODUTO,
              MAX(PV.PERSONA_NOME) AS PERSONA_NOME,
					    SUM( PV.DIVIDA_DOLAR - PV.PAGO_DOLAR ) AS SALDO_US,
					    SUM( PV.DIVIDA_GUARANI - PV.PAGO_GUARANI ) AS SALDO_GS,
              SUM( PV.DIVIDA_REAL - PV.PAGO_REAL ) AS SALDO_RS,
						  MAX(PV.VENCIMENTO) AS VENCI
				 FROM
							PROVEEDORES PV
				 INNER JOIN PERSONAS P
				 ON PV.PERSONA_ID = P.ID
         WHERE #{cond}
         AND P.TIPO_FORNECEDOR = 1
				 GROUP BY 1
         ORDER BY 2,7"
		Proveedore.find_by_sql(sql)
	end


    def self.relatorio_contas_pagar(params) #LISTADO DETALHADO POR FATURA
        unidade   = "PV.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
        pers      = "AND  PV.PERSONA_ID = #{params[:persona_id]} " unless params[:persona_id].blank?
        clasif    = "AND  PV.PLANO_DE_CONTA_ID = #{params[:busca]["clasif"]} " unless params[:busca]["clasif"].blank?
        cc        = "AND C.CENTRO_CUSTO_ID = #{params[:busca]["cc"]} " unless params[:busca]["cc"].blank?
        liq_open  = "AND  PV.liquidacao = 0 #{pers}" if params[:filtro] == "0"
        liq_close = "AND  PV.liquidacao = 1 #{pers}" if params[:filtro] == "1"
        liq_all   = "#{pers}"                        if params[:filtro] == "2"
        doc       = "AND PV.DOCUMENTO_NUMERO = '#{params[:doc]}'"  unless params[:doc] == ""

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND  PV.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND  PV.moeda = 1"
           elsif params[:moeda] == "2"
              moeda = "AND  PV.moeda = 2"
           elsif params[:moeda] == "4"
              moeda = "AND  PV.moeda = 4"
           end
        end

        #FITRO POR DATA FATURACAO
        if params[:tipo_data].to_s == 'emicao'
            cond = "#{unidade} PV.data  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{doc} #{clasif} #{cc}"
            od = "6,13,7,8,9,12,15 DESC"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "#{unidade} PV.vencimento  BETWEEN  '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{doc} #{clasif} #{cc}"
            od = "6,13,7,8,9,12,15 DESC"
        end

        sql =  "SELECT
    								 PV.ID,
                     PV.DATA,
                     PV.MOEDA,
                     PV.COMPRA_ID,
                     PV.PERSONA_ID,
                     P.NOME AS PERSONA_NOME,
                     PV.DOCUMENTO_NUMERO_01,
                     PV.DOCUMENTO_NUMERO_02,
                     PV.DOCUMENTO_NUMERO,
                     PV.DOCUMENTO_NOME,
                     PV.CLASE_PRODUTO,
                     PV.COTA,
                     PV.VENCIMENTO,
                     PV.DIVIDA_GUARANI,
                     PV.DIVIDA_DOLAR,
                     PV.DIVIDA_REAL,
                     PV.DIVIDA_EURO,
                     PV.PAGO_GUARANI,
                     PV.PAGO_DOLAR,
                     PV.PAGO_REAL,
                     PV.PAGO_EURO,
                     PV.sigla_proc,
                     PV.cod_proc,
                     PV.DESCRICAO,
                     PV.SIGLA_PROC AS SIGLA,
                     CC.NOME AS CENTRO_CUSTO_NOME,
                     R.DESCRICAO AS RUBRO_NOME,
                     PV.TOT_COTAS


      				FROM PROVEEDORES PV
      				INNER JOIN PERSONAS P
      				ON PV.PERSONA_ID = P.ID

              LEFT JOIN CENTRO_CUSTOS CC
              ON PV.CENTRO_CUSTO_ID = CC.ID

              LEFT JOIN RUBROS R
              ON R.ID = PV.RUBRO_ID


      				WHERE #{cond}
      				ORDER BY 6,13,7,8,9,12,15 DESC"
		Proveedore.find_by_sql(sql)
    end

    def self.relatorio_contas_pagar_saldo_anterior(params)
        unidade   = "PROVEEDORES.UNIDADE_ID = #{params[:unidade]} AND " unless params[:unidade].blank?
        pers      = "AND PROVEEDORES.PERSONA_ID = #{params[:persona_id]} " unless params[:persona_id].blank?
        liq_open  = "AND PROVEEDORES.liquidacao = 0 #{pers}"                     if params[:filtro] == "0"
        liq_close = "AND PROVEEDORES.liquidacao = 1 #{pers}"                     if params[:filtro] == "1"
        liq_all   = "#{pers}"                                        if params[:filtro] == "2"


        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND PROVEEDORES.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND PROVEEDORES.moeda = 1"
          else
            moeda = "AND PROVEEDORES.moeda = 1"
           end
        end

        if params[:moeda] == "0"
            valor = "PROVEEDORES.divida_dolar - PROVEEDORES.pago_dolar"
        elsif params[:moeda] == "1"
            valor = "PROVEEDORES.divida_guarani - PROVEEDORES.pago_guarani"
        elsif params[:moeda] == "2"
            valor = "PROVEEDORES.divida_real - PROVEEDORES.pago_real"
        elsif params[:moeda] == "4"
            valor = "PROVEEDORES.divida_euro - PROVEEDORES.pago_euro"
        end

		#FILTRO PROVEEDOR LOCAL OU EXTERIOR
        if params[:tipo_prov] =="0"
			tipo_prov = " AND P.PER_INTER_EXTER = 0"
		elsif params[:tipo_prov] == "1"
			tipo_prov = "AND P.PER_INTER_EXTER = 1"
		else
			tipo_prov = ""
		end


        if params[:tipo_data].to_s == 'emicao'
            #FITRO POR DATA FATURACAO
            cond = "#{unidade} PROVEEDORES.data < '#{params[:inicio].split("/").reverse.join("-")}}' #{liq_open} #{liq_close} #{liq_all} #{moeda}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "#{unidade} PROVEEDORES.vencimento < '#{params[:inicio].split("/").reverse.join("-")}}' #{liq_open} #{liq_close} #{liq_all} #{moeda}"
        end

        Proveedore.sum(valor,:conditions => cond,:joins => "INNER JOIN PERSONAS P ON PROVEEDORES.PERSONA_ID = P.ID" )
    end

end
