class PagaresDetalhesController < ApplicationController
  before_filter :authenticate

  def index
    @pagares_detalhes = PagaresDetalhe.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pagares_detalhes }
    end
  end

  def show
    @pagares_detalhe = PagaresDetalhe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pagares_detalhe }
    end
  end

  def new
    @pagares_detalhe = PagaresDetalhe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pagares_detalhe }
    end
  end

  def edit
    @pagares_detalhe = PagaresDetalhe.find(params[:id])
  end

  def create
    @pagares_detalhe = PagaresDetalhe.new(params[:pagares_detalhe])

    respond_to do |format|
      if @pagares_detalhe.save
        format.html { redirect_to(@pagares_detalhe, :notice => 'PagaresDetalhe was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @pagares_detalhe = PagaresDetalhe.find(params[:id])

    respond_to do |format|
      if @pagares_detalhe.update_attributes(params[:pagares_detalhe])
        format.html { redirect_to('/pagares/' << @pagares_detalhe.pagare_id.to_s, :notice => t('SUCESSFUL_EDIT_MESSAGE')) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @pagares_detalhe = PagaresDetalhe.find(params[:id])
    @pagares_detalhe.destroy

    respond_to do |format|
      format.html { redirect_to(pagares_detalhes_url) }
    end
  end
end
