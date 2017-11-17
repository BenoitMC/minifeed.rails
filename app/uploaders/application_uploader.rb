class ApplicationUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    if Rails.env.test?
      "uploads.test/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end
