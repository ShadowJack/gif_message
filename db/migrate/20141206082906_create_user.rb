class CreateUser < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      t.integer :vk_id
      t.float :gif_length
      t.string :gif_font_color
    end
    # setup primary key for table myself
    execute "ALTER TABLE users ADD PRIMARY KEY (vk_id);"

    add_index :users, :vk_id
  end
end
