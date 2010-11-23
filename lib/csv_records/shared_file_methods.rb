module CSVRecords::SharedFileMethods

  private

  def csv_filepath(filename)
    File.join(csv_dir, filename)
  end

  def csv_filename
    "#{table_name}.csv"
  end

  def csv_dir
    const_get(:'CSV_DIR') or fail 'You must specify a base CSV directory.'
  end
end
