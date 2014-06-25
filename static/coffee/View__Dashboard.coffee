# TEMPLATES ====================================================================
{div, text, renderable} = window.teacup

templates =
    dashboard: renderable ->
        div ".dashboard", ->
            div ".dashboard__header", ->
                div ".dashboard__header-title", ->
                    text "DeplOrgy"
            div ".dashboard__container"

# VIEW =========================================================================
define ["view", "navigation"], ({View}, View__Navigation) ->
    class View__Dashboard extends View
        constructor: ->
            @$container = null
            return

        render: ->
            @$el = $(templates.dashboard())
            @$container = @$el.find(".dashboard__container")
            return

        setup_handlers: ->
            CDB.listen "request_url_change", (url) ->
                history.pushState({}, "", url)
                return

            CDB.listen "request_view_change", (view_name) =>
                require [view_name], (view_klass) =>
                    @$container.html(new view_klass().content())
                    return
                return
            return

        post_setup: ->
            @$container.html(new View__Navigation().content())
            return

    return View__Dashboard
