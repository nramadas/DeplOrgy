# TEMPLATES ====================================================================
{div, text, renderable} = window.teacup

templates =
    navigation_item: renderable ({view_filename, title, msg}) ->
        random_color_num = ->
            return Math.floor((Math.random() * 100) + 50)

        random_color = ->
            color1 = random_color_num()
            color2 = random_color_num()
            color3 = random_color_num()
            return "rgb(#{color1},#{color2},#{color3})"

        color = random_color()

        item_attrs =
            view_filename: view_filename
            style: "background-color: #{color}; border-color: #{color}"

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
                view_filename: "pullrequests",
                title: "Pull Requests",
                msg: "Manage and review pull requests"
            }
        ]

        constructor: ->
            CDB.broadcast("request_url_change", "/navigation")
            return

        render: ->
            @$el = $(templates.navigation())

            for view in View__Navigation.NAVABLE_VIEWS
                $nav_item = $(templates.navigation_item(view))
                @$el.find(".navigation-menu__nav").append($nav_item)

            return

        setup_handlers: ->
            @$el.on "click", ".navigation-item", (e) ->
                $nav_item = $(e.currentTarget)
                view_filename = $nav_item.attr("view_filename")
                CDB.broadcast("request_view_change", view_filename)
                return
            return

    return View__Navigation
