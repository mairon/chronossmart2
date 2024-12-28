class PresupuestoProdutosController < ApplicationController
    before_filter :authenticate

    def index                                      #
        @presupuesto_produtos = PresupuestoProduto.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @presupuesto_produtos }
        end
    end

    def show                                       #
        @presupuesto_produto = PresupuestoProduto.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @presupuesto_produto }
        end
    end

    def new                                        #
        @presupuesto = Presupuesto.find(params[:presupuesto_id])

        @presupuesto_produto = PresupuestoProduto.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @presupuesto_produto }
        end
    end

    def edit                                       #
        @presupuesto = Presupuesto.find(params[:presupuesto_id])

        @presupuesto_produto = PresupuestoProduto.find(params[:id])
    end

    def create                                     #

        @presupuesto = Presupuesto.find(params[:presupuesto_id])

        @presupuesto_produto = @presupuesto.presupuesto_produtos.build(params[:presupuesto_produto])

        respond_to do |format|
            if @presupuesto_produto.save
                format.html { redirect_to presupuesto_path(@presupuesto) }
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update                                     #
        @presupuesto = Presupuesto.find(params[:presupuesto_id])
        @presupuesto_produto = PresupuestoProduto.find(params[:id])

        respond_to do |format|
            if @presupuesto_produto.update_attributes(params[:presupuesto_produto])
                format.html { redirect_to presupuesto_path(@presupuesto) }
            else
                format.html { render :action => "edit" }
            end
        end
    end

    def destroy                                    #
        @presupuesto = Presupuesto.find(params[:presupuesto_id])
        @presupuesto_produto = PresupuestoProduto.find(params[:id])
        @presupuesto_produto.destroy

        respond_to do |format|
            format.html { redirect_to presupuesto_path(@presupuesto) }
        end
    end
end
