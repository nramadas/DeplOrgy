// Generated by CoffeeScript 1.6.3
(function() {
  requirejs.config({
    baseUrl: "/static/bin"
  });

  requirejs(["login", "dashboard"], function(_arg, _arg1) {
    var View__Dashboard, View__Login, _ref;
    View__Login = _arg.View__Login;
    View__Dashboard = _arg1.View__Dashboard;
    if ((_ref = window.dp) != null ? _ref.user_token : void 0) {
      return $("body").append(new View__Dashboard().content());
    } else {
      return $("body").append(new View__Login().content());
    }
  });

}).call(this);