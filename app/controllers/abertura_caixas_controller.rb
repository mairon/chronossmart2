class AberturaCaixasController < ApplicationController

  def modal_detalhe
    @financas = Financa.where(controle_caixa: params[:abertura_caixa_id], forma_pago_id: params[:forma_pago_id], moeda: params[:moeda]).order(:id)

    render layout: false
  end

  def print_transf_saldo
    @transf_saldo = FechamentoCaixaDt.find(params[:id])
    render :layout => false
  end

  def index
    @abertura_caixas = AberturaCaixa.paginate(:page => params[:page], :per_page => 20).where("unidade_id = #{current_unidade.id} ").order('id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @abertura_caixas }
    end
  end

  # GET /abertura_caixas/1
  # GET /abertura_caixas/1.json
  def show
    @abertura_caixa = AberturaCaixa.find(params[:id])
    @transf_saldo = FechamentoCaixaDt.where(abertura_caixa_id: @abertura_caixa.id).order("id desc")
    render layout: 'chart'
  end

  # GET /abertura_caixas/new
  # GET /abertura_caixas/new.json
  def new
    @abertura_caixa = AberturaCaixa.new
  end

  # GET /abertura_caixas/1/edit
  def edit
    @abertura_caixa = AberturaCaixa.find(params[:id])
  end

  # POST /abertura_caixas
  # POST /abertura_caixas.json
  def create
    @abertura_caixa = AberturaCaixa.new(params[:abertura_caixa])
    @abertura_caixa.unidade_id = current_unidade.id

    respond_to do |format|
      if @abertura_caixa.save
        format.html { redirect_to abertura_caixa_path(@abertura_caixa) }
        format.json { render json: @abertura_caixa, status: :created, location: @abertura_caixa }
      else
        format.html { render action: "new" }
        format.json { render json: @abertura_caixa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /abertura_caixas/1
  # PUT /abertura_caixas/1.json
  def update
    @abertura_caixa = AberturaCaixa.find(params[:id])

    respond_to do |format|
      if @abertura_caixa.update_attributes(params[:abertura_caixa])
        format.html { redirect_to abertura_caixa_path(@abertura_caixa) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @abertura_caixa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /abertura_caixas/1
  # DELETE /abertura_caixas/1.json
  def destroy
    @abertura_caixa = AberturaCaixa.find(params[:id])
    @abertura_caixa.destroy

    respond_to do |format|
      format.html { redirect_to abertura_caixas_url }
      format.json { head :no_content }
    end
  end
end
