require 'spec_helper'
require 'yaml'

describe CSVRecords::CSVImportable do
  before(:all) do
    @filepath = File.expand_path('../fixtures/users.csv', File.dirname(__FILE__))
  end

  before(:each) do
    ActiveRecordTestConnector.load_schema
  end

  describe '.csv_import' do
    it 'creates a record for each row in the csv file' do
      expect { User.csv_import(:filepath => @filepath) }
        .to change{ User.count }
        .from(0)
        .to(4)
    end

    it 'returns the number of records created by the import' do
      10.times { User.create! }
      User.csv_import(:filepath => @filepath).should eq(4)
    end

    it 'writes expected data' do
      expected_data = YAML.load_file(File.expand_path('../fixtures/users.yml', File.dirname(__FILE__)))
      User.csv_import(:filepath => @filepath)
      expected_data.each do |attributes|
        User.where(attributes).count.should eq(1)
      end
    end
  end
end
