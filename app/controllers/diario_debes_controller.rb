class DiarioDebesController < ApplicationController
before_filter :authenticate

  def get_codigo_debe               #
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



  def index             #
    @diario_debes = DiarioDebe.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @diario_debes }
    end
  end

  def show              #
    @diario_debe = DiarioDebe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @diario_debe }
    end
  end

  def new               #
    @diario_debe = DiarioDebe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @diario_debe }
    end
  end

  def edit              #
    @diario_debe = DiarioDebe.find(params[:id])
  end

  def create            #
    @diario_debe = DiarioDebe.new(params[:diario_debe])
    @diario_debe.usuario_created = current_user.id
    @diario_debe.unidade_created = current_unidade.id

    respond_to do |format|
      if @diario_debe.save
        format.html { redirect_to "/diarios/#{@diario_debe.diario_id}", :notice => t('SAVE_SUCESSFUL_MESSAGE') }
        format.xml  { render :xml => @diario_debe, :status => :created, :location => @diario_debe }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @diario_debe.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update            #
    @diario_debe = DiarioDebe.find(params[:id])
    @diario_debe.usuario_updated = current_user.id
    @diario_debe.unidade_updated = current_unidade.id

    respond_to do |format|
      if @diario_debe.update_attributes(params[:diario_debe])
        format.html { redirect_to "/diarios/#{@diario_debe.diario_id}", :notice => t('SUCESSFUL_EDIT_MESSAGE') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @diario_debe.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy           #
    @diario_debe = DiarioDebe.find(params[:id])
    @diario_debe.destroy

    respond_to do |format|
     format.html { redirect_to "/diarios/#{@diario_debe.diario_id}", :notice => t('SAVE_SUCESSFUL_MESSAGE') }
      format.xml  { head :ok }
    end
  end
end
