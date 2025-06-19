class VendasOrdemServsController < ApplicationController
  # GET /vendas_ordem_servs
  # GET /vendas_ordem_servs.json
  def index
    @vendas_ordem_servs = VendasOrdemServ.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vendas_ordem_servs }
    end
  end

  # GET /vendas_ordem_servs/1
  # GET /vendas_ordem_servs/1.json
  def show
    @vendas_ordem_serv = VendasOrdemServ.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vendas_ordem_serv }
    end
  end

  # GET /vendas_ordem_servs/new
  # GET /vendas_ordem_servs/new.json
  def new
    @vendas_ordem_serv = VendasOrdemServ.new
    render layout: false
  end

  # GET /vendas_ordem_servs/1/edit
  def edit
    @vendas_ordem_serv = VendasOrdemServ.find(params[:id])
  end

  # POST /vendas_ordem_servs
  # POST /vendas_ordem_servs.json
  def create
    @vendas_ordem_serv = VendasOrdemServ.new(params[:vendas_ordem_serv])

    respond_to do |format|
      if @vendas_ordem_serv.save
        format.html { redirect_to venda_path(@vendas_ordem_serv.venda_id)}
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /vendas_ordem_servs/1
  # PUT /vendas_ordem_servs/1.json
  def update
    @vendas_ordem_serv = VendasOrdemServ.find(params[:id])

    respond_to do |format|
      if @vendas_ordem_serv.update_attributes(params[:vendas_ordem_serv])
        format.html { redirect_to venda_path(@vendas_ordem_serv.venda_id)}        
      else
        format.html { render action: "edit" }        
      end
    end
  end

  # DELETE /vendas_ordem_servs/1
  # DELETE /vendas_ordem_servs/1.json
  def destroy
    @vendas_ordem_serv = VendasOrdemServ.find(params[:id])
    @vendas_ordem_serv.destroy

    respond_to do |format|
      format.html { redirect_to venda_path(@vendas_ordem_serv.venda_id)}
      format.json { head :no_content }
    end
  end
end
