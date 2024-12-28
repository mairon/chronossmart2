class Crm::NegociosController < Crm::CrmController

  def update_status
    Negocio.find(params[:id]).update_column(:status, params[:status])
    render json: { data: 'OK', status: 200 }
  end

  def update_task
    tf = Tarefa.find(params[:tk_tarefa_id])
    tf.update_column(:status, params[:tk_status])
    Nota.create(tarefa_id: params[:tk_tarefa_id],
      descricao: params[:tk_descricao],
      usuario_id: current_user.id 
      )
    if params[:tk_status] == 'finalizado'
      or_at = 'TAREFA FINALIZADA'
    else params[:tk_status] == 'cancelado'
      or_at = 'TAREFA CANCELADA'
    end
    #Cria histotico
    NegocioHistorico.create(negocio_id: tf.negocio_id, 
      etapa_id: tf.negocio.etapa_id, 
      usuario_id: current_user.id,
      titulo: "Tarefa #{tf.tipo_tarefa.nome} Finalizada", 
      origem: or_at,
      detalhe: "<b>Tarefa Agendada para:</b> #{tf.dia_inicio.strftime("%d/%m/%y - %H:%M")} <br/> <b>Descripción Tarefa:</b> #{tf.descricao} <br/> <b>Marcado como #{params[:tk_status]}:</b> #{Time.now.strftime("%d/%m/%y - %H:%M")} <br/> <b>Nota de Conclusión:</b> #{params[:tk_descricao]}"
    )

    redirect_to crm_negocio_path(tf.negocio_id) 
  end

  def draggable
    Negocio.find(params[:deal_id]).update_column(:etapa_id, params[:step_id])

    #Cria histotico
    NegocioHistorico.create(negocio_id: params[:deal_id], 
      etapa_id: params[:step_id], 
      usuario_id: current_user.id,
      titulo: 'Etapa Alterada', 
      origem: 'ETAPA ALTERADA',
      detalhe: "Etapa Alterada de <b>#{Etapa.find(params[:origin_step_id]).nome}</b> para  <b>#{Etapa.find(params[:step_id]).nome}</b>" 
    )

    render json: { data: 'OK', status: 200 }
  end

  def index
    @negocios = Negocio.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @negocios }
    end
  end

  # GET /negocios/1
  # GET /negocios/1.json
  def show
    @negocio = Negocio.find(params[:id])

    @usuario_pipe =  PipelineUsuario.where(pipeline_id: @negocio.etapa.pipeline_id, usuario_id: current_user.id).last

    @etapas  = Etapa.where(pipeline_id: @negocio.etapa.pipeline_id).order(:ordem)
    @historico = NegocioHistorico.where(negocio_id: @negocio.id).order("id desc")
    
    @tarefas_pendentes = Tarefa.where(negocio_id: @negocio.id, status: 'pendente')
    render layout: 'chart'
  end

  # GET /negocios/new
  # GET /negocios/new.json
  def new
    @negocio = Negocio.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @negocio }
    end
  end

  # GET /negocios/1/edit
  def edit
    @negocio = Negocio.find(params[:id])
    @pipeline = Pipeline.find(@negocio.etapa.pipeline_id)
  end

  # POST /negocios
  # POST /negocios.json
  def create
    @negocio = Negocio.new(params[:negocio])

    respond_to do |format|
      if @negocio.save
    #Cria histotico
    NegocioHistorico.create(negocio_id: @negocio.id, 
      etapa_id: @negocio.etapa_id, 
      usuario_id: @negocio.usuario_id, 
      titulo: 'Negocio Adicionado', 
      origem: 'NEGOCIO CRIADO',
      detalhe: "Negocio Adicionado na Etapa <b>#{Etapa.find(@negocio.etapa_id).nome}</b>" 
    )        
        format.html { redirect_to crm_negocio_path(@negocio.id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /negocios/1
  # PUT /negocios/1.json
  def update
    @negocio = Negocio.find(params[:id])

    respond_to do |format|      
      if @negocio.update_attributes(params[:negocio])

             
        format.html { redirect_to crm_negocio_path(@negocio.id) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @negocio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /negocios/1
  # DELETE /negocios/1.json
  def destroy
    @negocio = Negocio.find(params[:id])
    @negocio.destroy

    respond_to do |format|
      format.html { redirect_to crm_pipeline_path(@negocio.etapa.pipeline_id) }
      format.json { head :no_content }
    end
  end
end
