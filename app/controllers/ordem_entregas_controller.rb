class OrdemEntregasController < ApplicationController

  def modal_consulta
    render layout: false
  end

  def busca_consulta
    @ordem_entregas = OrdemEntrega.busca(params)
    render layout: false
  end

  def modal_endereco
    @ordem_entrega = OrdemEntrega.find(params[:id])
    @persona_locais_entregas = PersonaLocaisEntrega.where(persona_id: @ordem_entrega.persona_id)
    render layout: false
  end

  def add_produtos
    OrdemEntregaProduto.create(params[:products].values)

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.js {render text: "$('.modal-body-oe').load('#{modal_add_ordem_entregas_path(venda_id: params[:venda_id]) }');"}
    end

  end

  def modal_add
    @venda  = Venda.find(params[:venda_id])
    params[:presupuesto_id] = @venda.id
    params[:data] = @venda.data

    @ordem_entrega = OrdemEntrega.where(venda_id: @venda.id, status: 0).last

    unless @ordem_entrega.blank?
      @lista_entrega_produtos = OrdemEntregaProduto.where(ordem_entrega_id: @ordem_entrega.id)
    else
      @ordem_entrega = OrdemEntrega.create(venda_id: @venda.id, persona_id: @venda.persona_id, vendedor_id: @venda.vendedor_id, obs: "FC:|_|      CTROLE  ENTREGA:|_|      PEDIDO:|_|" )
      @lista_entrega_produtos = OrdemEntregaProduto.where(ordem_entrega_id: @ordem_entrega.id)
    end

    @pendente_entrega = OrdemEntrega.produtos_pendentes(params)

    render layout: false
  end

  def index
    @ordem_entregas = OrdemEntrega.includes(:rodado).includes(:persona).joins(:venda).where("exists (select 1 from ordem_entrega_produtos oep where oep.ordem_entrega_id = ordem_entregas.id ) and exists (select 1 from vendas_financas vf where vf.venda_id = vendas.id )").order("ordem_entregas.id")

    render layout: 'crm'
  end

  # GET /ordem_entregas/1
  # GET /ordem_entregas/1.json
  def show
    @ordem_entrega = OrdemEntrega.find(params[:id])

    render layout: 'chart'
  end

  # GET /ordem_entregas/new
  # GET /ordem_entregas/new.json
  def new
    @ordem_entrega = OrdemEntrega.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ordem_entrega }
    end
  end

  # GET /ordem_entregas/1/edit
  def edit
    @ordem_entrega = OrdemEntrega.find(params[:id])
  end

  # POST /ordem_entregas
  # POST /ordem_entregas.json
  def create
    @ordem_entrega = OrdemEntrega.new(params[:ordem_entrega])
    @ordem_entrega.obs = "FC:|_|      CTROLE  ENTREGA:|_|      PEDIDO:|_|"

    respond_to do |format|
      if @ordem_entrega.save
        format.html { redirect_to @ordem_entrega, notice: 'Ordem entrega was successfully created.' }
        format.json { render json: @ordem_entrega, status: :created, location: @ordem_entrega }
      else
        format.html { render action: "new" }
        format.json { render json: @ordem_entrega.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ordem_entregas/1
  # PUT /ordem_entregas/1.json
  def update
    @ordem_entrega = OrdemEntrega.find(params[:id])

    respond_to do |format|
      if @ordem_entrega.update_attributes(params[:ordem_entrega])
        format.html { redirect_to @ordem_entrega, notice: 'Ordem entrega was successfully updated.' }
        format.js {render text: "$('#ModalOrdemEntrega').modal('hide');"}
      else
        format.html { render action: "edit" }
        format.json { render json: @ordem_entrega.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ordem_entregas/1
  # DELETE /ordem_entregas/1.json
  def destroy
    @ordem_entrega = OrdemEntrega.find(params[:id])
    @ordem_entrega.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.json { head :no_content }
    end
  end
end
