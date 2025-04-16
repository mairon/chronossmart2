class DevChequeClientesController < ApplicationController
  def dynamic_motivo_dev_cheque
    m =  MotivosDevCheque.find_by_id(params[:id], :select => 'deb_cli_prov')
    return render :text => m.deb_cli_prov

  end
  def add_cheque
    @dev_cheque_cliente = DevChequeCliente.find(params[:id])

    @cheques = Financa.find(params[:dev_cheque_cliente]["cheque_ids"])
      @cheques.each do |c|
        DevChequeClienteDt.create(  :dev_cheque_cliente_id => params[:id],
                                    :obs                   => @dev_cheque_cliente.obs,
                                    :data                  => @dev_cheque_cliente.data,
                                    :valor_us              => c.entrada_dolar,  
                                    :valor_gs              => c.entrada_guarani,
                                    :cheque                => c.cheque,
                                    :titula                => c.titular,
                                    :banco                 => c.banco   )
      end

    redirect_to(dev_cheque_cliente_path(@dev_cheque_cliente))
  end

  def index
    @dev_cheque_clientes = DevChequeCliente.where("unidade_id = #{current_unidade.id}").order('id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dev_cheque_clientes }
    end
  end

  # GET /dev_cheque_clientes/1
  # GET /dev_cheque_clientes/1.json
  def show
    @dev_cheque_cliente = DevChequeCliente.find(params[:id])
    @lista_cheque = DevChequeCliente.lista_cheques(@dev_cheque_cliente.persona_id,@dev_cheque_cliente.moeda,@dev_cheque_cliente.conta_id)
    @dev_dts = DevChequeClienteDt.where("dev_cheque_cliente_id = ?",@dev_cheque_cliente.id)
    
    render layout: 'chart'
  end

  def comprovante
    @dev_cheque_cliente = DevChequeCliente.find(params[:id])
    @dev_dts = DevChequeClienteDt.where("dev_cheque_cliente_id = ?",@dev_cheque_cliente.id)
    render layout: false
  end


  # GET /dev_cheque_clientes/new
  # GET /dev_cheque_clientes/new.json
  def new
    @dev_cheque_cliente = DevChequeCliente.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dev_cheque_cliente }
    end
  end

  # GET /dev_cheque_clientes/1/edit
  def edit
    @dev_cheque_cliente = DevChequeCliente.find(params[:id])
  end

  # POST /dev_cheque_clientes
  # POST /dev_cheque_clientes.json
  def create
    @dev_cheque_cliente = DevChequeCliente.new(params[:dev_cheque_cliente])

    respond_to do |format|
      @dev_cheque_cliente.usuario_created = current_user.id
      @dev_cheque_cliente.unidade_id = current_unidade.id

      if @dev_cheque_cliente.save
        format.html { redirect_to @dev_cheque_cliente, notice: 'Dev cheque cliente was successfully created.' }
        format.json { render json: @dev_cheque_cliente, status: :created, location: @dev_cheque_cliente }
      else
        format.html { render action: "new" }
        format.json { render json: @dev_cheque_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dev_cheque_clientes/1
  # PUT /dev_cheque_clientes/1.json
  def update
    @dev_cheque_cliente = DevChequeCliente.find(params[:id])

    respond_to do |format|
      if @dev_cheque_cliente.update_attributes(params[:dev_cheque_cliente])
        format.html { redirect_to @dev_cheque_cliente, notice: 'Dev cheque cliente was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dev_cheque_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dev_cheque_clientes/1
  # DELETE /dev_cheque_clientes/1.json
  def destroy
    @dev_cheque_cliente = DevChequeCliente.find(params[:id])
    @dev_cheque_cliente.destroy

    respond_to do |format|
      format.html { redirect_to dev_cheque_clientes_url }
      format.json { head :no_content }
    end
  end
end
