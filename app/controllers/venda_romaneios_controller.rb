class VendaRomaneiosController < ApplicationController

  def baixa_romaneio
    @romaneios = Romaneio.find(params[:romaneio]["romaneios_ids"])

    @romaneios.each do |r|
      VendaRomaneio.create(
        venda_id: params[:venda_id],
        romaneio_id: r.id
      )
    end

    v  = Venda.find(params[:venda_id]) 
    rp = RomaneioProduto.where(romaneio_id: params[:romaneio]["romaneios_ids"])

      VendasProduto.create( :venda_id         => v.id,
                              :persona_id       => v.persona_id,
                              :data             => v.data,
                              :moeda            => v.moeda,
                              :cotacao          => v.cotacao,
                              :quantidade             => rp.sum(:quantidade).to_f,
                              :unitario_dolar         => 0,
                              :preco_dolar            => 0,
                              :total_dolar            => 0,
                              :unitario_guarani       => (rp.sum(:total_guarani).to_f / rp.sum(:quantidade).to_f),
                              :preco_guarani          => (rp.sum(:total_guarani).to_f / rp.sum(:quantidade).to_f),
                              :total_guarani          => rp.sum(:total_guarani).to_f,
                              :produto_id             => rp.last.produto_id,
                              :produto_nome           => rp.last.produto_nome,

                            )


    redirect_to(venda_path(params[:venda_id]))

  end

  def lista_romaneios

    sql = "SELECT R.ID,
                  R.DATA,
                  R.DOCUMENTO_NUMERO,
                  R.PERSONA_NOME,
                  P.NOME AS CHOFER_NOME,
                  NR.DOCUMENTO_NUMERO AS NOT_REMICAO_DOC,
                  (SELECT SUM(RP.QUANTIDADE) FROM ROMANEIO_PRODUTOS RP WHERE RP.ROMANEIO_ID = R.ID) AS QTD,
                  (SELECT SUM(RP.TOTAL_GUARANI) FROM ROMANEIO_PRODUTOS RP WHERE RP.ROMANEIO_ID = R.ID) AS TOT_GS
                  FROM ROMANEIOS R

                  LEFT JOIN VENDA_ROMANEIOS VR
                  ON R.ID = VR.ROMANEIO_ID

                  LEFT JOIN NOTA_REMICAOS NR
                  ON NR.ID = R.NOTA_REMICAO_ID

                  LEFT JOIN PERSONAS P
                  ON P.ID = NR.CHOFER_ID

                  WHERE VR.ID IS NULL AND R.PERSONA_ID = #{params[:persona_id]}

                  ORDER BY R.ID
    "
    @venda_romaneios = Romaneio.find_by_sql(sql)

    render layout: false
  end

  def index
    @venda_romaneios = VendaRomaneio.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @venda_romaneios }
    end
  end

  # GET /venda_romaneios/1
  # GET /venda_romaneios/1.json
  def show
    @venda_romaneio = VendaRomaneio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @venda_romaneio }
    end
  end

  # GET /venda_romaneios/new
  # GET /venda_romaneios/new.json
  def new
    @venda_romaneio = VendaRomaneio.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venda_romaneio }
    end
  end

  # GET /venda_romaneios/1/edit
  def edit
    @venda_romaneio = VendaRomaneio.find(params[:id])
  end

  # POST /venda_romaneios
  # POST /venda_romaneios.json
  def create
    @venda_romaneio = VendaRomaneio.new(params[:venda_romaneio])

    respond_to do |format|
      if @venda_romaneio.save
        format.html { redirect_to "/vendas/#{@venda_romaneio.venda_id}" }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /venda_romaneios/1
  # PUT /venda_romaneios/1.json
  def update
    @venda_romaneio = VendaRomaneio.find(params[:id])

    respond_to do |format|
      if @venda_romaneio.update_attributes(params[:venda_romaneio])
        format.html { redirect_to "/vendas/#{@venda_romaneio.venda_id}" }

      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /venda_romaneios/1
  # DELETE /venda_romaneios/1.json
  def destroy
    @venda_romaneio = VendaRomaneio.find(params[:id])
    @venda_romaneio.destroy

    respond_to do |format|
      format.html { redirect_to "/vendas/#{@venda_romaneio.venda_id}" }
    end
  end
end
