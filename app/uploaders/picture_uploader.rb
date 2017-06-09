class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_limit: [200, 200]

  storage :file


  def store_dir
    "system/#{Rails.env}#{ENV['TEST_ENV_NUMBER']}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    'system/tmp/carrier_wave_cache'
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "system/#{Rails.env}#{ENV['TEST_ENV_NUMBER']}/#{model.class.to_s.underscore}/#{mounted_as}/#{id_partition}/#{model.id}"
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [200, 200]
  # end
  #
  # version :large do
  #   process resize_to_fit: [600, 600]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{Time.now.strftime('%Y%m%d%H%M%s')}.jpg" if original_filename.present?
  end
end
