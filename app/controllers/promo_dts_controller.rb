class PromoDtsController < ApplicationController
  # GET /promo_dts
  # GET /promo_dts.json
  def index
    @promo_dts = PromoDt.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @promo_dts }
    end
  end

  # GET /promo_dts/1
  # GET /promo_dts/1.json
  def show
    @promo_dt = PromoDt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @promo_dt }
    end
  end

  # GET /promo_dts/new
  # GET /promo_dts/new.json
  def new
    @promo_dt = PromoDt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @promo_dt }
    end
  end

  # GET /promo_dts/1/edit
  def edit
    @promo_dt = PromoDt.find(params[:id])
  end

  # POST /promo_dts
  # POST /promo_dts.json
  def create
    @promo_dt = PromoDt.new(params[:promo_dt])

    respond_to do |format|
      if @promo_dt.save
        format.html { redirect_to promo_path(@promo_dt.promo_id) }
        format.json { render json: @promo_dt, status: :created, location: @promo_dt }
      else
        format.html { render action: "new" }
        format.json { render json: @promo_dt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /promo_dts/1
  # PUT /promo_dts/1.json
  def update
    @promo_dt = PromoDt.find(params[:id])

    respond_to do |format|
      if @promo_dt.update_attributes(params[:promo_dt])
        format.html { redirect_to promo_path(@promo_dt.promo_id) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @promo_dt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promo_dts/1
  # DELETE /promo_dts/1.json
  def destroy
    @promo_dt = PromoDt.find(params[:id])
    @promo_dt.destroy

    respond_to do |format|
      format.html { redirect_to promo_path(@promo_dt.promo_id) }
      format.json { head :no_content }
    end
  end
end
