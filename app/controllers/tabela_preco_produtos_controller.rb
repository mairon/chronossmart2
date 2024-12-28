class TabelaPrecoProdutosController < ApplicationController
  # GET /tabela_preco_produtos
  # GET /tabela_preco_produtos.xml
  def index
    @tabela_preco_produtos = TabelaPrecoProduto.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tabela_preco_produtos }
    end
  end

  # GET /tabela_preco_produtos/1
  # GET /tabela_preco_produtos/1.xml
  def show
    @tabela_preco_produto = TabelaPrecoProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tabela_preco_produto }
    end
  end

  # GET /tabela_preco_produtos/new
  # GET /tabela_preco_produtos/new.xml
  def new
    @tabela_preco_produto = TabelaPrecoProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tabela_preco_produto }
    end
  end

  # GET /tabela_preco_produtos/1/edit
  def edit
    @tabela_preco_produto = TabelaPrecoProduto.find(params[:id])
  end

  # POST /tabela_preco_produtos
  # POST /tabela_preco_produtos.xml
  def create
    @tabela_preco_produto = TabelaPrecoProduto.new(params[:tabela_preco_produto])

    respond_to do |format|
      if @tabela_preco_produto.save
        flash[:notice] = 'TabelaPrecoProduto was successfully created.'
        format.html { redirect_to(@tabela_preco_produto) }
        format.xml  { render :xml => @tabela_preco_produto, :status => :created, :location => @tabela_preco_produto }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tabela_preco_produto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tabela_preco_produtos/1
  # PUT /tabela_preco_produtos/1.xml
  def update
    @tabela_preco_produto = TabelaPrecoProduto.find(params[:id])

    respond_to do |format|
      if @tabela_preco_produto.update_attributes(params[:tabela_preco_produto])
        flash[:notice] = 'TabelaPrecoProduto was successfully updated.'
        format.html { redirect_to(@tabela_preco_produto) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tabela_preco_produto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tabela_preco_produtos/1
  # DELETE /tabela_preco_produtos/1.xml
  def destroy
    @tabela_preco_produto = TabelaPrecoProduto.find(params[:id])
    @tabela_preco_produto.destroy

    respond_to do |format|
      format.html { redirect_to(tabela_preco_produtos_url) }
      format.xml  { head :ok }
    end
  end
end
