class EventoConvidadosController < ApplicationController
  before_filter :authenticate, :except => ["confirm", "update"]

  def ticket_detalhe
    @persona = Persona.find(params[:persona_id])
    @tickets = EventoConvidado.where(persona_id: params[:persona_id]).order("venda_id, updated_at")
  end

  def controle_tickets
    sql = "
            SELECT P.ID AS PERSONA_ID,
                 PD.NOME AS PRODUTO_NOME,
                 MAX(P.NOME) AS PERSONA_NOME,
                 MAX(T.NOME) AS ESCOLARIDADE,
                 COUNT(EC.ID) AS SALDO
                 
            FROM EVENTO_CONVIDADOS EC
            INNER JOIN PERSONAS P
            ON P.ID = EC.PERSONA_ID

            INNER JOIN VENDAS_PRODUTOS VP
            ON VP.ID = EC.VENDAS_PRODUTO_ID

            INNER JOIN PRODUTOS PD
            ON PD.ID = VP.PRODUTO_ID

            LEFT JOIN TURMAS T
            ON T.ID = P.TURMA_ID
            WHERE P.UNIDADE_ID = #{current_unidade.id}
            AND EC.PRESENTE = FALSE
            GROUP BY 1,2
            ORDER BY 4,2
    "

    @tickets = EventoConvidado.find_by_sql(sql)
    render layout: 'chart'   
  end

  def confirm
    @evento_convidado = EventoConvidado.find(params[:id])
    @evento = Evento.find(@evento_convidado.evento_id)

    render layout: 'logins'
  end

  def qrcode
    @evento_convidado = EventoConvidado.find(params[:id])
    @evento = Evento.find(@evento_convidado.evento_id) unless @evento_convidado.evento_id.blank?
   respond_to do |format|
     format.html do
            render  :pdf                    => "#{@evento_convidado.id.to_s.rjust(6,'0')}-#{@evento_convidado.nome}",
                    :layout                 => "layer_relatorios",
                    :page_height            => 150,
                    :page_width             => 100,
                    :margin => {:top        => '0.80in',
                                :bottom     => '0.25in',
                                :left       => '0.10in',
                                :right      => '0.10in'},
                   :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                :font_size  => 7,
                                :spacing    => 25},
                    :footer => {:font_name  => 'arial, 900',
                                :font_size  => 7,
                                :center       => "Chronos Software - chronos.com.py"}
          end
      end
  end

  def index
    @evento_convidados = EventoConvidado.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @evento_convidados }
    end
  end

  def show
    @evento_convidado = EventoConvidado.find(params[:id])
    @evento = Evento.find(@evento_convidado.evento_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @evento_convidado }
    end
  end

  # GET /evento_convidados/new
  # GET /evento_convidados/new.json
  def new
    @evento_convidado = EventoConvidado.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @evento_convidado }
    end
  end

  # GET /evento_convidados/1/edit
  def edit
    @evento_convidado = EventoConvidado.find(params[:id])
  end

  # POST /evento_convidados
  # POST /evento_convidados.json
  def create
    @evento_convidado = EventoConvidado.new(params[:evento_convidado])

    respond_to do |format|
      if @evento_convidado.save
        format.html { redirect_to evento_path(@evento_convidado.evento_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /evento_convidados/1
  # PUT /evento_convidados/1.json
  def update
    @evento_convidado = EventoConvidado.find(params[:id])

    respond_to do |format|
      if @evento_convidado.update_attributes(params[:evento_convidado])
        format.html { redirect_to ticket_detalhe_evento_convidados_path(persona_id: @evento_convidado.persona_id) }
        
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /evento_convidados/1
  # DELETE /evento_convidados/1.json
  def destroy
    @evento_convidado = EventoConvidado.find(params[:id])
    @evento_convidado.destroy

    respond_to do |format|
      format.html { redirect_to evento_path(@evento_convidado.evento_id) }
      format.json { head :no_content }
    end
  end
end
