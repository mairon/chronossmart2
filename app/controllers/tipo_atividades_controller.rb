class TipoAtividadesController < ApplicationController
  # GET /tipo_atividades
  # GET /tipo_atividades.json
  def index
    @tipo_atividades = TipoAtividade.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tipo_atividades }
    end
  end

  # GET /tipo_atividades/1
  # GET /tipo_atividades/1.json
  def show
    @tipo_atividade = TipoAtividade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tipo_atividade }
    end
  end

  # GET /tipo_atividades/new
  # GET /tipo_atividades/new.json
  def new
    @tipo_atividade = TipoAtividade.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tipo_atividade }
    end
  end

  # GET /tipo_atividades/1/edit
  def edit
    @tipo_atividade = TipoAtividade.find(params[:id])
  end

  # POST /tipo_atividades
  # POST /tipo_atividades.json
  def create
    @tipo_atividade = TipoAtividade.new(params[:tipo_atividade])

    respond_to do |format|
      if @tipo_atividade.save
        format.html { redirect_to @tipo_atividade, notice: 'Tipo atividade was successfully created.' }
        format.json { render json: @tipo_atividade, status: :created, location: @tipo_atividade }
      else
        format.html { render action: "new" }
        format.json { render json: @tipo_atividade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tipo_atividades/1
  # PUT /tipo_atividades/1.json
  def update
    @tipo_atividade = TipoAtividade.find(params[:id])

    respond_to do |format|
      if @tipo_atividade.update_attributes(params[:tipo_atividade])
        format.html { redirect_to @tipo_atividade, notice: 'Tipo atividade was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tipo_atividade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_atividades/1
  # DELETE /tipo_atividades/1.json
  def destroy
    @tipo_atividade = TipoAtividade.find(params[:id])
    @tipo_atividade.destroy

    respond_to do |format|
      format.html { redirect_to tipo_atividades_url }
      format.json { head :no_content }
    end
  end
end
