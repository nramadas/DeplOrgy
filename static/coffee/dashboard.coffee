define ["teacup", "jquery", "view"], (tc, $, {View}) ->
    # TEMPLATES ================================================================
    {div, text, renderable} = tc

    templates =
        dashboard: renderable ->
            div ".dashboard", ->
                div ".dashboard__container"

        pull_requests: renderable (pull_requests) ->
            div ".pull-requests", ->
                for pull_request in pull_requests
                    div ".pull-requests__request", ->
                        text pull_request.title

    # VIEW =====================================================================
    class View__Dashboard extends View
        constructor: ->
            history.pushState({}, "", "/dashboard")
            @fetch_pull_requests().done(@draw_pull_requests)
            return

        render: ->
            @$el = $(templates.dashboard())
            return

        fetch_pull_requests: ->
            url = "https://api.github.com/repos/"
            url += "#{dp.repo_owner}/#{dp.repo_name}/pulls"
            url += "?access_token=#{dp.user_token}"
            return $.ajax
                url: url
                type: "GET"

        draw_pull_requests: (requests) =>
            @$el.find(".dashboard__container")
                .html(templates.pull_requests(requests))
            return

    # EXPORT ===================================================================
    return {View__Dashboard}
