GifMessage.IndexController = Ember.Controller.extend
  queryParams: ['user_id']
  user_id: null

  userIdChanged: (->
    if @get('user_id') != null
      @transitionToRoute 'user.capture', @get('user_id')
  ).observes('user_id')
