# Google Drive Normalizer

This is a script for normalizing content in Google Sheets spreadsheets to [Unicode Normalized Form C (NFC)](https://en.wikipedia.org/wiki/Unicode_equivalence#Normal_forms).

## Requirements

 * Ruby (tested with 2.4.1)
 * [Bundler](https://bundler.io/) for dependencies. Run `bundle install` in the script's directory before running the script for the first time.

## Usage

First, you'll need to follow [the `google-drive-ruby` Authorization instructions](https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md#on-behalf-of-you-command-line-authorization) to generate a `config.json` file to put in the directory you run the script from.

The `google-sheets-normalizer.rb` script takes any number of Google Sheets [Spreadsheet IDs](https://developers.google.com/sheets/api/guides/concepts#spreadsheet_id) as arguments, and an optional `-n` "dry run" flag to see what changes would be made, e.g.:

    bundle exec ./google-sheets-normalizer.rb -n '1qpyC0XzvTcKT6EISywvqESX3A0MwQoFDE8p-Bll4hps'

The script will iterate over all cells in all worksheets and update any cells where the NFC-normalized string differs from the original cell value.

The script also supports a `-a` ("auto-save") flag that will automatically save in smaller batches (tweakable with the `BATCH_SIZE` parameter inside the script, defaults to 1000 changes per batch), instead of one big save per worksheet. This is mostly useful if the full-worksheet save takes too long and aborts with a `HTTPClient::KeepAliveDisconnected` error — you can use this flag to make the initial normalization run complete.
