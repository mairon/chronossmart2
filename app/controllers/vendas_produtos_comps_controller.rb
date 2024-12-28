class VendasProdutosCompsController < ApplicationController
  # GET /vendas_produtos_comps
  # GET /vendas_produtos_comps.json
  def index
    @vendas_produtos_comps = VendasProdutosComp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vendas_produtos_comps }
    end
  end

  # GET /vendas_produtos_comps/1
  # GET /vendas_produtos_comps/1.json
  def show
    @vendas_produtos_comp = VendasProdutosComp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vendas_produtos_comp }
    end
  end

  # GET /vendas_produtos_comps/new
  # GET /vendas_produtos_comps/new.json
  def new
    @vendas_produtos_comp = VendasProdutosComp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vendas_produtos_comp }
    end
  end

  # GET /vendas_produtos_comps/1/edit
  def edit
    @vendas_produtos_comp = VendasProdutosComp.find(params[:id])
  end

  # POST /vendas_produtos_comps
  # POST /vendas_produtos_comps.json
  def create
    @vendas_produtos_comp = VendasProdutosComp.new(params[:vendas_produtos_comp])

    respond_to do |format|
      if @vendas_produtos_comp.save
        format.html { redirect_to @vendas_produtos_comp, notice: 'Vendas produtos comp was successfully created.' }
        format.json { render json: @vendas_produtos_comp, status: :created, location: @vendas_produtos_comp }
      else
        format.html { render action: "new" }
        format.json { render json: @vendas_produtos_comp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vendas_produtos_comps/1
  # PUT /vendas_produtos_comps/1.json
  def update
    @vendas_produtos_comp = VendasProdutosComp.find(params[:id])

    respond_to do |format|
      if @vendas_produtos_comp.update_attributes(params[:vendas_produtos_comp])
        format.html { redirect_to @vendas_produtos_comp, notice: 'Vendas produtos comp was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vendas_produtos_comp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendas_produtos_comps/1
  # DELETE /vendas_produtos_comps/1.json
  def destroy
    @vendas_produtos_comp = VendasProdutosComp.find(params[:id])
    @vendas_produtos_comp.destroy

    respond_to do |format|
      format.html { redirect_to vendas_produtos_comps_url }
      format.json { head :no_content }
    end
  end
end
