case @status

when :ok
	jbuilder_success( json, true ) do
		json.auth @token
	end
when :unauthorized
  jbuilder_failure_oauth(json, false, @token)
else
	hash = { :undefined => "Undefined error" }
	jbuilder_failure( json, false, hash )
end