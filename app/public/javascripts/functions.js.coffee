window.ready = (cb) ->
  $(document).on 'page:change', cb
