class AvaliacaoFuncRefsController < ApplicationController
  # GET /avaliacao_func_refs
  # GET /avaliacao_func_refs.json
  def index
    @avaliacao_func_refs = AvaliacaoFuncRef.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @avaliacao_func_refs }
    end
  end

  # GET /avaliacao_func_refs/1
  # GET /avaliacao_func_refs/1.json
  def show
    @avaliacao_func_ref = AvaliacaoFuncRef.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @avaliacao_func_ref }
    end
  end

  # GET /avaliacao_func_refs/new
  # GET /avaliacao_func_refs/new.json
  def new
    @avaliacao_func_ref = AvaliacaoFuncRef.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @avaliacao_func_ref }
    end
  end

  # GET /avaliacao_func_refs/1/edit
  def edit
    @avaliacao_func_ref = AvaliacaoFuncRef.find(params[:id])
  end

  # POST /avaliacao_func_refs
  # POST /avaliacao_func_refs.json
  def create
    @avaliacao_func_ref = AvaliacaoFuncRef.new(params[:avaliacao_func_ref])

    respond_to do |format|
      if @avaliacao_func_ref.save
        format.html { redirect_to @avaliacao_func_ref, notice: 'Avaliacao func ref was successfully created.' }
        format.json { render json: @avaliacao_func_ref, status: :created, location: @avaliacao_func_ref }
      else
        format.html { render action: "new" }
        format.json { render json: @avaliacao_func_ref.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /avaliacao_func_refs/1
  # PUT /avaliacao_func_refs/1.json
  def update
    @avaliacao_func_ref = AvaliacaoFuncRef.find(params[:id])

    respond_to do |format|
      if @avaliacao_func_ref.update_attributes(params[:avaliacao_func_ref])
        format.html { redirect_to @avaliacao_func_ref, notice: 'Avaliacao func ref was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @avaliacao_func_ref.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /avaliacao_func_refs/1
  # DELETE /avaliacao_func_refs/1.json
  def destroy
    @avaliacao_func_ref = AvaliacaoFuncRef.find(params[:id])
    @avaliacao_func_ref.destroy

    respond_to do |format|
      format.html { redirect_to avaliacao_func_refs_url }
      format.json { head :no_content }
    end
  end
end
