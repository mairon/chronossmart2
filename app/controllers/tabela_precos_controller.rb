class TabelaPrecosController < ApplicationController

  def gera_tabela_produtos
    @tabela_preco = TabelaPreco.find(params[:id])

    pd = Produto.all
    un = Unidade.where(id: 4)
    un.each do |u|
      pd.each do |p|
          ProdutosTabelaPreco.create( :produto_id       => p.id,
                                      :unidade_id       => u.id,
                                      :tabela_preco_id  => @tabela_preco.id
                                 )

      end
    end

    flash[:notice] = 'Table Add com sucesso!'
    respond_to do |format|
      format.html { redirect_to tabela_precos_url }
      format.json { head :no_content }
    end

  end
  
  def index
    @tabela_precos = TabelaPreco.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tabela_precos }
    end
  end

  # GET /tabela_precos/1
  # GET /tabela_precos/1.json
  def show
    @tabela_preco = TabelaPreco.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tabela_preco }
    end
  end

  # GET /tabela_precos/new
  # GET /tabela_precos/new.json
  def new
    @tabela_preco = TabelaPreco.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tabela_preco }
    end
  end

  # GET /tabela_precos/1/edit
  def edit
    @tabela_preco = TabelaPreco.find(params[:id])
  end

  # POST /tabela_precos
  # POST /tabela_precos.json
  def create
    @tabela_preco = TabelaPreco.new(params[:tabela_preco])

    respond_to do |format|
      if @tabela_preco.save
        format.html { redirect_to tabela_precos_url }
        format.json { render json: @tabela_preco, status: :created, location: @tabela_preco }
      else
        format.html { render action: "new" }
        format.json { render json: @tabela_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tabela_precos/1
  # PUT /tabela_precos/1.json
  def update
    @tabela_preco = TabelaPreco.find(params[:id])

    respond_to do |format|
      if @tabela_preco.update_attributes(params[:tabela_preco])
        format.html { redirect_to tabela_precos_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tabela_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tabela_precos/1
  # DELETE /tabela_precos/1.json
  def destroy
    @tabela_preco = TabelaPreco.find(params[:id])
    @tabela_preco.destroy

    respond_to do |format|
      format.html { redirect_to tabela_precos_url }
      format.json { head :no_content }
    end
  end
end
