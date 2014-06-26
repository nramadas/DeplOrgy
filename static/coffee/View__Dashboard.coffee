# TEMPLATES ====================================================================
{div, text, a, renderable} = window.teacup

templates =
    dashboard: renderable ->
        div ".dashboard", ->
            div ".dashboard__header", ->
                a ".dashboard__header-title", {href: "/"}, ->
                    text "DeplOrgy"
            div ".dashboard__container"

# VIEW =========================================================================
define ["View", "View__Navigation"], ({View}, View__Navigation) ->
    class View__Dashboard extends View
        @ROUTES =
            "#login": "View__Login"
            "#navigation": "View__Navigation"
            "#pullrequests": "View__PullRequests"

        constructor: ->
            @$container = null
            return

        render: ->
            @$el = $(templates.dashboard())
            @$container = @$el.find(".dashboard__container")
            return

        toggle_header: (should_show) ->
            @$el.find(".dashboard__header").toggle(should_show)
            return

        goto_view_from_url: =>
            hash = window.location.hash

            for re, view of View__Dashboard.ROUTES
                regexp = new RegExp(re)

                if regexp.test(hash)
                    CDB.broadcast("request_view_change", view, false)
                    return

            # Fallback
            CDB.broadcast("request_view_change", "View__Navigation")
            return

        setup_handlers: ->
            CDB.listen "request_url_change", (url) ->
                history.pushState({}, "", url)
                return

            CDB.listen "request_view_change", (view_name, push_url=true) =>
                require [view_name], (view_klass) =>
                    @$container.html(new view_klass().content())
                    @toggle_header(not view_klass.fullscreen)
                    if push_url
                        history.pushState({}, "", view_klass.url)
                    return
                return

            $(window).on("hashchange popstate", @goto_view_from_url)
            return

        post_setup: ->
            if $.cookie("user_auth_token")
                @goto_view_from_url()
            else
                CDB.broadcast("request_view_change", "View__Login")
            return

    return View__Dashboard
