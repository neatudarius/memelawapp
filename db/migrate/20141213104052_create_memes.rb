class CreateMemes < ActiveRecord::Migration
  def change
    create_table :memes do |t|
      t.string :url
      t.string :author
      t.integer :copy_count
      t.string :title
      t.text :tags
      t.integer :likes_count
      t.integer :favs_count
      t.integer :req_count

      t.timestamps
    end
  end
end
