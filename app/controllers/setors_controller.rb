class SetorsController < ApplicationController
  # GET /setors
  # GET /setors.xml
  def index
    @setors = Setor.all(:order => 'id')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @setors }
    end
  end

  # GET /setors/1
  # GET /setors/1.xml
  def show
    @setor = Setor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @setor }
    end
  end

  # GET /setors/new
  # GET /setors/new.xml
  def new
    @setor = Setor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @setor }
    end
  end

  # GET /setors/1/edit
  def edit
    @setor = Setor.find(params[:id])
  end

  # POST /setors
  # POST /setors.xml
  def create
    @setor = Setor.new(params[:setor])

    respond_to do |format|
      if @setor.save
        format.html { redirect_to(setors_url) }
        format.xml  { render :xml => @setor, :status => :created, :location => @setor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @setor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /setors/1
  # PUT /setors/1.xml
  def update
    @setor = Setor.find(params[:id])

    respond_to do |format|
      if @setor.update_attributes(params[:setor])
        format.html { redirect_to(setors_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @setor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /setors/1
  # DELETE /setors/1.xml
  def destroy
    @setor = Setor.find(params[:id])
    @setor.destroy

    respond_to do |format|
      format.html { redirect_to(setors_url) }
      format.xml  { head :ok }
    end
  end
end
