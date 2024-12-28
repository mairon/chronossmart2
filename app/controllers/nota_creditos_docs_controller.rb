class NotaCreditosDocsController < ApplicationController
  # GET /nota_creditos_docs
  # GET /nota_creditos_docs.xml
  def index
    @nota_creditos_docs = NotaCreditosDoc.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nota_creditos_docs }
    end
  end

  # GET /nota_creditos_docs/1
  # GET /nota_creditos_docs/1.xml
  def show
    @nota_creditos_doc = NotaCreditosDoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nota_creditos_doc }
    end
  end

  # GET /nota_creditos_docs/new
  # GET /nota_creditos_docs/new.xml
  def new
    @nota_creditos_doc = NotaCreditosDoc.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nota_creditos_doc }
    end
  end

  # GET /nota_creditos_docs/1/edit
  def edit
    @nota_creditos_doc = NotaCreditosDoc.find(params[:id])
  end

  # POST /nota_creditos_docs
  # POST /nota_creditos_docs.xml
  def create
    @nota_creditos_doc = NotaCreditosDoc.new(params[:nota_creditos_doc])

    respond_to do |format|
      if @nota_creditos_doc.save
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to "/nota_creditos/#{@nota_creditos_doc.nota_credito_id}/documentos" }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nota_creditos_doc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nota_creditos_docs/1
  # PUT /nota_creditos_docs/1.xml
  def update
    @nota_creditos_doc = NotaCreditosDoc.find(params[:id])

    respond_to do |format|
      if @nota_creditos_doc.update_attributes(params[:nota_creditos_doc])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to "/nota_creditos/#{@nota_creditos_doc.nota_credito_id}/documentos" }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nota_creditos_doc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nota_creditos_docs/1
  # DELETE /nota_creditos_docs/1.xml
  def destroy
    @nota_creditos_doc = NotaCreditosDoc.find(params[:id])
    @nota_creditos_doc.destroy

    respond_to do |format|
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to "/nota_creditos/#{@nota_creditos_doc.nota_credito_id}/documentos" }
      format.xml  { head :ok }
    end
  end
end
