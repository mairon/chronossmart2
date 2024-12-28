class RodadosController < ApplicationController
    # GET /rodados
    # GET /rodados.xml
    def index
        @rodados = Rodado.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @rodados }
        end
    end

    # GET /rodados/1
    # GET /rodados/1.xml
    def show
        @rodado = Rodado.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @rodado }
        end
    end

    # GET /rodados/new
    # GET /rodados/new.xml
    def new
        @rodado = Rodado.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @rodado }
        end
    end

    # GET /rodados/1/edit
    def edit
        @rodado = Rodado.find(params[:id])
    end

    # POST /rodados
    # POST /rodados.xml
    def create
        @rodado = Rodado.new(params[:rodado])

        respond_to do |format|
            if @rodado.save
                format.html { redirect_to(rodados_url) }
                format.xml  { render :xml => @rodado, :status => :created, :location => @rodado }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @rodado.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /rodados/1
    # PUT /rodados/1.xml
    def update
        @rodado = Rodado.find(params[:id])

        respond_to do |format|
            if @rodado.update_attributes(params[:rodado])
                format.html { redirect_to(rodados_url) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @rodado.errors, :status => :unprocessable_entity }
            end
        end
    end

    # DELETE /rodados/1
    # DELETE /rodados/1.xml
    def destroy
        @rodado = Rodado.find(params[:id])
        @rodado.destroy

        respond_to do |format|
            format.html { redirect_to(rodados_url) }
            format.xml  { head :ok }
        end
    end
end
