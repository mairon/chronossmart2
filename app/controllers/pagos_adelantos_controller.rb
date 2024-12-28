class PagosAdelantosController < ApplicationController
  # GET /pagos_adelantos
  # GET /pagos_adelantos.json
  def index
    @pagos_adelantos = PagosAdelanto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pagos_adelantos }
    end
  end

  # GET /pagos_adelantos/1
  # GET /pagos_adelantos/1.json
  def show
    @pagos_adelanto = PagosAdelanto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pagos_adelanto }
    end
  end

  # GET /pagos_adelantos/new
  # GET /pagos_adelantos/new.json
  def new
    @pagos_adelanto = PagosAdelanto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pagos_adelanto }
    end
  end

  # GET /pagos_adelantos/1/edit
  def edit
    @pagos_adelanto = PagosAdelanto.find(params[:id])
  end

  # POST /pagos_adelantos
  # POST /pagos_adelantos.json
  def create
    @pagos_adelanto = PagosAdelanto.new(params[:pagos_adelanto])

    respond_to do |format|
      if @pagos_adelanto.save
        format.html { redirect_to "/pagos/#{@pagos_adelanto.pago_id}/pago_adelanto"}
        format.json { render json: @pagos_adelanto, status: :created, location: @pagos_adelanto }
      else
        format.html { render action: "new" }
        format.json { render json: @pagos_adelanto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pagos_adelantos/1
  # PUT /pagos_adelantos/1.json
  def update
    @pagos_adelanto = PagosAdelanto.find(params[:id])

    respond_to do |format|
      if @pagos_adelanto.update_attributes(params[:pagos_adelanto])
        format.html { redirect_to "/pagos/#{@pagos_adelanto.pago_id}/pago_adelanto"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pagos_adelanto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pagos_adelantos/1
  # DELETE /pagos_adelantos/1.json
  def destroy
    @pagos_adelanto = PagosAdelanto.find(params[:id])
    @pagos_adelanto.destroy

    respond_to do |format|
      format.html { redirect_to "/pagos/#{@pagos_adelanto.pago_id}/pago_adelanto"}
      format.json { head :no_content }
    end
  end
end
