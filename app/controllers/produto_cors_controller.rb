class ProdutoCorsController < ApplicationController
  # GET /produto_cors
  # GET /produto_cors.json
  def index
    @produto_cors = ProdutoCor.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @produto_cors }
    end
  end

  # GET /produto_cors/1
  # GET /produto_cors/1.json
  def show
    @produto_cor = ProdutoCor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @produto_cor }
    end
  end

  # GET /produto_cors/new
  # GET /produto_cors/new.json
  def new
    @produto_cor = ProdutoCor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @produto_cor }
    end
  end

  # GET /produto_cors/1/edit
  def edit
    @produto_cor = ProdutoCor.find(params[:id])
  end

  # POST /produto_cors
  # POST /produto_cors.json
  def create
    @produto_cor = ProdutoCor.new(params[:produto_cor])

    respond_to do |format|
      if @produto_cor.save
        format.html { redirect_to @produto_cor, notice: 'Produto cor was successfully created.' }
        format.json { render json: @produto_cor, status: :created, location: @produto_cor }
      else
        format.html { render action: "new" }
        format.json { render json: @produto_cor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /produto_cors/1
  # PUT /produto_cors/1.json
  def update
    @produto_cor = ProdutoCor.find(params[:id])

    respond_to do |format|
      if @produto_cor.update_attributes(params[:produto_cor])
        format.html { redirect_to @produto_cor, notice: 'Produto cor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @produto_cor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produto_cors/1
  # DELETE /produto_cors/1.json
  def destroy
    @produto_cor = ProdutoCor.find(params[:id])
    @produto_cor.destroy

    respond_to do |format|
      format.html { redirect_to produto_cors_url }
      format.json { head :no_content }
    end
  end
end
