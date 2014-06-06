define ["jquery"], ($) ->
    class View
        constructor: ->
            @$el = null
            return

        content: ->
            if not @$el
                @render()
                @setup_handlers()

            return @$el

        render: ->
            @$el = $("<div>")
            return

        setup_handlers: -> return

    # EXPORT ===================================================================
    return {View}
