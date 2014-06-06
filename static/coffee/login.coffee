define ["teacup", "jquery", "view"], (tc, $, {View}) ->
    # TEMPLATES ================================================================
    {div, text, renderable} = tc

    templates =
        login: renderable ->
            div ".login", ->
                div ".login__button", ->
                    text "Login"

    # VIEW =====================================================================
    class View__Login extends View
        render: ->
            @$el = $(templates.login())
            return

        setup_handlers: ->
            @$el.on "click", ".login__button", (e) ->
                window.location = "/login"
            return

    # EXPORT ===================================================================
    return {View__Login}
