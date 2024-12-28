class ApartamentosController < ApplicationController
  # GET /apartamentos
  # GET /apartamentos.json
  def index
    @apartamentos = Apartamento.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apartamentos }
    end
  end

  # GET /apartamentos/1
  # GET /apartamentos/1.json
  def show
    @apartamento = Apartamento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @apartamento }
    end
  end

  # GET /apartamentos/new
  # GET /apartamentos/new.json
  def new
    @apartamento = Apartamento.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @apartamento }
    end
  end

  # GET /apartamentos/1/edit
  def edit
    @apartamento = Apartamento.find(params[:id])
  end

  # POST /apartamentos
  # POST /apartamentos.json
  def create
    @apartamento = Apartamento.new(params[:apartamento])

    respond_to do |format|
      if @apartamento.save
        format.html { redirect_to predio_path(@apartamento.predio_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /apartamentos/1
  # PUT /apartamentos/1.json
  def update
    @apartamento = Apartamento.find(params[:id])

    respond_to do |format|
      if @apartamento.update_attributes(params[:apartamento])
        format.html { redirect_to predio_path(@apartamento.predio_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /apartamentos/1
  # DELETE /apartamentos/1.json
  def destroy
    @apartamento = Apartamento.find(params[:id])
    @apartamento.destroy

    respond_to do |format|
      format.html { redirect_to predio_path(@apartamento.predio_id) }
      format.json { head :no_content }
    end
  end
end
