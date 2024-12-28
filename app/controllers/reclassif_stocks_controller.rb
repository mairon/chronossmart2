class ReclassifStocksController < ApplicationController
  before_filter :authenticate
  def index
    @reclassif_stocks = ReclassifStock.filtro_rs(params)
  end

  # GET /reclassif_stocks/1
  # GET /reclassif_stocks/1.xml
  def show
    @reclassif_stock = ReclassifStock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reclassif_stock }
    end
  end

  # GET /reclassif_stocks/new
  # GET /reclassif_stocks/new.xml
  def new
    @reclassif_stock = ReclassifStock.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reclassif_stock }
    end
  end

  # GET /reclassif_stocks/1/edit
  def edit
    @reclassif_stock = ReclassifStock.find(params[:id])
  end

  # POST /reclassif_stocks
  # POST /reclassif_stocks.xml
  def create
    @reclassif_stock = ReclassifStock.new(params[:reclassif_stock])

    respond_to do |format|
      if @reclassif_stock.save
        
        format.html { redirect_to(reclassif_stocks_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /reclassif_stocks/1
  # PUT /reclassif_stocks/1.xml
  def update
    @reclassif_stock = ReclassifStock.find(params[:id])

    respond_to do |format|
      if @reclassif_stock.update_attributes(params[:reclassif_stock])
        format.html { redirect_to(reclassif_stocks_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /reclassif_stocks/1
  # DELETE /reclassif_stocks/1.xml
  def destroy
    @reclassif_stock = ReclassifStock.find(params[:id])
    @reclassif_stock.destroy

    respond_to do |format|
      format.html { redirect_to(reclassif_stocks_url) }
      format.xml  { head :ok }
    end
  end
end
