class RecisaoFuncsController < ApplicationController
  def index
    @recisao_funcs = RecisaoFunc.order('id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recisao_funcs }
    end
  end

  # GET /recisao_funcs/1
  # GET /recisao_funcs/1.json
  def comprovante
    @recisao_func = RecisaoFunc.find(params[:id])

      respond_to do |format|
        format.html do
          render  :pdf                    => "liquidacao",
                  :layout                 => "layer_relatorios",
                  :margin => {:top        => '0.05in',
                              :bottom     => '0.10in',
                              :left       => '0.10in',
                              :right      => '0.10in'},

                  :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                              :font_size  => 7,
                              :right      => "Pagina [page] de [toPage]",
                              :left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
        end
      end

  end


  def show
    @recisao_func = RecisaoFunc.find(params[:id])

    render layout: 'chart'
  end

  # GET /recisao_funcs/new
  # GET /recisao_funcs/new.json
  def new
    @recisao_func = RecisaoFunc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recisao_func }
    end
  end

  # GET /recisao_funcs/1/edit
  def edit
    @recisao_func = RecisaoFunc.find(params[:id])
  end

  # POST /recisao_funcs
  # POST /recisao_funcs.json
  def create
    @recisao_func = RecisaoFunc.new(params[:recisao_func])

    respond_to do |format|
      if @recisao_func.save
        format.html { redirect_to @recisao_func }
        format.json { render json: @recisao_func, status: :created, location: @recisao_func }
      else
        format.html { render action: "new" }
        format.json { render json: @recisao_func.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recisao_funcs/1
  # PUT /recisao_funcs/1.json
  def update
    @recisao_func = RecisaoFunc.find(params[:id])

    respond_to do |format|
      if @recisao_func.update_attributes(params[:recisao_func])
        format.html { redirect_to @recisao_func}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recisao_func.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recisao_funcs/1
  # DELETE /recisao_funcs/1.json
  def destroy
    @recisao_func = RecisaoFunc.find(params[:id])
    @recisao_func.destroy

    respond_to do |format|
      format.html { redirect_to recisao_funcs_url }
      format.json { head :no_content }
    end
  end
end
