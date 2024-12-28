class ProdutosTributsController < ApplicationController
  # GET /produtos_tributs
  # GET /produtos_tributs.json
  def index
    @produtos_tributs = ProdutosTribut.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @produtos_tributs }
    end
  end

  # GET /produtos_tributs/1
  # GET /produtos_tributs/1.json
  def show
    @produtos_tribut = ProdutosTribut.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @produtos_tribut }
    end
  end

  # GET /produtos_tributs/new
  # GET /produtos_tributs/new.json
  def new
    @produtos_tribut = ProdutosTribut.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @produtos_tribut }
    end
  end

  # GET /produtos_tributs/1/edit
  def edit
    @produtos_tribut = ProdutosTribut.find(params[:id])
  end

  # POST /produtos_tributs
  # POST /produtos_tributs.json
  def create
    @produtos_tribut = ProdutosTribut.new(params[:produtos_tribut])

    respond_to do |format|
      if @produtos_tribut.save
        format.html { redirect_to "/produtos/#{@produtos_tribut.produto_id}/atributs" }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @produtos_tribut.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /produtos_tributs/1
  # PUT /produtos_tributs/1.json
  def update
    @produtos_tribut = ProdutosTribut.find(params[:id])

    respond_to do |format|
      if @produtos_tribut.update_attributes(params[:produtos_tribut])
        format.html { redirect_to "/produtos/#{@produtos_tribut.produto_id}/atributs" }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @produtos_tribut.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produtos_tributs/1
  # DELETE /produtos_tributs/1.json
  def destroy
    @produtos_tribut = ProdutosTribut.find(params[:id])
    @produtos_tribut.destroy

    respond_to do |format|
      format.html { redirect_to "/produtos/#{@produtos_tribut.produto_id}/atributs" }
      format.json { head :no_content }
    end
  end
end
