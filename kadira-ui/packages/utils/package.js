Package.describe({
  summary: "App utils",
  name: "local:utils"
});

Package.onUse(function(api) {
  configure(api);
  api.export("Utils", ["client", "server"]);
});

function configure(api) {
  api.versionsFrom("1.1.0.2");
  api.use("mrt:moment");
  api.addFiles("lib/utils.js", ["client", "server"]);
}