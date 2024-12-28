class SubGrupoPrecosController < ApplicationController
  # GET /sub_grupo_precos
  # GET /sub_grupo_precos.json
  def index
    @sub_grupo_precos = SubGrupoPreco.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sub_grupo_precos }
    end
  end

  # GET /sub_grupo_precos/1
  # GET /sub_grupo_precos/1.json
  def show
    @sub_grupo_preco = SubGrupoPreco.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sub_grupo_preco }
    end
  end

  # GET /sub_grupo_precos/new
  # GET /sub_grupo_precos/new.json
  def new
    @sub_grupo_preco = SubGrupoPreco.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sub_grupo_preco }
    end
  end

  # GET /sub_grupo_precos/1/edit
  def edit
    @sub_grupo_preco = SubGrupoPreco.find(params[:id])
  end

  # POST /sub_grupo_precos
  # POST /sub_grupo_precos.json
  def create
    @sub_grupo_preco = SubGrupoPreco.new(params[:sub_grupo_preco])

    respond_to do |format|
      if @sub_grupo_preco.save
        format.html { redirect_to "/sub_grupos/#{@sub_grupo_preco.sub_grupo_id}"}
        format.json { render json: @sub_grupo_preco, status: :created, location: @sub_grupo_preco }
      else
        format.html { render action: "new" }
        format.json { render json: @sub_grupo_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sub_grupo_precos/1
  # PUT /sub_grupo_precos/1.json
  def update
    @sub_grupo_preco = SubGrupoPreco.find(params[:id])

    respond_to do |format|
      if @sub_grupo_preco.update_attributes(params[:sub_grupo_preco])
        format.html { redirect_to "/sub_grupos/#{@sub_grupo_preco.sub_grupo_id}"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sub_grupo_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_grupo_precos/1
  # DELETE /sub_grupo_precos/1.json
  def destroy
    @sub_grupo_preco = SubGrupoPreco.find(params[:id])
    @sub_grupo_preco.destroy

    respond_to do |format|
      format.html { redirect_to "/sub_grupos/#{@sub_grupo_preco.sub_grupo_id}"}
      format.json { head :no_content }
    end
  end
end
