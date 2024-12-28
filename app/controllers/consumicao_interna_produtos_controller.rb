class ConsumicaoInternaProdutosController < ApplicationController
  def index
    @consumicao_interna_produtos = ConsumicaoInternaProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consumicao_interna_produtos }
    end
  end

  def show
    @consumicao_interna_produto = ConsumicaoInternaProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consumicao_interna_produto }
    end
  end

  def new

    @consumicao_interna = ConsumicaoInterna.find(params[:id])

    @consumicao_interna_produto = ConsumicaoInternaProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consumicao_interna_produto }
    end
  end

  def edit
    @consumicao_interna = ConsumicaoInterna.find(params[:id])

    @consumicao_interna_produto = ConsumicaoInternaProduto.find(params[:id])
  end

  def create

    @consumicao_interna = ConsumicaoInterna.find(params[:consumicao_interna_id])

    @consumicao_interna_produto = @consumicao_interna.consumicao_interna_produtos.build(params[:consumicao_interna_produto])

    respond_to do |format|
      if @consumicao_interna_produto.save
        format.html { redirect_to consumicao_interna_path(@consumicao_interna) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @consumicao_interna = ConsumicaoInterna.find(params[:consumicao_interna_id])

    @consumicao_interna_produto = ConsumicaoInternaProduto.find(params[:id])

    respond_to do |format|
      if @consumicao_interna_produto.update_attributes(params[:consumicao_interna_produto])
        format.html { redirect_to consumicao_interna_path(@consumicao_interna) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @consumicao_interna = ConsumicaoInterna.find(params[:consumicao_interna_id])

    @consumicao_interna_produto = ConsumicaoInternaProduto.find(params[:id])
    @consumicao_interna_produto.destroy

    respond_to do |format|
      format.html { redirect_to consumicao_interna_path(@consumicao_interna) }
    end
  end
end
