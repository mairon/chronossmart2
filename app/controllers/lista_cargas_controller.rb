class ListaCargasController < ApplicationController

  def detalhe_pedido
    @pedido = Presupuesto.find(params[:pedido])
    render layout: 'consulta'
  end


  def produtos_adicionados
    @lista_carga = ListaCarga.find(params[:id])
    @pedido = Presupuesto.find(params[:pedido])
    @lista_carga_produtos = ListaCargaProduto.where(lista_carga_id: @lista_carga.id, presupuesto_id: params[:pedido])
    render layout: 'consulta'
  end

  def rota
    @lista_carga = ListaCarga.find(params[:id])
    params[:lista_carga_id] = @lista_carga.id
    @lista_produtos = ListaCarga.rota(params)
    render layout: false
  end


  def separacao
    @lista_carga = ListaCarga.find(params[:id])
    @pedido = Presupuesto.find(params[:pedido])
    @lista_carga_produtos = ListaCargaProduto.where(lista_carga_id: @lista_carga.id, presupuesto_id: params[:pedido])
    render layout: false
  end

  def add_produtos
    @lista_carga = ListaCarga.find(params[:id])
    ListaCargaProduto.create(params[:products].values)

    redirect_to(lista_carga_path(@lista_carga))
  end

  def index
    @lista_cargas = ListaCarga.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lista_cargas }
    end
  end

  def show
    @lista_carga = ListaCarga.find(params[:id])
    @lista_carga_adds = ListaCarga.lista_carga_add(params)
    params[:unidade_id] = current_unidade.id
    @pedido = Presupuesto.find(params[:presupuesto_id]) if params[:presupuesto_id].present?
    @pedidos_pendentes = ListaCarga.pedido_pendentes(params)
    @pedido_produtos = ListaCarga.pedido_produtos(params) if params[:presupuesto_id].present?

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /lista_cargas/new
  # GET /lista_cargas/new.json
  def new
    @lista_carga = ListaCarga.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lista_carga }
    end
  end

  # GET /lista_cargas/1/edit
  def edit
    @lista_carga = ListaCarga.find(params[:id])
  end

  # POST /lista_cargas
  # POST /lista_cargas.json
  def create
    @lista_carga = ListaCarga.new(params[:lista_carga])

    respond_to do |format|
      if @lista_carga.save
        format.html { redirect_to lista_carga_path(@lista_carga) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /lista_cargas/1
  # PUT /lista_cargas/1.json
  def update
    @lista_carga = ListaCarga.find(params[:id])

    respond_to do |format|
      if @lista_carga.update_attributes(params[:lista_carga])
        format.html { redirect_to lista_carga_path(@lista_carga) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /lista_cargas/1
  # DELETE /lista_cargas/1.json
  def destroy
    @lista_carga = ListaCarga.find(params[:id])
    @lista_carga.destroy

    respond_to do |format|
      format.html { redirect_to lista_cargas_url }
    end
  end
end
