class AbastecidasController < ApplicationController

  def index
  	render layout: 'chart'
  end

  def busca
		bic    = "AND B.ID = #{params[:busca]["bico"]}" unless params[:busca]["bico"].blank?
		frent  = "AND PS.PERSONA_ID = #{params[:busca]["frentista"]}" unless params[:busca]["frentista"].blank?
		status = "AND A.STATUS = #{params[:status]}" unless params[:status].blank?

		sql = "SELECT A.ID,
									A.CHAVE,
									B.ID AS BICO_ID,
									(A.LITROS / 100) AS LITROS,
									A.PRECO,
									B.NOME AS BICO_NOME,
									B.DEPOSITO_ID,
									P.NOME AS PRODUTO_NOME,
									P.ID AS PRODUTO_ID,
									A.STATUS,
									A.DATA,
									A.HORA,
									A.VALOR,
									PS.NOME AS FRENTISTA_NOME
						FROM ABASTECIDAS A

						INNER JOIN BICOS B
						ON B.BICO_AUTO = A.BICO

						LEFT JOIN DEPOSITOS D
						ON D.ID = B.DEPOSITO_ID

						LEFT JOIN PRODUTOS P
						ON P.ID = D.PRODUTO_ID

						LEFT JOIN CHAVES C
						ON C.nome = A.chave

						LEFT JOIN PERSONAS PS
						ON PS.ID = C.PERSONA_ID

						WHERE A.LITROS > 0
						AND A.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' and '#{params[:final].split("/").reverse.join("-")}'
						#{bic} #{frent} #{status}
						ORDER BY ID, A.DATA, A.HORA

									"
		@abastecidas = Abastecida.find_by_sql(sql)
		render layout: false
  end


	def modal_abastecidas
		#importa abastecidas
		Abastecida.get_abastecidas_sql
		sql = "SELECT A.ID,
									A.CHAVE,
									B.ID AS BICO_ID,
									(A.LITROS / 100) AS LITROS,
									A.PRECO,
									B.NOME AS BICO_NOME,
									B.DEPOSITO_ID,
									P.NOME AS PRODUTO_NOME,
									P.ID AS PRODUTO_ID,
									A.STATUS,
									A.DATA,
									A.HORA,
									A.VALOR,
									PS.NOME AS FRENTISTA_NOME
						FROM ABASTECIDAS A

						INNER JOIN BICOS B
						ON B.BICO_AUTO = A.BICO

						LEFT JOIN DEPOSITOS D
						ON D.ID = B.DEPOSITO_ID

						LEFT JOIN PRODUTOS P
						ON P.ID = D.PRODUTO_ID

						LEFT JOIN CHAVES C
						ON C.nome = A.chave

						LEFT JOIN PERSONAS PS
						ON PS.ID = C.PERSONA_ID

						WHERE A.STATUS IN (0,2) AND A.LITROS > 0
						ORDER BY ID

									"
		@abastecidas = Abastecida.find_by_sql(sql)
		render layout: false
	end

	def get_abastecidas_sql
		postgres = PG.connect :host => '38.52.135.201', :port => 5500, :dbname => 'postgres', :user => 'postgres', :password => 'Ask936tjh1245mnbvcxz'
   	tables = postgres.exec('SELECT ID,chave, litros, preco, bico FROM ABASTECIDAS WHERE STATUS = 0')

   	tables.each do |t|
   		Abastecida.create(
   			api_id: t['id'],
   			chave: t['chave'],
   			litros: t['litros'].to_f,
   			preco: t['preco'].to_f,
   			bico: t['bico'],
   			data: t['data'],
   			hora: t['hora'],
   			status: 0
   			)
   		postgres.exec("UPDATE ABASTECIDAS SET STATUS = 1 WHERE ID = #{t['id']}")
   	end

   	render nothing: true
	end

	def get_api

    url = URI("http://38.52.135.201:6000/abastecidas")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    request["content-type"] = 'application/json'
    # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
    puts '----------------------------------------------------------------------'
    response = http.request(request)
    puts   = JSON.parse(response.body)
		puts get_resp = JSON.parse(response.body)

		get_resp.each do |gr|

			puts gr["id"]
		end

    return render :json => { :fe => get_resp }
	end


	def update_status

    url = URI("http://38.52.135.201:6000/abastecidas?id=eq.2")
    data = {status: 1}
    http = Net::HTTP.new(url.host, url.port)


    request = Net::HTTP::Put.new(url)
    request["content-type"] = 'application/json'
    # O exemplo do objeto completo está detalhado abaixo na sessão "Conteúdo de Envio".
    puts '----------------------------------------------------------------------'
    request.body = data.to_json
    response = http.request(request)
    puts   = JSON.parse(response.body)
		puts get_resp = JSON.parse(response.body)

    return render :json => { :fe => get_resp }
	end


  # GET /abastecidas/1
  # GET /abastecidas/1.json
  def show
    @abastecida = Abastecida.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @abastecida }
    end
  end

  # GET /abastecidas/new
  # GET /abastecidas/new.json
  def new
    @abastecida = Abastecida.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @abastecida }
    end
  end

  # GET /abastecidas/1/edit
  def edit
    @abastecida = Abastecida.find(params[:id])
  end

  # POST /abastecidas
  # POST /abastecidas.json
  def create
    @abastecida = Abastecida.new(params[:abastecida])

    respond_to do |format|
      if @abastecida.save
        format.html { redirect_to @abastecida, notice: 'Abastecida was successfully created.' }
        format.json { render json: @abastecida, status: :created, location: @abastecida }
      else
        format.html { render action: "new" }
        format.json { render json: @abastecida.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /abastecidas/1
  # PUT /abastecidas/1.json
  def update
    @abastecida = Abastecida.find(params[:id])

    respond_to do |format|
      if @abastecida.update_attributes(params[:abastecida])
        format.html { redirect_to @abastecida, notice: 'Abastecida was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @abastecida.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /abastecidas/1
  # DELETE /abastecidas/1.json
  def destroy
    @abastecida = Abastecida.find(params[:id])
    @abastecida.destroy

    respond_to do |format|
      format.html { redirect_to abastecidas_url }
      format.json { head :no_content }
    end
  end

end