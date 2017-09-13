class Clearance < ApplicationRecord
  belongs_to :user
  has_many :uploads, as: :uploadable
end
