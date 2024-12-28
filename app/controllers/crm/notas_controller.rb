class Crm::NotasController < Crm::CrmController
  # GET /notas
  # GET /notas.json
  def index
    @notas = Nota.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notas }
    end
  end

  # GET /notas/1
  # GET /notas/1.json
  def show
    @nota = Nota.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nota }
    end
  end

  # GET /notas/new
  # GET /notas/new.json
  def new
    @nota = Nota.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nota }
    end
  end

  # GET /notas/1/edit
  def edit
    @nota = Nota.find(params[:id])
  end

  # POST /notas
  # POST /notas.json
  def create
    @nota = Nota.new(params[:nota])

    respond_to do |format|
      if @nota.save
        #Cria histotico
        NegocioHistorico.create(negocio_id: @nota.negocio_id, 
          etapa_id: @nota.negocio.etapa_id, 
          usuario_id: @nota.usuario_id,
          titulo: 'Nota Adicionado', 
          origem: 'NOTA GERADA',
          nota_id: @nota.id,
          detalhe: @nota.descricao 
        )        

        format.html { redirect_to crm_negocio_path(@nota.negocio_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /notas/1
  # PUT /notas/1.json
  def update
    @nota = Nota.find(params[:id])

    respond_to do |format|
      if @nota.update_attributes(params[:nota])
        format.html { redirect_to crm_negocio_path(@nota.negocio_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /notas/1
  # DELETE /notas/1.json
  def destroy
    @nota = Nota.find(params[:id])
    @nota.destroy

    respond_to do |format|
      format.html { redirect_to crm_negocio_path(@nota.negocio_id) }
    end
  end
end
