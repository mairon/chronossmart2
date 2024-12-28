class SolicitudesController < ApplicationController
  before_filter :authenticate

  def comprovante
    @solicitude = Solicitude.find(params[:id])

    respond_to do |format|

      format.html do
        render  :pdf                    => "comprovante",
                :layout                 => "layer_relatorios",
                :margin => {:top        => '0.15in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :spacing    => 10},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "Chronos Smart #{t('DATE')} impr.: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
  end

  def add_anexo
    @solicitude = Solicitude.find(params[:id])
  end

  def index
    if current_user.tipo.to_i == 2
      @solicitudes = Solicitude.where(usuario_id: current_user.id).order('id desc')
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @solicitudes }
    end
  end

  def busca
    status = "and solicitudes.status = '#{params[:status]}' " unless params[:status].blank?
    usuario = "and usuarios.usuario_nome ilike '%#{params[:busca]}%' " unless params[:busca].blank?
    @solicitudes = Solicitude.joins(:usuario).where("solicitudes.id > 0 #{status} #{usuario}").paginate(:page => params[:page], :per_page => 20).order('solicitudes.id desc')

    render layout: false

  end

  def get_solicitudes
    @solicitudes = Solicitude.where(usuario_id: params[:pin]).order('id desc')

    render json: @solicitudes
  end

  # GET /solicitudes/1
  # GET /solicitudes/1.json
  def show
    @solicitude = Solicitude.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @solicitude }
    end
  end

  # GET /solicitudes/new
  # GET /solicitudes/new.json
  def new
    @solicitude = Solicitude.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @solicitude }
    end
  end

  # GET /solicitudes/1/edit
  def edit
    @solicitude = Solicitude.find(params[:id])
  end

  # POST /solicitudes
  # POST /solicitudes.json
  def create
    @solicitude = Solicitude.new(params[:solicitude])    
    @solicitude.status = 'PENDIENTE'
    respond_to do |format|

      if @solicitude.save
        format.html { redirect_to solicitudes_url }
        format.json { render json: @solicitude, status: :created, location: @solicitude }
      else
        format.html { render action: "new" }
        format.json { render json: @solicitude.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /solicitudes/1
  # PUT /solicitudes/1.json
  def update
    @solicitude = Solicitude.find(params[:id])

    respond_to do |format|
      if @solicitude.update_attributes(params[:solicitude])
        format.html { redirect_to solicitudes_url }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /solicitudes/1
  # DELETE /solicitudes/1.json
  def destroy
    @solicitude = Solicitude.find(params[:id])
    @solicitude.destroy

    respond_to do |format|
      format.html { redirect_to solicitudes_url }
    end
  end
end
