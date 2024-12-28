class CobracasController < ApplicationController
  # GET /cobracas
  # GET /cobracas.json
  def index
    @cobracas = Cobraca.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cobracas }
    end
  end

  # GET /cobracas/1
  # GET /cobracas/1.json
  def show

    @cobraca = Cobraca.find(params[:id])
    @list_contas = Cobraca.list_contas(@cobraca)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cobraca }
    end
  end

  # GET /cobracas/new
  # GET /cobracas/new.json
  def new
    @cobraca = Cobraca.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cobraca }
    end
  end

  # GET /cobracas/1/edit
  def edit
    @cobraca = Cobraca.find(params[:id])
  end

  # POST /cobracas
  # POST /cobracas.json
  def create
    @cobraca = Cobraca.new(params[:cobraca])

    respond_to do |format|
      if @cobraca.save
        format.html { redirect_to @cobraca, notice: 'Cobraca was successfully created.' }
        format.json { render json: @cobraca, status: :created, location: @cobraca }
      else
        format.html { render action: "new" }
        format.json { render json: @cobraca.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cobracas/1
  # PUT /cobracas/1.json
  def update
    @cobraca = Cobraca.find(params[:id])

    respond_to do |format|
      if @cobraca.update_attributes(params[:cobraca])
        format.html { redirect_to @cobraca, notice: 'Cobraca was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cobraca.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cobracas/1
  # DELETE /cobracas/1.json
  def destroy
    @cobraca = Cobraca.find(params[:id])
    @cobraca.destroy

    respond_to do |format|
      format.html { redirect_to cobracas_url }
      format.json { head :no_content }
    end
  end
end
