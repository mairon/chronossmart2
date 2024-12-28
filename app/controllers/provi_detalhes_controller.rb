class ProviDetalhesController < ApplicationController
  # GET /provi_detalhes
  # GET /provi_detalhes.json
  def index
    @provi_detalhes = ProviDetalhe.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @provi_detalhes }
    end
  end

  # GET /provi_detalhes/1
  # GET /provi_detalhes/1.json
  def show
    @provi_detalhe = ProviDetalhe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @provi_detalhe }
    end
  end

  # GET /provi_detalhes/new
  # GET /provi_detalhes/new.json
  def new
    @provi_detalhe = ProviDetalhe.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @provi_detalhe }
    end
  end

  # GET /provi_detalhes/1/edit
  def edit
    @provi_detalhe = ProviDetalhe.find(params[:id])
  end

  # POST /provi_detalhes
  # POST /provi_detalhes.json
  def create
    @provi_detalhe = ProviDetalhe.new(params[:provi_detalhe])

    respond_to do |format|
      if @provi_detalhe.save
        format.html { redirect_to @provi_detalhe, notice: 'Provi detalhe was successfully created.' }
        format.json { render json: @provi_detalhe, status: :created, location: @provi_detalhe }
      else
        format.html { render action: "new" }
        format.json { render json: @provi_detalhe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /provi_detalhes/1
  # PUT /provi_detalhes/1.json
  def update
    @provi_detalhe = ProviDetalhe.find(params[:id])

    respond_to do |format|
      if @provi_detalhe.update_attributes(params[:provi_detalhe])
        format.html { redirect_to @provi_detalhe, notice: 'Provi detalhe was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @provi_detalhe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provi_detalhes/1
  # DELETE /provi_detalhes/1.json
  def destroy
    @provi_detalhe = ProviDetalhe.find(params[:id])
    @provi_detalhe.destroy

    respond_to do |format|
      format.html { redirect_to provi_detalhes_url }
      format.json { head :no_content }
    end
  end
end
