class HomeController < ApplicationController
  EXAMPLE_SPREADSHEET_ID = '1Ac5nCY_bLSD15BstHZ2fX4R1WzzHTUmDe0QReON_ff4'
  def index
    sheet = if protocol_params[:google_spreadsheet_url]
              GSpreadsheetProtocol::Sheet.new(
                  google_spreadsheet_url: protocol_params[:google_spreadsheet_url])
            elsif params[:google_spreadsheet_id]
              GSpreadsheetProtocol::Sheet.new(
                  spreadsheet_id: params[:google_spreadsheet_id])
            end

    @sheet = sheet if sheet && sheet.get_spreadsheet_values
    respond_to do |format|
      format.html
      format.js {render 'index.js'}
    end
  end

  private

  def protocol_params
    return {} unless params[:protocol].present?
    params.require(:protocol)
        .permit(:google_spreadsheet_url)
  end
end
