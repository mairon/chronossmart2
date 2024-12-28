class PainelClienteLogsController < ApplicationController
  # GET /painel_cliente_logs
  # GET /painel_cliente_logs.json
  def index
    @painel_cliente_logs = PainelClienteLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @painel_cliente_logs }
    end
  end

  # GET /painel_cliente_logs/1
  # GET /painel_cliente_logs/1.json
  def show
    @painel_cliente_log = PainelClienteLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @painel_cliente_log }
    end
  end

  # GET /painel_cliente_logs/new
  # GET /painel_cliente_logs/new.json
  def new
    @painel_cliente_log = PainelClienteLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @painel_cliente_log }
    end
  end

  # GET /painel_cliente_logs/1/edit
  def edit
    @painel_cliente_log = PainelClienteLog.find(params[:id])
  end

  # POST /painel_cliente_logs
  # POST /painel_cliente_logs.json
  def create
    @painel_cliente_log = PainelClienteLog.new(params[:painel_cliente_log])

    respond_to do |format|
      if @painel_cliente_log.save
        format.html { redirect_to @painel_cliente_log, notice: 'Painel cliente log was successfully created.' }
        format.json { render json: @painel_cliente_log, status: :created, location: @painel_cliente_log }
      else
        format.html { render action: "new" }
        format.json { render json: @painel_cliente_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /painel_cliente_logs/1
  # PUT /painel_cliente_logs/1.json
  def update
    @painel_cliente_log = PainelClienteLog.find(params[:id])

    respond_to do |format|
      if @painel_cliente_log.update_attributes(params[:painel_cliente_log])
        format.html { redirect_to @painel_cliente_log, notice: 'Painel cliente log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @painel_cliente_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /painel_cliente_logs/1
  # DELETE /painel_cliente_logs/1.json
  def destroy
    @painel_cliente_log = PainelClienteLog.find(params[:id])
    @painel_cliente_log.destroy

    respond_to do |format|
      format.html { redirect_to painel_cliente_logs_url }
      format.json { head :no_content }
    end
  end
end
