App.ApplicationController.reopen
  queryParams: ['user_id']
  user_id: null

  userIdChanged: (->
    if user_id != null
      @transitionToRoute 'user', user_id
  ).observes('user_id')
