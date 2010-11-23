require 'spec_helper'

describe CSVRecords::SharedFileMethods do
  before(:each) do
    @source_dirpath = File.dirname(__FILE__)
    @klass = User.dup
    @klass::CSV_DIR = @source_dirpath    
  end

  describe '.csv_dir' do
    it 'returns path based on CSV_DIR constant' do
      @klass.send(:csv_dir).should eq(@source_dirpath)
    end
  end

  describe '.csv_filename' do
    it 'returns the table name appended by .csv' do
      User.send(:csv_filename).should eq(User.table_name << '.csv')
    end
  end

  describe '.csv_filepath' do
    it 'appends filename to csv_dir' do
      @klass.send(:csv_filepath, 'foo.csv').should eq(File.join @klass.send(:csv_dir), 'foo.csv')
    end
  end
end
