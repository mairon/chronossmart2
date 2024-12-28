class EgressosController < ApplicationController
    before_filter :authenticate


    def busca_egreso
        params[:unidade] = current_unidade.id
        @egressos = Egresso.filtro_egreso(params)
        respond_to do |format|
            format.html { render :layout => false}
        end
    end

    def index
      render layout: 'chart'
    end

    def show                    #
        @egresso = Egresso.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @egresso }
        end
    end

    def comprovante                    #
        @egresso = Egresso.find(params[:id])

        render :layout => false	
    end


    def new                     #
        @egresso = Egresso.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @egresso }
        end
    end

    def edit                    #
        @egresso = Egresso.find(params[:id])
    end

    def create                  #
        @egresso = Egresso.new(params[:egresso])
        @egresso.unidade_id = current_unidade.id.to_i
        @egresso.usuario_created = current_user.id.to_i

        respond_to do |format|
            if @egresso.save
                format.html { redirect_to(@egresso, :notice => 'Grabado Con Sucesso.') }
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update                  #
        @egresso = Egresso.find(params[:id])

        respond_to do |format|
            if @egresso.update_attributes(params[:egresso])
                format.html { redirect_to(@egresso, :notice => 'Actualizado con Sucesso.') }
            else
                format.html { render :action => "edit" }
            end
        end
    end

    def destroy                 #
        @egresso = Egresso.find(params[:id])
        @egresso.destroy

        respond_to do |format|
            format.html { redirect_to(egressos_url) }
        end
    end
end
