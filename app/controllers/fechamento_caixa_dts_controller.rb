class FechamentoCaixaDtsController < ApplicationController
  # GET /fechamento_caixa_dts
  # GET /fechamento_caixa_dts.json
  def index
    @fc = FechamentoCaixaDt.where("fechamento_caixa_id = 999999999")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fechamento_caixa_dts }
    end
  end

  # GET /fechamento_caixa_dts/1
  # GET /fechamento_caixa_dts/1.json
  def show
    @fechamento_caixa_dt = FechamentoCaixaDt.find(params[:id])
              
		@fp_detalhados = Financa.where(controle_caixa: @fechamento_caixa_dt.fechamento_caixa.abertura_caixa_id, forma_pago_id: @fechamento_caixa_dt.forma_pago_id, moeda: @fechamento_caixa_dt.moeda )

    render layout: 'chart'
  end

  # GET /fechamento_caixa_dts/new
  # GET /fechamento_caixa_dts/new.json
  def new
    @fechamento_caixa_dt = FechamentoCaixaDt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fechamento_caixa_dt }
    end
  end

  # GET /fechamento_caixa_dts/1/edit
  def edit
    @fechamento_caixa_dt = FechamentoCaixaDt.find(params[:id])
  end

  # POST /fechamento_caixa_dts
  # POST /fechamento_caixa_dts.json
  def create
    @fechamento_caixa_dt = FechamentoCaixaDt.new(params[:fechamento_caixa_dt])

    respond_to do |format|
      if @fechamento_caixa_dt.save
        format.html { redirect_to(:back) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /fechamento_caixa_dts/1
  # PUT /fechamento_caixa_dts/1.json
  def update
    @fechamento_caixa_dt = FechamentoCaixaDt.find(params[:id])

    respond_to do |format|
      if @fechamento_caixa_dt.update_attributes(params[:fechamento_caixa_dt])
        format.html { redirect_to "/fechamento_caixas/#{@fechamento_caixa_dt.fechamento_caixa_id}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fechamento_caixa_dt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fechamento_caixa_dts/1
  # DELETE /fechamento_caixa_dts/1.json
  def destroy
    @fechamento_caixa_dt = FechamentoCaixaDt.find(params[:id])
    @fechamento_caixa_dt.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.json { head :no_content }
    end
  end
end
