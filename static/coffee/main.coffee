requirejs.config
    baseUrl: "/static/bin"

requirejs ["View__Login", "View__Dashboard"], (View__Login, View__Dashboard) ->
    $("body").append(new View__Dashboard().content())
