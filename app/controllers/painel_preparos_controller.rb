class PainelPreparosController < ApplicationController
  def index
    @painel_preparos = PainelPreparo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @painel_preparos }
    end
  end

  def status_preparo
    @produtos = VendasProduto.where(venda_id: params[:venda_id], id: params[:venda_produto_ids])
    @produtos.each do |v|
      v.update_attribute(:status_preparo, params[:status_preparo])
    end

    redirect_to painel_preparo_path(params[:painel_preparo_id])

  end

  def preparo_pendentes
    @painel_preparo = PainelPreparo.find(params[:painel_preparo_id])
    sql = "
         SELECT V.ID,
       V.DATA,
       V.OBS,
       V.CREATED_AT,
       C.NOME AS CARTAO_NOME,
       (SELECT COUNT(VP.ID)
        FROM VENDAS_PRODUTOS VP
        INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID
        WHERE (VP.STATUS_PREPARO IS NULL OR VP.STATUS_PREPARO = 0)
          AND VP.VENDA_ID = V.ID
          AND P.PREPARACAO = TRUE
          AND VP.PRINT = FALSE
          AND P.GRUPO_ID IN (#{@painel_preparo.grupo_ids})
       ) AS TOT_QTD
FROM VENDAS V
INNER JOIN CARTAOS C ON C.ID = V.CARTAO_ID
WHERE V.UNIDADE_ID = #{current_unidade.id}
  AND OP = TRUE
  AND (SELECT COUNT(VP.ID)
       FROM VENDAS_PRODUTOS VP
       INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID
       WHERE (VP.STATUS_PREPARO IS NULL OR VP.STATUS_PREPARO = 0)
         AND VP.VENDA_ID = V.ID
         AND P.PREPARACAO = TRUE
         AND VP.PRINT = FALSE
         AND P.GRUPO_ID IN (#{@painel_preparo.grupo_ids})
      ) > 0
ORDER BY ID

    "
    @produtos = VendasProduto.find_by_sql(sql)

    respond_to do |format|
        format.html { render :layout => false}
    end

  end
  # GET /painel_preparos/1
  # GET /painel_preparos/1.json
  def show
    @painel_preparo = PainelPreparo.find(params[:id])


    sql_s1 = "
          SELECT V.ID,
                 V.DATA,
                 V.CREATED_AT,
                 C.NOME AS CARTAO_NOME,
              (SELECT COUNT(VP.ID) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.STATUS_PREPARO = 1 AND VP.VENDA_ID = V.ID AND P.PREPARACAO = TRUE AND VP.PRINT = FALSE AND P.GRUPO_ID IN (#{@painel_preparo.grupo_ids}) ) AS TOT_QTD
          FROM VENDAS V
          INNER JOIN CARTAOS C
          ON C.ID = V.CARTAO_ID
          WHERE V.UNIDADE_ID = #{current_unidade.id} AND (SELECT COUNT(VP.ID) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.STATUS_PREPARO = 1 AND VP.VENDA_ID = V.ID  AND P.PREPARACAO = TRUE AND P.GRUPO_ID IN (#{@painel_preparo.grupo_ids}) ) > 0

          ORDER BY ID

    "

    @produtos_s1 = VendasProduto.find_by_sql(sql_s1)




    sql_f = "
          SELECT V.ID,
                 V.DATA,
                 V.CREATED_AT,
                 V.UPDATED_AT,
                 C.NOME AS CARTAO_NOME,
              (SELECT COUNT(VP.ID) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.STATUS_PREPARO = 1 AND VP.VENDA_ID = V.ID AND VP.PRINT = FALSE AND P.GRUPO_ID IN (#{@painel_preparo.grupo_ids}) ) AS TOT_QTD
          FROM VENDAS V
          INNER JOIN CARTAOS C
          ON C.ID = V.CARTAO_ID
          WHERE V.UNIDADE_ID = #{current_unidade.id} AND (SELECT COUNT(VP.ID) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.STATUS_PREPARO = 2 AND VP.VENDA_ID = V.ID  AND P.PREPARACAO = TRUE AND P.GRUPO_ID IN (#{@painel_preparo.grupo_ids}) ) > 0

          ORDER BY V.UPDATED_AT DESC, ID DESC

    "

    @produtos_f1 = VendasProduto.paginate_by_sql(sql_f, :page => params[:page], :per_page => 20)

    render layout: 'crm'
  end

  # GET /painel_preparos/new
  # GET /painel_preparos/new.json
  def new
    @painel_preparo = PainelPreparo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @painel_preparo }
    end
  end

  # GET /painel_preparos/1/edit
  def edit
    @painel_preparo = PainelPreparo.find(params[:id])
  end

  # POST /painel_preparos
  # POST /painel_preparos.json
  def create
    @painel_preparo = PainelPreparo.new(params[:painel_preparo])

    respond_to do |format|
      if @painel_preparo.save
        format.html { redirect_to painel_preparos_url }
      else
        format.html { render action: "new" }
        format.json { render json: @painel_preparo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /painel_preparos/1
  # PUT /painel_preparos/1.json
  def update
    @painel_preparo = PainelPreparo.find(params[:id])

    respond_to do |format|
      if @painel_preparo.update_attributes(params[:painel_preparo])
        format.html { redirect_to painel_preparos_url }
      else
        format.html { render action: "edit" }
        format.json { render json: @painel_preparo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /painel_preparos/1
  # DELETE /painel_preparos/1.json
  def destroy
    @painel_preparo = PainelPreparo.find(params[:id])
    @painel_preparo.destroy

    respond_to do |format|
      format.html { redirect_to painel_preparos_url }
    end
  end
end
