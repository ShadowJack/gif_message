class GifSerializer < ActiveModel::Serializer
  attributes :id, :vk_url, :title, :updated_at, :user_id
end