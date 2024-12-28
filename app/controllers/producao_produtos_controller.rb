class ProducaoProdutosController < ApplicationController
    before_filter :authenticate

    def new
        @producao_produto = ProducaoProduto.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => producao_produto }
        end
    end

    def edit
        @producao_produto = ProducaoProduto.find(params[:id])
        session[:pagina] = '0'
    end

    def create
        @producao_produto = ProducaoProduto.new(params[:producao_produto])

        respond_to do |format|
            if @producao_produto.save
              format.html { redirect_to "/producaos/#{@producao_produto.producao_id}" }
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update
        @producao_produto = ProducaoProduto.find(params[:id])

        respond_to do |format|
            if @producao_produto.update_attributes(params[:producao_produto])
              format.html { redirect_to "/producaos/#{@producao_produto.producao_id}" }
            else
                format.html { render :action => "edit" }
            end
        end
    end

    def destroy
        @producao_produto = ProducaoProduto.find(params[:id])
        @producao_produto.destroy

        respond_to do |format|
            format.html { redirect_to "/producaos/#{@producao_produto.producao_id}" }
        end
    end
end
