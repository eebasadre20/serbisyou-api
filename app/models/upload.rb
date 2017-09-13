class Upload < ApplicationRecord
  belongs_to :uploadable, polymorphic: true

  scope :user_clearances, -> ( clearances ) { where( id: clearances ) }
  scope :user_certifcates, -> ( certificates ) { where( id: certificates) }
end
