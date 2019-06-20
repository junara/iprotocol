require 'google/apis/sheets_v4'

module GSpreadsheetProtocol
  class Sheet
    GOOGLE_API_KEY = ENV['GOOGLE_API_KEY']
    attr_accessor :spreadsheet_id, :values, :protocol, :reagent, :google_api_key, :link

    def initialize(spreadsheet_id: nil, google_spreadsheet_url: nil, google_api_key: nil)
      @spreadsheet_id = get_spreadsheet_id(spreadsheet_id, google_spreadsheet_url)
      @google_api_key = google_api_key ? google_api_key : GOOGLE_API_KEY
      set_service(@google_api_key)
    end

    def link?
      raise StandardError, 'needs values' if values.nil?
      links = get_links.links_values
      GSpreadsheetProtocol::Url.valid?(links.first.url)
    end

    def get_protocol(values: @values, options: {})
      raise StandardError, 'needs values' if values.nil?
      @protocol = GSpreadsheetProtocol::Protocol.new({ values: values }.merge(options))
    end

    def get_reagent(values: @values, options: {})
      raise StandardError, 'needs values' if values.nil?
      @reagent = GSpreadsheetProtocol::Reagent.new({ values: values }.merge(options))
    end

    def get_links(values: @values, options: {})
      raise StandardError, 'needs values' if values.nil?
      @link = GSpreadsheetProtocol::Link.new({ values: values }.merge(options))
    end

    def get_spreadsheet_values(spreadsheet_id = @spreadsheet_id)
      @values = @service.get_spreadsheet_values(spreadsheet_id, spreadsheet_name).values
    rescue Google::Apis::ClientError
      @values = nil
      return false
    end

    def spreadsheet_url
      "https://docs.google.com/spreadsheets/d/#{@spreadsheet_id}/"
    end

    private

    def get_spreadsheet_id(spreadsheet_id, google_spreadsheet_url)
      return spreadsheet_id if spreadsheet_id.present?
      if google_spreadsheet_url.present?
        google_spreadsheet_url.match(/https.+\/spreadsheet.+\/d\/(.+)\//)[1]
      end
    end

    def load_spreadsheet
      service = Google::Apis::SheetsV4::SheetsService.new
      service.key = GOOGLE_API_KEY
      @spreadsheet = service.get_spreadsheet(@spreadsheet_id)
    end

    def get_sheet_names
      return unless @spreadsheet.present?
      @spreadsheet.sheets.map {|s| s.properties.title}
    end

    def spreadsheet_name(order_num = 0)
      @spreadsheet_name = spreadsheet_names[order_num]
    end

    def spreadsheet_names
      @service.get_spreadsheet(@spreadsheet_id).sheets.map {|sheet| sheet.properties.title}
    end

    def set_service(google_api_key)
      @service = Google::Apis::SheetsV4::SheetsService.new
      @service.key = google_api_key
    end
  end
end