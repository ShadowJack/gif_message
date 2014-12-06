GifMessage.User = DS.Model.extend
  # id - primary key in ember but it serializes/deserializes to vk_id on API call
  gifLength: DS.attr('number')
  gifFontColor: DS.attr('string')

GifMessage.UserSerializer = DS.ActiveModelSerializer.extend
  primaryKey: 'vk_id'