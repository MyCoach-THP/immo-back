class PasswordResetsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_reset_token!
      
      # Configurez votre URL de base ici
      frontend_url = "http://localhost:5173"
      
      # Générez le chemin complet
      reset_password_path = "/resetpassword/#{user.reset_password_token}"
      reset_password_url = "#{frontend_url}#{reset_password_path}"

      # Envoyez le courrier électronique (Assurez-vous de passer l'URL complète à votre mailer)
      UserMailer.with(reset_password_url: reset_password_url).password_reset(user).deliver_now
      
      render json: { message: 'Email sent' }, status: :ok
    else
      render json: { errors: 'Email not found' }, status: :unprocessable_entity
    end
  end

  def update
    user = User.find_by(reset_password_token: params[:id])
    
    if user && user.update(password: user_params[:password])
      render json: { message: 'Mot de passe mis à jour avec succès' }, status: :ok
    else
      render json: { errors: 'Jeton invalide ou mot de passe incorrect' }, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:token])
    render 'password_resets/edit'
  end

  private

  def user_params
    params.require(:password_reset).permit(:password)
  end
end