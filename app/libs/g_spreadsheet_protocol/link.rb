module GSpreadsheetProtocol
  class Link
    LinkValue = Struct.new(:url)

    # row, col
    CONFIG = {
        base: [0, 0],
        text: [nil, 0],
        title: [1, nil],
        description: [2, nil],
        links: [3, nil]
    }
    attr_accessor :base, :text, :title, :description, :links, :values

    def initialize(attr = {})
      @base = set_attr(attr, :base)
      @text = set_attr(attr, :text)
      @title = set_attr(attr, :title)
      @description = set_attr(attr, :description)
      @links = set_attr(attr, :links)
      @values = attr[:values] ? attr[:values] : []
    end

    def set_attr(attr, sym)
      attr[sym] ? GSpreadsheetProtocol::Cell.new(attr[sym]) : GSpreadsheetProtocol::Cell.new(CONFIG[sym])
    end

    def title_value
      LinkValue.new(cell_value(base + title + text))
    end

    def description_value
      LinkValue.new(cell_value(base + description + text))
    end

    def links_values(values: @values)
      rows = values[(links.row)..nil].select {|value| value[(base + text).col].present?}
      rows.map {|value| LinkValue.new(value[(base + text).col])}
    end

    def cell_value(cell, values: @values)
      values[cell.row][cell.col]
    end
  end
end