var collectionPersister = require('./collection');
var zlib = require('zlib');
var mongo = require('mongodb');
var _ = require('underscore');
var async = require('async');

const ErrorStackParser = require('error-stack-parser');
import {SourceMapConsumer} from 'source-map';
const fetch = require('node-fetch');
const URL_REGEXP = "^(([^:/\\?#]+):)?(//(([^:/\\?#]*)(?::([^/\\?#]*))?))?([^\\?#]*)(\\?([^#]*))?(#(.*))?$";
const rx = new RegExp(URL_REGEXP);
const sourceMapsConsumer = {};

module.exports = function tracerPersister(collName, mongoDb) {
  return function (app, traces, callback) {

    async.map(traces, deflateEvents, async function (err, compressedTraces) {
        if (err) {
          console.error('error when deflating events JSON:', err.message);
        } else {
          const mappedCompressedTraces = await mapErrorStack(compressedTraces);
          collectionPersister(collName, mongoDb)(app, mappedCompressedTraces, callback);


        }
      }
    );
  };
};

function deflateEvents(trace, callback) {
  trace = _.clone(trace);
  // events will be compressed before saving to the DB
  // this is used to reduce the data usage for the events
  var eventsJsonString = JSON.stringify(trace.events || []);
  zlib.deflate(eventsJsonString, function (err, convertedJson) {
    if (err) {
      callback(err);
    } else {
      trace.events = new mongo.Binary(convertedJson);
      trace.compressed = true;
      callback(null, trace);
    }
  });
}

/**
 * Strip any JSON XSSI avoidance prefix from the string (as documented
 * in the source maps specification), and then parse the string as
 * JSON.
 */
function parseSourceMapInput(str) {
  return JSON.parse(str.replace(/^\)]}'[^\n]*\n/, ''));
}

function mapStackTrace(traceStacks, consumer, message) {
  const stacks = JSON.parse(traceStacks);


  stacks.forEach((stack) => {
    let mappedStack = `${message}\n`;
    if (stack.stack != '') {

      const error = new Error(message);
      error.stack = stack.stack;
      const parsedError = ErrorStackParser.parse(error);

      parsedError.forEach((trace) => {
        const map = consumer.originalPositionFor({
          line: trace.lineNumber,
          column: trace.columnNumber
        });
        trace.map = map;
        if (map.line) {
          mappedStack = `${mappedStack}${trace.source}:${trace.lineNumber} (${map.source}:${map.line}:${map.column})\n`;
        } else {
          mappedStack = `${mappedStack}${trace.source}:${trace.lineNumber}\n`;
        }

      });
      stack.stack = mappedStack;
    }

  });
  return JSON.stringify(stacks);
}

async function mapErrorStack(compressedTraces) {
  let appUrl = '';
  let srcHash = '';
  const mappedCompressedTraces = [...compressedTraces];


  // await mappedCompressedTraces.forEach(async (trace) => {
  for (let trace of mappedCompressedTraces) {
    if (trace && trace.type && trace.type === 'client' && trace.stacks) {
      if (trace.info && trace.info.url) {
        const parts = rx.exec(trace.info.url);
        appUrl = parts[1] + parts[3];
      }

      if (trace.hash && trace.sourceMap === 'true') {
        srcHash = trace.hash;
      }


      const errorMessage = trace.name ? trace.name : 'Undefined error';

      if (appUrl && srcHash) {
        const soureMapUrl = appUrl + '/app.js.map';


        if (!sourceMapsConsumer[srcHash]) {

          try {
            const appSecret = getAppSecret(trace.appId);

            const headers = {
              'x-auth-token': appSecret,
            };

            const sourceMap = await fetch(soureMapUrl, {headers})
              .then((res) => {
                  if (res.status !== 200) {
                    throw new Error('' + res.status + ' response');
                  } else {
                    return res.text();
                  }
                }
              );
            const jsonSourceMap = parseSourceMapInput(sourceMap);
            sourceMapsConsumer[srcHash] = await new SourceMapConsumer(jsonSourceMap);

            trace.stacks = mapStackTrace(trace.stacks, sourceMapsConsumer[srcHash], errorMessage);

          } catch (err) {
            console.error('error when fetching source map ' + soureMapUrl + ':', err.message);
            delete sourceMapsConsumer[srcHash];
            return compressedTraces;
          }

        } else {
          sourceMapsConsumer[srcHash];
          trace.stacks = mapStackTrace(trace.stacks, sourceMapsConsumer[srcHash], errorMessage);

        }
      }
    }
  }
  return mappedCompressedTraces;
}

function getAppSecret(appId) {
  const app = Apps.findOne({_id: appId});
  return app.secret;
}
