GifMessage.UserCaptureController = Ember.Controller.extend Ember.Evented,
  needs: 'user'

  gifWidth: 500            # gif width on screen and image itself
  gifHeight: 375           # gif height on screen and image itself
  gifLength: 2.0           # gif time length
  gifText: ''              # text to be displayed on gif
  gifFontColor: '#FFF'     # color of the text on the gif

  videoElement: null
  cameraStream: null
  animatedImage: null

  init: ->
    color = @get('controllers.user.model.gifFontColor') || '#FFF'
    @set('gifFontColor', color)
    length = @get('controllers.user.model.gifLength') || 2.0
    @set('gifLength', length)

    if !navigator.getMedia
      console.log('User media is not supported!');
    else
      gumHelper = window.GumHelper
      console.log 'gumHelper is ready!'
      gumHelper.startVideoStreaming((err, stream, videoElement, width, height) =>
        if err
          console.log "Error! Can't get video from user"
          #TODO: render error partial
          return

        $('#placeholder').hide()

        $(videoElement).width(@get('gifWidth'))
        videoHeight = Math.ceil(@get('gifWidth') / width * height)
        @set('gifHeight', videoHeight)
        $(videoElement).height(videoHeight + 'px')

        $(videoElement).addClass('img-thumbnail')
        @set 'videoElement', videoElement
        @set 'cameraStream', stream

        $('#video_container').append(videoElement)
        $('#video_container').show()
        $('.progress-container').show()
        $('#text_preview').show()
        $('#record_btn').prop('disabled', false)
      )

  actions:
    onShooting:( ->
      unless @get('videoElement') || @get('cameraStream')
        console.log "Can't get videoElement or stream from camera "
        return

      user = @get('controllers.user.model')
      user.set('gifLength', @get('gifLength'))
      user.set('gifFontColor', @get('gifFontColor'))
      user.save()

      $('#backcount').slideDown('fast', =>
        setTimeout(=>
          $('#backcount p').text('2')
          setTimeout(=>
            $('#backcount p').text('1')
            setTimeout(=>
              $('#backcount').slideUp()

              progressbarClass = 'tr' + @get('gifLength')*10
              $('.progress-bar').addClass(progressbarClass)
              $('.progress-bar').attr('aria-valuenow', '100')
              $('.progress-bar').width('100%')

              console.log 'Shooting stars'
              gifshot.createGIF(
                'gifWidth': @get('gifWidth')
                'gifHeight': @get('gifHeight')
                'keepCameraOn': true
                'cameraStream': @get('cameraStream')
                'numFrames': 10*@get('gifLength')
                'text': @get('gifText')
                'fontSize': '28px'
                'minFontSize': '16px'
                'resizeFont': true
                'fontColor': @get('gifFontColor')
                'progressCallback': (captureProgress) ->
                  if captureProgress == 1
                    $('#splash_screen').show()
                    $('#splash_screen').spin('large', '#e6e5d9')
              ,(result) =>
                console.log "I'm finished!"
                $('#splash_screen').hide()
                $('#splash_screen').spin(false)
                if result.error
                  console.log result.errorCode, ':', result.errorMsg
                else
                  image = result.image
                  animatedImage = document.createElement('img')
                  animatedImage.src = image
                  @set('animatedImage', animatedImage)
                  @trigger('gifIsReady')
              )
            ,700)
          ,700)
        ,700)
      )

    )