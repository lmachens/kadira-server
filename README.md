# Knotel Kadira

This project reduces the original Kadira APM to a single Meteor project.
Most of the original features are working (like Slack alerts), but there is still a lot of work.
Includes Knotel private data! DO NOT contribute without cleanup!

## Running it

A mongo replica set is required!
Check conf/start_instance.sh for settings consumed by node.js and meteor. 

```
cd docker
./build.sh
./push-to-registry.sh
./deploy-to-host.sh
```

This uses the following ports:

* UI: 3000
* RMA: 11011
* API: 7007

## Login

If running on new Replica Set, the app creates 'admin' user:
email: admin@admin.com
password: admin

For now, users must be added to the collection 'users' manually before inviting them to collaborate the app. Without doin this, new users become pending collaborators and get an email with invitation link, but can't login using their emails.  This will be fixed in future.

## Meteor apm settings
`metricsLifetime` sets the maximum lifetime of the metrics. Old metrics are removed after each aggregation.
The default value is 2592000000 (1000 * 60 * 60 * 24 * 7 ^= 30 days).

```
"metricsLifetime": 2592000000
```

## Meteor client settings
When running without NGINX, you can use the following:
```
"kadira": {
    "appId": "...",
    "appSecret": "...",
    "options": {
        "endpoint": "http://your_host:11011",
        "sourceMap": "true"
    }
},
```
But as our webapp works using HTTPS, metrics and errors should be collected using HTTPS connection to APM, too.

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

* Add new users when sending collaboration invitations.
* Knotel-independent configuration for sharing with Knotable.
* Replace invalid links to old kadira docs.
__
* Direct db access of alertsman (apm/server/alertsman/server.js) and remove api (apm/server/api/server.js)
