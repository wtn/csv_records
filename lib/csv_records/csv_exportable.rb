module CSVRecords::CSVExportable
  def csv_write(options={})
    scope = options[:scope] || self.scoped
    filename = options[:filename] || csv_filename
    filepath = options[:filepath] || csv_filepath(filename)
    col_names = options[:column_names] || csv_export_column_names

    CSV.open(filepath, 'w') do |csv|
      csv << col_names
      sql = scope.select(col_names).to_sql
      scope.connection.select_rows(sql).each do |row|
        csv << row
      end
    end
    scope.count
  end

  private

  def csv_export_column_names
    column_names - csv_export_excluded_column_names
  end

  def csv_export_excluded_column_names
    []
  end

  def noncontent_column_names
    column_names - content_columns.map(&:name)
  end

  def timestamp_column_names
    %w{created_at updated_at}
  end
end
