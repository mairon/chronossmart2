class MetaDetalhesController < ApplicationController
  # GET /meta_detalhes
  # GET /meta_detalhes.json
  def index
    @meta_detalhes = MetaDetalhe.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meta_detalhes }
    end
  end

  # GET /meta_detalhes/1
  # GET /meta_detalhes/1.json
  def show
    @meta_detalhe = MetaDetalhe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meta_detalhe }
    end
  end

  # GET /meta_detalhes/new
  # GET /meta_detalhes/new.json
  def new
    @meta_detalhe = MetaDetalhe.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meta_detalhe }
    end
  end

  # GET /meta_detalhes/1/edit
  def edit
    @meta_detalhe = MetaDetalhe.find(params[:id])
  end

  # POST /meta_detalhes
  # POST /meta_detalhes.json
  def create
    @meta_detalhe = MetaDetalhe.new(params[:meta_detalhe])

    respond_to do |format|
      if @meta_detalhe.save
      format.html { redirect_to "/metas/#{@meta_detalhe.meta_id}"}
      else
      format.html { redirect_to "/metas/#{@meta_detalhe.meta_id}"}
      end
    end
  end

  # PUT /meta_detalhes/1
  # PUT /meta_detalhes/1.json
  def update
    @meta_detalhe = MetaDetalhe.find(params[:id])

    respond_to do |format|
      if @meta_detalhe.update_attributes(params[:meta_detalhe])
      format.html { redirect_to "/metas/#{@meta_detalhe.meta_id}"}
      format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @meta_detalhe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meta_detalhes/1
  # DELETE /meta_detalhes/1.json
  def destroy
    @meta_detalhe = MetaDetalhe.find(params[:id])
    @meta_detalhe.destroy

    respond_to do |format|
      format.html { redirect_to "/metas/#{@meta_detalhe.meta_id}"}
      format.json { head :no_content }
    end
  end
end
