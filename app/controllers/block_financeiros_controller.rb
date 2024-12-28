class BlockFinanceirosController < ApplicationController
  # GET /block_financeiros
  # GET /block_financeiros.json
  def index
    @block_financeiros = BlockFinanceiro.paginate(:page => params[:page], :per_page => 20).order('periodo desc').includes(:usuario)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @block_financeiros }
    end
  end

  # GET /block_financeiros/1
  # GET /block_financeiros/1.json
  def show
    @block_financeiro = BlockFinanceiro.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @block_financeiro }
    end
  end

  # GET /block_financeiros/new
  # GET /block_financeiros/new.json
  def new
    @block_financeiro = BlockFinanceiro.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @block_financeiro }
    end
  end

  # GET /block_financeiros/1/edit
  def edit
    @block_financeiro = BlockFinanceiro.find(params[:id])
  end

  # POST /block_financeiros
  # POST /block_financeiros.json
  def create

    @block_financeiro = BlockFinanceiro.new(params[:block_financeiro])
    @block_financeiro.usuario_id = current_user.id

    respond_to do |format|
      if @block_financeiro.save
        format.html { redirect_to block_financeiros_url }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /block_financeiros/1
  # PUT /block_financeiros/1.json
  def update
    @block_financeiro = BlockFinanceiro.find(params[:id])

    respond_to do |format|
      if @block_financeiro.update_attributes(params[:block_financeiro])
        format.html { redirect_to block_financeiros_url }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /block_financeiros/1
  # DELETE /block_financeiros/1.json
  def destroy
    @block_financeiro = BlockFinanceiro.find(params[:id])
    @block_financeiro.destroy

    respond_to do |format|
      format.html { redirect_to block_financeiros_url }
      format.json { head :no_content }
    end
  end
end
