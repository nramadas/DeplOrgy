# TEMPLATES ====================================================================
{div, text, renderable} = window.teacup

templates =
    login: renderable ->
        div ".login", ->
            div ".login__content", ->
                div ".login__title", ->
                    text "DeplOrgy"
                div ".login__button", ->
                    text "Get Started"

# VIEW =========================================================================
define ["View"], ({View}) ->
    class View__Login extends View
        @url: "/#login"
        @fullscreen: true

        render: ->
            @$el = $(templates.login())
            return

        setup_handlers: ->
            @$el.on "click", ".login__button", (e) ->
                window.location = "/login"
            return

    return View__Login
