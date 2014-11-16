class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :vk_id
    end
  end
end
