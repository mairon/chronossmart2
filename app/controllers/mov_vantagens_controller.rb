class MovVantagensController < ApplicationController
  # GET /mov_vantagens
  # GET /mov_vantagens.json
  def index
    @mov_vantagens = MovVantagen.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mov_vantagens }
    end
  end

  # GET /mov_vantagens/1
  # GET /mov_vantagens/1.json
  def show
    @mov_vantagen = MovVantagen.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mov_vantagen }
    end
  end

  # GET /mov_vantagens/new
  # GET /mov_vantagens/new.json
  def new
    @mov_vantagen = MovVantagen.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mov_vantagen }
    end
  end

  # GET /mov_vantagens/1/edit
  def edit
    @mov_vantagen = MovVantagen.find(params[:id])
  end

  # POST /mov_vantagens
  # POST /mov_vantagens.json
  def create
    @mov_vantagen = MovVantagen.new(params[:mov_vantagen])

    respond_to do |format|
      if @mov_vantagen.save
        format.html { redirect_to @mov_vantagen, notice: 'Mov vantagen was successfully created.' }
        format.json { render json: @mov_vantagen, status: :created, location: @mov_vantagen }
      else
        format.html { render action: "new" }
        format.json { render json: @mov_vantagen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mov_vantagens/1
  # PUT /mov_vantagens/1.json
  def update
    @mov_vantagen = MovVantagen.find(params[:id])

    respond_to do |format|
      if @mov_vantagen.update_attributes(params[:mov_vantagen])
        format.html { redirect_to @mov_vantagen, notice: 'Mov vantagen was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mov_vantagen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mov_vantagens/1
  # DELETE /mov_vantagens/1.json
  def destroy
    @mov_vantagen = MovVantagen.find(params[:id])
    @mov_vantagen.destroy

    respond_to do |format|
      format.html { redirect_to mov_vantagens_url }
      format.json { head :no_content }
    end
  end
end
