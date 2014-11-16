GifMessage.IndexController = Ember.Controller.extend
  queryParams: ['user_id']
  user_id: null

  userIdChanged: (->
    if @get('user_id') != null
      @transitionToRoute 'user', {id: @get('user_id')}
  ).observes('user_id')