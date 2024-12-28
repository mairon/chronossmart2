class VendasFinancasController < ApplicationController
    before_filter :authenticate

    def index              #
        @vendas_financas = VendasFinanca.find(:all)

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @vendas_financas }
        end
    end

    def gerador_cotas                #
        @vendas_financa = VendasFinanca.new

        @produto_sum_dolar   = VendasProduto.sum(:total_dolar, :conditions => ['venda_id = ?',params[:id]] )
        @produto_sum_guarani = VendasProduto.sum(:total_guarani, :conditions => ['venda_id = ?',params[:id]] )
        @contado_sum_dolar   = VendasFinanca.sum(:valor_dolar_contado, :conditions => ['venda_id = ?',params[:id]] )
        @contado_sum_guarani = VendasFinanca.sum(:valor_guarani_contado, :conditions => ['venda_id = ?',params[:id]] )

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @vendas_financa }
        end
    end


    def show               #
        @vendas_financa = VendasFinanca.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @vendas_financa }
        end
    end

    def new                #
        @vendas_financa = VendasFinanca.new

        respond_to do |format|
            format.html # new.html.erb
        end
    end

    def edit               #
        @vendas_financa = VendasFinanca.find(params[:id])
        @produto_count       = VendasProduto.sum(:quantidade,:conditions => ['venda_id = ?',@vendas_financa.venda_id] )
        @produto_sum_dolar   = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',@vendas_financa.venda_id] )
        @produto_sum_guarani = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',@vendas_financa.venda_id] )
        @cota_count          = VendasFinanca.count(:id,:conditions => ['venda_id = ?',@vendas_financa.venda_id] )
        @cota_total          = @cota_count +1

    end

    def create             #
        @vendas_financa = VendasFinanca.new(params[:vendas_financa])
        @vendas_financa.usuario_created      = current_user.id
        @vendas_financa.unidade_created      = current_unidade.id

        respond_to do |format|
            if @vendas_financa.save
                flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
                    format.html { redirect_to "/vendas/#{@vendas_financa.venda_id}/financas" }
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update             #
        @vendas_financa = VendasFinanca.find(params[:id])
        @vendas_financa.usuario_updated      = current_user.id
        @vendas_financa.unidade_updated      = current_unidade.id

        respond_to do |format|
            if @vendas_financa.update_attributes(params[:vendas_financa])
                flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
                    format.html { redirect_to "/vendas/#{@vendas_financa.venda_id}/financas" }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @vendas_financa.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy            #
        @vendas_financa = VendasFinanca.find(params[:id])
        @vendas_financa.destroy

        respond_to do |format|
            format.html { redirect_to "/vendas/#{@vendas_financa.venda_id}/financas" }
        end
    end
end
