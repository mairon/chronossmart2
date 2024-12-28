class Mensagem < ActionMailer::Base

  default :from => "mercosur@chronos.com.py"
  def contato(amostra)
    @parametros = amostra

    @parametros.each do |p|
      @empresa = p.empresa_nome

      @tipo = p.tipo_id

      @revision = p.revisao_result_id

    mail(
      :to => p.email,
      :subject => "Resultado(s) disponible(s)"
      )
   end
  end
end
