class FechamentoTurnosController < ApplicationController
  def index
    @fechamento_turnos = FechamentoTurno.all(:order => 'data')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fechamento_turnos }
    end
  end

  def show
    @fechamento_turno = FechamentoTurno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fechamento_turno }
    end
  end

  def new
    @fechamento_turno = FechamentoTurno.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fechamento_turno }
    end
  end

  def edit
    @fechamento_turno = FechamentoTurno.find(params[:id])
  end

  def create
    @fechamento_turno = FechamentoTurno.new(params[:fechamento_turno])
    @fechamento_turno.usuario_created = current_user.id
    @fechamento_turno.unidade_created = current_unidade.id

    respond_to do |format|
      if @fechamento_turno.save

        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')

        format.html { redirect_to(fechamento_turnos_url) }
        format.xml  { render :xml => @fechamento_turno, :status => :created, :location => @fechamento_turno }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fechamento_turno.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @fechamento_turno = FechamentoTurno.find(params[:id])
    @fechamento_turno.usuario_updated = current_user.id
    @fechamento_turno.unidade_updated = current_unidade.id

    respond_to do |format|
      if @fechamento_turno.update_attributes(params[:fechamento_turno])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to(fechamento_turnos_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fechamento_turno.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @fechamento_turno = FechamentoTurno.find(params[:id])
    @fechamento_turno.destroy

    respond_to do |format|
      format.html { redirect_to(fechamento_turnos_url) }
      format.xml  { head :ok }
    end
  end
end
