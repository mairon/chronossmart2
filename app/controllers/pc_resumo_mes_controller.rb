class PcResumoMesController < ApplicationController
  # GET /pc_resumo_mes
  # GET /pc_resumo_mes.json
  def index
    @pc_resumo_mes = PcResumoMe.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pc_resumo_mes }
    end
  end

  # GET /pc_resumo_mes/1
  # GET /pc_resumo_mes/1.json
  def show
    @pc_resumo_me = PcResumoMe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pc_resumo_me }
    end
  end

  # GET /pc_resumo_mes/new
  # GET /pc_resumo_mes/new.json
  def new
    @pc_resumo_me = PcResumoMe.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pc_resumo_me }
    end
  end

  # GET /pc_resumo_mes/1/edit
  def edit
    @pc_resumo_me = PcResumoMe.find(params[:id])
  end

  # POST /pc_resumo_mes
  # POST /pc_resumo_mes.json
  def create
    @pc_resumo_me = PcResumoMe.new(params[:pc_resumo_me])

    respond_to do |format|
      if @pc_resumo_me.save
        format.html { redirect_to @pc_resumo_me, notice: 'Pc resumo me was successfully created.' }
        format.json { render json: @pc_resumo_me, status: :created, location: @pc_resumo_me }
      else
        format.html { render action: "new" }
        format.json { render json: @pc_resumo_me.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pc_resumo_mes/1
  # PUT /pc_resumo_mes/1.json
  def update
    @pc_resumo_me = PcResumoMe.find(params[:id])

    respond_to do |format|
      if @pc_resumo_me.update_attributes(params[:pc_resumo_me])
        format.html { redirect_to @pc_resumo_me, notice: 'Pc resumo me was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pc_resumo_me.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pc_resumo_mes/1
  # DELETE /pc_resumo_mes/1.json
  def destroy
    @pc_resumo_me = PcResumoMe.find(params[:id])
    @pc_resumo_me.destroy

    respond_to do |format|
      format.html { redirect_to pc_resumo_mes_url }
      format.json { head :no_content }
    end
  end
end
