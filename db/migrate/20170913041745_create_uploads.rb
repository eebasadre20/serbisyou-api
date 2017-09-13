class CreateUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :uploads do |t|
      t.references :uploadable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
