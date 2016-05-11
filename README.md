# Samle SAML IDP for testing purposes

To set it up, put in your SP settings:

**SAML Endpoint URL**: http://localhost:3001/saml/auth

**Certificate fingerprint**: 9E:65:2E:03:06:8D:80:F2:86:C7:6C:77:A1:D9:14:97:0A:4D:F4:4D

And start IDP:

```
bin/rails s -p 3001
```
