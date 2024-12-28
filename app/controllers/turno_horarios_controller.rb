class TurnoHorariosController < ApplicationController
  # GET /turno_horarios
  # GET /turno_horarios.json
  def index
    @turno_horarios = TurnoHorario.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @turno_horarios }
    end
  end

  # GET /turno_horarios/1
  # GET /turno_horarios/1.json
  def show
    @turno_horario = TurnoHorario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @turno_horario }
    end
  end

  # GET /turno_horarios/new
  # GET /turno_horarios/new.json
  def new
    @turno_horario = TurnoHorario.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @turno_horario }
    end
  end

  # GET /turno_horarios/1/edit
  def edit
    @turno_horario = TurnoHorario.find(params[:id])
  end

  # POST /turno_horarios
  # POST /turno_horarios.json
  def create
    @turno_horario = TurnoHorario.new(params[:turno_horario])

    respond_to do |format|
      if @turno_horario.save
        format.html { redirect_to @turno_horario, notice: 'Turno horario was successfully created.' }
        format.json { render json: @turno_horario, status: :created, location: @turno_horario }
      else
        format.html { render action: "new" }
        format.json { render json: @turno_horario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /turno_horarios/1
  # PUT /turno_horarios/1.json
  def update
    @turno_horario = TurnoHorario.find(params[:id])

    respond_to do |format|
      if @turno_horario.update_attributes(params[:turno_horario])
        format.html { redirect_to @turno_horario, notice: 'Turno horario was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @turno_horario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turno_horarios/1
  # DELETE /turno_horarios/1.json
  def destroy
    @turno_horario = TurnoHorario.find(params[:id])
    @turno_horario.destroy

    respond_to do |format|
      format.html { redirect_to turno_horarios_url }
      format.json { head :no_content }
    end
  end
end
