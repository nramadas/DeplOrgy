window.parse_int = (n) -> return parseInt(n, 10)

requirejs.config
    baseUrl: "/static/bin"

requirejs ["View__Login", "View__Dashboard"], (View__Login, View__Dashboard) ->
    $("body").append(new View__Dashboard().content())
