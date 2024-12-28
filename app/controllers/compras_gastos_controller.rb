class ComprasGastosController < ApplicationController
    before_filter :authenticate
    
    def index                  #
        @compras_gastos = ComprasGasto.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @compras_gastos }
        end
    end

    def show                   #
        @compras_gasto = ComprasGasto.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @compras_gasto }
        end
    end

    def new                    #
        @compras_gasto = ComprasGasto.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @compras_gasto }
        end
    end

    def edit                   #
        @compras_gasto = ComprasGasto.find(params[:id])
    end

    def create                 #
        @compras_gasto = ComprasGasto.new(params[:compras_gasto])

        respond_to do |format|
            if @compras_gasto.save
                format.html { redirect_to "/compras/#{@compras_gasto.compra_id}/compras_gasto", :notice => t('SAVE_SUCESSFUL_MESSAGE') }
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update                 #
        @compras_gasto = ComprasGasto.find(params[:id])

        respond_to do |format|
            if @compras_gasto.update_attributes(params[:compras_gasto])
                format.html { redirect_to "/compras/#{@compras_gasto.compra_id}/compras_gasto", :notice => t('SAVE_SUCESSFUL_MESSAGE') }
            else
                format.html { render :action => "edit" }
            end
        end
    end

    def destroy                #
        @compras_gasto = ComprasGasto.find(params[:id])
        @compras_gasto.destroy

        respond_to do |format|
            format.html { redirect_to "/compras/#{@compras_gasto.compra_id}/compras_gasto" }
        end
    end
end
