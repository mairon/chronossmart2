class SeguimentosController < ApplicationController
  # GET /seguimentos
  # GET /seguimentos.json
  def index
    @seguimentos = Seguimento.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @seguimentos }
    end
  end

  # GET /seguimentos/1
  # GET /seguimentos/1.json
  def show
    @seguimento = Seguimento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @seguimento }
    end
  end

  # GET /seguimentos/new
  # GET /seguimentos/new.json
  def new
    @seguimento = Seguimento.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @seguimento }
    end
  end

  # GET /seguimentos/1/edit
  def edit
    @seguimento = Seguimento.find(params[:id])
  end

  # POST /seguimentos
  # POST /seguimentos.json
  def create
    @seguimento = Seguimento.new(params[:seguimento])

    respond_to do |format|
      if @seguimento.save
        format.html { redirect_to seguimentos_url }
        format.json { render json: @seguimento, status: :created, location: @seguimento }
      else
        format.html { render action: "new" }
        format.json { render json: @seguimento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /seguimentos/1
  # PUT /seguimentos/1.json
  def update
    @seguimento = Seguimento.find(params[:id])

    respond_to do |format|
      if @seguimento.update_attributes(params[:seguimento])
        format.html { redirect_to seguimentos_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @seguimento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seguimentos/1
  # DELETE /seguimentos/1.json
  def destroy
    @seguimento = Seguimento.find(params[:id])
    @seguimento.destroy

    respond_to do |format|
      format.html { redirect_to seguimentos_url }
      format.json { head :no_content }
    end
  end
end
