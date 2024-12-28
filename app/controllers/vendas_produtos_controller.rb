class VendasProdutosController < ApplicationController
  def modal_update
    @vendas_produto = VendasProduto.find(params[:vendas_produto_id])
    @vendas_produto.update_attributes(quantidade: params[:update_vendas_produto_qtd])

    respond_to do |format|      
      format.js
    end
  end

    def busca_nota_credito_produto
        @vendas_produtos = VendasProduto.nota_credito_produto(params)
        render :layout => 'consulta'
    end

    def index                       #
        #@vendas_produtos = VendasProduto.where("data between '2019-01-01' and '2019-06-30'").order('deposito_id,data,id')
        render layout: false
    end

    def show
        @vendas_produto = VendasProduto.find(params[:id])
        render layout: 'chart'
    end

    def new                         #
        @vendas_produto = VendasProduto.new
        @vendas_produto.current_user = current_user.tipo

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @vendas_produto }
        end
    end

    def edit                        #
        @vendas_produto = VendasProduto.find(params[:id])
        @venda = Venda.find(@vendas_produto.venda_id)
        @vendas_produto.current_user = current_user.tipo
        render :layout => 'layout_vendas'
    end

    def create                      #

        @vendas_produto = VendasProduto.new(params[:vendas_produto])
        @vendas_produto.current_user = current_user.tipo

        respond_to do |format|
            if @vendas_produto.save
                format.html {  redirect_to venda_path(@vendas_produto.venda_id) }
                format.js
            else
                format.html { render :action => "new" }
                format.js
            end
        end

    end

    def update
        @vendas_produto = VendasProduto.find(params[:id])
        @vendas_produto.usuario_updated   = current_user.id
        @vendas_produto.unidade_updated   = current_unidade.id

        respond_to do |format|
            if @vendas_produto.update_attributes(params[:vendas_produto])
                format.html { redirect_to "/vendas/#{@vendas_produto.venda_id}" }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @vendas_produto.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy



      @vendas_produto = VendasProduto.destroy(params[:id])
        vd = Persona.find(@vendas_produto.venda.vendedor_id)
      Audit.create(
        auditable_type: 'VendasProduto',
        owner_id: @vendas_produto.id,
        owner_type: 'VendasProduto',
        auditable_id: @vendas_produto.id,
        user_id: current_user.id,
        user_type: 'Usuario',
        action: 'destroy',
        version: 1,
        vendedor_id: @vendas_produto.venda.vendedor_id,
        unidade_id: current_unidade.id,
        cod_processo: @vendas_produto.venda_id.to_s.rjust(6,'0'),
        comment: "Producto Excluido por #{current_user.usuario_nome}",
        audited_changes: "Vend: #{vd.nome} -  #{@vendas_produto.produto_nome} - Ctd: #{@vendas_produto.quantidade.to_i} - Unit: #{ @vendas_produto.unitario_guarani}"
      )

      respond_to do |format|
        if params[:origen] == 'VendasFinanca'
          format.html { redirect_to "/vendas/#{@vendas_produto.venda_id}/financas" }
        else
          format.html { redirect_to "/vendas/#{@vendas_produto.venda_id}" }
        end
            
      end
    end
end


