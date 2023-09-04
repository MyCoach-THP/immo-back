class UserMailer < ApplicationMailer
  default from: "from@example.com"

def password_reset(user)
    @user = user
    @url = params[:reset_password_url]
    mail(to: @user.email, subject: 'Réinitialisation de votre mot de passe')
end

end