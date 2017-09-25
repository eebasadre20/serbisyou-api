class Upload < ApplicationRecord
  belongs_to :uploadable, polymorphic: true
  has_attached_file :file, style: { medium: "300x300>", thumb: "100x100>" },
                          url: "/tmp/:hash.:extension",
                          hash_secret: "abc123"

  validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/

  scope :find_user_clearances, -> ( clearances ) { where( id: clearances ) }
  scope :find_user_certificates, -> ( certificates ) { where( id: certificates) }
end
