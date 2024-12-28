class FechamentoCaixasController < ApplicationController
  before_filter :authenticate

def print_dt_fechamento
  @fechamento_caixa = FechamentoCaixa.find(params[:id])
          sql = "SELECT 'CB' AS PC,
                        C.ID,
                        C.PERSONA_NOME,
                        C.MOEDA,
                        FP.NOME,
                        CB.NOME AS CARTAO_BANDEIRA_NOME,
                        CF.CHEQUE,
                        CF.VALOR_GUARANI,
                        CF.VALOR_DOLAR,
                        CF.VALOR_REAL
                  FROM COBROS_FINANCAS CF

                  INNER JOIN COBROS C
                  ON C.ID = CF.COBRO_ID

                  INNER JOIN FORMA_PAGOS FP
                  ON FP.ID = CF.FORMA_PAGO_ID

                  LEFT JOIN CARTAO_BANDEIRAS CB
                  ON CB.ID = CF.CARTAO_BANDEIRA_ID

                  WHERE C.DATA = '#{@fechamento_caixa.data}'
                  AND CF.MOEDA = 1

                  UNION ALL

                  SELECT 'VT' AS PC,
                         C.ID,
                         C.PERSONA_NOME,
                         C.MOEDA,
                         FP.NOME,
                         CB.NOME AS CARTAO_BANDEIRA_NOME,
                         CF.CHEQUE,
                         CF.VALOR_GUARANI,
                         CF.VALOR_DOLAR,
                         CF.VALOR_REAL
                  FROM VENDAS_FINANCAS CF
                  INNER JOIN VENDAS C
                  ON C.ID = CF.VENDA_ID

                  INNER JOIN FORMA_PAGOS FP
                  ON FP.ID = CF.FORMA_PAGO_ID

                  LEFT JOIN CARTAO_BANDEIRAS CB
                  ON CB.ID = CF.CARTAO_BANDEIRA_ID

                  WHERE C.DATA = '#{@fechamento_caixa.data}'
                  AND C.CONTROLE_CAIXA = #{@fechamento_caixa.abertura_caixa_id}
                  AND CF.MOEDA = 1"


    @fp_detalhados_gs = Venda.find_by_sql(sql)


    @fechamento_caixa_dts    = FechamentoCaixaDt.where("fechamento_caixa_id = #{@fechamento_caixa.id}" )
    @fechamento_caixa_dts_gs = FechamentoCaixaDt.where("moeda = 1 and fechamento_caixa_id = #{@fechamento_caixa.id}" )
    @fechamento_caixa_dts_us = FechamentoCaixaDt.where("moeda = 0 and fechamento_caixa_id = #{@fechamento_caixa.id}" )
    @fechamento_caixa_dts_rs = FechamentoCaixaDt.where("moeda = 2 and fechamento_caixa_id = #{@fechamento_caixa.id}" )
    @fechamento_caixa_dts_ps = FechamentoCaixaDt.where("moeda = 3 and fechamento_caixa_id = #{@fechamento_caixa.id}" )
    @saldo_transf = FechamentoCaixaDt.where("forma_pago_id = 17 and fechamento_caixa_id = #{@fechamento_caixa.id}" )

    sql = "SELECT VP.PRODUTO_ID,
                  MAX(P.NOME) AS PRODUTO_NOME,
                   MAX(G.DESCRICAO) AS GRUPO_PRODUTO,
                   MAX(VP.VENDA_ID) AS VENDA_ID,
                   SUM(VP.QUANTIDADE) AS QTD,
                   MAX(VP.UNITARIO_GUARANI) AS UNIT,
                   SUM(VP.TOTAL_GUARANI) AS TOT
        FROM VENDAS_PRODUTOS VP

        INNER JOIN PRODUTOS P
        ON P.ID = VP.PRODUTO_ID

        LEFT JOIN SUB_GRUPOS G
        ON G.ID = P.SUB_GRUPO_ID

        INNER JOIN VENDAS V
        ON V.ID = VP.VENDA_ID
        WHERE V.controle_caixa = #{@fechamento_caixa.abertura_caixa_id}

        GROUP BY 1
        ORDER BY 3 DESC"

    @produtos_vendidos = Venda.find_by_sql(sql)

respond_to do |format|
        format.html do
          render  :pdf                    => "print",
              :layout                 => "layer_relatorios",
              :margin => {:top        => '0.90in',
                    :bottom     => '0.25in',
                    :left       => '0.10in',
                    :right      => '0.10in'},
              :header => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                    :font_size  => 7,
                    :spacing    => 18},
              :footer => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                    :font_size  => 7,
                    :right      => "Pagina [page] de [toPage]",
                    :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
end


def conferir_caixa
    FechamentoCaixa.update(params[:id], :conferido => true)

    fechamento_caixa_ids = FechamentoCaixaDt.where(:fechamento_caixa_id => params[:id]).select("ID AS CODIGO_FECHAMENTO")

    fechamento_caixa_ids.each do |fechamento_caixa_id|
      FechamentoCaixaDt.update(fechamento_caixa_id.codigo_fechamento, :conferido => '1')
    end

    redirect_to fechamento_caixa_path(params[:id])
  end



def print

    @fechamento_caixa = FechamentoCaixa.find(params[:id])

    @fechamento_caixa_dts = FechamentoCaixaDt.where("fechamento_caixa_id = #{@fechamento_caixa.id}" )

    head =
      "

        Movimentacion en lo Sistema
        Cierre de Caja N.: #{@fechamento_caixa.id}
        Fecha : #{@fechamento_caixa.data.strftime("%d/%m/%Y")} as #{@fechamento_caixa.created_at.strftime("%H:%M")}
        Usuario : #{@fechamento_caixa.usuario.usuario_nome}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Cod.                 Forma Pago                                                                                              Bandeira                               Moneda                 Valor             Valor Registrado                     Dif.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      "

      respond_to do |format|
        format.html do
          render  :pdf                    => "print",
              :layout                 => "layer_relatorios",
              :margin => {:top        => '0.90in',
                    :bottom     => '0.25in',
                    :left       => '0.10in',
                    :right      => '0.10in'},
              :header => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                    :font_size  => 7,
                    :left       => head,
                    :spacing    => 18},
              :footer => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                    :font_size  => 7,
                    :right      => "Pagina [page] de [toPage]",
                    :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
  end



  def reabre_fechamento
    @fechamento_caixa = FechamentoCaixa.find(params[:id])
    @fechamento_caixa.update_attribute :status, nil
    redirect_to fechamento_caixa_path(@fechamento_caixa.id)
  end

  def produtos
    @fechamento_caixa = FechamentoCaixa.find(params[:id])
    sql = "SELECT VP.VENDA_ID,
                  P.NOME AS PRODUTO_NOME,
                  VP.QUANTIDADE,
                  VP.TOTAL_GUARANI,
                  B.NOME AS BICO
            FROM VENDAS_PRODUTOS VP
            LEFT JOIN VENDAS V
            ON V.ID = VP.VENDA_ID
            LEFT JOIN BICOS B
            ON B.ID = VP.BICO_ID

            LEFT JOIN PRODUTOS P
            ON P.ID = VP.PRODUTO_ID
            WHERE P.ID = #{params[:produto_id]}
            AND VF.CONTROLE_CAIXA = #{@fechamento_caixa.abertura_caixa_id}
            ORDER BY 5
          "
    @produtos = Venda.find_by_sql(sql)
  end

  def fecha_caixa
    @fechamento_caixa = FechamentoCaixa.find(params[:id])
    @fechamento_caixa.update_attribute :status, true
    @fechamento_caixa.abertura_caixa.update_attribute :status, false

    sql = "SELECT SS.FORMA_PAGO_ID,SS.MOEDA,SS.CARTAO_BANDEIRA_ID, SUM(SS.GS) AS GS, SUM(SS.RS) AS RS, SUM(SS.US) AS US, SUM(SS.PS) AS PS, MAX(SS.CONTA_ID) AS CONTA_ID FROM (

    SELECT VF.FORMA_PAGO_ID,
                  VF.MOEDA,
                  COALESCE(VF.CARTAO_BANDEIRA_ID,0) AS CARTAO_BANDEIRA_ID,
                  SUM(VF.VALOR_GUARANI) AS GS,
                  SUM(VF.VALOR_REAL) AS RS,
                  SUM(VF.VALOR_DOLAR) AS US,
                  SUM(VF.VALOR_PESO) AS PS,
                  MAX(VF.CONTA_ID) AS CONTA_ID
            FROM VENDAS_FINANCAS VF
            INNER JOIN VENDAS V
            ON V.ID = VF.VENDA_ID
            INNER JOIN FORMA_PAGOS FP
            ON FP.ID = VF.FORMA_PAGO_ID
            WHERE VF.CONTROLE_CAIXA = #{@fechamento_caixa.abertura_caixa_id}
            AND VF.FORMA_PAGO_ID <> 8 AND VF.FORMA_PAGO_ID <> 1
            GROUP BY 1, 2,3

          UNION ALL

          SELECT VF.FORMA_PAGO_ID,
                  VF.MOEDA,
                  COALESCE(VF.CARTAO_BANDEIRA_ID,0) AS CARTAO_BANDEIRA_ID,
                  ( SUM(VF.VALOR_GUARANI) - (coalesce((SELECT SUM(DVF.VALOR_GUARANI) FROM VENDAS_FINANCAS DVF INNER JOIN VENDAS DV ON DV.ID = DVF.VENDA_ID WHERE DV.CONTROLE_CAIXA = #{@fechamento_caixa.abertura_caixa_id} AND DVF.FORMA_PAGO_ID = 8),0) ))  AS GS,
                  SUM(VF.VALOR_REAL) AS RS,
                  SUM(VF.VALOR_DOLAR) AS US,
                  SUM(VF.VALOR_PESO) AS PS,
                  MAX(VF.CONTA_ID) AS CONTA_ID
          FROM VENDAS_FINANCAS VF
          INNER JOIN VENDAS V
          ON V.ID = VF.VENDA_ID
          INNER JOIN FORMA_PAGOS FP
          ON FP.ID = VF.FORMA_PAGO_ID
          WHERE VF.CONTROLE_CAIXA = #{@fechamento_caixa.abertura_caixa_id}
          AND VF.FORMA_PAGO_ID <> 8 AND VF.FORMA_PAGO_ID = 1
          GROUP BY 1,2,3


          UNION ALL

          SELECT  16 AS FORMA_PAGO_ID,
                  A.MOEDA AS MOEDA,
                  0 AS CARTAO_BANDEIRA_ID,
                  SUM(A.VALOR_GUARANI) AS GS,
                  SUM(A.VALOR_REAL) AS RS,
                  SUM(A.VALOR_DOLAR) AS US,
                  0 AS PS,
                  MAX(A.CONTA_ID) AS CONTA_ID
            FROM ADELANTOS A
            INNER JOIN CONTAS C
            ON C.ID = A.CONTA_ID
            WHERE C.TERMINAL_ID = #{@fechamento_caixa.abertura_caixa.terminal_id} AND A.DATA = '#{@fechamento_caixa.abertura_caixa.data}'
            AND A.TIPO_ADELANTO = 1
            GROUP BY 1, 2,3

) ss
GROUP BY 1, 2,3
ORDER BY 1;
          "
    valores = Venda.find_by_sql(sql)

    redirect_to fechamento_caixa_path(@fechamento_caixa.id)
  end
  def atuliza_forma_pagos
    @fechamento_caixa = FechamentoCaixa.find(params[:id])

    FechamentoCaixaDt.destroy_all("fechamento_caixa_id = #{@fechamento_caixa.id}" )

    params[:abertura_caixa_id] = @fechamento_caixa.abertura_caixa_id
    FechamentoCaixa.gera_valores(params)

    
    redirect_to fechamento_caixa_path(@fechamento_caixa.id)
  end

  def index
    FechamentoCaixa.destroy_all("status is null and unidade_id = #{current_unidade.id} and usuario_id = #{current_user.id}" )
    @fechamento_caixas = FechamentoCaixa.paginate(:page => params[:page], :per_page => 25, :conditions => ["unidade_id = #{current_unidade.id}"], :order => "data desc,id desc")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fechamento_caixas }
    end
  end

  def show
    @fechamento_caixa = FechamentoCaixa.find(params[:id])
    @fechamento_caixa_dts    = FechamentoCaixaDt.where("fechamento_caixa_id = #{@fechamento_caixa.id}" )
    @saldo_transf = FechamentoCaixaDt.where("forma_pago_id = 17 and fechamento_caixa_id = #{@fechamento_caixa.id}" )
    @fechamento_caixa_dts_gs = FechamentoCaixaDt.where("moeda = 1 and fechamento_caixa_id = #{@fechamento_caixa.id}" )
    @fechamento_caixa_dts_us = FechamentoCaixaDt.where("moeda = 0 and fechamento_caixa_id = #{@fechamento_caixa.id}" )
    @fechamento_caixa_dts_rs = FechamentoCaixaDt.where("moeda = 2 and fechamento_caixa_id = #{@fechamento_caixa.id}" )
    @fechamento_caixa_dts_ps = FechamentoCaixaDt.where("moeda = 3 and fechamento_caixa_id = #{@fechamento_caixa.id}" )

    sql = "SELECT VP.PRODUTO_ID,
                  P.NOME AS PRODUTO_NOME,
                  G.DESCRICAO AS GRUPO_PRODUTO,
                  VP.VENDA_ID AS VENDA_ID,
                  VP.QUANTIDADE AS QTD,
                  VP.DESCONTO_GUARANI AS DESC_GS,
                  VP.UNITARIO_GUARANI AS UNIT,
                  VP.TOTAL_GUARANI AS TOT
        FROM VENDAS_PRODUTOS VP
        INNER JOIN PRODUTOS P
        ON P.ID = VP.PRODUTO_ID
        LEFT JOIN SUB_GRUPOS G
        ON G.ID = P.SUB_GRUPO_ID

        INNER JOIN VENDAS V
        ON V.ID = VP.VENDA_ID


        INNER JOIN VENDAS_FINANCAS VF
        ON V.ID = VF.VENDA_ID

        WHERE VF.controle_caixa = #{@fechamento_caixa.abertura_caixa_id}

        ORDER BY 3 DESC"

    @produtos_vendidos = Venda.find_by_sql(sql)


    sqlg = "SELECT
                   F.SIGLA_PROC AS CONCEPTO,
                   COUNT(F.ID) AS PERSONA_NOME,
                   SUM(F.ENTRADA_GUARANI) AS ENTRADA_GUARANI,
                   SUM(F.SAIDA_GUARANI) AS SAIDA_GUARANI,
                   MAX(F.SIGLA_PROC) AS SIGLA_PROC,
                   MAX(F.COD_PROC) AS COD_PROC


            FROM FINANCAS F
            INNER JOIN CONTAS C
            ON C.ID = F.CONTA_ID
            WHERE COALESCE(F.SIGLA_PROC, '') <> 'FC    '
            AND F.FORMA_PAGO_ID in (1, 13)
            AND C.TERMINAL_ID = #{@fechamento_caixa.abertura_caixa.terminal_id}
            AND F.DATA = '#{@fechamento_caixa.abertura_caixa.data}'
            AND C.MOEDA = 1
            GROUP BY 1
            "

            @mov_efetivo_gs = Financa.find_by_sql(sqlg)

    render layout: 'chart'
  end

  def new
    sql = "SELECT AC.ID,
                  (AC.ID || ' ' || AC.DATA || ' '  || ' ' || P.USUARIO_NOME || ' '  || TM.NOME || ' ' || T.NOME) AS CAIXA
          FROM ABERTURA_CAIXAS AC
          INNER JOIN TERMINALS TM
          ON TM.ID = AC.TERMINAL_ID
          INNER JOIN TURNOS T
          ON T.ID = AC.TURNO_ID
          INNER JOIN USUARIOS P
          ON P.ID = AC.USUARIO_ID
          WHERE AC.STATUS = TRUE
          AND AC.UNIDADE_ID = #{current_unidade.id}
          ORDER BY AC.DATA"
    @caixas = AberturaCaixa.find_by_sql(sql)
    @fechamento_caixa = FechamentoCaixa.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fechamento_caixa }
    end
  end

  def edit
    @fechamento_caixa = FechamentoCaixa.find(params[:id])
      sql = "SELECT AC.ID,
                  (AC.ID  || ' ' || P.USUARIO_NOME || ' '  || ' ' || AC.DATA || ' '  || TM.NOME || ' ' || T.NOME) AS CAIXA
          FROM ABERTURA_CAIXAS AC
          INNER JOIN TERMINALS TM
          ON TM.ID = AC.TERMINAL_ID
          INNER JOIN TURNOS T
          ON T.ID = AC.TURNO_ID
          INNER JOIN USUARIOS P
          ON P.ID = AC.USUARIO_ID
          WHERE AC.UNIDADE_ID = #{current_unidade.id}
          AND AC.ID = #{@fechamento_caixa.abertura_caixa_id}
          ORDER BY AC.DATA"
    @caixas = AberturaCaixa.find_by_sql(sql)
  end

  def create

    @fechamento_caixa = FechamentoCaixa.new(params[:fechamento_caixa])
    @fechamento_caixa.unidade_id = current_unidade.id
    @fechamento_caixa.usuario_id = current_user.id
    respond_to do |format|
      if @fechamento_caixa.save
        format.html { redirect_to(@fechamento_caixa) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @fechamento_caixa = FechamentoCaixa.find(params[:id])

    respond_to do |format|
      if @fechamento_caixa.update_attributes(params[:fechamento_caixa])
        format.html { redirect_to(@fechamento_caixa) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @fechamento_caixa = FechamentoCaixa.find(params[:id])

    @fechamento_caixa.destroy

    respond_to do |format|
      format.html { redirect_to(fechamento_caixas_url) }
    end
  end
end
