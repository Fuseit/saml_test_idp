class SamlIdpController < SamlIdp::IdpController

  private

    def idp_authenticate(email, password)
      OpenStruct.new optional_attributes.merge(email: email) if password == 'password'
    end

    def optional_attributes
      {
        first_name: params[:first_name].presence,
        last_name: params[:last_name].presence
      }
    end

    def idp_make_saml_response(found_user)
      encode_response found_user, audience_uri: params[:audience_uri].presence
    end
end
