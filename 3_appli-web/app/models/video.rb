require 'zip'
class Video < ApplicationRecord
  belongs_to :chaine
  has_many :images

  def extract_images
    chaine.stream.extract(self)
  end

  def clear_images
    FileUtils.rm_rf(Rails.root.join('public', 'export', id.to_s))
    images.delete_all
  end

  def zip_images
    #Attachment name
    filename = Rails.root.join('public', 'export', id.to_s+'.zip').to_s

    Zip::File.open(filename, Zip::File::CREATE) do |zipfile|
      images.each do |image|
        zipfile.add(image.filename.split('/').last, image.filename)
      end
    end
    puts "DONE"
  end

end
