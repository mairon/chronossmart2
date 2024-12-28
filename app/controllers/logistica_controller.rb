class LogisticaController < ApplicationController
  def index
    @listas_cargas = ListaCarga.where(status: true).select('id,rodado_id,cidade_id').order('1')
  end

  def busca
    params[:unidade] = current_unidade.id
    @presupuestos = Logistica.filtro_busca(params)
    render :layout => false
  end

  def separacao
    @presupuesto = Presupuesto.find(params[:id])
    dp = Deposito.find_by_unidade_id(current_unidade.id)
    sql = "SELECT PP.PRESUPUESTO_ID,
                  PP.FABRICANTE_COD,
                  PP.PRODUTO_ID,
                  P.NOME AS PRODUTO_NOME,
                  PP.TOTAL_DOLAR,
                  PP.TOTAL_GUARANI,                    
                  (PP.QUANTIDADE - coalesce((SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.PRESUPUESTO_PRODUTO_ID = PP.ID),0)) AS QUANTIDADE,
                  coalesce((SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.DEPOSITO_ID = #{dp.id} AND S.PRODUTO_ID = PP.PRODUTO_ID),0) AS STOCK
          FROM PRESUPUESTO_PRODUTOS PP
          INNER JOIN PRODUTOS P
          ON PP.PRODUTO_ID = P.ID
          WHERE PRESUPUESTO_ID = #{@presupuesto.id}
          ORDER BY PP.PRESUPUESTO_ID, PP.ID"
    @produtos_pedido_vendas = PresupuestoProduto.find_by_sql(sql)


    sql_lista = "SELECT LC.ID,
                        R.PLACA || ' - ' || C.NOME AS NOME
                 FROM LISTA_CARGAS LC
                 INNER JOIN RODADOS R
                 ON R.ID = LC.RODADO_ID
                 INNER JOIN CIDADES C
                 ON C.ID = LC.CIDADE_ID
                 WHERE STATUS = TRUE
                 ORDER BY ID"

     @lista_cargas = ListaCarga.find_by_sql(sql_lista)
    render layout: 'consulta'
  end


  def add_venda
    pre = Presupuesto.find_by_id(params[:id])
    pre.update_attribute :status, 1
    Venda.create( 
                  :data              => '2015-01-01',
                  :moeda             => 1,
                  :pedido_id         => pre.id,
                  :pedido            => 1,
                  :vendedor_id       => pre.vendedor_id,
                  :persona_id        => pre.persona_id,
                  :tipo_venda        => 1,
                  :vendedor_id       => pre.vendedor_id,
                  :unidade_id        => pre.unidade_id,
                  :presupuesto_id    => params[:id],
                  :lista_carga_id    => params[:add]["lista_carga"],
                  :tabela_preco_id   => pre.tabela_preco_id,
                  :prazo_id          => pre.prazo_id,
                  :desconto          => pre.desconto
                  )

      @venda = Venda.find_by_presupuesto_id(params[:id])
      
      dp = Deposito.find_by_unidade_id(current_unidade.id)
      sql = "SELECT 
                    PP.ID,
                    PP.PRESUPUESTO_ID,
                    PP.FABRICANTE_COD,
                    PP.PRODUTO_ID,
                    PP.UNITARIO_DOLAR,
                    PP.TOTAL_DOLAR,
                    PP.UNITARIO_GUARANI,
                    PP.TOTAL_GUARANI,
                    P.NOME AS PRODUTO_NOME,
                    (PP.QUANTIDADE - coalesce((SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.PRESUPUESTO_PRODUTO_ID = PP.ID),0)) AS QUANTIDADE,
                    coalesce((SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.DEPOSITO_ID = #{dp.id} AND S.PRODUTO_ID = PP.PRODUTO_ID AND S.DATA <= '#{@venda.data}'),0) AS STOCK
            FROM PRESUPUESTO_PRODUTOS PP
            INNER JOIN PRODUTOS P
            ON PP.PRODUTO_ID = P.ID
            WHERE PRESUPUESTO_ID = #{@venda.presupuesto_id}"
      @produtos_pedido_vendas = PresupuestoProduto.find_by_sql(sql)

      @produtos_pedido_vendas.each do |il|

        if il.quantidade.to_f > 0 and il.stock.to_f > 0
          if il.quantidade.to_f >= il.stock.to_f
            saldo = il.stock.to_f

          elsif il.stock.to_f >= il.quantidade.to_f
            saldo = il.quantidade.to_f
            up_status = PresupuestoProduto.find_by_id(il.id)
            up_status.update_attribute :status, 1
          end
        end

        VendasProduto.create( :venda_id         => @venda.id,
                              :persona_id       => @venda.persona_id,
                              :data             => @venda.data,
                              :moeda            => @venda.moeda,
                              :cotacao          => @venda.cotacao,
                              :deposito_id      => dp.id,
                              :presupuesto_produto_id => il.id,
                              :presupuesto_id         => il.presupuesto_id,
                              :quantidade             => saldo.to_f,
                              :unitario_dolar         => il.unitario_dolar.to_f,
                              :preco_dolar            => il.unitario_dolar.to_f,
                              :total_dolar            => (saldo.to_f * il.unitario_dolar.to_f),
                              :unitario_guarani         => il.unitario_guarani.to_f,
                              :preco_guarani            => il.unitario_guarani.to_f,
                              :total_guarani            => (saldo.to_f * il.unitario_guarani.to_f),
                              :produto_id             => il.produto_id,
                              :produto_nome           => il.produto_nome,
                              :fabricante_cod         => il.fabricante_cod,

                            )
      end
    redirect_to("/vendas/#{@venda.id}")    
  end

end
