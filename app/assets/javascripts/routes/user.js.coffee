GifMessage.UserRoute = Ember.Route.extend
  model: (params) ->
    user = (@store.find 'user', params.id).then((user)=> user).catch((err)=>
      console.log 'No such user!'
      # create new user
      user = @store.createRecord('user', {vkId: params.id})
      user.save().then((data) => @model = data)
    )
