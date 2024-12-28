class AberturaCaixasController < ApplicationController
  # GET /abertura_caixas
  # GET /abertura_caixas.json
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
    sql = "SELECT C.ID,
                  C.NOME,
                  C.MOEDA,
                  (SELECT SUM(F.ENTRADA_DOLAR - F.SAIDA_DOLAR) FROM FINANCAS F WHERE F.MOEDA = C.MOEDA AND F.CONTA_ID = C.ID AND DATA <= '#{@abertura_caixa.data}') AS SALDO_US,
                  (SELECT SUM(F.ENTRADA_GUARANI - F.SAIDA_GUARANI) FROM FINANCAS F WHERE F.MOEDA = C.MOEDA AND F.CONTA_ID = C.ID AND DATA <= '#{@abertura_caixa.data}') AS SALDO_GS,
                  (SELECT SUM(F.ENTRADA_REAL - F.SAIDA_REAL) FROM FINANCAS F WHERE F.MOEDA = C.MOEDA AND F.CONTA_ID = C.ID AND DATA <= '#{@abertura_caixa.data}') AS SALDO_RS
            FROM CONTAS C
          WHERE C.TERMINAL_ID = #{@abertura_caixa.terminal_id} "
    @caixas = Financa.find_by_sql(sql)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @abertura_caixa }
    end
  end

  # GET /abertura_caixas/new
  # GET /abertura_caixas/new.json
  def new
    @abertura_caixa = AberturaCaixa.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @abertura_caixa }
    end
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
        format.html { redirect_to abertura_caixas_url }
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
        format.html { redirect_to abertura_caixas_url }
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
