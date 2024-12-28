class ComprasFinancasController < ApplicationController
 before_filter :authenticate

  def update_individual
      ComprasFinanca.update(params[:compras_financas].keys, params[:compras_financas].values)
        flash[:notice] = "Products updated"
        redirect_to "/compras/#{params[:id]}/compras_financa"
  end


  def index         #
    @compras_financas = ComprasFinanca.where('moeda = 2')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @compras_financas }
    end
  end

  def show          #
    @compras_financa = ComprasFinanca.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @compras_financa }
    end
  end

  def new           #
    @compras_financa = ComprasFinanca.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @compras_financa }
    end
  end
  
  def edit          #
    @compras_financa = ComprasFinanca.find(params[:id])
  end

  def create        #
    @compras_financa = ComprasFinanca.new(params[:compras_financa])
    @compras_financa.usuario_created = current_user.id
    @compras_financa.unidade_created = current_unidade.id

    respond_to do |format|
      if @compras_financa.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to "/compras/#{@compras_financa.compra_id}/compras_financa" }
        format.xml  { render :xml => @compras_financa, :status => :created, :location => @compras_financa }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @compras_financa.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update        #
    @compras_financa = ComprasFinanca.find(params[:id])
    @compras_financa.usuario_updated = current_user.id
    @compras_financa.unidade_updated = current_unidade.id

    respond_to do |format|
      if @compras_financa.update_attributes(params[:compras_financa])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to "/compras/#{@compras_financa.compra_id}/compras_financa" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @compras_financa.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy       #
    @compras_financa = ComprasFinanca.find(params[:id])
    @compras_financa.destroy

    respond_to do |format|
      format.html { redirect_to "/compras/#{@compras_financa.compra_id}/compras_financa" }
      format.xml  { head :ok }
    end
  end
end
