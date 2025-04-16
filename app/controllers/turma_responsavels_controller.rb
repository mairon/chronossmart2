class TurmaResponsavelsController < ApplicationController
  # GET /turma_responsavels
  # GET /turma_responsavels.json
  def index
    @turma_responsavels = TurmaResponsavel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @turma_responsavels }
    end
  end

  # GET /turma_responsavels/1
  # GET /turma_responsavels/1.json
  def show
    @turma_responsavel = TurmaResponsavel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @turma_responsavel }
    end
  end

  # GET /turma_responsavels/new
  # GET /turma_responsavels/new.json
  def new
    @turma_responsavel = TurmaResponsavel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @turma_responsavel }
    end
  end

  # GET /turma_responsavels/1/edit
  def edit
    @turma_responsavel = TurmaResponsavel.find(params[:id])
  end

  # POST /turma_responsavels
  # POST /turma_responsavels.json
  def create
    @turma_responsavel = TurmaResponsavel.new(params[:turma_responsavel])

    respond_to do |format|
      if @turma_responsavel.save
        format.html { redirect_to turma_path(@turma_responsavel.turma_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /turma_responsavels/1
  # PUT /turma_responsavels/1.json
  def update
    @turma_responsavel = TurmaResponsavel.find(params[:id])

    respond_to do |format|
      if @turma_responsavel.update_attributes(params[:turma_responsavel])
        format.html { redirect_to turma_path(@turma_responsavel.turma_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /turma_responsavels/1
  # DELETE /turma_responsavels/1.json
  def destroy
    @turma_responsavel = TurmaResponsavel.find(params[:id])
    @turma_responsavel.destroy

    respond_to do |format|
      format.html { redirect_to turma_path(@turma_responsavel.turma_id) }
      format.json { head :no_content }
    end
  end
end
