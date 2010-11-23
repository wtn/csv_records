require 'spec_helper'

describe CSVRecords::TableEmpty do
  before(:all) do
    @conn = ActiveRecord::Base.connection
  end

  before(:each) do
    ActiveRecordTestConnector.load_schema
  end

  describe '.table_empty?' do
    describe 'when table is empty' do
      it 'returns true' do
        User.table_empty?.should be_true
      end
    end

    describe 'when table has records' do
      it 'returns false' do
        User.create!
        User.table_empty?.should be_false
      end
    end

    describe 'when table does not exist' do
      it 'returns nil' do
        drop_table(User.table_name)
        User.table_empty?.should be_nil
      end
    end

    def drop_table(table_name)
      conn = ActiveRecord::Base.connection
      conn.execute "DROP TABLE #{conn.quote_table_name(table_name)}"
    end
  end
end
