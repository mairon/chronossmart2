class ProdutoComposicaosController < ApplicationController
  # GET /produto_composicaos
  # GET /produto_composicaos.xml
  def index
    @produto_composicaos = ProdutoComposicao.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @produto_composicaos }
    end
  end

  # GET /produto_composicaos/1
  # GET /produto_composicaos/1.xml
  def show
    @produto_composicao = ProdutoComposicao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @produto_composicao }
    end
  end

  # GET /produto_composicaos/new
  # GET /produto_composicaos/new.xml
  def new
    @produto_composicao = ProdutoComposicao.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @produto_composicao }
    end
  end

  # GET /produto_composicaos/1/edit
  def edit
    @produto_composicao = ProdutoComposicao.find(params[:id])
  end

  # POST /produto_composicaos
  # POST /produto_composicaos.xml
  def create
    @produto_composicao = ProdutoComposicao.new(params[:produto_composicao])

    respond_to do |format|
      if @produto_composicao.save
        format.html { redirect_to "/produtos/#{@produto_composicao.produto_id}/composicao" }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @produto_composicao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /produto_composicaos/1
  # PUT /produto_composicaos/1.xml
  def update
    @produto_composicao = ProdutoComposicao.find(params[:id])

    respond_to do |format|
      if @produto_composicao.update_attributes(params[:produto_composicao])
        format.html { redirect_to "/produtos/#{@produto_composicao.produto_id}/composicao" }

        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @produto_composicao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /produto_composicaos/1
  # DELETE /produto_composicaos/1.xml
  def destroy
    @produto_composicao = ProdutoComposicao.find(params[:id])
    @produto_composicao.destroy

    respond_to do |format|
        format.html { redirect_to "/produtos/#{@produto_composicao.produto_id}/composicao" }
      format.xml  { head :ok }
    end
  end
end
