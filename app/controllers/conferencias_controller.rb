class ConferenciasController < ApplicationController
  # GET /conferencias
  # GET /conferencias.json

  def gera_stock_conferido
    @conferencia = Conferencia.find(params[:id])
    Stock.where( tabela: 'CONFERENCIA_PRODUTOS_IVENTARIO', tabela_id: @conferencia.id).destroy_all

        sql = "SELECT S.PRODUTO_ID,
                      S.DEPOSITO_ID,
                      MAX(P.NOME) AS PRODUTO_NOME,
                      SUM(S.ENTRADA - S.SAIDA) STOCK

                FROM STOCKS S

                INNER JOIN PRODUTOS P
                ON P.ID = S.PRODUTO_ID

                WHERE P.TIPO_PRODUTO = 0 AND S.DATA <= '#{@conferencia.data}'
                AND S.DEPOSITO_ID = #{@conferencia.deposito_id}

                GROUP BY 2,1
                ORDER BY 1"


    stock_atual = Stock.find_by_sql(sql)
    stock_atual.each do |sa|
      if sa.stock.to_f > 0
        Stock.create(
          :tabela => 'CONFERENCIA_PRODUTOS_IVENTARIO',
          :tabela_id => @conferencia.id,
          :cod_processo => @conferencia.id,
          :sigla_proc => 'CPI',
          :persona_nome     => 'CONFERENCIA STOCK',
          :data             => @conferencia.data,
          :status           => 5,
          :deposito_id      => @conferencia.deposito_id,
          :entrada          => 0,
          :saida            => sa.stock.to_f,
          :produto_id       => sa.produto_id,
          :produto_nome     => sa.produto_nome
        )

      else

        Stock.create(
          :tabela => 'CONFERENCIA_PRODUTOS_IVENTARIO',
          :tabela_id => @conferencia.id,
          :cod_processo => @conferencia.id,
          :sigla_proc => 'CPI',
          :persona_nome     => 'CONFERENCIA STOCK',
          :data             => @conferencia.data,
          :status           => 5,
          :deposito_id      => @conferencia.deposito_id,
          :entrada          => (sa.stock.to_f * -1) ,
          :saida            => 0,
          :produto_id       => sa.produto_id,
          :produto_nome     => sa.produto_nome
        )
      end
    end

    @conferencia.conferencia_produtos.each do |ccp|
        Stock.create(
          :tabela => 'CONFERENCIA_PRODUTOS_IVENTARIO',
          :tabela_id => @conferencia.id,
          :cod_processo => @conferencia.id,
          :sigla_proc => 'CPI',
          :persona_nome     => 'CONFERENCIA STOCK NEW',
          :data             => @conferencia.data,
          :status           => 6,
          :deposito_id      => @conferencia.deposito_id,
          :entrada          => ccp.quantidade.to_f,
          :saida            => 0,
          :produto_id       => ccp.produto_id,
          :produto_nome     => ccp.produto_nome
        )
    end

    redirect_to("/conferencias/#{@conferencia.id}")

  end

  def index
    @conferencias = Conferencia.paginate( conditions: ["unidade_id = #{current_unidade.id}"],
      page: params[:page],
      per_page: 50,
      ).order('id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conferencias }
    end
  end

  # GET /conferencias/1
  # GET /conferencias/1.json
  def show
    @conferencia = Conferencia.find(params[:id])

    sql = "SELECT CP.ID,
                   CP.PRODUTO_ID,
                   CP.PRODUTO_NOME,
                   CP.saldo_anterior,
                   CP.quantidade,
                   CP.custo_medio_us,
                   CP.custo_medio_gs
            FROM CONFERENCIA_PRODUTOS CP
            WHERE CP.CONFERENCIA_ID = #{@conferencia.id}
            "

    @conferencia_produtos = ConferenciaProduto.find_by_sql(sql)
    render layout: 'chart'
  end

  def print_conferencia
    @conferencia = Conferencia.find(params[:id])
    @pcp = ConferenciaProduto.where("conferencia_id = #{@conferencia.id}")


        head =
        "                                                         #{current_unidade.nome_sys}
                                                   Conferencia y Ajuste de Stock
        "

            respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_fechamento_caixa",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '0.90in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 15},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - #{t('DATE')} de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end  end

  # GET /conferencias/new
  # GET /conferencias/new.json
  def new
    @conferencia = Conferencia.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conferencia }
    end
  end

  # GET /conferencias/1/edit
  def edit
    @conferencia = Conferencia.find(params[:id])
  end

  # POST /conferencias
  # POST /conferencias.json
  def create
    @conferencia = Conferencia.new(params[:conferencia])
    @conferencia.unidade_id = current_unidade.id.to_i

    respond_to do |format|
      if @conferencia.save
        format.html { redirect_to @conferencia }
        format.json { render json: @conferencia, status: :created, location: @conferencia }
      else
        format.html { render action: "new" }
        format.json { render json: @conferencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conferencias/1
  # PUT /conferencias/1.json
  def update
    @conferencia = Conferencia.find(params[:id])

    respond_to do |format|
      if @conferencia.update_attributes(params[:conferencia])
        format.html { redirect_to @conferencia }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conferencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conferencias/1
  # DELETE /conferencias/1.json
  def destroy
    @conferencia = Conferencia.find(params[:id])
    @conferencia.destroy

    respond_to do |format|
      format.html { redirect_to conferencias_url }
      format.json { head :no_content }
    end
  end

    def grade
      params[:unidade] = current_unidade.id
      @conferencia = Conferencia.find(params[:id])
      render :layout => 'consulta'
    end

    def resultado_grade
        @conferencia = Conferencia.find(params[:id])
        tipo = "P.NOME"            if params[:tipo] == "DESCRIPCION"
        tipo = "P.FABRICANTE_COD"  if params[:tipo] == "REFERENCIA"
        tipo = "BARRA"             if params[:tipo] == "BARRA"
        sql = "
        SELECT PG.ID AS PRODUTOS_GRADE_ID,
               P.ID AS PRODUTO_ID,
               P.NOME AS NOME,
               PG.COR_ID AS COR_ID,
               C.NOME AS COR_NOME,
               C.COD_COR AS COD_COR,
               P.FABRICANTE_COD,
               PG.TAMANHO_ID AS TAMANHO_ID,
               T.NOME AS TAMANHO_NOME,
               (SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.DEPOSITO_ID = 3 AND S.PRODUTOS_GRADE_ID = PG.ID) AS STOCK

        FROM PRODUTOS_GRADES PG
        INNER JOIN PRODUTOS P
        ON PG.PRODUTO_ID = P.ID
        LEFT JOIN PRODUTOS_TABELA_PRECOS TB
        ON PG.PRODUTO_ID = TB.PRODUTO_ID
        LEFT JOIN CORS C
        ON PG.COR_ID = C.ID
        LEFT JOIN TAMANHOS T
        ON PG.TAMANHO_ID = T.ID
        WHERE TB.UNIDADE_ID = #{params[:unidade]} AND #{tipo} LIKE '%#{params[:busca]}%'
        ORDER BY 1,3"
        @produtos = Produto.find_by_sql(sql)
        render :layout => 'consulta'
    end

    def add_produtos
      @conferencia = Conferencia.find(params[:id])

      params[:fields].each do |i, values|
        #elimina produtos conforme grade
        ConferenciaProduto.destroy_all("produtos_grade_id = #{values["produtos_grade_id"].to_i} and conferencia_id = #{@conferencia.id}")
        if values["quantidade"].to_i > 0
          #adiciona produtos
          values["quantidade"].to_i.times do |a|
          ConferenciaProduto.create(
                              :conferencia_id        => values["conferencia_id"].to_i,
                              :produto_id            => values["produto_id"].to_i,
                              :produtos_grade_id     => values["produtos_grade_id"].to_i,
                              :fabricante_cod        => values["fabricante_cod"],
                              :cor_id                => values["cor_id"].to_i,
                              :cor_nome              => values["cor_nome"],
                              :tamanho_id            => values["tamanho_id"].to_i,
                              :tamanho_nome          => values["tamanho_nome"],
                              :produto_nome          => values["produto_nome"]
                              )
          end
        end

      end
      redirect_to "/conferencias/#{@conferencia.id}"
    end

end
