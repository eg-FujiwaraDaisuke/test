var fs = require('fs');
var path = require('path');

var async = require('async');
var SheetLoader = require('sheet-loader');


var UNDEFINED_KEY = '【Undefined】';
var SHEET_KEY = '1q-Rj5CO6Da-NZAjeSJWpvuwzKWwZXEtVM65NlhBo_nk';
var SHEET_NAME = 'Localization';
var COLUMN_KEYS_LOCALIZE = ['jp', 'en'];

(function () {
    var config = loadConfig('config.json');
    var files = config.files;
    var placeHolders = {
        '{num}' : '%d',
        '{str}' : '%s'
    };

    var sheetLoader = new SheetLoader({
        sheetKey: SHEET_KEY,
        sheetTitle: SHEET_NAME,
        columns: {
            key: 'key',
            jp: 'jp',
            en: 'en'
        }
    });

    var book, bookInfo, worksheet, rows;

    async.series([function (next) {
        // load sheet
        sheetLoader.load({ usePrompt: true }, function (err, result) {
            if (err) {
                console.log(err);
                next(err);
                return;
            }
            rows = result;
            next();
        });

    }, function (next) {
        // reduce empty row
        var filtered = [];
        rows.forEach(function (row) {
            if (!row.key) {
                return;
            }
            filtered.push(row);
        });
        rows = filtered;
        return next();

    }, function (next) {
        // sort
        rows = rows.sort(function (a, b) {
            return a.key > b.key ? 1 : -1;
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
    console.log("searchDuplicated");
    // 重複するrow.keyがあれば、そのキーのリストを返す
    var duplicated = [];
    var map = {};
    rows.forEach(function (row) {
        if (map[row.key]) {
            duplicated.push(row.key);
        }
        map[row.key] = true;
    });
    console.log(duplicated);
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
            if (!row[columnKey] || !row.key) {
                nextItem();
                return;
            }

            var value = row[columnKey];

            for (var exp in placeHolders) {
                value = value.replace(new RegExp(exp, 'g'), placeHolders[exp]);
            }

            var line = formatter(row.key, value);
            formattedRows.push(line);
            nextItem();
        }, next);
    }, function (next) {
        writable.end(formattedRows.join(delimiter) + footer, ENCODING, next);
    }], callback);
}
