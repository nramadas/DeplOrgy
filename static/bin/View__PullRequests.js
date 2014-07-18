// Generated by CoffeeScript 1.6.3
(function() {
  var div, renderable, templates, text, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ref = window.teacup, div = _ref.div, text = _ref.text, renderable = _ref.renderable;

  templates = {
    container: renderable(function() {
      return div(".pull-requests.standard-view", function() {
        div(".pull-requests__title.standard-view__title", function() {
          return text("Pull Requests");
        });
        return div(".pull-requests__container");
      });
    }),
    pull_requests: renderable(function(type, pull_requests) {
      return div(".pull-request-list.standard-view", function() {
        var index, pull_request, url, _i, _len, _results;
        div(".pull-request-list__title.standard-view__subtitle", type);
        _results = [];
        for (index = _i = 0, _len = pull_requests.length; _i < _len; index = ++_i) {
          pull_request = pull_requests[index];
          url = pull_request.url;
          _results.push(div(".pull-request-list__request", {
            url: url
          }, function() {
            return text("" + (index + 1) + ") " + pull_request.title);
          }));
        }
        return _results;
      });
    })
  };

  define(["view"], function(_arg) {
    var View, View__PullRequests;
    View = _arg.View;
    View__PullRequests = (function(_super) {
      __extends(View__PullRequests, _super);

      View__PullRequests.url = "/#pullrequests";

      View__PullRequests.DND_RE = /\[dnd\]/i;

      View__PullRequests.REVIEWED_RE = /\[([^}]+)\]/i;

      View__PullRequests.TICKET_RE = /HIP/;

      View__PullRequests.TYPE_MAP = {
        dnd: "Do NOT deploy these:",
        reviewed: "Ready for deploy:",
        other: "Open pull requests:"
      };

      function View__PullRequests() {
        this.organize_data = __bind(this.organize_data, this);
        View__PullRequests.__super__.constructor.apply(this, arguments);
        this.organized_requests = {
          reviewed: [],
          other: [],
          dnd: []
        };
        this.organization_members = [];
        $.when(this.fetch_organization_members(), this.fetch_pull_requests()).done(this.organize_data);
        return;
      }

      View__PullRequests.prototype.render = function() {
        this.$el = $(templates.container());
      };

      View__PullRequests.prototype.setup_handlers = function() {
        var _this = this;
        this.$el.on("click", ".pull-request-list__request", function(e) {
          var $pr, url;
          $pr = $(e.currentTarget);
          url = $pr.attr("url");
          _this.fetch_diff(url).done(function(diff_content) {
            return CDB.broadcast("request_view_change", "View__Diff", {
              view_args: [diff_content]
            });
          });
        });
      };

      View__PullRequests.prototype.fetch_organization_members = function() {
        var url;
        url = "https://api.github.com/orgs/";
        url += "" + ($.cookie('user_repo_owner')) + "/members";
        url += "?access_token=" + ($.cookie('user_auth_token')) + "&per_page=100";
        return $.ajax({
          url: url,
          type: "GET"
        });
      };

      View__PullRequests.prototype.fetch_pull_requests = function() {
        var url;
        url = "https://api.github.com/repos/";
        url += "" + ($.cookie('user_repo_owner')) + "/" + ($.cookie('user_repo')) + "/pulls";
        url += "?access_token=" + ($.cookie('user_auth_token')) + "&per_page=100";
        return $.ajax({
          url: url,
          type: "GET"
        });
      };

      View__PullRequests.prototype.fetch_diff = function(url) {
        url += "?access_token=" + ($.cookie('user_auth_token'));
        return $.ajax({
          url: url,
          headers: {
            Accept: "application/vnd.github.diff"
          },
          type: "GET"
        });
      };

      View__PullRequests.prototype.organize_data = function(members, requests) {
        var request_list, type, _ref1;
        this.organize_members(members[0]);
        this.organize_pull_requests(requests[0]);
        _ref1 = this.organized_requests;
        for (type in _ref1) {
          request_list = _ref1[type];
          this.draw_pull_requests(View__PullRequests.TYPE_MAP[type], request_list);
        }
      };

      View__PullRequests.prototype.organize_members = function(members) {
        var member, _i, _len;
        for (_i = 0, _len = members.length; _i < _len; _i++) {
          member = members[_i];
          this.organization_members.push(member.login);
        }
      };

      View__PullRequests.prototype.organize_pull_requests = function(requests) {
        var DND_RE, REVIEWED_RE, TICKET_RE, bracket_content, is_ticket, request, title, _i, _len;
        DND_RE = View__PullRequests.DND_RE, REVIEWED_RE = View__PullRequests.REVIEWED_RE, TICKET_RE = View__PullRequests.TICKET_RE;
        console.log("REQUESTS:", requests);
        for (_i = 0, _len = requests.length; _i < _len; _i++) {
          request = requests[_i];
          title = request.title;
          if (DND_RE.test(title)) {
            this.organized_requests.dnd.push(request);
          } else {
            bracket_content = REVIEWED_RE.exec(title);
            is_ticket = TICKET_RE.test(bracket_content != null ? bracket_content[1] : void 0);
            if (bracket_content && !is_ticket) {
              this.organized_requests.reviewed.push(request);
            } else {
              this.organized_requests.other.push(request);
            }
          }
        }
      };

      View__PullRequests.prototype.draw_pull_requests = function(title, requests) {
        this.$el.find(".pull-requests__container").append(templates.pull_requests(title, requests));
      };

      return View__PullRequests;

    })(View);
    return View__PullRequests;
  });

}).call(this);
