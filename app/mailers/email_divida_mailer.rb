class EmailDividaMailer < ActionMailer::Base
  default from: "from@example.com"
  layout 'mailer'

  def email_dividas(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end
