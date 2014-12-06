GifMessage.PublishView = Ember.View.extend
  templateName: 'publish'

  didInsertElement: ->
    gif = @get('controller.animatedImage')

    $('#gif_container').empty()
    $('#gif_container').append(gif)
    $('#gif_container').width(@get('controller.gifWidth'))
    $('#gif_container').height(@get('controller.gifHeight'))