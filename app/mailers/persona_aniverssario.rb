class PersonaAniverssario < ActionMailer::Base
  default :from => "Info RRHH Mercosur <mercosur@chronos.com.py>"

  def mensagem_aniversario
    personas = Persona.where("estado = 0 and tipo_funcionario = 1 and date_part('day', data_nascimento) = '#{Time.now.strftime("%d")}'  and date_part('month', data_nascimento) = '#{Time.now.strftime("%m")}' ")
    @logo = Unidade.first.avatar.url

    personas.each do |p|
      @p = p
      mail(
        :to => p.email,
        :subject => "¡Feliz cumpleaños #{p.nome.titleize}!"
      )
    end
  end


  def mensagem_ferias
    ferias = Persona.where("tipo_funcionario = 1 and estado = 0 and date_part('day', data_entrada) = '#{Time.now.strftime("%d")}' and date_part('month', data_entrada) = '#{Time.now.strftime("%m")}' and  date_part('year', data_entrada) <>'#{Time.now.strftime("%Y")}'").order('data_entrada')
    anos_causado = 0
    emails = ""
    ferias.each do |p|

      anos = (( ("#{Time.now.strftime("%Y")}-#{p.data_entrada.strftime("%m")}-#{p.data_entrada.strftime("%d")}").to_date - p.data_entrada.to_date).to_i  / 365) 
      if anos <= 5 
        anos_causado = 12 
      elsif anos > 5  and anos <= 10 
        anos_causado = 18 
      elsif anos > 10 
        anos_causado = 30 
      end 


      PersonaFeria.create(
        persona_id: p.id, 
        tipo: 'CAUSADAS', 
        ano_ref: "#{Time.now.strftime("%Y").to_i - 1 }",
        inicio: ("#{Time.now.strftime("%Y").to_i- 1}-#{p.data_entrada.strftime("%m")}-#{p.data_entrada.strftime("%d")}").to_date, 
        final: (("#{Time.now.strftime("%Y").to_i - 1}-#{p.data_entrada.strftime("%m")}-#{p.data_entrada.strftime("%d")}").to_date + 1.year), 
        dias: anos_causado.to_i)

      if p.unidade_id.to_i == 1 #central
        emails = "daisy.mtz@hotmail.com, gerencia.matriz@mercosurcambios.com, maironbrasil99@gmail.com"
      elsif p.unidade_id.to_i == 2 #km4
        emails = "daisy.mtz@hotmail.com, pcg.mtz@hotmail.com, maironbrasil99@gmail.com, maironbrasil99@gmail.com"
      elsif p.unidade_id.to_i == 3 #san alberto
        emails = "daisy.mtz@hotmail.com, gerencia.sanalberto@mercosurcambios.com, maironbrasil99@gmail.com, maironbrasil99@gmail.com"
      end

      @p = p
      mail(
        :to => emails,
        :subject => "#{p.nome.titleize} Tiene #{anos_causado} dias de Vacacciones Diponible Hoy"
      )
    end
  end
end



