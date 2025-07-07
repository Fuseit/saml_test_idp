class SamlIdpController < ApplicationController
  include SamlIdp::Controller
  skip_forgery_protection

  def new
    # GET /saml/auth - Show SAML auth form
    render plain: "SAML Auth Form"
  end

  def create
    # POST /saml/auth - Process SAML authentication
    if params[:SAMLRequest]
      # SAML SP-initiated request
      render plain: idp_make_saml_response(idp_authenticate(params[:email], params[:password]))
    else
      render plain: "Invalid SAML request"
    end
  end

  def show
    # GET /saml/metadata - Return SAML metadata
    render xml: SamlIdp.metadata.signed
  end

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
