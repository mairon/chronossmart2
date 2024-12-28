class TipoTarefasController < ApplicationController
  # GET /tipo_tarefas
  # GET /tipo_tarefas.json
  def index
    @tipo_tarefas = TipoTarefa.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tipo_tarefas }
    end
  end

  # GET /tipo_tarefas/1
  # GET /tipo_tarefas/1.json
  def show
    @tipo_tarefa = TipoTarefa.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tipo_tarefa }
    end
  end

  # GET /tipo_tarefas/new
  # GET /tipo_tarefas/new.json
  def new
    @tipo_tarefa = TipoTarefa.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tipo_tarefa }
    end
  end

  # GET /tipo_tarefas/1/edit
  def edit
    @tipo_tarefa = TipoTarefa.find(params[:id])
  end

  # POST /tipo_tarefas
  # POST /tipo_tarefas.json
  def create
    @tipo_tarefa = TipoTarefa.new(params[:tipo_tarefa])

    respond_to do |format|
      if @tipo_tarefa.save
        format.html { redirect_to tipo_tarefas_url }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /tipo_tarefas/1
  # PUT /tipo_tarefas/1.json
  def update
    @tipo_tarefa = TipoTarefa.find(params[:id])

    respond_to do |format|
      if @tipo_tarefa.update_attributes(params[:tipo_tarefa])
        format.html { redirect_to tipo_tarefas_url }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /tipo_tarefas/1
  # DELETE /tipo_tarefas/1.json
  def destroy
    @tipo_tarefa = TipoTarefa.find(params[:id])
    @tipo_tarefa.destroy

    respond_to do |format|
      format.html { redirect_to tipo_tarefas_url }
    end
  end
end
