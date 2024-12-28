class SubGruposController < ApplicationController
  def index
    @sub_grupos = SubGrupo.order("descricao")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sub_grupos }
    end
  end

  def update_individual
       SubGrupoPreco.update(params[:tabela_precos].keys, params[:tabela_precos].values)
        redirect_to sub_grupo_path(params[:id])
  end


  def show
    @sub_grupo       = SubGrupo.find(params[:id])
    @unidades_porces = SubGrupoPreco.where('sub_grupo_id = ? and unidade_id = ?', @sub_grupo.id, current_unidade.id)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sub_grupo }
    end
  end

  def new
    @sub_grupo = SubGrupo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sub_grupo }
    end
  end

  def edit
    @sub_grupo = SubGrupo.find(params[:id])
  end

  def create
    @sub_grupo = SubGrupo.new(params[:sub_grupo])

    respond_to do |format|
      if @sub_grupo.save
        format.html { redirect_to(sub_grupos_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @sub_grupo = SubGrupo.find(params[:id])

    respond_to do |format|
      if @sub_grupo.update_attributes(params[:sub_grupo])
        format.html { redirect_to(sub_grupos_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @sub_grupo = SubGrupo.find(params[:id])
    begin
    @sub_grupo.destroy
    flash[:notice] = t('SUCESSFUL_DELETION_MESSAGE')
    rescue ActiveRecord::DeleteRestrictionError => e
      @sub_grupo.errors.add(:base, e)
      flash[:error] = "No es possible remover lo cadastro porque elle possui  un vinculo con otro cadastro"
    ensure
      redirect_to(sub_grupos_url)
    end
  end
end
