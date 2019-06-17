module GSpreadsheetProtocol
  class Protocol
    ProtocolValue = Struct.new(:text, :photo)

    # row, col
    CONFIG = {
        base: [0, 0],
        text: [nil, 0],
        photo: [nil, 1],
        title: [1, nil],
        description: [2, nil],
        steps: [3, nil]
    }
    attr_accessor :base, :text, :photo, :title, :description, :steps, :values

    def initialize(attr = {})
      @base = set_attr(attr, :base)
      @text = set_attr(attr, :text)
      @photo = set_attr(attr, :photo)
      @title = set_attr(attr, :title)
      @description = set_attr(attr, :description)
      @steps = set_attr(attr, :steps)
      @values = attr[:values] ? attr[:values] : []
    end

    def set_attr(attr, sym)
      attr[sym] ? GSpreadsheetProtocol::Cell.new(attr[sym]) : GSpreadsheetProtocol::Cell.new(CONFIG[sym])
    end

    def title_value
      ProtocolValue.new(cell_value(base + title + text), cell_value(base + title + photo))
    end

    def description_value
      ProtocolValue.new(cell_value(base + description + text), cell_value(base + description + photo))
    end

    def steps_values(values: @values)
      rows = values[(steps.row)..nil].select {|value| value[(base + text).col].present?}
      rows.map {|value| ProtocolValue.new(value[(base + text).col], value[(base + photo).col])}
    end

    def cell_value(cell, values: @values)
      values[cell.row][cell.col]
    end
  end
end