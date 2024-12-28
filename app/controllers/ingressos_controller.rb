class IngressosController < ApplicationController

    before_filter :authenticate

    def get_moeda           #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('ingresso_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                            </script>"
    end

    def get_moeda_data            #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:ingresso_data]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('ingresso_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                            </script>"
    end

    def get_moeda_real            #
        @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:ingresso_data]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('ingresso_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end


    def busca_ingreso       #
        params[:unidade] = current_unidade.id
        @ingressos = Ingresso.filtro_ingreso(params)
        respond_to do |format|
            format.html { render :layout => false}
        end
    end

    def index

        render layout: 'chart'
    end

    def show                #
        @ingresso = Ingresso.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @ingresso }
        end
    end

    def comprovante                #
        @ingresso = Ingresso.find(params[:id])
        render :layout => false	
    end


    def new                 #
        @ingresso = Ingresso.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @ingresso }
        end
    end
  
    def edit                #
        @ingresso = Ingresso.find(params[:id])
    end

    def create              #
        @ingresso = Ingresso.new(params[:ingresso])
        @ingresso.usuario_created = current_user.id
        @ingresso.unidade_created = current_unidade.id
        @ingresso.unidade_id = current_unidade.id


        respond_to do |format|
            if @ingresso.save
                format.html { redirect_to(@ingresso, :notice => 'Ingresso was successfully created.') }
                format.xml  { render :xml => @ingresso, :status => :created, :location => @ingresso }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @ingresso.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update              #
        @ingresso = Ingresso.find(params[:id])
        @ingresso.usuario_updated = current_user.id
        @ingresso.unidade_updated = current_unidade.id

        respond_to do |format|
            if @ingresso.update_attributes(params[:ingresso])
                format.html { redirect_to(@ingresso, :notice => 'Ingresso was successfully updated.') }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @ingresso.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy             #
        @ingresso = Ingresso.find(params[:id])
        @ingresso.destroy

        respond_to do |format|
            format.html { redirect_to(ingressos_url) }
            format.xml  { head :ok }
        end
    end
end
