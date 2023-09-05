require 'cloudinary'

class PropertiesController < ApplicationController
  before_action :set_property, only: %i[ show update destroy delete_photo ]  # Added :delete_photo
  before_action :authenticate_user!, only: [:new, :create]
  before_action :check_ownership, only: [:edit, :update, :destroy, :delete_photo]  # Added :delete_photo

  include Rails.application.routes.url_helpers


  # GET /properties
  def index
    if params[:user_id]
      @properties = Property.where(user_id: params[:user_id])
    elsif params[:city]
      @properties = Property.where(city: params[:city])
    else
      @properties = Property.all
    end
    render json: @properties
  end

  # GET /properties/1
  def show
    photos = @property.photos.attached? ? @property.photos.map { |photo| {id: photo.id, url: rails_blob_url(photo) } } : []
    render json: @property.as_json.merge({ photos: photos}).merge({ user: @property.user })
  end

  # POST /properties
  def create
    @property = current_user.properties.new(property_params)
    if @property.save
      attach_photos if params[:property][:photos]
      render json: @property, status: :created, location: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /properties/1
  def update
    property = Property.find(params[:id])
    if property.update(property_params.except(:photos))
      if params[:property][:photos]
        params[:property][:photos].each do |photo|
          property.photos.attach(photo)
        end
      end
      render json: property, status: :ok
    else
      render json: { errors: property.errors }, status: :unprocessable_entity
    end
  end

  def delete_photo
    puts "Received Photo ID: #{params[:photo_id]}"  # Debug log
    begin
      photoId = params[:photo_id]
    photo = @property.photos.find_by(id: photoId)
    rescue => e
      puts "Erreur lors de la suppression d'une photo : " +e
    end

    if photo
      photo.purge
      render json: { message: 'Photo deleted successfully' }, status: :ok
    else
      render json: { error: 'Photo not found' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound => e
    puts "Exception caught: #{e.message}"  # Debug log
    render json: { error: 'Photo not found' }, status: :not_found
  end


  # DELETE /properties/1
  def destroy
    @property.destroy
  end

  private

    def attach_photos
      params[:property][:photos].each do |photo|
        @property.photos.attach(photo)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(:user_id, :title, :price, :description, :private, :city, photos: [])
    end

    def check_ownership
      puts "Current Property's User: #{@property.user.id}"  # Debug log
      puts "Current User: #{current_user.id}"  # Debug log
      
      unless @property.user == current_user
        puts "Ownership Check Failed!"  
        render json: { error: "Vous n'avez pas la permission d'effectuer cette action." }, status: :forbidden
      end
    end

end