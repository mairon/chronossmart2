class NotaCreditoProveedorsController < ApplicationController
before_filter :authenticate

  def nc_proveedor_docs
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    @faturas = Compra.all(:select => 'id,persona_id,persona_nome,documento_numero_01,documento_numero_02,documento_numero,data',:conditions => ["persona_id = #{@nota_credito_proveedor.persona_id}"],
                          :order  => 'data DESC,documento_numero DESC')

  end
  def add_docs
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])

      @docs = Compra.find(params[:nota_credito_proveedors]["ids"])      
        @docs.each do |d|
          NcProveedorFatura.create(  nota_credito_proveedor_id: @nota_credito_proveedor.id,
                                		compra_id:           d.id,
                                		documento_numero_01: d.documento_numero_01,
                                		documento_numero_02: d.documento_numero_02,
                                		documento_numero:    d.documento_numero

                                )
        end

      redirect_to(cobro_path(@cobro))
    end  

  def filtro_busca_faturas
    @faturas = Compra.all(:select => 'id,persona_id,persona_nome,documento_numero_01,documento_numero_02,documento_numero,data',:conditions => ["persona_id = ? AND documento_numero LIKE ?",params[:busca],"%#{params[:filtro]}%"],
                          :order  => 'data DESC,documento_numero DESC')

    render :layout => false
  end
   

  def busca_produtos

    render :layout => false
  end

  def nc_proveedor_produtos
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    
    produtos_id = ComprasProduto.select('produto_id').where("persona_id = #{@nota_credito_proveedor.persona_id}").group('produto_id').collect{|d| d.produto_id}.join("', '")
    sql = "SELECT S.PRODUTO_ID,
									S.DEPOSITO_ID,
									MAX(P.NOME) AS PRODUTO_NOME,
									MAX(U.UNIDADE_NOME) AS UNIDADE_NOME,
									MAX(D.NOME) AS DEPOSITO_NOME,
									(SELECT SS.PROMEDIO_GUARANI FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.ENTRADA > 0 AND SS.PRODUTO_ID = S.PRODUTO_ID AND SS.DATA <= '#{@nota_credito_proveedor.data}'  ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) CUSTO_MEDIO_GS,
								  SUM(S.ENTRADA - S.SAIDA) STOCK
								FROM STOCKS S
								INNER JOIN PRODUTOS P
								ON P.ID = S.PRODUTO_ID
								INNER JOIN DEPOSITOS D
								ON D.ID = S.DEPOSITO_ID
								INNER JOIN UNIDADES U
								ON U.ID = D.UNIDADE_ID

								WHERE S.PRODUTO_ID IN (#{produtos_id})
								AND S.DATA <= '#{@nota_credito_proveedor.data}'
								GROUP BY 1,2
								HAVING SUM(S.ENTRADA - S.SAIDA) > 0"
    @produtos = ComprasProduto.find_by_sql(sql)

  end

  def nc_proveedor_aplic
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    sql = "SELECT C.ID,
                          C.PERSONA_ID,
                          C.PERSONA_NOME,
                          C.LIQUIDACAO,
                          C.MOEDA,
                          C.TIPO,
                          C.DATA,
                          C.VENCIMENTO,
                          C.COMPRA_ID,
                          C.DOCUMENTO_NOME,
                          C.DOCUMENTO_NUMERO,
                          C.COTA,
                          C.ORIGINAL,
                          C.DIVIDA_DOLAR,
                          C.DIVIDA_GUARANI,
                          C.DIVIDA_REAL,
                          C.PAGO_DOLAR,
                          C.PAGO_GUARANI,
                          C.PAGO_REAL,
                          C.DESCRICAO,
                          C.DOCUMENTO_NUMERO_01,
                          C.documento_numero_02,
                          ( SELECT SUM(AT.PAGO_DOLAR) FROM PROVEEDORES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} and  AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_US,
                          ( SELECT SUM(AT.PAGO_GUARANI) FROM PROVEEDORES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} and  AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_GS,
                          ( SELECT SUM(AT.PAGO_REAL) FROM PROVEEDORES AT WHERE AT.UNIDADE_ID = #{current_unidade.id} and AT.PERSONA_ID = C.PERSONA_ID AND AT.DOCUMENTO_NUMERO_01 = C.DOCUMENTO_NUMERO_01 AND AT.DOCUMENTO_NUMERO_02 = C.DOCUMENTO_NUMERO_02 AND AT.DOCUMENTO_NUMERO = C.DOCUMENTO_NUMERO AND AT.COTA = C.COTA AND AT.LIQUIDACAO = 0) AS ANTERIOR_RS
                FROM PROVEEDORES C
                LEFT JOIN COMPRAS V
                ON C.COMPRA_ID = V.ID
                LEFT JOIN SUB_GRUPOs SG
                ON V.SUB_GRUPO_ID = SG.ID
                WHERE C.UNIDADE_ID = #{current_unidade.id} and C.PERSONA_ID = #{@nota_credito_proveedor.persona_id} AND C.LIQUIDACAO = 0 AND (C.DIVIDA_GUARANI + C.DIVIDA_DOLAR ) > 0
                ORDER BY 8,12
                          "        
                @dividas  = Proveedore.find_by_sql(sql)


    @valor_total_us = NotaCreditoProveedorProduto.sum('total_dolar',:conditions => ["nota_credito_proveedor_id = ? ",@nota_credito_proveedor.id])

    @valor_total_gs = NotaCreditoProveedorProduto.sum('total_guarani',:conditions => ["nota_credito_proveedor_id = ? ",@nota_credito_proveedor.id])
    @valor_total_rs = NotaCreditoProveedorProduto.sum('total_real',:conditions => ["nota_credito_proveedor_id = ? ",@nota_credito_proveedor.id])

  end

    def comprovante
        @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
        @produtos               = NotaCreditoProveedorProduto.all(:conditions => ['nota_credito_proveedor_id = ?', params[:id]], :order => "fabricante_cod")
        @aplics                 = NotaCreditoProveedorAplic.all(:conditions => ['nota_credito_proveedor_id = ?', params[:id]])

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
                            :left       => '',
                            :spacing    => 5},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
      end
    end

  def nc_proveedor_financa
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    
    @valor_total_us = NcProveedorFatura.sum('valor_dolar',:conditions => ["nota_credito_proveedor_id = ? ",@nota_credito_proveedor.id])

    @valor_total_gs = NcProveedorFatura.sum('valor_guarani',:conditions => ["nota_credito_proveedor_id = ? ",@nota_credito_proveedor.id])

    session[:pagina] = ''
  end

  def index
    @nota_credito_proveedors = NotaCreditoProveedor.where("unidade_id = #{current_unidade.id}").order('data desc')
  end

  def show
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    
    produtos_id = ComprasProduto.select('produto_id').where("tipo_compra = 0 and persona_id = #{@nota_credito_proveedor.persona_id}").group('produto_id').collect{|d| d.produto_id}.join(",")
    sql = "SELECT S.PRODUTO_ID,
									S.DEPOSITO_ID,
									MAX(P.NOME) AS PRODUTO_NOME,
									MAX(U.UNIDADE_NOME) AS UNIDADE_NOME,
									MAX(D.NOME) AS DEPOSITO_NOME,
									(SELECT SS.PROMEDIO_GUARANI FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.ENTRADA > 0 AND SS.PRODUTO_ID = S.PRODUTO_ID AND SS.DATA <= '#{@nota_credito_proveedor.data}'  ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) CUSTO_MEDIO_GS,
									(SELECT SS.PROMEDIO_DOLAR FROM STOCKS SS WHERE SS.STATUS = 0 AND SS.ENTRADA > 0 AND SS.PRODUTO_ID = S.PRODUTO_ID AND SS.DATA <= '#{@nota_credito_proveedor.data}'  ORDER BY SS.DATA DESC, SS.TABELA_ID DESC  LIMIT 1) CUSTO_MEDIO_US,
								  SUM(S.ENTRADA - S.SAIDA) STOCK
								FROM STOCKS S
								INNER JOIN PRODUTOS P
								ON P.ID = S.PRODUTO_ID
								INNER JOIN DEPOSITOS D
								ON D.ID = S.DEPOSITO_ID
								INNER JOIN UNIDADES U
								ON U.ID = D.UNIDADE_ID

								WHERE S.PRODUTO_ID IN (#{produtos_id})
								AND S.DATA <= '#{@nota_credito_proveedor.data}'
								GROUP BY 1,2
								HAVING SUM(S.ENTRADA - S.SAIDA) > 0
								ORDER BY 1"
    @produtos = ComprasProduto.find_by_sql(sql)
  end

  def new
    @nota_credito_proveedor = NotaCreditoProveedor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nota_credito_proveedor }
    end
  end

  def edit
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    session[:pagina] = '1'
  end

  def create
    @nota_credito_proveedor = NotaCreditoProveedor.new(params[:nota_credito_proveedor])
    @nota_credito_proveedor.unidade_id = current_unidade.id.to_i

    respond_to do |format|
      if @nota_credito_proveedor.save
        if @nota_credito_proveedor.operacao == 0
          format.html { redirect_to(@nota_credito_proveedor) }
        else
          format.html { redirect_to "/nota_credito_proveedors/#{@nota_credito_proveedor.id}/nc_proveedor_aplic" }
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])

    respond_to do |format|
      if @nota_credito_proveedor.update_attributes(params[:nota_credito_proveedor])

        if @nota_credito_proveedor.operacao == 0
          format.html { redirect_to(@nota_credito_proveedor) }
        else
          format.html { redirect_to "/nota_credito_proveedors/#{@nota_credito_proveedor.id}/nc_proveedor_aplic" }
        end

      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nota_credito_proveedor.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    @nota_credito_proveedor.destroy

    respond_to do |format|
      format.html { redirect_to(nota_credito_proveedors_url) }
      format.xml  { head :ok }
    end
  end
end
