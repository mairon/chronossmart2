class FaturaImportsController < ApplicationController

  def update_individual
    FaturaImportProduto.update(params[:products].keys, params[:products].values)
    redirect_to fatura_import_path(params[:id])
    flash[:notice] = "Produtos Actulizados!"
  end

  def index
    @fatura_imports = FaturaImport.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fatura_imports }
    end
  end

  # GET /fatura_imports/1
  # GET /fatura_imports/1.json
  def show
    @fatura_import = FaturaImport.find(params[:id])
    
    render layout: 'chart'
  end

  # GET /fatura_imports/new
  # GET /fatura_imports/new.json
  def new
    @fatura_import = FaturaImport.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fatura_import }
    end
  end

  # GET /fatura_imports/1/edit
  def edit
    @fatura_import = FaturaImport.find(params[:id])
  end

  # POST /fatura_imports
  # POST /fatura_imports.json
  def create
    @fatura_import = FaturaImport.new(params[:fatura_import])

    respond_to do |format|
      if @fatura_import.save
        format.html { redirect_to @fatura_import, notice: 'Fatura import was successfully created.' }
        format.json { render json: @fatura_import, status: :created, location: @fatura_import }
      else
        format.html { render action: "new" }
        format.json { render json: @fatura_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fatura_imports/1
  # PUT /fatura_imports/1.json
  def update
    @fatura_import = FaturaImport.find(params[:id])

    respond_to do |format|
      if @fatura_import.update_attributes(params[:fatura_import])
        format.html { redirect_to @fatura_import, notice: 'Fatura import was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fatura_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fatura_imports/1
  # DELETE /fatura_imports/1.json
  def destroy
    @fatura_import = FaturaImport.find(params[:id])
    @fatura_import.destroy

    respond_to do |format|
      format.html { redirect_to fatura_imports_url }
      format.json { head :no_content }
    end
  end
end
