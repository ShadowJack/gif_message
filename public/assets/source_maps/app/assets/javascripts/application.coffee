












# for more details see: http://emberjs.com/guides/application/
window.GifMessage = Ember.Application.create(
  LOG_TRANSITIONS: true
)

# Init vk API
$(->
  VK.init (->
    console.log 'Init Vk successfully'
  ), (->
    console.log 'Failed Vk initialization'
  ),
  '5.26'
)
