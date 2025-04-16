class AfericaosController < ApplicationController

  def index
    sql = "SELECT  A.ID,
                   A.DATA,
                   A.ABASTECIDA_ID,
                   P.NOME AS RESPOSAVEL_NOME,
                   B.NOME AS BICO_NOME,
                   PD.NOME AS PRODUTO_NOME,
                   DOI.NOME AS DEPOSITO_ORIGEM_NOME,
                   DD.NOME AS DEPOSITO_DESTINO_NOME,
                   A.QUANTIDADE
                   
            FROM AFERICAOS A

            INNER JOIN PERSONAS P
            ON P.ID = A.PERSONA_ID

            INNER JOIN BICOS B
            ON B.ID = A.BICO_ID

            INNER JOIN DEPOSITOS DOI
            ON DOI.ID = A.DEPOSITO_ORIGEM_ID

            INNER JOIN DEPOSITOS DD
            ON DD.ID = A.DEPOSITO_ID

            INNER JOIN PRODUTOS PD
            ON PD.ID = A.PRODUTO_ID
            WHERE A.UNIDADE_ID = #{current_unidade.id}
            ORDER BY 2 DESC, 1 DESC"
    @afericaos = Afericao.find_by_sql(sql)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @afericaos }
    end
  end

  # GET /afericaos/1
  # GET /afericaos/1.json
  def show
    @afericao = Afericao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @afericao }
    end
  end

  # GET /afericaos/new
  # GET /afericaos/new.json
  def new
    @afericao = Afericao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @afericao }
    end
  end

  # GET /afericaos/1/edit
  def edit
    @afericao = Afericao.find(params[:id])
  end

  # POST /afericaos
  # POST /afericaos.json
  def create
    @afericao = Afericao.new(params[:afericao])
    @afericao.unidade_id = current_unidade.id.to_i
    respond_to do |format|
      if @afericao.save
        format.html { redirect_to afericaos_url }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /afericaos/1
  # PUT /afericaos/1.json
  def update
    @afericao = Afericao.find(params[:id])

    respond_to do |format|
      if @afericao.update_attributes(params[:afericao])
        format.html { redirect_to afericaos_url }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /afericaos/1
  # DELETE /afericaos/1.json
  def destroy
    @afericao = Afericao.find(params[:id])
    @afericao.destroy

    respond_to do |format|
      format.html { redirect_to afericaos_url }
    end
  end
end
