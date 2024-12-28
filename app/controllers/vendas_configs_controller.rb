class VendasConfigsController < ApplicationController
  # GET /vendas_configs
  # GET /vendas_configs.json
  def index
    @vendas_configs = VendasConfig.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vendas_configs }
    end
  end

  # GET /vendas_configs/1
  # GET /vendas_configs/1.json
  def show
    @vendas_config = VendasConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vendas_config }
    end
  end

  # GET /vendas_configs/new
  # GET /vendas_configs/new.json
  def new
    @vendas_config = VendasConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vendas_config }
    end
  end

  # GET /vendas_configs/1/edit
  def edit
    @vendas_config = VendasConfig.find(params[:id])
    render layout: 'chart'
  end

  # POST /vendas_configs
  # POST /vendas_configs.json
  def create
    @vendas_config = VendasConfig.new(params[:vendas_config])

    respond_to do |format|
      if @vendas_config.save
        format.html { redirect_to vendas_configs_url }
        format.json { render json: @vendas_config, status: :created, location: @vendas_config }
      else
        format.html { render action: "new" }
        format.json { render json: @vendas_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vendas_configs/1
  # PUT /vendas_configs/1.json
  def update
    @vendas_config = VendasConfig.find(params[:id])

    respond_to do |format|
      if @vendas_config.update_attributes(params[:vendas_config])
        format.html { redirect_to vendas_configs_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vendas_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendas_configs/1
  # DELETE /vendas_configs/1.json
  def destroy
    @vendas_config = VendasConfig.find(params[:id])
    @vendas_config.destroy

    respond_to do |format|
      format.html { redirect_to vendas_configs_url }
      format.json { head :no_content }
    end
  end
end
