# TEMPLATES ====================================================================
{div, text, renderable} = window.teacup

templates =
    container: renderable ->
        div ".pull-requests.standard-view", ->
            div ".pull-requests__title.standard-view__title", ->
                text "Pull Requests"
            div ".pull-requests__container"

    pull_requests: renderable (type, pull_requests) ->
        div ".pull-request-list.standard-view", ->
            div ".pull-request-list__title.standard-view__subtitle", type
            for pull_request, index in pull_requests
                div ".pull-request-list__request", ->
                    text "#{index + 1}) #{pull_request.title}"

# VIEW =========================================================================
define ["view"], ({View}) ->
    class View__PullRequests extends View
        @url = "/#pullrequests"
        @DND_RE = /\[dnd\]/i
        @REVIEWED_RE = /\[([^}]+)\]/i
        @TYPE_MAP = {
            dnd: "Do NOT deploy these:"
            reviewed: "Ready for deploy:"
            other: "Open pull requests:"
        }

        constructor: ->
            super
            @organized_requests =
                reviewed: []
                other: []
                dnd: []

            @organization_members = []

            $.when(@fetch_organization_members(), @fetch_pull_requests())
                .done(@organize_data)
            return

        render: ->
            @$el = $(templates.container())
            return

        fetch_organization_members: ->
            url = "https://api.github.com/orgs/"
            url += "#{$.cookie('user_repo_owner')}/members"
            url += "?access_token=#{$.cookie('user_auth_token')}&per_page=100"
            return $.ajax
                url: url
                type: "GET"

        fetch_pull_requests: ->
            url = "https://api.github.com/repos/"
            url += "#{$.cookie('user_repo_owner')}/#{$.cookie('user_repo')}/pulls"
            url += "?access_token=#{$.cookie('user_auth_token')}&per_page=100"
            return $.ajax
                url: url
                type: "GET"

        organize_data: (members, requests) =>
            console.log "MEMBERS:", members
            console.log "REQUESTS:", requests
            @organize_members(members[0])
            @organize_pull_requests(requests[0])

            console.log @organized_requests

            for type, request_list of @organized_requests
                @draw_pull_requests(View__PullRequests.TYPE_MAP[type],
                    request_list)
            return

        organize_members: (members) ->
            for member in members
                @organization_members.push(member.login)
            return

        organize_pull_requests: (requests) ->
            for request in requests
                title = request.title
                if View__PullRequests.DND_RE.test(title)
                    @organized_requests.dnd.push(request)
                else
                    bracket_content = View__PullRequests.REVIEWED_RE.exec(title)

                    if bracket_content?[1] in @organization_members
                        @organized_requests.reviewed.push(request)
                    else
                        @organized_requests.other.push(request)
            return

        draw_pull_requests: (title, requests) ->
            @$el.find(".pull-requests__container")
                .append(templates.pull_requests(title, requests))
            return

    return View__PullRequests
