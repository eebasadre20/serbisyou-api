class CreateSubCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_categories do |t|
      t.string :name
      t.text :description
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
