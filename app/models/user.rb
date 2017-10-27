class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  accepts_nested_attributes_for :roles, allow_destroy: true

  has_many :sp_skills
  has_many :skill, class_name: 'SubCategory', through: :sp_skills

  has_many :clearances
  has_one :avatar, as: :uploadable, class_name: 'Upload'
  accepts_nested_attributes_for :avatar


  def save_avatar( params )
    Upload.create!( uploadable: self, file: parse_image( params[:image_base64] ) )
  rescue ActiveRecord::RecordInvalid => exception
    errors.add(:avatar, "Invalid file format. (Only JPG/JPEG/PNG allowed)")
  end

  private 

  # TODO Proper valdiation.
  def parse_image( image_base64 )
    image = Paperclip.io_adapters.for(image_base64) 
    image.original_filename = "file.jpg" 
    file = image
  end
end
