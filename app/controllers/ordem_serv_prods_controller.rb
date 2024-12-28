class OrdemServProdsController < ApplicationController
  # GET /ordem_serv_prods
  # GET /ordem_serv_prods.json
  def index
    @ordem_serv_prods = OrdemServProd.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ordem_serv_prods }
    end
  end

  # GET /ordem_serv_prods/1
  # GET /ordem_serv_prods/1.json
  def show
    @ordem_serv_prod = OrdemServProd.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ordem_serv_prod }
    end
  end

  # GET /ordem_serv_prods/new
  # GET /ordem_serv_prods/new.json
  def new
    @ordem_serv_prod = OrdemServProd.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ordem_serv_prod }
    end
  end

  # GET /ordem_serv_prods/1/edit
  def edit
    @ordem_serv_prod = OrdemServProd.find(params[:id])
  end

  # POST /ordem_serv_prods
  # POST /ordem_serv_prods.json
  def create
    @ordem_serv_prod = OrdemServProd.new(params[:ordem_serv_prod])

    respond_to do |format|
      if @ordem_serv_prod.save
        format.html { redirect_to ordem_serv_path(@ordem_serv_prod.ordem_serv_id) }
        
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /ordem_serv_prods/1
  # PUT /ordem_serv_prods/1.json
  def update
    @ordem_serv_prod = OrdemServProd.find(params[:id])

    respond_to do |format|
      if @ordem_serv_prod.update_attributes(params[:ordem_serv_prod])
        format.html { redirect_to ordem_serv_path(@ordem_serv_prod.ordem_serv_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /ordem_serv_prods/1
  # DELETE /ordem_serv_prods/1.json
  def destroy
    @ordem_serv_prod = OrdemServProd.find(params[:id])
    @ordem_serv_prod.destroy

    respond_to do |format|
      format.html { redirect_to ordem_serv_path(@ordem_serv_prod.ordem_serv_id) }
      format.json { head :no_content }
    end
  end
end
