class ContratoCustosController < ApplicationController
  # GET /contrato_custos
  # GET /contrato_custos.json
  def index
    @contrato_custos = ContratoCusto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contrato_custos }
    end
  end

  # GET /contrato_custos/1
  # GET /contrato_custos/1.json
  def show
    @contrato_custo = ContratoCusto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contrato_custo }
    end
  end

  # GET /contrato_custos/new
  # GET /contrato_custos/new.json
  def new
    @contrato_custo = ContratoCusto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contrato_custo }
    end
  end

  # GET /contrato_custos/1/edit
  def edit
    @contrato_custo = ContratoCusto.find(params[:id])
  end

  # POST /contrato_custos
  # POST /contrato_custos.json
  def create
    @contrato_custo = ContratoCusto.new(params[:contrato_custo])

    respond_to do |format|
      if @contrato_custo.save


      #gera valors referentes ao tempo de contrato 
      ("#{@contrato_custo.contrato.data.to_date.strftime("01/%m/%Y")}".to_date.beginning_of_month.."#{@contrato_custo.contrato.data_final.to_date.strftime("01/%m/%Y")}".to_date.beginning_of_month).each do |date| 
          if date.day == 1
            ContratoCustoDt.create(
              data: date.strftime("%Y-%m-%d"),
              contrato_id: @contrato_custo.contrato_id,
              contrato_custo_id: @contrato_custo.id,
              persona_id: @contrato_custo.persona_id,
              valor_gs:  @contrato_custo.valor_gs,
              valor_rs: @contrato_custo.valor_rs,
              valor_us: @contrato_custo.valor_us
            )

          end
        end


        format.html { redirect_to contrato_path(@contrato_custo.contrato_id)}
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /contrato_custos/1
  # PUT /contrato_custos/1.json
  def update
    @contrato_custo = ContratoCusto.find(params[:id])

    respond_to do |format|
      if @contrato_custo.update_attributes(params[:contrato_custo])
        format.html { redirect_to contrato_path(@contrato_custo.contrato_id)}
      else
        format.html { render action: "edit" }        
      end
    end
  end

  # DELETE /contrato_custos/1
  # DELETE /contrato_custos/1.json
  def destroy
    @contrato_custo = ContratoCusto.find(params[:id])
    @contrato_custo.destroy

    respond_to do |format|
      format.html { redirect_to contrato_path(@contrato_custo.contrato_id)}
      format.json { head :no_content }
    end
  end
end
