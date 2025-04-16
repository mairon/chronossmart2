class CondicionalsController < ApplicationController

  def entrada
    @condicional = Condicional.find(params[:id])
    @saldo = Condicional.saldo(params)
    render layout: 'chart'    
  end

  def dynamic_condicional_empaque_produto
    tb_cliente = Persona.find_by_id(params[:persona_id])
    if params[:entrada] == 'true'

      sql = "SELECT CP.PRODUTO_ID,
                    MAX('ENTRADA') AS CD,
                    MAX(CP.ID) AS ID,
                    MAX(P.FABRICANTE_COD) AS FABRICANTE_COD,
                    MAX('') AS TAMANHO,
                    MAX('') AS COR,
                    MAX(P.BARRA) AS BARRA,
                    MAX(P.NOME) PRODUTO_NOME,
                    MAX(CP.VALOR_GS) AS PRECO_GS,
                    MAX(CP.VALOR_US) AS PRECO_US,
                    SUM(CP.QUANTIDADE) AS SAIDA,
                    coalesce((SELECT SUM(CE.QUANTIDADE) FROM CONDICIONAL_PRODUTOS CE WHERE CE.PRODUTO_ID = CP.PRODUTO_ID AND CE.STATUS = FALSE AND CE.CONDICIONAL_ID = #{params[:id]}),0) AS ENTRADA
      FROM CONDICIONAL_PRODUTOS CP
      INNER JOIN PRODUTOS P
      ON P.ID = CP.PRODUTO_ID
      WHERE CP.CONDICIONAL_ID = #{params[:id]}
      AND CP.STATUS = TRUE
      AND P.BARRA = '#{params[:fabricante]}'
      GROUP BY 1
      HAVING
      (SUM(CP.QUANTIDADE) - coalesce((SELECT SUM(CE.QUANTIDADE) FROM CONDICIONAL_PRODUTOS CE WHERE CE.PRODUTO_ID = CP.PRODUTO_ID AND CE.STATUS = FALSE AND CE.CONDICIONAL_ID = #{params[:id]}),0)) > 0
      LIMIT 1"





      asql = "SELECT 'ENTRADA' AS CD,
                    P.ID AS PRODUTO_ID,
                    P.FABRICANTE_COD,
                    '' AS TAMANHO,
                    '' AS COR,
                    P.NOME AS PRODUTO_NOME,
                    OS.VALOR_GS AS PRECO_GS
            FROM CONDICIONAL_PRODUTOS OS

            INNER JOIN PRODUTOS P

            ON P.ID = OS.PRODUTO_ID
            WHERE OS.CONDICIONAL_ID = #{params[:id]}
            AND OS.STATUS = TRUE 
            AND P.BARRA = '#{params[:fabricante]}'
            AND (OS.QUANTIDADE - (COALESCE((SELECT SUM(E.QUANTIDADE) FROM CONDICIONAL_PRODUTOS E WHERE E.PRODUTO_ID = OS.PRODUTO_ID AND E.STATUS = FALSE AND E.CONDICIONAL_ID = #{params[:id]} ),0)) ) > 0
             LIMIT 1
            "
    else

      sql = "SELECT 'SAIDA' AS CD,
                    P.ID AS PRODUTO_ID,
                    P.FABRICANTE_COD,
                    '' AS TAMANHO,
                    '' AS COR,
                    P.NOME AS PRODUTO_NOME,
                    (COALESCE((SELECT SUM(E.QUANTIDADE) FROM CONDICIONAL_PRODUTOS E WHERE E.PRODUTO_ID = P.ID AND E.STATUS = TRUE AND E.CONDICIONAL_ID = #{params[:id]} ),0)) AS SALDO_CONDICIONAL,
                    (COALESCE( (SELECT SUM(S.ENTRADA - S.SAIDA) FROM STOCKS S WHERE S.PRODUTO_ID = P.ID AND S.DEPOSITO_ID = #{params[:deposito_id]}) ,0)) AS SALDO_STOCK,
                    (SELECT TB.PRECO_1_GS FROM PRODUTOS_TABELA_PRECOS TB WHERE TB.PRODUTO_ID = P.ID AND TB.TABELA_PRECO_ID = #{tb_cliente.tabela_preco_id} LIMIT 1) AS PRECO_GS,
                    0 AS PRECO_DESC_GS,
                    0 AS PERCEN_DESC,
                    0 AS PROMO_ID

      FROM PRODUTOS P
      WHERE P.BARRA = '#{params[:fabricante]}' LIMIT 1"

    end


      @list_grade = Produto.find_by_sql(sql)
      respond_to do |format|
        format.js
      end
    end




  def index
  end

  def busca
    params[:unidade] = current_unidade.id
    @condicionals = Condicional.filtro_busca(params)
    render :layout => false
  end


  # GET /condicionals/1
  # GET /condicionals/1.json
  def show
    @condicional = Condicional.find(params[:id])

    render layout: 'chart'
  end

  def comprovante
    @condicional = Condicional.find(params[:id])

      respond_to do |format|
      format.html do
        render  :pdf                    => "comprovante",
                :layout                 => "layer_relatorios",
                :margin => {:top        => '0.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :spacing    => 0},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "Chronos Smart - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end  
  end


  # GET /condicionals/new
  # GET /condicionals/new.json
  def new
    @condicional = Condicional.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @condicional }
    end
  end

  # GET /condicionals/1/edit
  def edit
    @condicional = Condicional.find(params[:id])
  end

  # POST /condicionals
  # POST /condicionals.json
  def create
    @condicional = Condicional.new(params[:condicional])
    @condicional.unidade_id = current_unidade.id.to_i
    @condicional.usuario_created = current_user.id

    respond_to do |format|
      if @condicional.save
        format.html { redirect_to @condicional, notice: 'Condicional was successfully created.' }
        format.json { render json: @condicional, status: :created, location: @condicional }
      else
        format.html { render action: "new" }
        format.json { render json: @condicional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /condicionals/1
  # PUT /condicionals/1.json
  def update
    @condicional = Condicional.find(params[:id])

    respond_to do |format|
      if @condicional.update_attributes(params[:condicional])
        format.html { redirect_to @condicional, notice: 'Condicional was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @condicional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /condicionals/1
  # DELETE /condicionals/1.json
  def destroy
    @condicional = Condicional.find(params[:id])
    @condicional.destroy

    respond_to do |format|
      format.html { redirect_to condicionals_url }
      format.json { head :no_content }
    end
  end
end
