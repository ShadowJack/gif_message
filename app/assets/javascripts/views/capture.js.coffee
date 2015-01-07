GifMessage.CaptureView = Ember.View.extend
  templateName: 'capture-gif'

  didInsertElement: ->
    container = @get('parentView')
    pubView = GifMessage.PublishView.create()
    pubView.set('isVisible', false)
    container.pushObject pubView
    $('#gif_container').addClass()

    $('.progress').width(@get('controller.gifWidth'))

    slider = $('#time_slider').slider(
      min: 1.0
      max: 5.0
      step: 0.5
      value: @get('controller.gifLength') || 2.0
      formatter: (value)-> value + ' сек.'
    )
    slider.on('change', (evt) =>
      console.log 'New gif length: ', evt.value.newValue
      @set('controller.gifLength', evt.value.newValue)
    )
    colorpicker = $('#colorPicker').colorpicker().on('changeColor', (ev)->
      $('#text_preview').css('color', ev.color.toHex())
    )
    curr_color = @get('controller.gifFontColor') || '#FFF'
    $('#text_preview').css('color', curr_color)