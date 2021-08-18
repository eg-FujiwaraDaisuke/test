'use strict';

var fs = require('fs');
var path = require('path');
var async = require('async');

const {google} = require('googleapis');
const {oAuth2ClientGen} = require('google-auth-token-generator');

(async () => {
  var config = loadConfig('config.json');
  var files = config.files;
  var placeHolders = {
      '{num}' : '%d',
      '{str}' : '%s'
  };

  const auth = oAuth2ClientGen({library: google});
  const sheets = google.sheets({version: 'v4', auth});
  var rows;
  try {
    const res = await sheets.spreadsheets.values.get({
      spreadsheetId: '1q-Rj5CO6Da-NZAjeSJWpvuwzKWwZXEtVM65NlhBo_nk',
      range: 'Localization!A2:C',
    });
    rows = res.data.values;
  } catch (error) {
    console.log('The API returned an error: ' + error);
  }

  async.series([function (next) {
      var filtered = [];
      rows.forEach(function (row) {
          if (!row[0]) {
              return;
          }
          filtered.push(row);
      });
      rows = filtered;
      return next();

  }, function (next) {
      rows = rows.sort(function (a, b) {
          return a[0] > b[0] ? 1 : -1;
      });
      return next();

  }, function (next) {
      // search duplicated
      var duplicated = searchDuplicated(rows);

      if (duplicated.length) {
          return next('found duplicated words.\n - ' + duplicated.join('\n - '));
      }
      return next();

  }, function (next) {
      var writeTasks = files
          .filter(param => param.column_key)
          .map(param => function (callback) {
              writeFile({
                  filename: filePath(param.path),
                  columnKey: param.column_key,
                  rows: rows,
                  placeHolders: placeHolders,
                  formatter: jsonFormat,
                  delimiter: ',\n',
                  header: '{\n',
                  footer: '\n}\n'
              }, callback);
          });
      async.parallel(writeTasks, next);
  }], function (err) {
      if (err) {
          console.error([
              '****** error ******',
              err.toString()
          ].join('\n').error);
          return;
      }
      console.log('done.');
  });
})();



function filePath (filename) {
    if (/^\//.test(filename)) {
        return filename;
    } else {
        return path.resolve(__dirname, filename);
    }
}

function loadConfig (filename) {
    var body = fs.readFileSync(filePath(filename), 'utf8');
    return JSON.parse(body);
}

function searchDuplicated (rows) {
    // 重複するrowがあれば、そのキーのリストを返す
    var duplicated = [];
    var map = {};
    rows.forEach(function (row) {
        if (map[row[0]]) {
            duplicated.push(row[0]);
        }
        map[row[0]] = true;
    });
    return duplicated;
}

function xmlFormat (key, value) {
    // escape
    value = value.replace(/'/g, '\\\'');
    value = value.replace(/"/g, '\"');
    value = value.replace(/&/g, '&amp;');
    value = value.replace(/</g, '&lt;');
    value = value.replace(/>/g, '&gt;');

    ['d', 's'].forEach(function (str) {
        var count = 1;
        var regexp = new RegExp('%' + str);
        while (regexp.test(value)) {
            value = value.replace(regexp, '%' + count + '$' + str);
            count++;
        }
    });

    return '    ' + '<string name="' + key + '">' + value + '</string>';
};

function jsonFormat (key, value) {
    value = value.replace(/"/g, '\\"');
    value = value.replace(/\r\n/g, '\\n');
    value = value.replace(/\r/g, '\\n');
    value = value.replace(/\n/g, '\\n');
    return '"'  + key + '" : "' + value + '"';
};

function writeFile (opts, callback) {
    var columnKey = opts.columnKey;
    var filename = opts.filename;
    var rows = opts.rows;
    var placeHolders = opts.placeHolders;
    var formatter = opts.formatter;
    var delimiter = opts.delimiter;
    var header = opts.header;
    var footer = opts.footer;
    var formattedRows = [];

    console.log('write file "%s"', filename);

    var ENCODING = 'utf8';

    var writable = fs.createWriteStream(filename);

    async.series([function (next) {
        // write header
        writable.write(header, ENCODING, next);

    }, function (next) {
        // write body
        async.eachSeries(rows, function (row, nextItem) {
            if (!row[0]) {
                nextItem();
                return;
            }

            var value;
            if (columnKey=="jp") {
              value = row[1];
            } else {
              value = row[2];
            }

            for (var exp in placeHolders) {
                value = value.replace(new RegExp(exp, 'g'), placeHolders[exp]);
            }

            var line = formatter(row[0], value);
            formattedRows.push(line);
            nextItem();
        }, next);
    }, function (next) {
        writable.end(formattedRows.join(delimiter) + footer, ENCODING, next);
    }], callback);
}
