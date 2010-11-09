module CSVRecords::SharedFileMethods

  private

  def csv_filepath(filename)
    File.join(csv_dir, filename)
  end

  def csv_filename
    "#{table_name}.csv"
  end
end
