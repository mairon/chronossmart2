class AberturaTurnosController < ApplicationController
  # GET /abertura_turnos
  # GET /abertura_turnos.json
  def index
    @abertura_turnos = AberturaTurno.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @abertura_turnos }
    end
  end

  # GET /abertura_turnos/1
  # GET /abertura_turnos/1.json
  def show
    @abertura_turno = AberturaTurno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @abertura_turno }
    end
  end

  # GET /abertura_turnos/new
  # GET /abertura_turnos/new.json
  def new
    @abertura_turno = AberturaTurno.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @abertura_turno }
    end
  end

  # GET /abertura_turnos/1/edit
  def edit
    @abertura_turno = AberturaTurno.find(params[:id])
  end

  # POST /abertura_turnos
  # POST /abertura_turnos.json
  def create
    @abertura_turno = AberturaTurno.new(params[:abertura_turno])

    respond_to do |format|
      if @abertura_turno.save
        format.html { redirect_to @abertura_turno, notice: 'Abertura turno was successfully created.' }
        format.json { render json: @abertura_turno, status: :created, location: @abertura_turno }
      else
        format.html { render action: "new" }
        format.json { render json: @abertura_turno.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /abertura_turnos/1
  # PUT /abertura_turnos/1.json
  def update
    @abertura_turno = AberturaTurno.find(params[:id])

    respond_to do |format|
      if @abertura_turno.update_attributes(params[:abertura_turno])
        format.html { redirect_to @abertura_turno, notice: 'Abertura turno was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @abertura_turno.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /abertura_turnos/1
  # DELETE /abertura_turnos/1.json
  def destroy
    @abertura_turno = AberturaTurno.find(params[:id])
    @abertura_turno.destroy

    respond_to do |format|
      format.html { redirect_to abertura_turnos_url }
      format.json { head :no_content }
    end
  end
end
