class EmbalagensController < ApplicationController

  before_filter :authenticate
  def index
    @embalagens = Embalagem.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @embalagens }
    end
  end

  def show
    @embalagem = Embalagem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @embalagem }
    end
  end

  def new
    @embalagem = Embalagem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @embalagem }
    end
  end

  def edit
    @embalagem = Embalagem.find(params[:id])
  end

  def create
    @embalagem = Embalagem.new(params[:embalagem])
    respond_to do |format|
      if @embalagem.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to(embalagens_url) }
        format.xml  { render :xml => @embalagem, :status => :created, :location => @embalagem }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @embalagem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /embalagens/1
  # PUT /embalagens/1.xml
  def update
    @embalagem = Embalagem.find(params[:id])

    respond_to do |format|
      if @embalagem.update_attributes(params[:embalagem])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to(embalagens_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @embalagem.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /embalagens/1
  # DELETE /embalagens/1.xml
  def destroy
    @embalagem = Embalagem.find(params[:id])
    @embalagem.destroy

    respond_to do |format|
      format.html { redirect_to(embalagens_url) }
      format.xml  { head :ok }
    end
  end
end
