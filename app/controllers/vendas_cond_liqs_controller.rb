class VendasCondLiqsController < ApplicationController
  # GET /vendas_cond_liqs
  # GET /vendas_cond_liqs.json
  def index
    @vendas_cond_liqs = VendasCondLiq.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vendas_cond_liqs }
    end
  end

  # GET /vendas_cond_liqs/1
  # GET /vendas_cond_liqs/1.json
  def show
    @vendas_cond_liq = VendasCondLiq.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vendas_cond_liq }
    end
  end

  # GET /vendas_cond_liqs/new
  # GET /vendas_cond_liqs/new.json
  def new
    @vendas_cond_liq = VendasCondLiq.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vendas_cond_liq }
    end
  end

  # GET /vendas_cond_liqs/1/edit
  def edit
    @vendas_cond_liq = VendasCondLiq.find(params[:id])
  end

  # POST /vendas_cond_liqs
  # POST /vendas_cond_liqs.json
  def create
    @vendas_cond_liq = VendasCondLiq.new(params[:vendas_cond_liq])

    respond_to do |format|
      if @vendas_cond_liq.save
        format.html { redirect_to "/vendas/#{@vendas_cond_liq.venda_id}/cond_liqs" }
        format.json { render json: @vendas_cond_liq, status: :created, location: @vendas_cond_liq }
      else
        format.html { render action: "new" }
        format.json { render json: @vendas_cond_liq.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vendas_cond_liqs/1
  # PUT /vendas_cond_liqs/1.json
  def update
    @vendas_cond_liq = VendasCondLiq.find(params[:id])

    respond_to do |format|
      if @vendas_cond_liq.update_attributes(params[:vendas_cond_liq])
        format.html { redirect_to "/vendas/#{@vendas_cond_liq.venda_id}/cond_liqs" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vendas_cond_liq.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendas_cond_liqs/1
  # DELETE /vendas_cond_liqs/1.json
  def destroy
    @vendas_cond_liq = VendasCondLiq.find(params[:id])
    @vendas_cond_liq.destroy

    respond_to do |format|
      format.html { redirect_to "/vendas/#{@vendas_cond_liq.venda_id}/cond_liqs" }
      format.json { head :no_content }
    end
  end
end
