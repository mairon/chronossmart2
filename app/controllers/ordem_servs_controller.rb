class OrdemServsController < ApplicationController
  before_filter :authenticate

  def checklist
    @ordem_serv = OrdemServ.find(params[:id])
    render layout: 'chart'
  end

  def busca
    params[:unidade] = current_unidade.id
    @ordem_servs = OrdemServ.filtro(params)
    render :layout => false
  end

  def comprovante
    @ordem_serv = OrdemServ.find(params[:id])
    render layout: false
  end

  def index    
  end

  def show
    @ordem_serv = OrdemServ.find(params[:id])
    
    if params[:vs] == 'true'
      render layout: 'consulta'
    else
      render layout: 'chart'
    end
  end

  # GET /ordem_servs/new
  # GET /ordem_servs/new.json
  def new
    @ordem_serv = OrdemServ.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ordem_serv }
    end
  end

  # GET /ordem_servs/1/edit
  def edit
    @ordem_serv = OrdemServ.find(params[:id])
  end

  # POST /ordem_servs
  # POST /ordem_servs.json
  def create
    @ordem_serv = OrdemServ.new(params[:ordem_serv])
    @ordem_serv.usuario_created = current_user.id
    @ordem_serv.unidade_id = current_unidade.id
    @ordem_serv.status = 'PENDIENTE'


    respond_to do |format|
      if @ordem_serv.save
        format.html { redirect_to @ordem_serv, notice: 'Ordem serv was successfully created.' }
        format.json { render json: @ordem_serv, status: :created, location: @ordem_serv }
      else
        format.html { render action: "new" }
        format.json { render json: @ordem_serv.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ordem_servs/1
  # PUT /ordem_servs/1.json
  def update
    @ordem_serv = OrdemServ.find(params[:id])

    respond_to do |format|
      if @ordem_serv.update_attributes(params[:ordem_serv])
        if params[:tela] == 'checklist'
          format.html { redirect_to checklist_ordem_serv_path(@ordem_serv),  notice: 'Checklist Atualizado' }
        else
          format.html { redirect_to @ordem_serv }
        end
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /ordem_servs/1
  # DELETE /ordem_servs/1.json
  def destroy
    @ordem_serv = OrdemServ.find(params[:id])
    @ordem_serv.destroy

    respond_to do |format|
      format.html { redirect_to ordem_servs_url }
      format.json { head :no_content }
    end
  end
end
