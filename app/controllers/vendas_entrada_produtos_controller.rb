class VendasEntradaProdutosController < ApplicationController
    before_filter :authenticate

    def get_moeda                 #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                                  document.getElementById('vendas_entrada_produto_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                                </script>"
    end

    def index                                            #
        @vendas_entrada_produtos = VendasEntradaProduto.all(:conditions => ["venda_id is null"])

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @vendas_entrada_produtos }
        end
    end

    def show                                             #
        @vendas_entrada_produto = VendasEntradaProduto.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @vendas_entrada_produto }
        end
    end

    def new_entrada                                          #
        @vendas_entrada_produto = VendasEntradaProduto.new
        session[:new] = ""

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @vendas_entrada_produto }
        end
    end


    def new                                              #
        @vendas_entrada_produto = VendasEntradaProduto.new
        session[:new] = "0"

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @vendas_entrada_produto }
        end
    end

    def edit                                             #
        @vendas_entrada_produto = VendasEntradaProduto.find(params[:id])
    end

    def create                                           #
        @vendas_entrada_produto = VendasEntradaProduto.new(params[:vendas_entrada_produto])
        @vendas_entrada_produto.usuario_created = current_user.usuario_nome
        @vendas_entrada_produto.unidade_created = current_unidade.unidade_nome

        respond_to do |format|
            if @vendas_entrada_produto.save
                format.html { redirect_to "/vendas/vendas_entrada_produto/#{@vendas_entrada_produto.venda_id}" }
            else
               if session[:new] == "0"            
                format.html { render :action => "new" }
               else
                format.html { render :action => "new_entrada" }
               end                
            end
        end
    end

    def update                                           #
        @vendas_entrada_produto = VendasEntradaProduto.find(params[:id])
        @vendas_entrada_produto.usuario_updated = current_user.usuario_nome
        @vendas_entrada_produto.unidade_updated = current_unidade.unidade_nome

        respond_to do |format|
            if @vendas_entrada_produto.update_attributes(params[:vendas_entrada_produto])
                format.html { redirect_to "/vendas/vendas_entrada_produto/#{@vendas_entrada_produto.venda_id}" }
            else
               if session[:new] == "0"            
                format.html { render :action => "new" }
               else
                format.html { render :action => "new_entrada" }
               end                
            end
        end
    end

    def destroy                                          #
        @vendas_entrada_produto = VendasEntradaProduto.find(params[:id])
        @vendas_entrada_produto.destroy

        respond_to do |format|
            format.html { redirect_to "/vendas/vendas_entrada_produto/#{@vendas_entrada_produto.venda_id}" }
        end
    end
end
