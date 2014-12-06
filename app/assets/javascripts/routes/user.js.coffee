GifMessage.UserRoute = Ember.Route.extend
  model: (params) ->
    user = (@store.find 'user', params.id).then((user)=> @model = user).catch((err)=>
      console.log 'No such user!'
      # create new user
      user = @store.createRecord('user', {vkId: params.id, gifLength: 2.0, gifFontColor: '#FFF'})
      user.save().then((data) => @model = data)
    )
