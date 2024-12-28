class PersonaLogin < ActionMailer::Base
	default :from => "Colegio Crecer <colegiocrecer@chronos.com.py>"

  def mensagem_login(persona)
    @persona = persona
    mail(to: @persona.email, subject: 'Login App Crecer')
  end

end