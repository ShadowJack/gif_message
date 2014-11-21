#= require jquery
#= require jquery_ujs
#= require handlebars
#= require ember
#= require ember-data
#= require twitter/bootstrap
#= require gumhelper
#= require omggif
#= require Animated_GIF
#= require VideoShooter
#= require_self
#= require_tree .

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