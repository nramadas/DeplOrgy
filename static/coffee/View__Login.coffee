# TEMPLATES ====================================================================
{div, text, renderable} = window.teacup

templates =
    login: renderable ->
        div ".login", ->
            div ".login__title", ->
                text "DeplOrgy"
            div ".login__tagline", ->
                text "The fastest, easiest way to manage pull requests"
            div ".login__button", ->
                text "Get Started"

# VIEW =========================================================================
define ["view"], ({View}) ->
    class View__Login extends View
        render: ->
            @$el = $(templates.login())
            return

        setup_handlers: ->
            @$el.on "click", ".login__button", (e) ->
                window.location = "/login"
            return

    return View__Login
