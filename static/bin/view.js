// Generated by CoffeeScript 1.6.3
(function() {
  var View;

  View = (function() {
    View.url = "/";

    View.fullscreen = false;

    function View() {
      this.$el = null;
      return;
    }

    View.prototype.content = function() {
      if (!this.$el) {
        this.render();
        this.setup_handlers();
        this.post_setup();
      }
      return this.$el;
    };

    View.prototype.render = function() {
      this.$el = $("<div>");
    };

    View.prototype.setup_handlers = function() {};

    View.prototype.post_setup = function() {};

    return View;

  })();

  define({
    View: View
  });

}).call(this);