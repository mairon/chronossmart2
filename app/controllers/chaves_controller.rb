class ChavesController < ApplicationController
  # GET /chaves
  # GET /chaves.json
  def index
    @chaves = Chafe.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chaves }
    end
  end

  # GET /chaves/1
  # GET /chaves/1.json
  def show
    @chafe = Chafe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chafe }
    end
  end

  # GET /chaves/new
  # GET /chaves/new.json
  def new
    @chafe = Chafe.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chafe }
    end
  end

  # GET /chaves/1/edit
  def edit
    @chafe = Chafe.find(params[:id])
  end

  # POST /chaves
  # POST /chaves.json
  def create
    @chafe = Chafe.new(params[:chafe])

    respond_to do |format|
      if @chafe.save
        format.html { redirect_to chaves_url }
        format.json { render json: @chafe, status: :created, location: @chafe }
      else
        format.html { render action: "new" }
        format.json { render json: @chafe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /chaves/1
  # PUT /chaves/1.json
  def update
    @chafe = Chafe.find(params[:id])

    respond_to do |format|
      if @chafe.update_attributes(params[:chafe])
        format.html { redirect_to chaves_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @chafe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chaves/1
  # DELETE /chaves/1.json
  def destroy
    @chafe = Chafe.find(params[:id])
    @chafe.destroy

    respond_to do |format|
      format.html { redirect_to chaves_url }
      format.json { head :no_content }
    end
  end
end
