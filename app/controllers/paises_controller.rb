class PaisesController < ApplicationController
before_filter :authenticate

  def index
    @paises = Paise.find(:all, :order => 1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paises }
    end
  end

  def show
    @paise = Paise.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paise }
    end
  end

  def new
    @paise = Paise.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paise }
    end
  end

  def edit
    @paise = Paise.find(params[:id])
  end

  def create
    @paise = Paise.new(params[:paise])
    @paise.usuario_created = current_user.usuario_nome
    @paise.unidade_created = current_unidade.unidade_nome

    respond_to do |format|
      if @paise.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to(paises_url) }
        format.xml  { render :xml => @paise, :status => :created, :location => @paise }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paise.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @paise = Paise.find(params[:id])
    @paise.usuario_updated = current_user.usuario_nome
    @paise.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @paise.update_attributes(params[:paise])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to(paises_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paise.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /paises/1
  # DELETE /paises/1.xml
  def destroy
    @paise = Paise.find(params[:id])
    @paise.destroy

    respond_to do |format|
      format.html { redirect_to(paises_url) }
      format.xml  { head :ok }
    end
  end
end
