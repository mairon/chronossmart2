class ConsumicaoInternasController < ApplicationController
  before_filter :authenticate

  def busca
    params[:unidade] = current_unidade.id
    params[:usuario_id] = current_user.id
    @consumicao_internas = ConsumicaoInterna.filtro_busca(params)
    render :layout => false    
  end
  
  def index
    @consumicao_internas = ConsumicaoInterna.where("unidade_id = #{current_unidade.id}").order('data desc, id desc')
    @consumicao_interna = ConsumicaoInterna.new

  end

  def show
    @consumicao_interna = ConsumicaoInterna.find(params[:id])

    render layout: 'chart'
  end

  def comprovante
    @consumicao_interna = ConsumicaoInterna.find(params[:id])
    @consumicao_interna_produtos = ConsumicaoInternaProduto.where("consumicao_interna_id = #{@consumicao_interna.id}").order('id')

    render :layout => false
  end


  def new

    @consumicao_interna = ConsumicaoInterna.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consumicao_interna }
    end
  end

  def edit
    @consumicao_interna = ConsumicaoInterna.find(params[:id])
  end

  def create
    @consumicao_interna = ConsumicaoInterna.new(params[:consumicao_interna])
    @consumicao_interna.unidade_id = current_unidade.id.to_i
    @consumicao_interna.usuario_created = current_user.id
    @consumicao_interna..unidade_created = current_unidade.id


    respond_to do |format|
      if @consumicao_interna.save
        format.html { redirect_to(@consumicao_interna) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @consumicao_interna = ConsumicaoInterna.find(params[:id])
    @consumicao_interna.usuario_created = current_user.id
    @consumicao_interna..unidade_created = current_unidade.id

    respond_to do |format|
      if @consumicao_interna.update_attributes(params[:consumicao_interna])
        format.html { redirect_to(@consumicao_interna) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @consumicao_interna = ConsumicaoInterna.find(params[:id])
    @consumicao_interna.destroy

    respond_to do |format|
      format.html { redirect_to(consumicao_internas_url) }
    end
  end

  def dynamic_consumicao_colecao
    @personas = Colecao.find_all_by_sub_grupo_id(params[:id])
    respond_to do |format|
      format.js
    end
  end

end
