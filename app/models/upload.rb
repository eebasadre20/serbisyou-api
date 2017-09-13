class Upload < ApplicationRecord
  belongs_to :uploadable, polymorphic: true

  scope :find_user_clearances, -> ( clearances ) { where( id: clearances ) }
  scope :find_user_certificates, -> ( certificates ) { where( id: certificates) }
end
