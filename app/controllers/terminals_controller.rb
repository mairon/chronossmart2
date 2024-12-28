class TerminalsController < ApplicationController
  # GET /terminals
  # GET /terminals.json
  def index
    @terminals = Terminal.where("unidade_id = #{current_unidade.id}")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @terminals }
    end
  end

  # GET /terminals/1
  # GET /terminals/1.json
  def show
    @terminal = Terminal.find(params[:id])
    render layout: 'chart'
  end

  # GET /terminals/new
  # GET /terminals/new.json
  def new
    @terminal = Terminal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @terminal }
    end
  end

  # GET /terminals/1/edit
  def edit
    @terminal = Terminal.find(params[:id])
  end

  # POST /terminals
  # POST /terminals.json
  def create
    @terminal = Terminal.new(params[:terminal])
    @terminal.unidade_id = current_unidade.id
    respond_to do |format|
      if @terminal.save
        format.html { redirect_to terminals_url }
        format.json { render json: @terminal, status: :created, location: @terminal }
      else
        format.html { render action: "new" }
        format.json { render json: @terminal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /terminals/1
  # PUT /terminals/1.json
  def update
    @terminal = Terminal.find(params[:id])    
    respond_to do |format|
      if @terminal.update_attributes(params[:terminal])
        format.html { redirect_to terminals_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @terminal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terminals/1
  # DELETE /terminals/1.json
  def destroy
    @terminal = Terminal.find(params[:id])
    @terminal.destroy

    respond_to do |format|
      format.html { redirect_to terminals_url }
      format.json { head :no_content }
    end
  end
end
