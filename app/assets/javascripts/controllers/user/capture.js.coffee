GifMessage.UserCaptureController = Ember.Controller.extend

  videoShooter: null

  shootGif: (callback, numFrames, interval, progressCallback)->
    videoShooter = @get('videoShooter')
    unless videoShooter
      console.log "Can't get videoShooter"
      callback('')
      return
    videoShooter.getShot(callback, numFrames, interval, progressCallback)

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
          return

        $('#placeholder').hide()
        $(videoElement).width('500px')
        $(videoElement).height('470px')
        $(videoElement).addClass('img-thumbnail')
        $('#video_container').append(videoElement)
        $('#video_container').show()

        gifWidth = 135
        gifHeight = 101
        cropDimens =
          VideoShooter.getCropDimensions(width, height, gifWidth, gifHeight)

        @set('videoShooter', new VideoShooter(videoElement, gifWidth, gifHeight, width, height, cropDimens))
      )

  actions:
    onShooting: ->
      #TODO: copy implementation from meatspace usage of getScreenshot function but with manual pause