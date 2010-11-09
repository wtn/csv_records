module CSVRecords::TableEmpty
  def table_empty?
    count.zero?
  rescue ActiveRecord::StatementInvalid
    nil
  end
end
