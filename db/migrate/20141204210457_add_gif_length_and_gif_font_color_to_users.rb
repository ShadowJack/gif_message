class AddGifLengthAndGifFontColorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gif_length, :float
    add_column :users, :gif_font_color, :string
  end
end
