requirejs.config
    baseUrl: "/static/bin"

requirejs ["login", "dashboard"], ({View__Login}, {View__Dashboard}) ->
    if window.dp?.user_token
        $("body").append(new View__Dashboard().content())
    else
        $("body").append(new View__Login().content())
