class CreateGifs < ActiveRecord::Migration
  def change
    create_table :gifs do |t|
      t.integer :user_id
      t.string :vk_url
      t.string :title

      t.timestamps
    end
  end
end
