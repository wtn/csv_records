require 'csv'

if CSV.const_defined? :Reader
  require 'fastercsv'
  Object.send(:remove_const, :CSV)
  CSV = FasterCSV
end

require 'csv_records/csv_exportable'
require 'csv_records/csv_importable'
require 'csv_records/table_empty'
require 'csv_records/shared_file_methods'

modules = [
  CSVRecords::CSVExportable,
  CSVRecords::CSVImportable,
  CSVRecords::TableEmpty,
  CSVRecords::SharedFileMethods,
]

ActiveRecord::Base.class_eval do
  modules.each {|m| extend m }

  def self.csv_dir
    const_get(:'CSV_DIR') or fail 'You must specify a base CSV directory.'
  end
end
