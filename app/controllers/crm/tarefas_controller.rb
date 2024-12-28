class Crm::TarefasController < Crm::CrmController

  def index
    @tarefas = Tarefa.order("id desc")
    render layout: 'chart'
  end

  # GET /tarefas/1
  # GET /tarefas/1.json
  def show
    @tarefa = Tarefa.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tarefa }
    end
  end

  # GET /tarefas/new
  # GET /tarefas/new.json
  def new
    @tarefa = Tarefa.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tarefa }
    end
  end

  # GET /tarefas/1/edit
  def edit
    @tarefa = Tarefa.find(params[:id])
    render layout: 'chart'
  end

  # POST /tarefas
  # POST /tarefas.json
  def create
    @tarefa = Tarefa.new(params[:tarefa])

    respond_to do |format|
      if @tarefa.save
        
        if @tarefa.origem == "CRM"
          format.html { redirect_to crm_negocio_path(@tarefa.negocio_id) }
        else  
          format.html { redirect_to tarefas_path(vendedor_id: @tarefa.vendedor_id, data: @tarefa.dia_inicio.strftime("%Y-%m-%d") ) }
        end
        
      else
        format.html { render action: "new" }
      end
    end
  end
  # PUT /tarefas/1
  # PUT /tarefas/1.json
  def update
    @tarefa = Tarefa.find(params[:id])

    respond_to do |format|
      if @tarefa.update_attributes(params[:tarefa])
        format.html { redirect_to tarefas_path(vendedor_id: @tarefa.vendedor_id, data: @tarefa.dia_inicio.strftime("%Y-%m-%d") ) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tarefa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tarefas/1
  # DELETE /tarefas/1.json
  def destroy
    @tarefa = Tarefa.find(params[:id])
    @tarefa.destroy

    respond_to do |format|
      format.html { redirect_to tarefas_url }
      format.json { head :no_content }
    end
  end
end
