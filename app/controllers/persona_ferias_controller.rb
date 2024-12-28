class PersonaFeriasController < ApplicationController

  def retorno_empleado
    @pf = PersonaFeria.find(params[:id])
    @persona = Persona.find(@pf.persona_id)

    respond_to do |format|

      format.html do
        render  :pdf                    => "print_funcionario",
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

  def comprovante
    @pf = PersonaFeria.find(params[:id])
    @persona = Persona.find(@pf.persona_id)

    respond_to do |format|

      format.html do
        render  :pdf                    => "print_funcionario",
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


  def add_escala
    pf = PersonaFeria.find(params[:id])



    anos_causado = 0 
    anos = (( ("#{pf.ano_ref}-#{pf.persona.data_entrada.strftime("%m")}-#{pf.persona.data_entrada.strftime("%d")}").to_date - pf.persona.data_entrada.to_date).to_i  / 365)
    if anos <= 5 
      anos_causado = 12 
    elsif anos > 5  and anos <= 10 
      anos_causado = 18 
    elsif anos > 10 
      anos_causado = 30 
    end 
    puts "Anos ---- #{anos_causado}"
    count_fds = 0

    DiasUtei.where("data BETWEEN '#{pf.inicio.to_date}' and '#{pf.final.to_date}'").each do |ut| 
      if ut.util == true

        PersonaEscala.create(
          :persona_id => pf.persona_id,
          :data => ut.data,
          :tipo => 1,
          :persona_feria_id => pf.id,
          :obs => 'Vacacciones'
        )
        
      end 

      if anos_causado.to_i == 30 
        if l(ut.data.to_date, :format => :dia_semana, locale: 'es') == 'domingo'

            PersonaEscala.create(
              :persona_id => pf.persona_id,
              :data => ut.data,
              :tipo => 1,
              :persona_feria_id => pf.id,
              :obs => 'Vacacciones'
            )
          
          puts 'DOMINGO > 10 ANOS'
        end
      end
    end
    puts "=====================-- #{count_fds}"

    pf.update_attributes(status: true)

    redirect_to("/personas/#{pf.persona_id}/show_funcionario")

  end

  # GET /persona_ferias
  # GET /persona_ferias.json
  def index
    @persona_ferias = PersonaFeria.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @persona_ferias }
    end
  end

  # GET /persona_ferias/1
  # GET /persona_ferias/1.json
  def show
    @persona_feria = PersonaFeria.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @persona_feria }
    end
  end

  # GET /persona_ferias/new
  # GET /persona_ferias/new.json
  def new
    @persona_feria = PersonaFeria.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @persona_feria }
    end
  end

  # GET /persona_ferias/1/edit
  def edit
    @persona_feria = PersonaFeria.find(params[:id])
    render layout: 'chart'
  end

  # POST /persona_ferias
  # POST /persona_ferias.json
  def create
    @persona_feria = PersonaFeria.new(params[:persona_feria])

    anos_causado = 0 
    anos = (( ("#{@persona_feria.ano_ref}-#{@persona_feria.persona.data_entrada.strftime("%m")}-#{@persona_feria.persona.data_entrada.strftime("%d")}").to_date - @persona_feria.persona.data_entrada.to_date).to_i  / 365)
    if anos <= 5 
      anos_causado = 12 
    elsif anos > 5  and anos <= 10 
      anos_causado = 18 
    elsif anos > 10 
      anos_causado = 30 
    end 
    puts "Anos ---- #{anos_causado}"
    count_fds = 0
    DiasUtei.where("data BETWEEN '#{@persona_feria.inicio.to_date}' and '#{@persona_feria.final.to_date}'").each do |ut| 
      if ut.util == false 
        count_fds += 1
      end 

      if anos_causado.to_i == 30 
        if l(ut.data.to_date, :format => :dia_semana, locale: 'es') == 'domingo'
          count_fds -= 1 
          puts 'DOMINGO > 10 ANOS'
        end
      end
    end
    puts "=====================-- #{count_fds}"

    @persona_feria.dias = (((@persona_feria.inicio.to_date..@persona_feria.final.to_date).count - count_fds.to_i) * -1).to_i


    respond_to do |format|
      if @persona_feria.save
        format.html { redirect_to "/personas/#{@persona_feria.persona_id}/show_funcionario" }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /persona_ferias/1
  # PUT /persona_ferias/1.json
  def update
    @persona_feria = PersonaFeria.find(params[:id])

    respond_to do |format|
      if @persona_feria.update_attributes(params[:persona_feria])
        format.html { redirect_to "/personas/#{@persona_feria.persona_id}/show_funcionario" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona_feria.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /persona_ferias/1
  # DELETE /persona_ferias/1.json
  def destroy
    @persona_feria = PersonaFeria.find(params[:id])
    @persona_feria.destroy

    respond_to do |format|
      format.html { redirect_to "/personas/#{@persona_feria.persona_id}/show_funcionario" }
      format.json { head :no_content }
    end
  end
end
