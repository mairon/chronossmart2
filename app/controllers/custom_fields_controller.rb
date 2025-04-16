class CustomFieldsController < ApplicationController
  # GET /custom_fields
  # GET /custom_fields.json
  def index
    @custom_fields = CustomField.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @custom_fields }
    end
  end

  # GET /custom_fields/1
  # GET /custom_fields/1.json
  def show
    @custom_field = CustomField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @custom_field }
    end
  end

  # GET /custom_fields/new
  # GET /custom_fields/new.json
  def new
    @custom_field = CustomField.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @custom_field }
    end
  end

  # GET /custom_fields/1/edit
  def edit
    @custom_field = CustomField.find(params[:id])
  end

  # POST /custom_fields
  # POST /custom_fields.json
  def create
    @custom_field = CustomField.new(params[:custom_field])

    respond_to do |format|
      if @custom_field.save
        format.html { redirect_to custom_fields_url }
      else
        format.html { render action: "new" }
        format.json { render json: @custom_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /custom_fields/1
  # PUT /custom_fields/1.json
  def update
    @custom_field = CustomField.find(params[:id])

    respond_to do |format|
      if @custom_field.update_attributes(params[:custom_field])
        format.html { redirect_to custom_fields_url }
      else
        format.html { render action: "edit" }
        format.json { render json: @custom_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_fields/1
  # DELETE /custom_fields/1.json
  def destroy
    @custom_field = CustomField.find(params[:id])
    @custom_field.destroy

    respond_to do |format|
      format.html { redirect_to custom_fields_url }
      format.json { head :no_content }
    end
  end
end
