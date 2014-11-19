# For more information see: http://emberjs.com/guides/routing/

GifMessage.Router.reopen
  rootURL: '/'
  location: 'auto'

GifMessage.Router.map ()->
  @resource 'user', path: '/:id', ->
    @route 'capture'
    @route 'album'

