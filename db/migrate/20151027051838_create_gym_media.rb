class CreateGymMedia < ActiveRecord::Migration
  def change
    create_table :gym_media do |t|
      t.string :mime_type
      t.string :name
      t.string :path
      t.integer :size
      t.integer :width
      t.integer :height
      t.string :encoding
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
    end
  end
end
