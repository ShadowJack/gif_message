class User < ActiveRecord::Base
  self.primary_key = :vk_id
  has_many :gifs

end