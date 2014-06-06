// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["teacup", "jquery", "view"], function(tc, $, _arg) {
    var View, View__Dashboard, div, renderable, templates, text;
    View = _arg.View;
    div = tc.div, text = tc.text, renderable = tc.renderable;
    templates = {
      dashboard: renderable(function() {
        return div(".dashboard", function() {
          return div(".dashboard__container");
        });
      }),
      pull_requests: renderable(function(pull_requests) {
        return div(".pull-requests", function() {
          var pull_request, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = pull_requests.length; _i < _len; _i++) {
            pull_request = pull_requests[_i];
            _results.push(div(".pull-requests__request", function() {
              return text(pull_request.title);
            }));
          }
          return _results;
        });
      })
    };
    View__Dashboard = (function(_super) {
      __extends(View__Dashboard, _super);

      function View__Dashboard() {
        this.draw_pull_requests = __bind(this.draw_pull_requests, this);
        history.pushState({}, "", "/dashboard");
        this.fetch_pull_requests().done(this.draw_pull_requests);
        return;
      }

      View__Dashboard.prototype.render = function() {
        this.$el = $(templates.dashboard());
      };

      View__Dashboard.prototype.fetch_pull_requests = function() {
        var url;
        url = "https://api.github.com/repos/";
        url += "" + dp.repo_owner + "/" + dp.repo_name + "/pulls";
        url += "?access_token=" + dp.user_token;
        return $.ajax({
          url: url,
          type: "GET"
        });
      };

      View__Dashboard.prototype.draw_pull_requests = function(requests) {
        this.$el.find(".dashboard__container").html(templates.pull_requests(requests));
      };

      return View__Dashboard;

    })(View);
    return {
      View__Dashboard: View__Dashboard
    };
  });

}).call(this);
