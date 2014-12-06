#= require jquery
#= require jquery_ujs
#= require handlebars
#= require ember
#= require ember-data
#= require twitter/bootstrap
#= require bootstrap-slider
#= require bootstrap-colorpicker
#= require gumhelper
#= require gifshot
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