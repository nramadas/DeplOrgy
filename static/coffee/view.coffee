class View
    url: "/"

    constructor: ->
        @$el = null
        return

    content: ->
        if not @$el
            @render()
            @setup_handlers()
            @post_setup()

        return @$el

    render: ->
        @$el = $("<div>")
        return

    setup_handlers: -> return
    post_setup: -> return

define({View})
