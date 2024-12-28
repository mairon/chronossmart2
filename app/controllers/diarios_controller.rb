class DiariosController < ApplicationController
    before_filter :authenticate


    def get_moeda           #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('diario_cotacao').value       = '#{format("%.2f",@moeda.dolar_venda.to_f)}';
                            </script>"
    end

    def get_codigo_debe     #
        @codigo =  Rubro.find(:first, :conditions =>  [ "codigo = ?", params[:diario_debe_contabilidade]])
        return render :text => "<script type='text/javascript'>
                                document.getElementById('diario_debe_rubro_id').value                = '#{@codigo.id.to_i}';
                            </script>"
    end

    def get_codigo_descricao_debe     #
        @codi =  Rubro.find(:first, :conditions =>  [ "id = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                                document.getElementById('diario_debe_contabilidade').value                = '#{@codi.codigo.to_s}';
                            </script>"
    end

    def get_codigo_descricao_haber     #
        @codi =  Rubro.find(:first, :conditions =>  [ "id = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                                document.getElementById('diario_haber_contabilidade').value                = '#{@codi.codigo.to_s}';
                            </script>"
    end

    def get_codigo_haber    #
        @codigo =  Rubro.find(:first, :conditions =>  [ "codigo = ?", params[:diario_haber_contabilidade]])
        return render :text => "<script type='text/javascript'>
                                document.getElementById('diario_haber_rubro_id').value                = '#{@codigo.id.to_i}';
                            </script>"
    end

    def busca
        params[:unidade] = current_unidade.id
        @diarios = Diario.busca_acientos(params)
        render :layout => false
    end

    def novo_debe           #
        @diario = Diario.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @diario }
        end
    end

    def comprovante_diario  #
        @diario = Diario.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @diario }
        end
    end


    def novo_haber          #
        @diario = Diario.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @diario }
        end
    end


    def index               #
        respond_to do |format|
            format.html # index.html.erb
        end
    end

    def show                #
        @diario = Diario.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @diario }
        end
    end

    def new                 #
        @diario = Diario.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @diario }
        end
    end

    def edit                #
        @diario = Diario.find(params[:id])
    end

    def create              #
        @diario = Diario.new(params[:diario])
        @diario.usuario_created = current_user.id
        @diario.unidade_created = current_unidade.id


        respond_to do |format|
            if @diario.save
                format.html { redirect_to(@diario, :notice => 'Diario was successfully created.') }
                format.xml  { render :xml => @diario, :status => :created, :location => @diario }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @diario.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update              #
        @diario = Diario.find(params[:id])
        @diario.usuario_updated = current_user.id
        @diario.unidade_updated = current_unidade.id

        respond_to do |format|
            if @diario.update_attributes(params[:diario])
                format.html { redirect_to(@diario, :notice => 'Diario was successfully updated.') }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @diario.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy             #
        @diario = Diario.find(params[:id])
        @diario.destroy

        respond_to do |format|
            format.html { redirect_to(diarios_url) }
            format.xml  { head :ok }
        end
    end
end
