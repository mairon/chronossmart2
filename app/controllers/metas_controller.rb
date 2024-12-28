class MetasController < ApplicationController
  # GET /metas
  # GET /metas.json
  def index
    @metas = Meta.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @metas }
    end
  end

  # GET /metas/1
  # GET /metas/1.json
  def show
    @meta = Meta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meta }
    end
  end

  # GET /metas/new
  # GET /metas/new.json
  def new
    @meta = Meta.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meta }
    end
  end

  # GET /metas/1/edit
  def edit
    @meta = Meta.find(params[:id])
  end

  # POST /metas
  # POST /metas.json
  def create
    @meta = Meta.new(params[:meta])

    respond_to do |format|
      if @meta.save
        format.html { redirect_to @meta, notice: 'Meta was successfully created.' }
        format.json { render json: @meta, status: :created, location: @meta }
      else
        format.html { render action: "new" }
        format.json { render json: @meta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /metas/1
  # PUT /metas/1.json
  def update
    @meta = Meta.find(params[:id])

    respond_to do |format|
      if @meta.update_attributes(params[:meta])
        format.html { redirect_to @meta, notice: 'Meta was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @meta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metas/1
  # DELETE /metas/1.json
  def destroy
    @meta = Meta.find(params[:id])
    @meta.destroy

    respond_to do |format|
      format.html { redirect_to metas_url }
      format.json { head :no_content }
    end
  end
end
