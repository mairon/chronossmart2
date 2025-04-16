class TurmasController < ApplicationController

  def busca
    params[:unidade] = current_unidade.id
    @turmas = Turma.filtro_busca(params)
    render :layout => false
  end

  def index
    @turmas = Turma.where(unidade_id: current_unidade.id).order(:id)
    @turma = Turma.new

    render layout: 'chart'
  end

  # GET /turmas/1
  # GET /turmas/1.json
  def show
    @turma = Turma.find(params[:id])

    render layout: 'chart'
  end

  # GET /turmas/new
  # GET /turmas/new.json
  def new
    @turma = Turma.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @turma }
    end
  end

  # GET /turmas/1/edit
  def edit
    @turma = Turma.find(params[:id])
  end

  # POST /turmas
  # POST /turmas.json
  def create
    @turma = Turma.new(params[:turma])
    @turma.unidade_id = current_unidade.id

    respond_to do |format|
      if @turma.save
        format.html { redirect_to turmas_url }
        format.json { render json: @turma, status: :created, location: @turma }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /turmas/1
  # PUT /turmas/1.json
  def update
    @turma = Turma.find(params[:id])

    respond_to do |format|
      if @turma.update_attributes(params[:turma])
        format.html { redirect_to turmas_url }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /turmas/1
  # DELETE /turmas/1.json
  def destroy
    @turma = Turma.find(params[:id])
    @turma.destroy

    respond_to do |format|
      format.html { redirect_to turmas_url }
      format.json { head :no_content }
    end
  end
end
