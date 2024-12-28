class MoedasController < ApplicationController
  before_filter :authenticate
  def index
    @moedas = Moeda.paginate(:page => params[:page], :per_page => 20).order('data desc')
  end

  def show
    @moeda = Moeda.find(params[:id])
  end

  def new
    @moeda = Moeda.new
  end

  def edit
    @moeda = Moeda.find(params[:id])
  end

  def create
    @moeda = Moeda.new(params[:moeda])
    @moeda.usuario_created = current_user.usuario_nome
    @moeda.unidade_created = current_unidade.unidade_nome

    respond_to do |format|
        if @moeda.save
            format.html { redirect_to(moedas_url) }
        else
            format.html { render :action => "new" }
        end
    end
  end

  def update
    @moeda = Moeda.find(params[:id])
    @moeda.usuario_updated = current_user.usuario_nome
    @moeda.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @moeda.update_attributes(params[:moeda])
        format.html { redirect_to(moedas_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @moeda = Moeda.find(params[:id])
    @moeda.destroy

    respond_to do |format|
      format.html { redirect_to(moedas_url) }
    end
  end
end
