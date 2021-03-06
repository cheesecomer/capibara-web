class IconUploader < CarrierWave::Uploader::Base

  # Include RMagick
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :aws
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  # Process files as they are uploaded:
  process resize_to_fit: [500, 500]

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [100, 100]
  end
end
