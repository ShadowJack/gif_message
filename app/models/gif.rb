class Gif < ActiveRecord::Base
  validate :vk_url, presence: true
  belongs_to :user

end