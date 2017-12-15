Template.signIn.events({
  "submit #sign-in-with-email": function(e, tmpl) {
    e.preventDefault();
    var email = tmpl.$("input[name=email]").val();
    var password = tmpl.$("input[name=password]").val();
    FlowComponents.callAction("signInWithEmail", email, password);
  }
});