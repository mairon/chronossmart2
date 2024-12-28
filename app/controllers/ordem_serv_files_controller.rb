class OrdemServFilesController < ApplicationController
  # GET /ordem_serv_files
  # GET /ordem_serv_files.json
  def index
    @ordem_serv_files = OrdemServFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ordem_serv_files }
    end
  end

  # GET /ordem_serv_files/1
  # GET /ordem_serv_files/1.json
  def show
    @ordem_serv_file = OrdemServFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ordem_serv_file }
    end
  end

  # GET /ordem_serv_files/new
  # GET /ordem_serv_files/new.json
  def new
    @ordem_serv_file = OrdemServFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ordem_serv_file }
    end
  end

  # GET /ordem_serv_files/1/edit
  def edit
    @ordem_serv_file = OrdemServFile.find(params[:id])
  end

  # POST /ordem_serv_files
  # POST /ordem_serv_files.json
  def create
    @ordem_serv_file = OrdemServFile.new(params[:ordem_serv_file])

    respond_to do |format|
      if @ordem_serv_file.save
        format.html { redirect_to checklist_ordem_serv_path(@ordem_serv_file.ordem_serv_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /ordem_serv_files/1
  # PUT /ordem_serv_files/1.json
  def update
    @ordem_serv_file = OrdemServFile.find(params[:id])

    respond_to do |format|
      if @ordem_serv_file.update_attributes(params[:ordem_serv_file])
        format.html { redirect_to checklist_ordem_serv_path(@ordem_serv_file.ordem_serv_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /ordem_serv_files/1
  # DELETE /ordem_serv_files/1.json
  def destroy
    @ordem_serv_file = OrdemServFile.find(params[:id])
    @ordem_serv_file.destroy

    respond_to do |format|
      format.html { redirect_to checklist_ordem_serv_path(@ordem_serv_file.ordem_serv_id) }
    end
  end
end
