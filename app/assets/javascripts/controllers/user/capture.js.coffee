GifMessage.UserCaptureRoute = Ember.Route.extend
  init: ->
    if !navigator.getMedia
      console.log('User media is not supported!');
    else
      gumHelper = window.GumHelper
      console.log 'gumHelper is ready!'
      gumHelper.startVideoStreaming((err, stream, videoElement, width, height) ->
        if err
          console.log "Error! Can't get video from user"
          #TODO: render error partial
        else
          $('#placeholder').hide()
          $(videoElement).width('500px')
          $(videoElement).height('470px')
          $(videoElement).addClass('img-thumbnail')
          $('#video_container').append(videoElement)
          $('#video_container').show()
      )