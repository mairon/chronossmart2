class Tms::PedidoTrasladoDocsController < Tms::TmsController  
  # GET /pedido_traslado_docs
  # GET /pedido_traslado_docs.json
  def index
    @pedido_traslado_docs = PedidoTrasladoDoc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pedido_traslado_docs }
    end
  end

  # GET /pedido_traslado_docs/1
  # GET /pedido_traslado_docs/1.json
  def show
    @pedido_traslado_doc = PedidoTrasladoDoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pedido_traslado_doc }
    end
  end

  # GET /pedido_traslado_docs/new
  # GET /pedido_traslado_docs/new.json
  def new
    @pedido_traslado_doc = PedidoTrasladoDoc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pedido_traslado_doc }
    end
  end

  # GET /pedido_traslado_docs/1/edit
  def edit
    @pedido_traslado_doc = PedidoTrasladoDoc.find(params[:id])
  end

  # POST /pedido_traslado_docs
  # POST /pedido_traslado_docs.json
  def create
    @pedido_traslado_doc = PedidoTrasladoDoc.new(params[:pedido_traslado_doc])

    respond_to do |format|
      if @pedido_traslado_doc.save
        format.html { redirect_to tms_pedido_traslado_path(@pedido_traslado_doc.pedido_traslado_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /pedido_traslado_docs/1
  # PUT /pedido_traslado_docs/1.json
  def update
    @pedido_traslado_doc = PedidoTrasladoDoc.find(params[:id])

    respond_to do |format|
      if @pedido_traslado_doc.update_attributes(params[:pedido_traslado_doc])
        format.html { redirect_to tms_pedido_traslado_path(@pedido_traslado_doc.pedido_traslado_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /pedido_traslado_docs/1
  # DELETE /pedido_traslado_docs/1.json
  def destroy
    @pedido_traslado_doc = PedidoTrasladoDoc.find(params[:id])
    @pedido_traslado_doc.destroy

    respond_to do |format|
      format.html { redirect_to tms_pedido_traslado_path(@pedido_traslado_doc.pedido_traslado_id) }
      format.json { head :no_content }
    end
  end
end
