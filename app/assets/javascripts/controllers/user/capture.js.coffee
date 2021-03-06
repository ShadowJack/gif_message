GifMessage.UserCaptureController = Ember.Controller.extend Ember.Evented,
  needs: 'user'

  queryParams: ['access_token']

  gifWidth: 500            # gif width on screen and image itself
  gifHeight: 375           # gif height on screen and image itself
  gifLength: 2.0           # gif time length
  gifText: ''              # text to be displayed on gif
  gifFontColor: '#FFF'     # color of the text on the gif

  videoElement: null
  cameraStream: null
  animatedImage: null
  imageData: null

  init: ->
    color = @get('controllers.user.model.gifFontColor') || '#FFF'
    @set('gifFontColor', color)
    length = @get('controllers.user.model.gifLength') || 2.0
    @set('gifLength', length)

    if !navigator.getMedia
      console.log('User media is not supported!');
      window.alert('К сожалению ваш браузер не поддерживает запись видео с вебкамеры.')
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
              $('#backcount p').text('3')

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
                    $('#splash_screen').spin('large', '#3D332E')
              ,(result) =>
                console.log "I'm finished!"
                $('#splash_screen').hide()
                $('#splash_screen').spin(false)
                if result.error
                  console.log result.errorCode, ':', result.errorMsg
                else
                  image = result.image
                  @set('imageData', image)
                  animatedImage = document.createElement('img')
                  animatedImage.src = image
                  @set('animatedImage', animatedImage)

                  container = Ember.View.views['capture_container']
                  captView = container.get('childViews')[0]
                  pubView = container.get('childViews')[1]
                  captView.set('isVisible', false)
                  pubView.set('isVisible', true)

                  $('#gif_container').empty()
                  $('#gif_container').append(animatedImage)
                  $('#gif_container').width(@get('controller.gifWidth'))
                  $('#gif_container').height(@get('controller.gifHeight'))
                  $(animatedImage).removeClass()
                  $(animatedImage).addClass('img-thumbnail center-block')

                  #reset progressBar
                  progressbarClass = 'tr' + @get('gifLength')*10
                  $('.progress-bar').removeClass(progressbarClass)
                  $('.progress-bar').attr('aria-valuenow', '0')
                  $('.progress-bar').width('0%')

              )
            ,700)
          ,700)
        ,700)
      )

    )

    onBack: ->
      console.log 'Trying to go back to capture view'
      container = Ember.View.views['capture_container']
      captureView = container.get('childViews')[0]
      publishView = container.get('childViews')[1]
      captureView.set('isVisible', true)
      publishView.set('isVisible', false)


    onPublish: ->
      $('#splash_screen').show()
      $('#splash_screen').spin('large', '#3D332E')
      $.post '/api/v1/users/' + @get("controllers.user.model").id + '/publish',
        {image: @get('imageData'), access_token: @get('access_token')},
        (doc_data) ->
          $('#splash_screen').hide()
          $('#splash_screen').spin(false)
          console.log 'Doc data:', doc_data
          if doc_data.users
            $('#doc_url').attr('href', 'https://vk.com/doc' + doc_data.users[0].owner_id + '_' + doc_data.users[0].id)
            $('#doc_url').text('Посмотреть в документах')

    onPublishWall: ->
      $('#splash_screen').show()
      $('#splash_screen').spin('large', '#3D332E')
      $.post '/api/v1/users/' + @get("controllers.user.model").id + '/publish_wall',
        { image: @get('imageData'), access_token: @get('access_token') },
        (doc_data) ->
          $('#splash_screen').hide()
          $('#splash_screen').spin(false)
          console.log 'Resp:', doc_data
          doc_id = doc_data.users[0].id
          owner_id = doc_data.users[0].owner_id
          console.log 'doc' + owner_id + '_' + doc_id
          if doc_id && owner_id
            message = $('#message_text').val() || 'WebCamGif'
            VK.api 'wall.post', {message: message, attachments: 'doc' + owner_id + '_' + doc_id },
            (response) ->
              console.log 'Resp from wall.post: ', response
          else
            console.log "Can't get user_id or photo_id, sorry..."

    onDownload: ->
      window.location.href = @get('imageData').replace('image/gif', 'image/octet-stream')
