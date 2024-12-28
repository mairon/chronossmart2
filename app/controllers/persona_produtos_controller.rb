class PersonaProdutosController < ApplicationController
  # GET /persona_produtos
  # GET /persona_produtos.json
  def index
    @persona_produtos = PersonaProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_produtos }
    end
  end

  # GET /persona_produtos/1
  # GET /persona_produtos/1.json
  def show
    @persona_produto = PersonaProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_produto }
    end
  end

  # GET /persona_produtos/new
  # GET /persona_produtos/new.json
  def new
    @persona_produto = PersonaProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_produto }
    end
  end

  # GET /persona_produtos/1/edit
  def edit
    @persona_produto = PersonaProduto.find(params[:id])
  end

  # POST /persona_produtos
  # POST /persona_produtos.json
  def create
    @persona_produto = PersonaProduto.new(params[:persona_produto])

    respond_to do |format|
      if @persona_produto.save
        format.html { redirect_to "/personas/#{@persona_produto.persona_id}/descontos" }
        format.json { render json: @persona_produto, status: :created, location: @persona_produto }
      else
        format.html { render action: "new" }
        format.json { render json: @persona_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /persona_produtos/1
  # PUT /persona_produtos/1.json
  def update
    @persona_produto = PersonaProduto.find(params[:id])

    respond_to do |format|
      if @persona_produto.update_attributes(params[:persona_produto])
        format.html { redirect_to "/personas/#{@persona_produto.persona_id}/descontos" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /persona_produtos/1
  # DELETE /persona_produtos/1.json
  def destroy
    @persona_produto = PersonaProduto.find(params[:id])
    @persona_produto.destroy

    respond_to do |format|
      format.html { redirect_to "/personas/#{@persona_produto.persona_id}/descontos" }
      format.json { head :no_content }
    end
  end
end
