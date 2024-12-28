class PlanoVendaDocsController < ApplicationController
  # GET /plano_venda_docs
  # GET /plano_venda_docs.json
  def index
    @plano_venda_docs = PlanoVendaDoc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plano_venda_docs }
    end
  end

  # GET /plano_venda_docs/1
  # GET /plano_venda_docs/1.json
  def show
    @plano_venda_doc = PlanoVendaDoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plano_venda_doc }
    end
  end

  # GET /plano_venda_docs/new
  # GET /plano_venda_docs/new.json
  def new
    @plano_venda_doc = PlanoVendaDoc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plano_venda_doc }
    end
  end

  # GET /plano_venda_docs/1/edit
  def edit
    @plano_venda_doc = PlanoVendaDoc.find(params[:id])
  end

  # POST /plano_venda_docs
  # POST /plano_venda_docs.json
  def create
    @plano_venda_doc = PlanoVendaDoc.new(params[:plano_venda_doc])

    respond_to do |format|
      if @plano_venda_doc.save
        format.html { redirect_to plano_venda_path(@plano_venda_doc.plano_venda_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /plano_venda_docs/1
  # PUT /plano_venda_docs/1.json
  def update
    @plano_venda_doc = PlanoVendaDoc.find(params[:id])

    respond_to do |format|
      if @plano_venda_doc.update_attributes(params[:plano_venda_doc])
        format.html { redirect_to plano_venda_path(@plano_venda_doc.plano_venda_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /plano_venda_docs/1
  # DELETE /plano_venda_docs/1.json
  def destroy
    @plano_venda_doc = PlanoVendaDoc.find(params[:id])
    @plano_venda_doc.destroy

    respond_to do |format|
      format.html { redirect_to plano_venda_path(@plano_venda_doc.plano_venda_id) }
    end
  end
end
