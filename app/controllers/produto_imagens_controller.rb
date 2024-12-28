class ProdutoImagensController < ApplicationController
  # GET /produto_imagens
  # GET /produto_imagens.json
  def index
    @produto_imagens = ProdutoImagen.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @produto_imagens }
    end
  end

  # GET /produto_imagens/1
  # GET /produto_imagens/1.json
  def show
    @produto_imagen = ProdutoImagen.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @produto_imagen }
    end
  end

  # GET /produto_imagens/new
  # GET /produto_imagens/new.json
  def new
    @produto_imagen = ProdutoImagen.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @produto_imagen }
    end
  end

  # GET /produto_imagens/1/edit
  def edit
    @produto_imagen = ProdutoImagen.find(params[:id])
  end

  # POST /produto_imagens
  # POST /produto_imagens.json
  def create
    @produto_imagen = ProdutoImagen.new(params[:produto_imagen])

    respond_to do |format|
      if @produto_imagen.save
        format.html { redirect_to galeria_produto_path(@produto_imagen.produto_id) }
      else
        format.html { render action: "new" }
        format.json { render json: @produto_imagen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /produto_imagens/1
  # PUT /produto_imagens/1.json
  def update
    @produto_imagen = ProdutoImagen.find(params[:id])

    respond_to do |format|
      if @produto_imagen.update_attributes(params[:produto_imagen])
        format.html { redirect_to galeria_produto_path(@produto_imagen.produto_id) }
      else
        format.html { render action: "edit" }
        format.json { render json: @produto_imagen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produto_imagens/1
  # DELETE /produto_imagens/1.json
  def destroy
    @produto_imagen = ProdutoImagen.find(params[:id])
    @produto_imagen.destroy

    respond_to do |format|
      format.html { redirect_to galeria_produto_path(@produto_imagen.produto_id) }
      format.json { head :no_content }
    end
  end
end
