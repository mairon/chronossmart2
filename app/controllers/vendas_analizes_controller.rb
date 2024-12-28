class VendasAnalizesController < ApplicationController
  # GET /vendas_analizes
  # GET /vendas_analizes.json
  def index
    @vendas_analizes = VendasAnalize.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vendas_analizes }
    end
  end

  # GET /vendas_analizes/1
  # GET /vendas_analizes/1.json
  def show
    @vendas_analize = VendasAnalize.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vendas_analize }
    end
  end

  # GET /vendas_analizes/new
  # GET /vendas_analizes/new.json
  def new
    @vendas_analize = VendasAnalize.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vendas_analize }
    end
  end

  # GET /vendas_analizes/1/edit
  def edit
    @vendas_analize = VendasAnalize.find(params[:id])
  end

  # POST /vendas_analizes
  # POST /vendas_analizes.json
  def create
    @vendas_analize = VendasAnalize.new(params[:vendas_analize])

    respond_to do |format|
      if @vendas_analize.save
        format.html { redirect_to @vendas_analize, notice: 'Vendas analize was successfully created.' }
        format.json { render json: @vendas_analize, status: :created, location: @vendas_analize }
      else
        format.html { render action: "new" }
        format.json { render json: @vendas_analize.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vendas_analizes/1
  # PUT /vendas_analizes/1.json
  def update
    @vendas_analize = VendasAnalize.find(params[:id])

    respond_to do |format|
      if @vendas_analize.update_attributes(params[:vendas_analize])
        format.html { redirect_to @vendas_analize, notice: 'Vendas analize was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vendas_analize.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendas_analizes/1
  # DELETE /vendas_analizes/1.json
  def destroy
    @vendas_analize = VendasAnalize.find(params[:id])
    @vendas_analize.destroy

    respond_to do |format|
      format.html { redirect_to vendas_analizes_url }
      format.json { head :no_content }
    end
  end
end
