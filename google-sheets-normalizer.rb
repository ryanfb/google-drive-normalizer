#!/usr/bin/env ruby

require 'google_drive'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

session = GoogleDrive.saved_session('config.json')

dry_run = false

ARGV.each do |spreadsheet_id|
  if spreadsheet_id == '-n'
    $stderr.puts "Dry run mode enabled, no changes will be made"
    dry_run = true
  else
    spreadsheet = session.spreadsheet_by_key(spreadsheet_id)
    $stderr.puts "Normalizing #{spreadsheet_id} = #{spreadsheet.title}"
    spreadsheet.worksheets.each do |worksheet|
      $stderr.puts "Normalizing worksheet: #{worksheet.title}"
      (1..worksheet.num_rows).each do |row|
        (1..worksheet.num_cols).each do |col|
          original_value = worksheet[row,col]
          normalized_value = original_value.unicode_normalize(:nfc)
          if normalized_value != original_value
            if dry_run
              $stderr.puts "Would normalize:\n#{original_value}\nto:\n#{normalized_value}\n\n"
            else
              $stderr.puts "Normalized #{row},#{col} = #{normalized_value}"
              $stderr.flush
              worksheet[row,col] = normalized_value
            end
          end
        end
      end
      unless dry_run
        $stderr.puts "Saving worksheet: #{worksheet.title}"
        $stderr.flush
        worksheet.save
      end
    end
    $stderr.puts
  end
end
