class VendasFaturasController < ApplicationController

  def fatura
      @vendas_fatura = VendasFatura.find(params[:id])
      @venda                = Venda.find(@vendas_fatura.venda_id)
      @venda_produto        = VendasProduto.all(:conditions => ["venda_id = ? ",@vendas_fatura.venda_id],:order => 'id' )
      @produto_sum_dolar    = VendasProduto.sum(:total_dolar,:conditions => ["venda_id = ?",@vendas_fatura.venda_id] )
      @produto_sum_guarani  = VendasProduto.sum(:total_guarani,:conditions => ["venda_id = ?",@vendas_fatura.venda_id] )
      @produto_sum_iva10_us = VendasProduto.sum('total_dolar / 11' ,:conditions => ["taxa = 10 AND venda_id = ?",@vendas_fatura.venda_id] )
      @produto_sum_iva10_gs = VendasProduto.sum('total_guarani / 11' ,:conditions => ["taxa = 10 AND venda_id = ?",@vendas_fatura.venda_id] )
      @produto_sum_iva05_us = VendasProduto.sum('total_dolar / 21',:conditions => ["taxa = 5 AND venda_id = ?",@vendas_fatura.venda_id] )
      @produto_sum_iva05_gs = VendasProduto.sum('total_guarani / 21',:conditions => ["taxa = 5 AND venda_id = ?",@vendas_fatura.venda_id] )
      @produto_sum_iva80_us = VendasProduto.sum('iva_dolar * quantidade',:conditions => ["taxa = 80 AND venda_id = ?",@vendas_fatura.venda_id] )
      @produto_sum_iva80_gs = VendasProduto.sum('iva_guarani * quantidade',:conditions => ["taxa = 80 AND venda_id = ?",@vendas_fatura.venda_id] )

      sql = "SELECT VP.FABRICANTE_COD,
                MAX(VP.TAXA) AS TAXA,
                SUM(VP.QUANTIDADE) AS QUANTIDADE,
                MAX(VP.PRODUTO_NOME) AS PRODUTO_NOME,
                MAX(VP.UNITARIO_DOLAR) AS UNITARIO_DOLAR,
                MAX(VP.UNITARIO_GUARANI) AS UNITARIO_GUARANI,
                SUM(VP.TOTAL_DOLAR) AS TOTAL_DOLAR,
                SUM(VP.TOTAL_GUARANI) AS TOTAL_GUARANI
            FROM VENDAS_PRODUTOS VP
            WHERE VP.VENDA_ID = #{@venda.id}
            GROUP BY 1
            ORDER BY 1"
            @vendas_group_produtos = VendasProduto.find_by_sql(sql)
      @form                 = Form.find(:first,:select => 'form_venda_fatura')

      render :layout => false
  end

  def index
    @vendas_faturas = VendasFatura.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vendas_faturas }
    end
  end

  # GET /vendas_faturas/1
  # GET /vendas_faturas/1.json
  def show
    @vendas_fatura = VendasFatura.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vendas_fatura }
    end
  end

  # GET /vendas_faturas/new
  # GET /vendas_faturas/new.json
  def new
    @vendas_fatura = VendasFatura.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vendas_fatura }
    end
  end

  # GET /vendas_faturas/1/edit
  def edit
    @vendas_fatura = VendasFatura.find(params[:id])
  end

  # POST /vendas_faturas
  # POST /vendas_faturas.json
  def create
    @vendas_fatura = VendasFatura.new(params[:vendas_fatura])

    respond_to do |format|
      if @vendas_fatura.save
        vendas_financas = VendasFinanca.where("venda_id = #{@vendas_fatura.venda_id}")
        vendas_financas.each do |vf|
          vf.update_attributes(fatura: 1, documento_numero_01: @vendas_fatura.documento_numero_01, documento_numero_02: @vendas_fatura.documento_numero_02, documento_numero: @vendas_fatura.documento_numero, documento_id: 9)
        end

        format.html { redirect_to "/vendas/#{@vendas_fatura.venda_id}/vendas_financa" }
        format.json { render json: @vendas_fatura, status: :created, location: @vendas_fatura }
      else
        format.html { render action: "new" }
        format.json { render json: @vendas_fatura.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vendas_faturas/1
  # PUT /vendas_faturas/1.json
  def update
    @vendas_fatura = VendasFatura.find(params[:id])
      respond_to do |format|
      if @vendas_fatura.update_attributes(params[:vendas_fatura])

        format.html { redirect_to "/vendas/#{@vendas_fatura.venda_id}/vendas_financa" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vendas_fatura.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendas_faturas/1
  # DELETE /vendas_faturas/1.json
  def destroy
    @vendas_fatura = VendasFatura.find(params[:id])
    @vendas_fatura.destroy

    respond_to do |format|
      format.html { redirect_to "/vendas/#{@vendas_fatura.venda_id}/vendas_financa" }
      format.json { head :no_content }
    end
  end

  def anula_fatura
    @vendas_fatura = VendasFatura.find(params[:id])
    @vendas_fatura.update_attribute :status,  1
    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
