class ProdutosTamanhosController < ApplicationController
  # GET /produtos_tamanhos
  # GET /produtos_tamanhos.json
  def index
    @produtos_tamanhos = ProdutosTamanho.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @produtos_tamanhos }
    end
  end

  # GET /produtos_tamanhos/1
  # GET /produtos_tamanhos/1.json
  def show
    @produtos_tamanho = ProdutosTamanho.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @produtos_tamanho }
    end
  end

  # GET /produtos_tamanhos/new
  # GET /produtos_tamanhos/new.json
  def new
    @produtos_tamanho = ProdutosTamanho.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @produtos_tamanho }
    end
  end

  # GET /produtos_tamanhos/1/edit
  def edit
    @produtos_tamanho = ProdutosTamanho.find(params[:id])
  end

  # POST /produtos_tamanhos
  # POST /produtos_tamanhos.json
  def create
    @produtos_tamanho = ProdutosTamanho.new(params[:produtos_tamanho])

    respond_to do |format|
      if @produtos_tamanho.save
        format.html { redirect_to @produtos_tamanho, notice: 'Produtos tamanho was successfully created.' }
        format.json { render json: @produtos_tamanho, status: :created, location: @produtos_tamanho }
      else
        format.html { render action: "new" }
        format.json { render json: @produtos_tamanho.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /produtos_tamanhos/1
  # PUT /produtos_tamanhos/1.json
  def update
    @produtos_tamanho = ProdutosTamanho.find(params[:id])

    respond_to do |format|
      if @produtos_tamanho.update_attributes(params[:produtos_tamanho])
        format.html { redirect_to @produtos_tamanho, notice: 'Produtos tamanho was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @produtos_tamanho.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produtos_tamanhos/1
  # DELETE /produtos_tamanhos/1.json
  def destroy
    @produtos_tamanho = ProdutosTamanho.find(params[:id])
    ProdutosGrade.destroy_all("produto_id = #{@produtos_tamanho.produto_id} and tamanho_id = #{@produtos_tamanho.tamanho_id}")
    @produtos_tamanho.destroy

    respond_to do |format|
      format.html { redirect_to "/produtos/#{@produtos_tamanho.produto_id}" }
      format.json { head :no_content }
    end
  end
end
