class NotaCreditosDetalhesController < ApplicationController
before_filter :authenticate

  def index
    @nota_creditos_detalhes = NotaCreditosDetalhe.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nota_creditos_detalhes }
    end
  end

  def show
    @nota_creditos_detalhe = NotaCreditosDetalhe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nota_creditos_detalhe }
    end
  end

  def new
    @nota_creditos_detalhe = NotaCreditosDetalhe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nota_creditos_detalhe }
    end
  end

  def edit
    @nota_creditos_detalhe = NotaCreditosDetalhe.find(params[:id])
  end

  def create
    @nota_creditos_detalhe = NotaCreditosDetalhe.new(params[:nota_creditos_detalhe])
    @nota_creditos_detalhe.usuario_created = current_user.usuario_nome
    @nota_creditos_detalhe.unidade_created = current_unidade.unidade_nome

    respond_to do |format|
      if @nota_creditos_detalhe.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to "/nota_creditos/#{@nota_creditos_detalhe.nota_credito_id}" }
        format.xml  { render :xml => @nota_creditos_detalhe, :status => :created, :location => @nota_creditos_detalhe }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nota_creditos_detalhe.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @nota_creditos_detalhe = NotaCreditosDetalhe.find(params[:id])
    @nota_creditos_detalhe.usuario_updated = current_user.usuario_nome
    @nota_creditos_detalhe.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @nota_creditos_detalhe.update_attributes(params[:nota_creditos_detalhe])


        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to "/nota_creditos/#{@nota_creditos_detalhe.nota_credito_id}" }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @nota_creditos_detalhe = NotaCreditosDetalhe.find(params[:id])
    @nota_creditos_detalhe.destroy
    

    respond_to do |format|
        format.html { redirect_to "/nota_creditos/#{@nota_creditos_detalhe.nota_credito_id}" }
      format.xml  { head :ok }
    end
  end
end
