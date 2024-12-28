class CheckPointsController < ApplicationController

  def notificacao_app

    project_id   = "crescer-1498a" # Your project_id
    device_token = "dwV_1URQikaKv8IcaqsPeE:APA91bGEmjWf0OaQgwpSpO82wCR5ZTEK6Q8oq_7QWEaiHXrFxSCuSkJcwRITVXNRTLtSpeJsRmhEERAiPSHrw9znv7KJKz4IW4pdXv05yl7rPI2zh3sJQ0JMYWaey1tMK9hdfWrczlWY" # The device token of the device you'd like to push a message to

    client  = Fcmpush.new(project_id)
    payload = {
      message: {
        token: device_token,
        notification: {
          title: "this is title",
          body: "this is message body"
        }
      }
    }

    response = client.push(payload)

    json = response.json
    json[:name] # => "projects/[your_project_id]/messages/0:1571037134532751%31bd1c9631bd1c96"
    render layout: false

  end

  def busca_token
    persona = Persona.select('id,nome').where(facial_id: params[:faceid]).first
    return render :json => { :busca => persona }
  end 

  def lista_presenca
   
  end

  def resultado_lista_presenca
    params[:unidade_id] = current_unidade.id

      respond_to do |format|
                if params["tipo"] == '1'
                  format.html {
                    xls = render_to_string :action => "resultado_lista_presenca", :layout => false
                    kit = PDFKit.new(xls,
                                     :encoding => 'UTF-8')
                    send_data(xls,:filename => "resultado_entrada_modal-#{params[:mes]}-#{params[:ano]}.xls")
                  }
                else

                format.html do
                  render  :pdf                    => "resultado_lista_presenca",
                          :layout                 => "layer_relatorios",
                          :orientation                    => 'Landscape',
                          :margin => {:top        => '0.95in',
                                      :bottom     => '0.25in',
                                      :left       => '0.10in',
                                      :right      => '0.10in'},
                          :header => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                                      :font_size  => 7,
                                      :spacing    => 20},
                          :footer => {:font_name  => 'Helvetica Neue,Helvetica,Arial,sans-serif',
                                      :font_size  => 7,
                                      :right      => "Pagina [page] de [toPage]",
                                      :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
                end
              end    
            end  
  end

  def busca_ticket

    persona = Persona.select('id,nome,tabela_preco_id,unidade_id').where(facial_id: params[:faceid]).first
    cc = CentroCusto.where("nome ilike '%CANTINA%' and unidade_id = #{persona.unidade_id}").last
    ticket  = EventoConvidado.where(presente: false, persona_id: persona.id)
    if ticket.count(:id).to_i == 0 
      if params[:produto_id] != ''
        div = ProdutosTabelaPreco.where(unidade_id: persona.unidade_id, produto_id: params[:produto_id], tabela_preco_id: persona.tabela_preco_id).last.preco_1_gs
        pd = Produto.find(params[:produto_id])

        Cliente.create(persona_id: persona.id, 
          divida_guarani: div.to_f, 
          unidade_id: persona.unidade_id, 
          centro_custo_id: cc.id,
          documento_numero_01: '000',
          descricao: pd.nome,
          documento_numero_02: '000',
          moeda: 1,
          cota: 1,
          documento_numero: (Cliente.last.id.to_i + 1),
          data:  Time.now.strftime("%Y-%m-%d"),
          vencimento:  Time.now.strftime("%Y-%m-%d"),
          liquidacao: 0, 
          taxa: 10,
          tabela: 'CHECK_POINTS',
          sigla_proc: 'CP'
        )
        end
    else
      ticket.last.update_attributes(presente: true)
    end

    return render :json => { busca: persona, ticket: ticket.count(:id) }

  end

  def atualiza_cancela_titulo
    CheckPoint.destroy_all("id = #{params[:id]}" )


    respond_to do |format|
      format.json { head :no_content }
    end

  end

  def import_point
    CheckPoint.import(params[:file], params)

    redirect_to('/check_points')
  end

  def busca
    unless params[:inicio].blank?
      data = "CP.DATETIME::DATE BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
      emp = "AND CP.PERSONA_ID = #{params[:busca]["empregado"]}" unless params[:busca]["empregado"].blank?
    end

      sql = "

      SELECT  CP.ID,
              CP.CHECKPOINT,
              CP.CHECK_POINT_TYPE,
              CP.ID,
              CP.PERSONA_ID,
              CP.DATETIME,
              P.NOME AS PERSONA_NOME,
              P.DIRECAO AS DIRECAO
      FROM CHECK_POINTS CP

      INNER JOIN PERSONAS P
      ON P.ID = CP.PERSONA_ID
      where #{data}
      ORDER BY 5 desc, 1 desc


      "

    @check_points =  CheckPoint.find_by_sql(sql)


    render :layout => false
  end


  def index

  end

  # GET /check_points/1
  # GET /check_points/1.json
  def show
    @check_point = CheckPoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @check_point }
    end
  end

  # GET /check_points/new
  # GET /check_points/new.json
  def new
    @check_point = CheckPoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @check_point }
    end
  end

  # GET /check_points/1/edit
  def edit
    @check_point = CheckPoint.find(params[:id])
  end

  # POST /check_points
  # POST /check_points.json
  def create
    @check_point = CheckPoint.new(params[:check_point])

    respond_to do |format|
      if @check_point.save

        if @check_point.check_point_type == 'REGISTROCONSUMO'
          
          Stock.create(
            data:  Time.now.strftime("%Y-%m-%d"),
            deposito_id: 18,
            produto_id: @check_point.produto_id,
            persona_id: @check_point.persona_id,
            persona_nome: @check_point.persona.nome,
            status: 0,
            saida: 1,
            cod_processo:  @check_point.id,
            sigla_proc: 'CK',
            tabela: 'CHECK_POINTS'
            )

          format.html { redirect_to "/faceid/registro_consumo?produto_id=#{@check_point.produto_id}" }  

        elsif @check_point.check_point_type == 'ENTRADA-EXTRA' or @check_point.check_point_type == 'SALIDA-EXTRA' 
          format.html { redirect_to '/aula_extra' }           
        else
          format.html { redirect_to '/faceid' }  
        end        
        format.json { render json: @check_point, status: :created, location: @check_point }
        format.js

        #notificação app
        if @check_point.persona.consolidado == false
          title = ""
          body = ""
          if @check_point.check_point_type == 'REGISTROCONSUMO'
            title = "Registro Consumo #{@check_point.persona.nome}"
            body  = "Registro Consumo #{@check_point.persona.nome}"
          elsif @check_point.check_point_type == 'ENTRADA-EXTRA' 
            title = "Registro Entrada Aula Extra #{@check_point.persona.nome}"
            body  = "Registro Entrada Aula Extra #{@check_point.persona.nome}"
          elsif @check_point.check_point_type == 'SALIDA-EXTRA' 
            title = "Registro Salida Aula Extra #{@check_point.persona.nome}"
            body  = "Registro Salida Aula Extra #{@check_point.persona.nome}"
          elsif @check_point.check_point_type == 'ENTRADA' 
            title = "Registro Entrada #{@check_point.persona.nome}"
            body  = "Registro Entrada #{@check_point.persona.nome}"
          elsif @check_point.check_point_type == 'SALIDA' 
            title = "Registro Salida #{@check_point.persona.nome}"
            body  = "Registro Salida #{@check_point.persona.nome}"
          end

          data = {
                  message: {
                    token: "dwV_1URQikaKv8IcaqsPeE:APA91bGEmjWf0OaQgwpSpO82wCR5ZTEK6Q8oq_7QWEaiHXrFxSCuSkJcwRITVXNRTLtSpeJsRmhEERAiPSHrw9znv7KJKz4IW4pdXv05yl7rPI2zh3sJQ0JMYWaey1tMK9hdfWrczlWY",
                    notification: {
                      title: title,
                      body: body
                    }
                  }
                }

            url = URI("https://fcm.googleapis.com/v1/projects/crescer-1498a/messages:send")

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            request = Net::HTTP::Post.new(url)
            request["authorization"] = "Bearer ya29.a0AcM612yKHCqCiJeb1UGXS5DxLYbuzFh-M9w2QZ_UDtqocEHtP24jdxAKvKeM4CwM793o6MwSGziWR6Cfz5dIShGpn6jykfGoWI2f1jU4tkqsZ_gcIvzIi2TcTJGwuASFZ5F3q7xb0L-qpUd8J8Fg4rfvXZX7PL6gFYVWvRooaCgYKARYSAQ8SFQHGX2MimpoSUPXv3OZB3NnM8uKRJA0175"
            request["content-type"] = 'application/json'
            puts data.to_json
            request.body = data.to_json
            response = http.request(request)
            puts get_resp = JSON.parse(response.body)
        end 
      else
        format.html { render action: "new" }
        format.json { render json: @check_point.errors, status: :unprocessable_entity }
        format.js
      end
    end

  end

  # PUT /check_points/1
  # PUT /check_points/1.json
  def update
    @check_point = CheckPoint.find(params[:id])

    respond_to do |format|
      if @check_point.update_attributes(params[:check_point])
        format.html { redirect_to check_points_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @check_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_points/1
  # DELETE /check_points/1.json
  def destroy
    @check_point = CheckPoint.find(params[:id])
    @check_point.destroy

    respond_to do |format|
      format.html { redirect_to check_points_url }

    end
  end
end
