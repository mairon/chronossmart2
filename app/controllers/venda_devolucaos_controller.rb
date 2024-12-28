class VendaDevolucaosController < ApplicationController

  def busca_vendas

    params[:unidade] = current_unidade.id
    params[:finalidade] = "VENTA"
    params[:processo]   = "venda-finalizada"
    @vendas = Venda.filtro_vendas(params)
    respond_to do |format|
        format.html { render :layout => false}
        format.js { render :layout => false }
    end
  end

  def index

    @venda_devolucaos = Cliente.where(tabela: 'VENDAS_DEVOLUCAOS').order("data desc")

    render layout: 'chart'
  end

  # GET /venda_devolucaos/1
  # GET /venda_devolucaos/1.json
  def show
    @venda_devolucao = VendaDevolucao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @venda_devolucao }
    end
  end

  # GET /venda_devolucaos/new
  # GET /venda_devolucaos/new.json
  def new
    @venda_devolucao = VendaDevolucao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venda_devolucao }
    end
  end

  # GET /venda_devolucaos/1/edit
  def edit
    @venda_devolucao = VendaDevolucao.find(params[:id])
  end

  # POST /venda_devolucaos
  # POST /venda_devolucaos.json
  def create
    @venda_devolucao = VendaDevolucao.new(params[:venda_devolucao])

    respond_to do |format|
      if @venda_devolucao.save
        format.html { redirect_to devolucaos_venda_path(@venda_devolucao.venda_id)  }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /venda_devolucaos/1
  # PUT /venda_devolucaos/1.json
  def update
    @venda_devolucao = VendaDevolucao.find(params[:id])

    respond_to do |format|
      if @venda_devolucao.update_attributes(params[:venda_devolucao])
        format.html { redirect_to devolucaos_venda_path(@venda_devolucao.venda_id)  }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /venda_devolucaos/1
  # DELETE /venda_devolucaos/1.json
  def destroy
    @venda_devolucao = VendaDevolucao.find(params[:id])
    @venda_devolucao.destroy

    respond_to do |format|
      format.html { redirect_to devolucaos_venda_path(@venda_devolucao.venda_id)  }
    end
  end
end
