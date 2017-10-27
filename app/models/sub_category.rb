class SubCategory < ApplicationRecord
  belongs_to :category

  has_many :sp_skills
  has_many :service_providers, class_name: 'Users', through: :sp_skills
end
