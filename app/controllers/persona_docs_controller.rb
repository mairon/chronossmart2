class PersonaDocsController < ApplicationController
  # GET /persona_docs
  # GET /persona_docs.json
  def index
    @persona_docs = PersonaDoc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_docs }
    end
  end

  # GET /persona_docs/1
  # GET /persona_docs/1.json
  def show
    @persona_doc = PersonaDoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_doc }
    end
  end

  # GET /persona_docs/new
  # GET /persona_docs/new.json
  def new
    @persona_doc = PersonaDoc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_doc }
    end
  end

  # GET /persona_docs/1/edit
  def edit
    @persona_doc = PersonaDoc.find(params[:id])
  end

  # POST /persona_docs
  # POST /persona_docs.json
  def create
    @persona_doc = PersonaDoc.new(params[:persona_doc])

    respond_to do |format|
      if @persona_doc.save
        format.html { redirect_to "/personas/#{@persona_doc.persona_id}/show_funcionario" }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /persona_docs/1
  # PUT /persona_docs/1.json
  def update
    @persona_doc = PersonaDoc.find(params[:id])

    respond_to do |format|
      if @persona_doc.update_attributes(params[:persona_doc])
        format.html { redirect_to "/personas/#{@persona_doc.persona_id}/show_funcionario" }

      else
        format.html { render action: "edit" }

      end
    end
  end

  # DELETE /persona_docs/1
  # DELETE /persona_docs/1.json
  def destroy
    @persona_doc = PersonaDoc.find(params[:id])
    @persona_doc.destroy

    respond_to do |format|
      format.html { redirect_to "/personas/#{@persona_doc.persona_id}/show_funcionario" }
    end
  end
end
