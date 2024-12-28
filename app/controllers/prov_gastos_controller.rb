class ProvGastosController < ApplicationController
  # GET /prov_gastos
  # GET /prov_gastos.json
  def index
    @prov_gasto = ProvGasto.new
    @prov_gastos = ProvGasto.where(unidade_id: current_unidade.id).order('id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @prov_gastos }
    end
  end

  # GET /prov_gastos/1
  # GET /prov_gastos/1.json
  def show
    @prov_gasto = ProvGasto.find(params[:id])
    @cotas_prov = Proveedore.where(tabela: 'PROV_GASTOS', tabela_id: @prov_gasto.id).order(:id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prov_gasto }
    end
  end

  # GET /prov_gastos/new
  # GET /prov_gastos/new.json
  def new
    @prov_gasto = ProvGasto.new
  end

  # GET /prov_gastos/1/edit
  def edit
    @prov_gasto = ProvGasto.find(params[:id])
  end

  # POST /prov_gastos
  # POST /prov_gastos.json
  def create
    @prov_gasto = ProvGasto.new(params[:prov_gasto])
    @prov_gasto.usuario_created = current_user.id

    respond_to do |format|
      if @prov_gasto.save
        format.html { redirect_to @prov_gasto }

      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /prov_gastos/1
  # PUT /prov_gastos/1.json
  def update
    @prov_gasto = ProvGasto.find(params[:id])

    respond_to do |format|
      if @prov_gasto.update_attributes(params[:prov_gasto])
        format.html { redirect_to @prov_gasto }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @prov_gasto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prov_gastos/1
  # DELETE /prov_gastos/1.json
  def destroy
    @prov_gasto = ProvGasto.find(params[:id])
    @prov_gasto.destroy

    respond_to do |format|
      format.html { redirect_to prov_gastos_url }
      format.json { head :no_content }
    end
  end
end
