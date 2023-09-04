require 'cloudinary'

class PropertiesController < ApplicationController
  before_action :set_property, only: %i[ show update destroy ]
  before_action :authenticate_user!, only: [:new, :create]
  before_action :check_ownership, only: [:edit, :update, :destroy]
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
<<<<<<< HEAD
    photo_urls = @property.photos.map do |photo|
      rails_blob_url(photo)
    end
    render json: @property.as_json.merge({
      photo_urls: photo_urls
    }).merge({ user: @property.user })
=======
    photo_urls = @property.photos.attached? ? @property.photos.map { |photo| rails_blob_url(photo) } : []
    render json: @property.as_json.merge({ photo_urls: photo_urls }).merge({ user: @property.user })
>>>>>>> db2c995c3ab5958beca437d8d1033bb3dc15955d
  end


  # POST /properties
  def create
    @property = current_user.properties.new(property_params)
    
    if @property.save
      # Attach the photo if it exists
      if params[:property][:photos]
        params[:property][:photos].each do |photo|
          @property.photos.attach(photo)
<<<<<<< HEAD
        end  # <-- This is missing
=======
        end
>>>>>>> db2c995c3ab5958beca437d8d1033bb3dc15955d
      end
      render json: @property, status: :created, location: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end

  end



  # PATCH/PUT /properties/1
  def update
    if @property.update(property_params)
<<<<<<< HEAD
      if params[:property][:photos].present?
        @property.photos.purge # Remove all existing photos
        Array(params[:property][:photos]).each do |photo|
=======
      # Attach new photos if they exist
      if params[:property][:photos]
        params[:property][:photos].each do |photo|
>>>>>>> db2c995c3ab5958beca437d8d1033bb3dc15955d
          @property.photos.attach(photo)
        end
      end
      render json: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end


  # DELETE /properties/1
  def destroy
    @property.destroy
  end

  private

    def upload_photo
      photo = params[:property][:photos]
      result = Cloudinary::Uploader.upload(photo.path)
      @property.update(photo_url: result["url"])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def property_params
<<<<<<< HEAD
      params.require(:property).permit(:user_id, :title, :price, :description, :private, photos: [])
=======
      params.require(:property).permit(:user_id, :title, :price, :description, :private, :city, photos: [])
>>>>>>> db2c995c3ab5958beca437d8d1033bb3dc15955d
    end

    def check_ownership
      @property = Property.find(params[:id])
      unless @property.user == current_user
        render json: { error: "Vous n'avez pas la permission d'effectuer cette action." }, status: :forbidden
      end
    end

end