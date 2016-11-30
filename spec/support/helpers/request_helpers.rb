module Request
  module JsonHelpers
    def json
      @json ||= JSON.parse( response.body )
    end

    def errors
      @errors ||= collected_errors( json['errors'] )
    end
  end
end
