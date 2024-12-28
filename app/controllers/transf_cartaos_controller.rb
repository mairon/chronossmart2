class TransfCartaosController < ApplicationController

  def baixa_cartao
    @transf_cartao = TransfCartao.find(params[:id])

      @cartoes = Financa.find(params[:transf]["cartao_ids"])      
        @cartoes.each do |d|
          if d.documento_numero == ''
            doc = @transf_cartao.data.strftime('%d') + @transf_cartao.data.strftime('%m') +  d.id.to_s
          else
            doc = d.documento_numero
          end
          TransfCartaoDt.create(  transf_cartao_id:   @transf_cartao.id,
                                  nr_comprovante:     doc,
                                  tabela:             d.tabela,
                                  tabela_id:          d.tabela_id,
                                  valor_gs:           d.entrada_guarani,
                                  valor_us:           d.entrada_dolar,
                                  valor_rs:           d.entrada_real,
                                  saldo_gs:           d.entrada_guarani.to_f - ( d.entrada_guarani.to_f * ( @transf_cartao.taxa.to_f / 100) ),
                                  saldo_us:           d.entrada_dolar.to_f - ( d.entrada_dolar.to_f * ( @transf_cartao.taxa.to_f / 100) ),
                                  saldo_rs:           d.entrada_real.to_f - ( d.entrada_real.to_f * ( @transf_cartao.taxa.to_f / 100) ),
                                  taxa_gs:            ( d.entrada_guarani.to_f * (@transf_cartao.taxa.to_f / 100) ),
                                  taxa_us:            ( d.entrada_dolar.to_f * (@transf_cartao.taxa.to_f / 100) ),
                                  taxa_rs:            ( d.entrada_real.to_f * (@transf_cartao.taxa.to_f / 100) ),
                                  cartao_bandeira_id: d.cartao_bandeira_id
                                )
        end

      redirect_to @transf_cartao
    end

  def index
    sql ="SELECT T.ID,
                 T.DATA,
                 CO.NOME ORIGEM,
                 CD.NOME DESTINO
          FROM TRANSF_CARTAOS T
          LEFT JOIN CONTAS CO
          ON CO.ID = T.CONTA_ORIGEM_ID
          LEFT JOIN CONTAS CD
          ON CD.ID = T.CONTA_DESTINO_ID
          WHERE T.UNIDADE_ID = #{current_unidade.id}
          ORDER BY 2 DESC, 1 DESC"
    @transf_cartaos = TransfCartao.find_by_sql(sql)

  end

  # GET /transf_cartaos/1
  # GET /transf_cartaos/1.json
  def show
    @transf_cartao = TransfCartao.find(params[:id])
    sql = "SELECT F.DATA,
                  CB.NOME AS BANDEIRA,
                  F.DOCUMENTO_NUMERO,
                  F.CONCEPTO,
                  F.ENTRADA_GUARANI,
                  F.CARTAO_BANDEIRA_ID,
                  F.TABELA,
                  F.TABELA_ID,
                  F.ID,
                  (SELECT COUNT(T.ID) FROM TRANSF_CARTAO_DTS T WHERE T.TABELA = F.TABELA AND T.TABELA_ID = F.TABELA_ID)

            FROM FINANCAS F 
            LEFT JOIN CARTAO_BANDEIRAS CB
            ON CB.ID =  F.CARTAO_BANDEIRA_ID
            WHERE F.CONTA_ID = #{@transf_cartao.conta_origem_id}
            AND (SELECT COUNT(T.ID) FROM TRANSF_CARTAO_DTS T WHERE T.TABELA = F.TABELA AND T.TABELA_ID = F.TABELA_ID) = 0
            AND F.ENTRADA_GUARANI > 0
            ORDER BY F.DATA"
    @cartoes = Financa.find_by_sql(sql)
  end

  # GET /transf_cartaos/new
  # GET /transf_cartaos/new.json
  def new
    @transf_cartao = TransfCartao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transf_cartao }
    end
  end

  # GET /transf_cartaos/1/edit
  def edit
    @transf_cartao = TransfCartao.find(params[:id])
  end

  # POST /transf_cartaos
  # POST /transf_cartaos.json
  def create
    @transf_cartao = TransfCartao.new(params[:transf_cartao])
    @transf_cartao.usuario_created = current_user.id

    @transf_cartao.unidade_id = current_unidade.id

    respond_to do |format|
      if @transf_cartao.save
        format.html { redirect_to @transf_cartao }
        format.json { render json: @transf_cartao, status: :created, location: @transf_cartao }
      else
        format.html { render action: "new" }
        format.json { render json: @transf_cartao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /transf_cartaos/1
  # PUT /transf_cartaos/1.json
  def update
    @transf_cartao = TransfCartao.find(params[:id])

    respond_to do |format|
      if @transf_cartao.update_attributes(params[:transf_cartao])
        format.html { redirect_to @transf_cartao }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @transf_cartao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transf_cartaos/1
  # DELETE /transf_cartaos/1.json
  def destroy
    @transf_cartao = TransfCartao.find(params[:id])
    @transf_cartao.destroy

    respond_to do |format|
      format.html { redirect_to transf_cartaos_url }
      format.json { head :no_content }
    end
  end
end
