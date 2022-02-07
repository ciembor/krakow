desc "Import data from XLSX and XLS files."

task import_spreadsheet: [:environment] do
  SpreadsheetImporter.new().import_files
end
