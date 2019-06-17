module GSpreadsheetProtocol
  class Reagent
    ReagentValue = Struct.new(:name, :quantity)

    # row, col
    CONFIG = {
        base: [0, 2],
        servings_for: [0, 1],
        name: [nil, 0],
        quantity: [nil, 1],
        reagents_list: [1, nil]
    }
    attr_accessor :base, :servings_for, :name, :quantity, :values, :reagents_list

    def initialize(attr = {})
      @base = set_attr(attr, :base)
      @servings_for = set_attr(attr, :servings_for)
      @name = set_attr(attr, :name)
      @quantity = set_attr(attr, :quantity)
      @reagents_list = set_attr(attr, :reagents_list)
      @values = attr[:values] ? attr[:values] : []
    end

    def set_attr(attr, sym)
      attr[sym] ? GSpreadsheetProtocol::Cell.new(attr[sym]) : GSpreadsheetProtocol::Cell.new(CONFIG[sym])
    end

    def servings_for_string
      cell_value(base + servings_for)
    end

    def reagents_list_values(values: @values)
      rows = values[(reagents_list.row)..nil].select {|value| value[(base + name).col].present?}
      rows.map {|value| ReagentValue.new(value[(base + name).col], value[(base + quantity).col])}
    end

    def cell_value(cell, values: @values)
      values[cell.row][cell.col]
    end
  end
end