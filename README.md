# Meteor APM Server (ex. Kadira)

This project reduces the original Kadira APM to a single Meteor project.
Most of the original features are working (like Slack alerts), but there is still a lot of work.
Feel free to contribute!

## Running it

A mongo replica set is required!
Check 'docker/meteor-apm-server/deploy-to-host-example.sh' for settings consumed by node.js and meteor and deployment options.

This uses the following ports:

* UI: 3000
* RMA: 11011
* API: 7007

You can use the steps below to build your own APM image.
```
cd docker/meteor-apm-server
./build.sh
./push-to-registry.sh
./deploy-to-host.sh
```
The build script uses our meteor-base images for building and running meteor application bundles. See `docker/meteor-base/` for details.

## Login

If running on new Replica Set, the app creates 'admin' user:
email: admin@admin.com
password: admin

When inviting new users to collaborate or own the app, new entries are added to the collection 'users' with their emails as login and 'kadira2018' as password. Then ivitation link is sended using settings from 'MAIL_URL' environment variable. Users can change their passwords after logon.

If you don't have any mail server settings, you can manually add users to the app in 'apps' collection:
```
    "perAppTeam" : [ 
        {
            "role" : "collaborator",
            "userId" : "XXXXXXXXXXXXX" <--- document ID of user entry in 'users' collection.
        }
    ]
```


## Meteor apm settings
`metricsLifetime` sets the maximum lifetime of the metrics. Old metrics are removed after each aggregation.
The default value is 604800000 (1000 * 60 * 60 * 24 * 7 ^= 7 days).

```
"metricsLifetime": 604800000
```

## Meteor client settings
```
"kadira": {
    "appId": "...",
    "appSecret": "...",
    "options": {
        "endpoint": "http://kadira.mydomain.com:11011",
        "sourceMap": "true",
        "hash": "f84dea983ab7c071b0ac038b26a9ad11899c062b"
    }
},
```
### ATTENTION! As most webapps work using HTTPS, metrics and errors should be collected using HTTPS connection to APM, too. You can build NGINX image for it, using example settings provided in ./docker/nginx folder of this repo.

## Changes to original Kadira

* Reduce to one project
* Added MongoDB indexes
* Removed MongoDB shards
* Remove raw data after processed
* Use Meteor 1.6 (Node v8)
* Removed premium packages
* Replace invalid links to old kadira docs
* Dockerized bundle
* Source-maps support (with knotel:meteor-apm-client package)

## ToDo

* Direct db access of alertsman (apm/server/alertsman/server.js) and remove api (apm/server/api/server.js)
