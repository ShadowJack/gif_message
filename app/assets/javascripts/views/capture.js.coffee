GifMessage.CaptureView = Ember.View.extend
  templateName: 'capture-gif'

  didInsertElement: ->
    $('.progress').width(@get('controller.gifWidth'))
    #TODO: get value from user database and save it on record action
    slider = $('#time_slider').slider(
      min: 1.0
      max: 5.0
      step: 0.5
      value: 2.0
      formatter: (value)-> value + ' сек.'
    )
    slider.on('slide', (evt) =>
      @set('controller.gifLength', evt.value)
    )
    colorpicker = $('#colorPicker').colorpicker().on('changeColor', (ev)->
      $('#text_preview').css('color', ev.color.toHex())
    )
    @get('controller').on('gifIsReady', this, =>
      publishView = GifMessage.PublishView.create()
      container = Ember.View.views['capture_container']
      container.pushObject publishView
      container.removeObject this
    )

  willDestroyElement: ->
    @get('controller').off('gifIsReady', this, =>
      console.log 'Removed CaptureView'
    )