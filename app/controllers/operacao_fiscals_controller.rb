class OperacaoFiscalsController < ApplicationController
  # GET /operacao_fiscals
  # GET /operacao_fiscals.json
  def index
    @operacao_fiscals = OperacaoFiscal.order('cfop')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @operacao_fiscals }
    end
  end

  # GET /operacao_fiscals/1
  # GET /operacao_fiscals/1.json
  def show
    @operacao_fiscal = OperacaoFiscal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @operacao_fiscal }
    end
  end

  # GET /operacao_fiscals/new
  # GET /operacao_fiscals/new.json
  def new
    @operacao_fiscal = OperacaoFiscal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @operacao_fiscal }
    end
  end

  # GET /operacao_fiscals/1/edit
  def edit
    @operacao_fiscal = OperacaoFiscal.find(params[:id])
  end

  # POST /operacao_fiscals
  # POST /operacao_fiscals.json
  def create
    @operacao_fiscal = OperacaoFiscal.new(params[:operacao_fiscal])

    respond_to do |format|
      if @operacao_fiscal.save
        format.html { redirect_to operacao_fiscals_url }
        format.json { render json: @operacao_fiscal, status: :created, location: @operacao_fiscal }
      else
        format.html { render action: "new" }
        format.json { render json: @operacao_fiscal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /operacao_fiscals/1
  # PUT /operacao_fiscals/1.json
  def update
    @operacao_fiscal = OperacaoFiscal.find(params[:id])

    respond_to do |format|
      if @operacao_fiscal.update_attributes(params[:operacao_fiscal])
        format.html { redirect_to operacao_fiscals_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @operacao_fiscal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operacao_fiscals/1
  # DELETE /operacao_fiscals/1.json
  def destroy
    @operacao_fiscal = OperacaoFiscal.find(params[:id])
    @operacao_fiscal.destroy

    respond_to do |format|
      format.html { redirect_to operacao_fiscals_url }
      format.json { head :no_content }
    end
  end
end
