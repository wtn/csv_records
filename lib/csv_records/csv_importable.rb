module CSVRecords::CSVImportable
  def csv_import(options={})
    filename = options[:filename] || csv_filename
    filepath = options[:filepath] || csv_filepath(filename)
    initial_count = count
    transaction { csv_records_create(filepath) }
    count - initial_count
  end

  private

  def csv_records_create(filepath)
    CSV.foreach(filepath, :headers => true) do |row|
      create!(row.to_hash)
    end
  end
end
