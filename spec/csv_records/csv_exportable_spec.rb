require 'spec_helper'
require 'set'

describe CSVRecords::CSVExportable do
  before(:all) do
    @conn = ActiveRecord::Base.connection
    @users_hashes = YAML.load_file(File.expand_path('../fixtures/users.yml', File.dirname(__FILE__)))
    @write_filepath = File.expand_path('../fixtures/users.csv.out', File.dirname(__FILE__))
    ActiveRecordTestConnector.load_schema
    User.create! @users_hashes
  end

  describe '.csv_write' do
    describe 'with default scope' do
      it 'writes all records with data matching the source' do
        User.csv_write(:filepath => @write_filepath)
        set = Set.new
        CSV.foreach(@write_filepath, :headers => true) {|row| set << row.to_hash.values }
        set.should eq User.connection.select_rows(User.scoped.to_sql).map {|row| row.map(&:to_s)}.to_set
      end
    end

    describe 'with custom scope' do
      it 'writes records from specified scope with data matching the source' do
        user_salary_scope = User.where(:salary => 131072)
        User.csv_write(:filepath => @write_filepath, :scope => user_salary_scope)
        set = Set.new
        CSV.foreach(@write_filepath, :headers => true) {|row| set << row.to_hash.values }
        set.should eq User.connection.select_rows(user_salary_scope.to_sql).map {|row| row.map(&:to_s)}.to_set
      end
    end

    describe 'with custom column names' do
      it 'writes only data from specified columns' do
        export_columns = %w{name salary kind}
        User.csv_write(:filepath => @write_filepath, :column_names => export_columns)
        CSV.foreach(@write_filepath, :headers => true) do |row|
          export_columns.should eq row.to_hash.keys
        end
      end
    end

    describe 'optional column group methods' do
      describe 'csv_export_column_names' do
        it 'defaults to all columns' do
          User.send(:csv_export_column_names).should eq User.column_names
        end
      end

      describe 'csv_export_excluded_column_names' do
        it 'defaults to an empty list' do
          User.send(:csv_export_excluded_column_names).should be_empty
        end
      end

      describe 'noncontent_column_names' do
        it 'includes primary keys and foreign keys' do
          User.send(:noncontent_column_names).should eq %w{id}
        end
      end
    end
  end
end
