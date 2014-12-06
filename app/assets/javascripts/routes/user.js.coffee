GifMessage.UserRoute = Ember.Route.extend
  model: (params) ->
    (@store.find 'user', params.id).then((data) =>
      console.log 'Got new data', data
      @model = data
    ).catch((err)=>
        console.log "Can't find record: ", err
    )