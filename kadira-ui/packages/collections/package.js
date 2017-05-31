Package.describe({
  summary: "App collections",
  name: "local:collections"
});

Package.onUse(function(api) {
  configure(api);
  api.export("Apps", ["client", "server"]);
  api.export("PendingUsers", ["client", "server"]);
  api.export("Alerts", ["client", "server"]);
  api.export("ErrorsMeta", ["client", "server"]);
});

function configure(api) {
  api.versionsFrom("1.1.0.2");
  api.use("mongo");
  api.addFiles("lib/collections.js", ["client", "server"]);
}