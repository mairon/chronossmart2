class AvaliacaoRefsController < ApplicationController
  # GET /avaliacao_refs
  # GET /avaliacao_refs.json
  def index
    @avaliacao_refs = AvaliacaoRef.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @avaliacao_refs }
    end
  end

  # GET /avaliacao_refs/1
  # GET /avaliacao_refs/1.json
  def show
    @avaliacao_ref = AvaliacaoRef.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @avaliacao_ref }
    end
  end

  # GET /avaliacao_refs/new
  # GET /avaliacao_refs/new.json
  def new
    @avaliacao_ref = AvaliacaoRef.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @avaliacao_ref }
    end
  end

  # GET /avaliacao_refs/1/edit
  def edit
    @avaliacao_ref = AvaliacaoRef.find(params[:id])
  end

  # POST /avaliacao_refs
  # POST /avaliacao_refs.json
  def create
    @avaliacao_ref = AvaliacaoRef.new(params[:avaliacao_ref])

    respond_to do |format|
      if @avaliacao_ref.save
        format.html { redirect_to avaliacao_refs_url }
      else
        format.html { render action: "new" }
        format.json { render json: @avaliacao_ref.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /avaliacao_refs/1
  # PUT /avaliacao_refs/1.json
  def update
    @avaliacao_ref = AvaliacaoRef.find(params[:id])

    respond_to do |format|
      if @avaliacao_ref.update_attributes(params[:avaliacao_ref])
        format.html { redirect_to avaliacao_refs_url }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /avaliacao_refs/1
  # DELETE /avaliacao_refs/1.json
  def destroy
    @avaliacao_ref = AvaliacaoRef.find(params[:id])
    @avaliacao_ref.destroy

    respond_to do |format|
      format.html { redirect_to avaliacao_refs_url }
    end
  end
end
