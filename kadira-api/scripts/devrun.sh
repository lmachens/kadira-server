#/bin/bash

MONGO_APP_URL=mongodb://localhost/apm \
MONGO_SHARD_URL_one=mongodb://localhost/apm \
MAIL_URL=smtp://user:pass@smtp.mailgun.org:587 \
JWT_SECRET="secret" \
JWT_LIFETIME="1d" \
AUTH_SECRET="secret" \
PORT=7007 \
NODE_ENV=production \
  node_modules/.bin/nodemon server.js
