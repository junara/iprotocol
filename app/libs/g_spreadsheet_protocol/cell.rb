module GSpreadsheetProtocol
  class Cell
    attr_accessor :row, :col

    def initialize(ary)
      @row = ary[0]
      @col = ary[1]
    end

    def +(cell)
      new_row = if row.nil? && cell.row.nil?
                  nil
                else
                  row.to_i + cell.row.to_i
                end
      new_col = if col.nil? && cell.col.nil?
                  nil
                else
                  col.to_i + cell.col.to_i
                end
      GSpreadsheetProtocol::Cell.new([new_row, new_col])
    end
  end
end
