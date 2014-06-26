# TEMPLATES ====================================================================
{div, text, renderable} = window.teacup

templates =
    navigation_item: renderable ({viewname, title, msg}) ->
        item_attrs =
            viewname: viewname

        div ".navigation-item", item_attrs, ->
            div ".navigation-item__useless-box"
            div ".navigation-item__content", ->
                div ".navigation-item__title", title
                div ".navigation-item__text", msg

    navigation: renderable ->
        div ".navigation-menu.standard-view", ->
            div ".navigation-menu__title.standard-view__title", ->
                text "Main Menu"
            div ".navigation-menu__nav"


# VIEW =========================================================================
define ["view"], ({View}) ->
    class View__Navigation extends View
        @NAVABLE_VIEWS = [
            {
                viewname: "View__PullRequests",
                title: "Pull Requests",
                msg: "Manage and review pull requests"
            }
        ]

        @url: "/#navigation"

        render: ->
            @$el = $(templates.navigation())

            for view in View__Navigation.NAVABLE_VIEWS
                $nav_item = $(templates.navigation_item(view))
                @$el.find(".navigation-menu__nav").append($nav_item)

            return

        setup_handlers: ->
            @$el.on "click", ".navigation-item", (e) ->
                $nav_item = $(e.currentTarget)
                viewname = $nav_item.attr("viewname")
                CDB.broadcast("request_view_change", viewname)
                return
            return

    return View__Navigation
