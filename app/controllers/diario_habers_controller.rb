class DiarioHabersController < ApplicationController
before_filter :authenticate


  def get_codigo_descricao_haber     #
    @codi =  Rubro.find(:first, :conditions =>  [ "id = ?", params[:key]])
    return render :text => "<script type='text/javascript'>
                                document.getElementById('diario_haber_contabilidade').value                = '#{@codi.codigo.to_s}';
                            </script>"
  end

  def get_codigo_haber               #
    @codigo =  Rubro.find(:first, :conditions =>  [ "codigo = ?", params[:diario_haber_contabilidade]])
    return render :text => "<script type='text/javascript'>
                                document.getElementById('diario_haber_rubro_id').value                = '#{@codigo.id.to_i}';
                            </script>"
  end


  def index                #
    @diario_habers = DiarioHaber.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @diario_habers }
    end
  end

  def show                 #
    @diario_haber = DiarioHaber.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @diario_haber }
    end
  end

  def new                  #
    @diario_haber = DiarioHaber.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @diario_haber }
    end
  end

  def edit                 #
    @diario_haber = DiarioHaber.find(params[:id])
  end

  def create               #
    @diario_haber = DiarioHaber.new(params[:diario_haber])
    @diario_haber.usuario_created = current_user.id
    @diario_haber.unidade_created = current_unidade.id

    respond_to do |format|
      if @diario_haber.save
        format.html { redirect_to "/diarios/#{@diario_haber.diario_id}", :notice => t('SAVE_SUCESSFUL_MESSAGE') }
        format.xml  { render :xml => @diario_haber, :status => :created, :location => @diario_haber }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @diario_haber.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update               #
    @diario_haber = DiarioHaber.find(params[:id])
    @diario_haber.usuario_updated = current_user.id
    @diario_haber.unidade_updated = current_unidade.id

    respond_to do |format|
      if @diario_haber.update_attributes(params[:diario_haber])
        format.html { redirect_to "/diarios/#{@diario_haber.diario_id}", :notice => t('SUCESSFUL_EDIT_MESSAGE') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @diario_haber.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy              #
    @diario_haber = DiarioHaber.find(params[:id])
    @diario_haber.destroy

    respond_to do |format|
      format.html { redirect_to "/diarios/#{@diario_haber.diario_id}" }
      format.xml  { head :ok }
    end
  end
end
