class ComissaosController < ApplicationController
  # GET /comissaos
  # GET /comissaos.json
  def index
    @comissaos = Comissao.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comissaos }
    end
  end

  # GET /comissaos/1
  # GET /comissaos/1.json
  def show
    @comissao = Comissao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comissao }
    end
  end

  # GET /comissaos/new
  # GET /comissaos/new.json
  def new
    @comissao = Comissao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comissao }
    end
  end

  # GET /comissaos/1/edit
  def edit
    @comissao = Comissao.find(params[:id])
  end

  # POST /comissaos
  # POST /comissaos.json
  def create
    @comissao = Comissao.new(params[:comissao])

    respond_to do |format|
      if @comissao.save
        format.html { redirect_to @comissao, notice: 'Comissao was successfully created.' }
        format.json { render json: @comissao, status: :created, location: @comissao }
      else
        format.html { render action: "new" }
        format.json { render json: @comissao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comissaos/1
  # PUT /comissaos/1.json
  def update
    @comissao = Comissao.find(params[:id])

    respond_to do |format|
      if @comissao.update_attributes(params[:comissao])
        format.html { redirect_to @comissao, notice: 'Comissao was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comissao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comissaos/1
  # DELETE /comissaos/1.json
  def destroy
    @comissao = Comissao.find(params[:id])
    @comissao.destroy

    respond_to do |format|
      format.html { redirect_to comissaos_url }
      format.json { head :no_content }
    end
  end
end
