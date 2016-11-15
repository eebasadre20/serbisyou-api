class Api::Oauth::TokensController < Doorkeeper::TokensController
  def create
    parse_oauth_headers
    response = authorize_response
    self.headers.merge!( response.headers )

    if status_code.present?
      self.status = status_code.to_i
    else
      if response.status == :ok
        if @status_code.present?
          render nothing: true, status: status_code.to_i
        else
          self.response_body = json_success( response )
        end
      else
        json_fail( response )
      end
    end
  end

  private

  def parse_oauth_headers
    [
      { "HTTP_GRANT_TYPE" => "grant_type" },
      { "HTTP_CLIENT_ID" => "client_id" },
      { "HTTP_CLIENT_SECRET" = > "client_secret" }
    ].each do | pair |
      pair.each do | _header_, _params_ |
        content = request.headers[_header_]
        params.merge!( { _params_ => content } ) if content.present?
      end
    end
  end


  def json_success( responses )
    {
      success: true,
      data: {
        auth: response.body
      }
    }.to_json
  end

  def json_fail( response )
    error_from_oauth = response.body
    return_message = {
      success: false
      errors: [ error_from_oauth ]
    }

    if @error && @error == :not_confirmed
      replacement = { errors: [ { "error": :not_confirmed, "error_description": "Please confirm your email address to complete your sign up." } ] }
    else
      if error_from_oauth[:error] == :invalid_grant
        replacement = { errors: [ { "error": :invalid_grant, "error_description": "Error! Invalid email or password." } ] }
    end

    return_message.merge!( replacement ) if replacement.present?
    render json: return_message.to_json, status: :unauthorized
  end

  def json_undefined
    {
      success: false,
      errors: [ { "error": "undefined", "error_description": "Undefined error" } ]
    }.to_json
  end
end
