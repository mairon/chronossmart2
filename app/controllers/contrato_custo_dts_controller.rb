class ContratoCustoDtsController < ApplicationController
  # GET /contrato_custo_dts
  # GET /contrato_custo_dts.json
  def index
    @contrato_custo_dts = ContratoCustoDt.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contrato_custo_dts }
    end
  end

  # GET /contrato_custo_dts/1
  # GET /contrato_custo_dts/1.json
  def show
    @contrato_custo_dt = ContratoCustoDt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contrato_custo_dt }
    end
  end

  # GET /contrato_custo_dts/new
  # GET /contrato_custo_dts/new.json
  def new
    @contrato_custo_dt = ContratoCustoDt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contrato_custo_dt }
    end
  end

  # GET /contrato_custo_dts/1/edit
  def edit
    @contrato_custo_dt = ContratoCustoDt.find(params[:id])
  end

  # POST /contrato_custo_dts
  # POST /contrato_custo_dts.json
  def create
    @contrato_custo_dt = ContratoCustoDt.new(params[:contrato_custo_dt])

    respond_to do |format|
      if @contrato_custo_dt.save
        format.html { redirect_to @contrato_custo_dt, notice: 'Contrato custo dt was successfully created.' }
        format.json { render json: @contrato_custo_dt, status: :created, location: @contrato_custo_dt }
      else
        format.html { render action: "new" }
        format.json { render json: @contrato_custo_dt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contrato_custo_dts/1
  # PUT /contrato_custo_dts/1.json
  def update
    @contrato_custo_dt = ContratoCustoDt.find(params[:id])

    respond_to do |format|
      if @contrato_custo_dt.update_attributes(params[:contrato_custo_dt])
        format.html { redirect_to @contrato_custo_dt, notice: 'Contrato custo dt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contrato_custo_dt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contrato_custo_dts/1
  # DELETE /contrato_custo_dts/1.json
  def destroy
    @contrato_custo_dt = ContratoCustoDt.find(params[:id])
    @contrato_custo_dt.destroy

    respond_to do |format|
      format.html { redirect_to contrato_custo_dts_url }
      format.json { head :no_content }
    end
  end
end
