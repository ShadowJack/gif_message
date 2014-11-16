class User < ActiveRecord::Base
  validates :vk_id, presence: true
  has_many :gifs

end