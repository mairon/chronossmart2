class NotaCreditosController < ApplicationController
before_filter :authenticate


   def faturas_en_abertas
           @faturas = Cliente.all(:conditions => ["persona_id = ? and liquidacao = 0 and tabela = 'VENDAS_FINANCAS'",params[:persona_id]])
           render :layout => 'consulta' 
    end


    def index
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @nota_creditos }
      end
    end

    def busca_nc
        params[:unidade] = current_unidade.id
        @nota_creditos = NotaCredito.filtro_nc(params)
        respond_to do |format|
            format.html { render :layout => false}
        end
    end

    def show
        @nota_credito = NotaCredito.find(params[:id])

        vendedor = "AND V.VENDEDOR_ID = #{@nota_credito.vendedor_id}"
        sql = "SELECT VP.id,
                      V.data,
                      ((VP.quantidade) - (SELECT SUM(NCD.QUANTIDADE) FROM NOTA_CREDITOS_DETALHES NCD WHERE  NCD.PRODUTO_ID = VP.PRODUTO_ID AND NCD.VENDA_ID = VP.VENDA_ID AND NCD.NOTA_CREDITO_ID = #{@nota_credito.id})) AS QUANTIDADE ,
                      VP.produto_id,
                      VP.produto_nome,
                      VP.taxa,
                      VP.fabricante_cod,
                      VP.unitario_dolar,
                      VP.total_dolar,
                      VP.iva_dolar,
                      VP.unitario_guarani,
                      VP.total_guarani,
                      VP.iva_guarani,
                      VP.deposito_id,
                      VP.deposito_nome,
                      VP.venda_id 
            FROM VENDAS_PRODUTOS VP
            INNER JOIN VENDAS V
            ON V.ID = VP.VENDA_ID
            WHERE V.PERSONA_ID = #{@nota_credito.persona_id}
            ORDER BY V.DATA DESC"
        
       @vendas_produtos = VendasProduto.find_by_sql(sql)

      render layout: 'chart'
    end

    def comprovante
        @nota_credito = NotaCredito.find(params[:id])
        @produtos   = NotaCreditosDetalhe.all(:conditions => ['nota_credito_id = ?',params[:id]])
        @aplics   = NotaCreditosDoc.all(:conditions => ['nota_credito_id = ?',params[:id]])
        render layout: false
    end


    def documentos
        @nota_credito = NotaCredito.find(params[:id])
        @ncs = FormFiscal.where("sigla_proc = 'CBP' AND cod_proc = #{@nota_credito.id} and status != 0 ").select("id, tot_gs, doc_01, doc_02, doc, status, autorizacao,cdc")

        @total_nota_dolar   = NotaCreditosDetalhe.sum(:total_dolar,   :conditions => ['nota_credito_id = ?',params[:id]])
        @total_nota_guarani = NotaCreditosDetalhe.sum(:total_guarani, :conditions => ['nota_credito_id = ?',params[:id]])

        @total_doc_dolar   = NotaCreditosDoc.sum(:valor_dolar,   :conditions => ['nota_credito_id = ?',params[:id]])
        @total_doc_guarani = NotaCreditosDoc.sum(:valor_guarani,   :conditions => ['nota_credito_id = ?',params[:id]])

        if @nota_credito.operacao == 0 
          documentos_id = ""
          cond = ""
        end

        @cliente  = Cliente.all( :select => ' id,
                                              persona_id,
                                              persona_nome,
                                              vendedor_id,
                                              vendedor_nome,
                                              pagare,
                                              liquidacao,
                                              tipo,
                                              data,
                                              vencimento,
                                              venda_id,
                                              documento_nome,
                                              documento_numero,
                                              numero_ordem,
                                              cota,
                                              clase_produto,
                                              original,
                                              divida_dolar,
                                              divida_guarani,
                                              cobro_dolar,
                                              cobro_guarani,
                                              diferido,
                                              documento_numero_01,
                                              documento_numero_02',

                                 :conditions => ["liquidacao = 0 AND (divida_dolar + divida_guarani) > 0 AND persona_id = ? #{cond}",@nota_credito.persona_id],:order => 'data,venda_id,cota')

        render layout: 'chart'
    end


    def nota_credito_financas
      @nota_credito       = NotaCredito.find(params[:id])
      @total_nota_dolar   = NotaCreditosDetalhe.sum(:total_dolar,   :conditions => ['nota_credito_id = ?',params[:id]])
      @total_nota_guarani = NotaCreditosDetalhe.sum(:total_guarani, :conditions => ['nota_credito_id = ?',params[:id]])
      respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @nota_credito }
      end
    end

    def nota_credito_comprovante
        @nota_credito       = NotaCredito.find(params[:id])
        @total_nota_dolar   = NotaCreditosDetalhe.sum(:total_dolar,   :conditions => ['nota_credito_id = ?',params[:id]])
        @total_nota_guarani = NotaCreditosDetalhe.sum(:total_guarani, :conditions => ['nota_credito_id = ?',params[:id]])
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @nota_credito }
        end
    end

    def new
      @nota_credito = NotaCredito.new
    end

    def edit
      @nota_credito = NotaCredito.find(params[:id])
    end

    def create
      @nota_credito = NotaCredito.new(params[:nota_credito])
      @nota_credito.usuario_created = current_user.id
      @nota_credito.unidade_created = current_unidade.id
      @nota_credito.unidade_id      = current_unidade.id


      respond_to do |format|
        if @nota_credito.save
          format.html { redirect_to(@nota_credito) }
        else
          format.html { render :action => "new" }
        end
      end
    end

    def update
        @nota_credito = NotaCredito.find(params[:id])
        @nota_credito.usuario_updated = current_user.id
        @nota_credito.unidade_updated = current_unidade.id

        respond_to do |format|
            if @nota_credito.update_attributes(params[:nota_credito])
              format.html { redirect_to(@nota_credito) }            
            else
              format.html { render :action => "edit" }
            end
        end
    end

    def destroy
        @nota_credito = NotaCredito.find(params[:id])
        @nota_credito.destroy

        respond_to do |format|
            format.html { redirect_to(nota_creditos_url) }
        end
    end
end
