class SpSkill < ApplicationRecord
  belongs_to :service_provider, class_name: 'User'
  belongs_to :skill, class_name: 'SubCategory'
end
