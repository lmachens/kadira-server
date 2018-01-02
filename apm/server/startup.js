Meteor.startup(() => {
  if (!Meteor.users.findOne({ username: 'Evgeny' })) {
    Accounts.createUser({
      username: 'Evgeny',
      email: 'mail@eluck.me',
      password: 'knotel2018',
      plan: 'business'
    });
  }
});
