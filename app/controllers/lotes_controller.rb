class LotesController < ApplicationController
  # GET /lotes
  # GET /lotes.json
  def index
    @lotes = Lote.all

    render layout: 'chart'
  end

  # GET /lotes/1
  # GET /lotes/1.json
  def show
    @lote = Lote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lote }
    end
  end

  # GET /lotes/new
  # GET /lotes/new.json
  def new
    @lote = Lote.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lote }
    end
  end

  # GET /lotes/1/edit
  def edit
    @lote = Lote.find(params[:id])
  end

  # POST /lotes
  # POST /lotes.json
  def create
    @lote = Lote.new(params[:lote])

    respond_to do |format|
      if @lote.save
        format.html { redirect_to lotes_url }
      else
        format.html { render action: "new" }        
      end
    end
  end

  # PUT /lotes/1
  # PUT /lotes/1.json
  def update
    @lote = Lote.find(params[:id])

    respond_to do |format|
      if @lote.update_attributes(params[:lote])
        format.html { redirect_to lotes_url }
      else
        format.html { render action: "edit" }
        
      end
    end
  end

  # DELETE /lotes/1
  # DELETE /lotes/1.json
  def destroy
    @lote = Lote.find(params[:id])
    @lote.destroy

    respond_to do |format|
      format.html { redirect_to lotes_url }
    end
  end
end
