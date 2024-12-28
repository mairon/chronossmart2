class RetencaoDocsController < ApplicationController
  # GET /retencao_docs
  # GET /retencao_docs.json
  def index
    @retencao_docs = RetencaoDoc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @retencao_docs }
    end
  end

  # GET /retencao_docs/1
  # GET /retencao_docs/1.json
  def show
    @retencao_doc = RetencaoDoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @retencao_doc }
    end
  end

  # GET /retencao_docs/new
  # GET /retencao_docs/new.json
  def new
    @retencao_doc = RetencaoDoc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @retencao_doc }
    end
  end

  # GET /retencao_docs/1/edit
  def edit
    @retencao_doc = RetencaoDoc.find(params[:id])
  end

  # POST /retencao_docs
  # POST /retencao_docs.json
  def create
    @retencao_doc = RetencaoDoc.new(params[:retencao_doc])

    respond_to do |format|
      if @retencao_doc.save
        format.html { redirect_to "/retencaos/#{@retencao_doc.retencao_id}" }
        format.json { render json: @retencao_doc, status: :created, location: @retencao_doc }
      else
        format.html { render action: "new" }
        format.json { render json: @retencao_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /retencao_docs/1
  # PUT /retencao_docs/1.json
  def update
    @retencao_doc = RetencaoDoc.find(params[:id])

    respond_to do |format|
      if @retencao_doc.update_attributes(params[:retencao_doc])
        format.html { redirect_to "/retencaos/#{@retencao_doc.retencao_id}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @retencao_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /retencao_docs/1
  # DELETE /retencao_docs/1.json
  def destroy
    @retencao_doc = RetencaoDoc.find(params[:id])
    @retencao_doc.destroy

    respond_to do |format|
      format.html { redirect_to "/retencaos/#{@retencao_doc.retencao_id}" }
      format.json { head :no_content }
    end
  end
end
