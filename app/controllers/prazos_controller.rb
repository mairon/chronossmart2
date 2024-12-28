class PrazosController < ApplicationController
  # GET /prazos
  # GET /prazos.json
  def index
    @prazos = Prazo.order('nome')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @prazos }
    end
  end

  # GET /prazos/1
  # GET /prazos/1.json
  def show
    @prazo = Prazo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prazo }
    end
  end

  # GET /prazos/new
  # GET /prazos/new.json
  def new
    @prazo = Prazo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @prazo }
    end
  end

  # GET /prazos/1/edit
  def edit
    @prazo = Prazo.find(params[:id])
  end

  # POST /prazos
  # POST /prazos.json
  def create
    @prazo = Prazo.new(params[:prazo])

    respond_to do |format|
      if @prazo.save
        format.html { redirect_to prazos_url }
        format.json { render json: @prazo, status: :created, location: @prazo }
      else
        format.html { render action: "new" }
        format.json { render json: @prazo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /prazos/1
  # PUT /prazos/1.json
  def update
    @prazo = Prazo.find(params[:id])

    respond_to do |format|
      if @prazo.update_attributes(params[:prazo])
        format.html { redirect_to prazos_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @prazo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prazos/1
  # DELETE /prazos/1.json
  def destroy
    @prazo = Prazo.find(params[:id])
    @prazo.destroy

    respond_to do |format|
      format.html { redirect_to prazos_url }
      format.json { head :no_content }
    end
  end
end
