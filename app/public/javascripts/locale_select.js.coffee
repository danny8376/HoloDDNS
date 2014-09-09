ready () ->
  $("#locale").change () ->
    value = $(this).val()
    location.search = if location.search.match(/([\?&])locale=[^\&]+/) then location.search.replace(/([\?&])locale=[^\&]+/, "$1locale=#{value}") else "?locale=#{value}"
