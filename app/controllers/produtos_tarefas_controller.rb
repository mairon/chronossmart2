class ProdutosTarefasController < ApplicationController
  # GET /produtos_tarefas
  # GET /produtos_tarefas.json
  def index
    @produtos_tarefas = ProdutosTarefa.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @produtos_tarefas }
    end
  end

  # GET /produtos_tarefas/1
  # GET /produtos_tarefas/1.json
  def show
    @produtos_tarefa = ProdutosTarefa.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @produtos_tarefa }
    end
  end

  # GET /produtos_tarefas/new
  # GET /produtos_tarefas/new.json
  def new
    @produtos_tarefa = ProdutosTarefa.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @produtos_tarefa }
    end
  end

  # GET /produtos_tarefas/1/edit
  def edit
    @produtos_tarefa = ProdutosTarefa.find(params[:id])
  end

  # POST /produtos_tarefas
  # POST /produtos_tarefas.json
  def create
    @produtos_tarefa = ProdutosTarefa.new(params[:produtos_tarefa])

    respond_to do |format|
      if @produtos_tarefa.save
        format.html { redirect_to @produtos_tarefa, notice: 'Produtos tarefa was successfully created.' }
        format.json { render json: @produtos_tarefa, status: :created, location: @produtos_tarefa }
      else
        format.html { render action: "new" }
        format.json { render json: @produtos_tarefa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /produtos_tarefas/1
  # PUT /produtos_tarefas/1.json
  def update
    @produtos_tarefa = ProdutosTarefa.find(params[:id])

    respond_to do |format|
      if @produtos_tarefa.update_attributes(params[:produtos_tarefa])
        format.html { redirect_to @produtos_tarefa, notice: 'Produtos tarefa was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @produtos_tarefa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produtos_tarefas/1
  # DELETE /produtos_tarefas/1.json
  def destroy
    @produtos_tarefa = ProdutosTarefa.find(params[:id])
    @produtos_tarefa.destroy

    respond_to do |format|
      format.html { redirect_to produtos_tarefas_url }
      format.json { head :no_content }
    end
  end
end
