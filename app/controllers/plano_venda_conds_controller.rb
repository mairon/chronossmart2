class PlanoVendaCondsController < ApplicationController
  # GET /plano_venda_conds
  # GET /plano_venda_conds.json
  def index
    @plano_venda_conds = PlanoVendaCond.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plano_venda_conds }
    end
  end

  # GET /plano_venda_conds/1
  # GET /plano_venda_conds/1.json
  def show
    @plano_venda_cond = PlanoVendaCond.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plano_venda_cond }
    end
  end

  # GET /plano_venda_conds/new
  # GET /plano_venda_conds/new.json
  def new
    @plano_venda_cond = PlanoVendaCond.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plano_venda_cond }
    end
  end

  # GET /plano_venda_conds/1/edit
  def edit
    @plano_venda_cond = PlanoVendaCond.find(params[:id])
  end

  # POST /plano_venda_conds
  # POST /plano_venda_conds.json
  def create
    @plano_venda_cond = PlanoVendaCond.new(params[:plano_venda_cond])

    respond_to do |format|
      if @plano_venda_cond.save
        format.html { redirect_to plano_venda_path(@plano_venda_cond.plano_venda_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /plano_venda_conds/1
  # PUT /plano_venda_conds/1.json
  def update
    @plano_venda_cond = PlanoVendaCond.find(params[:id])

    respond_to do |format|
      if @plano_venda_cond.update_attributes(params[:plano_venda_cond])
        format.html { redirect_to plano_venda_path(@plano_venda_cond.plano_venda_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /plano_venda_conds/1
  # DELETE /plano_venda_conds/1.json
  def destroy
    @plano_venda_cond = PlanoVendaCond.find(params[:id])
    @plano_venda_cond.destroy

    respond_to do |format|
      format.html { redirect_to plano_venda_path(@plano_venda_cond.plano_venda_id) }
    end
  end
end
