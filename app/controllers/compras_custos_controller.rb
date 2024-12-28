class ComprasCustosController < ApplicationController
  # GET /compras_custos
  # GET /compras_custos.json
  def index
    @compras_custos = ComprasCusto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @compras_custos }
    end
  end

  # GET /compras_custos/1
  # GET /compras_custos/1.json
  def show
    @compras_custo = ComprasCusto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @compras_custo }
    end
  end

  # GET /compras_custos/new
  # GET /compras_custos/new.json
  def new
    @compras_custo = ComprasCusto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @compras_custo }
    end
  end

  # GET /compras_custos/1/edit
  def edit
    @compras_custo = ComprasCusto.find(params[:id])
  end

  # POST /compras_custos
  # POST /compras_custos.json
  def create
    @compras_custo = ComprasCusto.new(params[:compras_custo])
    venc = 0
    @compras_custo.plano_de_conta.competencia.to_i.times do |rc|
      ComprasCusto.create(  
        :compra_id       => @compras_custo.compra_id,
        :moeda           => @compras_custo.moeda,
        :unidade_id      => @compras_custo.unidade_id,
        :rodado_id      => @compras_custo.rodado_id,
        :funcionario_id      => @compras_custo.funcionario_id,
        :centro_custo_id => @compras_custo.centro_custo_id,
        :rubro_grupo_id  => @compras_custo.rubro_grupo_id,
        :plano_de_conta_id  => @compras_custo.plano_de_conta_id,
        :valor_us        => @compras_custo.valor_us / @compras_custo.plano_de_conta.competencia.to_i,
        :valor_gs        => @compras_custo.valor_gs / @compras_custo.plano_de_conta.competencia.to_i,
        :valor_rs        => @compras_custo.valor_rs / @compras_custo.plano_de_conta.competencia.to_i,
        :data            => @compras_custo.compra.competencia.to_date.months_since(venc.to_i),

      )
      venc += 1
    end
    redirect_to "/compras/#{@compras_custo.compra_id}/compras_custos"
  end

  # PUT /compras_custos/1
  # PUT /compras_custos/1.json
  def update
    @compras_custo = ComprasCusto.find(params[:id])

    respond_to do |format|
      if @compras_custo.update_attributes(params[:compras_custo])
        format.html { redirect_to @compras_custo, notice: 'Compras custo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @compras_custo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compras_custos/1
  # DELETE /compras_custos/1.json
  def destroy
    @compras_custo = ComprasCusto.find(params[:id])
    @compras_custo.destroy

    respond_to do |format|
      format.html { redirect_to "/compras/#{@compras_custo.compra_id}/compras_custos" }
      format.json { head :no_content }
    end
  end
end
