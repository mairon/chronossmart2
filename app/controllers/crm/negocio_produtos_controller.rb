class Crm::NegocioProdutosController  < Crm::CrmController

  def index
    @negocio_produtos = NegocioProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @negocio_produtos }
    end
  end

  # GET /negocio_produtos/1
  # GET /negocio_produtos/1.json
  def show
    @negocio_produto = NegocioProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @negocio_produto }
    end
  end

  # GET /negocio_produtos/new
  # GET /negocio_produtos/new.json
  def new
    @negocio_produto = NegocioProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @negocio_produto }
    end
  end

  # GET /negocio_produtos/1/edit
  def edit
    @negocio_produto = NegocioProduto.find(params[:id])
    @negocio = Negocio.find(@negocio_produto.negocio_id)
  end

  # POST /negocio_produtos
  # POST /negocio_produtos.json
  def create
    @negocio_produto = NegocioProduto.new(params[:negocio_produto])

    respond_to do |format|
      if @negocio_produto.save
        format.html { redirect_to crm_negocio_path(@negocio_produto.negocio_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /negocio_produtos/1
  # PUT /negocio_produtos/1.json
  def update
    @negocio_produto = NegocioProduto.find(params[:id])

    respond_to do |format|
      if @negocio_produto.update_attributes(params[:negocio_produto])
        format.html { redirect_to crm_negocio_path(@negocio_produto.negocio_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /negocio_produtos/1
  # DELETE /negocio_produtos/1.json
  def destroy
    @negocio_produto = NegocioProduto.find(params[:id])
    @negocio_produto.destroy

    respond_to do |format|
      format.html { redirect_to crm_negocio_path(@negocio_produto.negocio_id) }
      format.json { head :no_content }
    end
  end
end
