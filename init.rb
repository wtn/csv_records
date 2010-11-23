require 'csv'

if CSV.const_defined? :Reader
  require 'fastercsv'
  Object.send(:remove_const, :CSV)
  CSV = FasterCSV
end

require File.dirname(__FILE__) << '/lib/csv_records.rb'
require File.dirname(__FILE__) << '/lib/csv_records/csv_exportable.rb'
require File.dirname(__FILE__) << '/lib/csv_records/csv_importable.rb'
require File.dirname(__FILE__) << '/lib/csv_records/table_empty.rb'
require File.dirname(__FILE__) << '/lib/csv_records/shared_file_methods.rb'

modules = [
  CSVRecords::CSVExportable,
  CSVRecords::CSVImportable,
  CSVRecords::TableEmpty,
  CSVRecords::SharedFileMethods,
]

ActiveRecord::Base.class_eval do
  extend *modules
end
