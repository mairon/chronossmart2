class PersonaTabelaDescsController < ApplicationController
  # GET /persona_tabela_descs
  # GET /persona_tabela_descs.json
  def index
    @persona_tabela_descs = PersonaTabelaDesc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_tabela_descs }
    end
  end

  # GET /persona_tabela_descs/1
  # GET /persona_tabela_descs/1.json
  def show
    @persona_tabela_desc = PersonaTabelaDesc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_tabela_desc }
    end
  end

  # GET /persona_tabela_descs/new
  # GET /persona_tabela_descs/new.json
  def new
    @persona_tabela_desc = PersonaTabelaDesc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_tabela_desc }
    end
  end

  # GET /persona_tabela_descs/1/edit
  def edit
    @persona_tabela_desc = PersonaTabelaDesc.find(params[:id])
  end

  # POST /persona_tabela_descs
  # POST /persona_tabela_descs.json
  def create
    @persona_tabela_desc = PersonaTabelaDesc.new(params[:persona_tabela_desc])

    respond_to do |format|
      if @persona_tabela_desc.save
        format.html { redirect_to persona_path(@persona_tabela_desc.persona_id) }
      else
        format.html { redirect_to persona_path(@persona_tabela_desc.persona_id) }
      end
    end
  end

  # PUT /persona_tabela_descs/1
  # PUT /persona_tabela_descs/1.json
  def update
    @persona_tabela_desc = PersonaTabelaDesc.find(params[:id])

    respond_to do |format|
      if @persona_tabela_desc.update_attributes(params[:persona_tabela_desc])
        format.html { redirect_to persona_path(@persona_tabela_desc.persona_id) }
      else
        format.html { redirect_to persona_path(@persona_tabela_desc.persona_id) }
      end
    end
  end

  # DELETE /persona_tabela_descs/1
  # DELETE /persona_tabela_descs/1.json
  def destroy
    @persona_tabela_desc = PersonaTabelaDesc.find(params[:id])
    @persona_tabela_desc.destroy

    respond_to do |format|
      format.html { redirect_to persona_path(@persona_tabela_desc.persona_id) }
      format.json { head :no_content }
    end
  end
end
