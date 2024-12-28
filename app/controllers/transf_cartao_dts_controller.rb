class TransfCartaoDtsController < ApplicationController
  # GET /transf_cartao_dts
  # GET /transf_cartao_dts.json
  def index
    @transf_cartao_dts = TransfCartaoDt.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transf_cartao_dts }
    end
  end

  # GET /transf_cartao_dts/1
  # GET /transf_cartao_dts/1.json
  def show
    @transf_cartao_dt = TransfCartaoDt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transf_cartao_dt }
    end
  end

  # GET /transf_cartao_dts/new
  # GET /transf_cartao_dts/new.json
  def new
    @transf_cartao_dt = TransfCartaoDt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transf_cartao_dt }
    end
  end

  # GET /transf_cartao_dts/1/edit
  def edit
    @transf_cartao_dt = TransfCartaoDt.find(params[:id])
  end

  # POST /transf_cartao_dts
  # POST /transf_cartao_dts.json
  def create
    @transf_cartao_dt = TransfCartaoDt.new(params[:transf_cartao_dt])

    respond_to do |format|
      if @transf_cartao_dt.save
        format.html { redirect_to @transf_cartao_dt, notice: 'Transf cartao dt was successfully created.' }
        format.json { render json: @transf_cartao_dt, status: :created, location: @transf_cartao_dt }
      else
        format.html { render action: "new" }
        format.json { render json: @transf_cartao_dt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /transf_cartao_dts/1
  # PUT /transf_cartao_dts/1.json
  def update
    @transf_cartao_dt = TransfCartaoDt.find(params[:id])

    respond_to do |format|
      if @transf_cartao_dt.update_attributes(params[:transf_cartao_dt])
        format.html { redirect_to "/transf_cartaos/#{@transf_cartao_dt.transf_cartao_id}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @transf_cartao_dt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transf_cartao_dts/1
  # DELETE /transf_cartao_dts/1.json
  def destroy
    @transf_cartao_dt = TransfCartaoDt.find(params[:id])
    @transf_cartao_dt.destroy

    respond_to do |format|
      format.html { redirect_to "/transf_cartaos/#{@transf_cartao_dt.transf_cartao_id}" }
      format.json { head :no_content }
    end
  end
end
