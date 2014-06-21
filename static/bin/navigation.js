// Generated by CoffeeScript 1.6.3
(function() {
  var div, renderable, templates, text, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ref = window.teacup, div = _ref.div, text = _ref.text, renderable = _ref.renderable;

  templates = {
    navigation_item: renderable(function(_arg) {
      var color, item_attrs, msg, random_color, random_color_num, title, view_filename;
      view_filename = _arg.view_filename, title = _arg.title, msg = _arg.msg;
      random_color_num = function() {
        return Math.floor((Math.random() * 100) + 50);
      };
      random_color = function() {
        var color1, color2, color3;
        color1 = random_color_num();
        color2 = random_color_num();
        color3 = random_color_num();
        return "rgb(" + color1 + "," + color2 + "," + color3 + ")";
      };
      color = random_color();
      item_attrs = {
        view_filename: view_filename,
        style: "background-color: " + color + "; border-color: " + color
      };
      return div(".navigation-item", item_attrs, function() {
        div(".navigation-item__useless-box");
        return div(".navigation-item__content", function() {
          div(".navigation-item__title", title);
          return div(".navigation-item__text", msg);
        });
      });
    }),
    navigation: renderable(function() {
      return div(".navigation-menu.standard-view", function() {
        div(".navigation-menu__title.standard-view__title", function() {
          return text("Main Menu");
        });
        return div(".navigation-menu__nav");
      });
    })
  };

  define(["view"], function(_arg) {
    var View, View__Navigation;
    View = _arg.View;
    View__Navigation = (function(_super) {
      __extends(View__Navigation, _super);

      View__Navigation.NAVABLE_VIEWS = [
        {
          view_filename: "pullrequests",
          title: "Pull Requests",
          msg: "Manage and review pull requests"
        }
      ];

      function View__Navigation() {
        CDB.broadcast("request_url_change", "/navigation");
        return;
      }

      View__Navigation.prototype.render = function() {
        var $nav_item, view, _i, _len, _ref1;
        this.$el = $(templates.navigation());
        _ref1 = View__Navigation.NAVABLE_VIEWS;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          view = _ref1[_i];
          $nav_item = $(templates.navigation_item(view));
          this.$el.find(".navigation-menu__nav").append($nav_item);
        }
      };

      View__Navigation.prototype.setup_handlers = function() {
        this.$el.on("click", ".navigation-item", function(e) {
          var $nav_item, view_filename;
          $nav_item = $(e.currentTarget);
          view_filename = $nav_item.attr("view_filename");
          CDB.broadcast("request_view_change", view_filename);
        });
      };

      return View__Navigation;

    })(View);
    return View__Navigation;
  });

}).call(this);
