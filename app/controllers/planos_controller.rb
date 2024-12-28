class PlanosController < ApplicationController
  before_filter :authenticate

  def index
    @planos = Plano.select('id,condicao,pdv').order('id')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @planos }
    end
  end

  def show
    @plano = Plano.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @plano }
    end
  end

  def new
    @plano = Plano.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @plano }
    end
  end

  def edit
    @plano = Plano.find(params[:id])
  end

  def create
    @plano = Plano.new(params[:plano])

    respond_to do |format|
      if @plano.save
      format.html { redirect_to(plano_path(@plano)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @plano = Plano.find(params[:id])

    respond_to do |format|
      if @plano.update_attributes(params[:plano])
      format.html { redirect_to(plano_path(@plano)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @plano = Plano.find(params[:id])
    @plano.destroy

    respond_to do |format|
      format.html { redirect_to(planos_url) }
    end
  end
end
