class CreateSpSkills < ActiveRecord::Migration[5.1]
  def change
    create_table :sp_skills do |t|
      t.references :service_provider, foreign_key: { to_table: :users }, index: true
      t.references :skill, foreign_key: { to_table: :sub_categories }, index: true

      t.timestamps
    end
  end
end
