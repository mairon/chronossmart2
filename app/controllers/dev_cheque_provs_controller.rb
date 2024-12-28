class DevChequeProvsController < ApplicationController
  def add_cheque
    @dev_cheque_prov = DevChequeProv.find(params[:id])

    @cheques = Financa.find(params[:dev_cheque_prov]["cheque_ids"])
      @cheques.each do |c|
        DevChequeProvDt.create(  :dev_cheque_prov_id => params[:id],
                                    :obs                   => @dev_cheque_prov.obs,
                                    :data                  => @dev_cheque_prov.data,
                                    :valor_us              => c.saida_dolar,  
                                    :valor_gs              => c.saida_guarani,
                                    :cheque                => c.cheque,
                                    :titula                => c.titular,
                                    :banco                 => c.banco   )
      end

    redirect_to(dev_cheque_prov_path(@dev_cheque_prov))
  end

  def index
    @dev_cheque_provs = DevChequeProv.where("unidade_id = #{current_unidade.id}").order('id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dev_cheque_clientes }
    end
  end

  # GET /dev_cheque_clientes/1
  # GET /dev_cheque_clientes/1.json
  def show
    @dev_cheque_prov = DevChequeProv.find(params[:id])
    @lista_cheque = DevChequeProv.lista_cheques(@dev_cheque_prov.persona_id,@dev_cheque_prov.moeda,@dev_cheque_prov.conta_id)
    @dev_dts = DevChequeProvDt.where("dev_cheque_prov_id = ?",@dev_cheque_prov.id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dev_cheque_prov }
    end
  end

  def comprovante
    @dev_cheque_prov = DevChequeProv.find(params[:id])
    @dev_dts = DevChequeProvDt.where("dev_cheque_prov_id = ?",@dev_cheque_prov.id)
    render layout: false
  end


  # GET /dev_cheque_provs/new
  # GET /dev_cheque_provs/new.json
  def new
    @dev_cheque_prov = DevChequeProv.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dev_cheque_prov }
    end
  end

  # GET /dev_cheque_provs/1/edit
  def edit
    @dev_cheque_prov = DevChequeProv.find(params[:id])
  end

  # POST /dev_cheque_provs
  # POST /dev_cheque_provs.json
  def create
    @dev_cheque_prov = DevChequeProv.new(params[:dev_cheque_prov])
    @dev_cheque_prov.usuario_created = current_user.id
    @dev_cheque_prov.unidade_id = current_unidade.id

    respond_to do |format|
      if @dev_cheque_prov.save
        format.html { redirect_to @dev_cheque_prov, notice: 'Dev cheque prov was successfully created.' }
        format.json { render json: @dev_cheque_prov, status: :created, location: @dev_cheque_prov }
      else
        format.html { render action: "new" }
        format.json { render json: @dev_cheque_prov.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dev_cheque_provs/1
  # PUT /dev_cheque_provs/1.json
  def update
    @dev_cheque_prov = DevChequeProv.find(params[:id])

    respond_to do |format|
      if @dev_cheque_prov.update_attributes(params[:dev_cheque_prov])
        format.html { redirect_to @dev_cheque_prov, notice: 'Dev cheque prov was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dev_cheque_prov.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dev_cheque_provs/1
  # DELETE /dev_cheque_provs/1.json
  def destroy
    @dev_cheque_prov = DevChequeProv.find(params[:id])
    @dev_cheque_prov.destroy

    respond_to do |format|
      format.html { redirect_to dev_cheque_provs_url }
      format.json { head :no_content }
    end
  end
end
