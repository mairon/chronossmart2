class TerminalContasController < ApplicationController
  # GET /terminal_contas
  # GET /terminal_contas.json
  def index
    @terminal_contas = TerminalConta.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @terminal_contas }
    end
  end

  # GET /terminal_contas/1
  # GET /terminal_contas/1.json
  def show
    @terminal_conta = TerminalConta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @terminal_conta }
    end
  end

  # GET /terminal_contas/new
  # GET /terminal_contas/new.json
  def new
    @terminal_conta = TerminalConta.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @terminal_conta }
    end
  end

  # GET /terminal_contas/1/edit
  def edit
    @terminal_conta = TerminalConta.find(params[:id])
  end

  # POST /terminal_contas
  # POST /terminal_contas.json
  def create
    @terminal_conta = TerminalConta.new(params[:terminal_conta])

    respond_to do |format|
      if @terminal_conta.save
        format.html { redirect_to "/terminals/#{@terminal_conta.terminal_id}" }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /terminal_contas/1
  # PUT /terminal_contas/1.json
  def update
    @terminal_conta = TerminalConta.find(params[:id])

    respond_to do |format|
      if @terminal_conta.update_attributes(params[:terminal_conta])
        format.html { redirect_to "/terminals/#{@terminal_conta.terminal_id}" }
        
      else
        format.html { render action: "edit" }
        
      end
    end
  end

  # DELETE /terminal_contas/1
  # DELETE /terminal_contas/1.json
  def destroy
    @terminal_conta = TerminalConta.find(params[:id])
    @terminal_conta.destroy

    respond_to do |format|
      format.html { redirect_to "/terminals/#{@terminal_conta.terminal_id}" }
    end
  end
end
