class RubrosController < ApplicationController
before_filter :authenticate

  def get_codigo     #
    @codigo =  PlanoDeConta.find(:first,:select => 'id,codigo', :conditions =>  [ "codigo = ?", params[:rubro_codigo]])
    return render :text => "<script type='text/javascript'>
                                document.getElementById('rubro_plano_de_conta_id').value                = '#{@codigo.id.to_i}';
                            </script>"
  end

  def index          #
    @rubros = Rubro.find(:all,:select => 'id,codigo,plano_de_conta_descricao,descricao',:order => 'descricao')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rubros }
    end
  end

  def show           #
    @rubro = Rubro.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rubro }
    end
  end

  def new            #
    @rubro = Rubro.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rubro }
    end
  end

  def edit           #
    @rubro = Rubro.find(params[:id])
  end

  def create         #
    @rubro = Rubro.new(params[:rubro])
    @rubro.usuario_created = current_user.usuario_nome
    @rubro.unidade_created = current_unidade.unidade_nome


    respond_to do |format|
      if @rubro.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to(rubros_url) }
        format.xml  { render :xml => @rubro, :status => :created, :location => @rubro }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rubro.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update         #
    @rubro = Rubro.find(params[:id])
    @rubro.usuario_updated = current_user.usuario_nome
    @rubro.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @rubro.update_attributes(params[:rubro])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to(rubros_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rubro.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy        #
    @rubro = Rubro.find(params[:id])
    @rubro.destroy

    respond_to do |format|
      format.html { redirect_to(rubros_url) }
      format.xml  { head :ok }
    end
  end
end
