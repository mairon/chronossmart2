class ComprasProdutosController < ApplicationController
    before_filter :authenticate

    def gerar_raterio
      ComprasProduto.update(params[:compras_produtos].keys, params[:compras_produtos].values)
      flash[:notice] = "Products updated"
      redirect_to "/compras/#{params[:id]}"
    end

    def index                  #
      @compras_produtos = ComprasProduto.where('deposito_id = 1 AND MOEDA = 2').order('produtos_grade_id,data,id')

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @compras_produtos }
      end
    end

    def show
      @compras_produto = ComprasProduto.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @compras_produto }
      end
    end

    def new
      @compras_produto = ComprasProduto.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @compras_produto }
      end
    end
    
    def edit
      @compras_produto = ComprasProduto.find(params[:id])
      @compra  = Compra.find(@compras_produto.compra_id)
    end

    def create
      @compras_produto = ComprasProduto.new(params[:compras_produto])
      respond_to do |format|
        if @compras_produto.save
          format.html { redirect_to "/compras/#{@compras_produto.compra_id}" }
        else
          format.html { render :action => "edit" }
        end
      end
    end

    def update                 #
      @compras_produto = ComprasProduto.find(params[:id])
      @compras_produto.usuario_updated = current_user.id
      @compras_produto.unidade_updated = current_unidade.id

      respond_to do |format|
        if @compras_produto.update_attributes(params[:compras_produto])
          format.html { redirect_to "/compras/#{@compras_produto.compra_id}" }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @compras_produto.errors, :status => :unprocessable_entity }
        end
      end
    end

    def destroy                #
      @compras_produto = ComprasProduto.find(params[:id])
      @compras_produto.destroy
      redirect_to "/compras/#{@compras_produto.compra_id}" 
        
    end

end
