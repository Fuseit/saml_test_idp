# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a simple SAML Identity Provider (IDP) built with Rails 8.0.2 and Ruby 3.3.8, designed for testing SAML integrations. It provides basic SAML authentication functionality using the `saml_idp` gem.

## Architecture

- **Framework**: Rails 8.0.2 with minimal components (no ActiveRecord, ActiveJob, or ActionMailer)
- **Authentication**: Simple password-based authentication (password: "password")
- **SAML Configuration**: Located in `config/initializers/saml_idp.rb`
- **Main Controller**: `SamlIdpController` extends `SamlIdp::Controller` with three actions:
  - `new` (GET /saml/auth): Shows SAML auth form
  - `create` (POST /saml/auth): Processes SAML authentication requests
  - `show` (GET /saml/metadata): Returns signed SAML metadata
- **Routes**: Three SAML endpoints - auth (GET/POST) and metadata (GET)

## Development Commands

Start the server:
```bash
bin/rails s -p 3001
```

Install dependencies:
```bash
bundle install
```

Run tests:
```bash
bin/rails test
```

## SAML Configuration

The IDP provides these endpoints:
- **Auth URL**: `http://localhost:3001/saml/auth`
- **Metadata URL**: `http://localhost:3001/saml/metadata`
- **Certificate Fingerprint**: `9E:65:2E:03:06:8D:80:F2:86:C7:6C:77:A1:D9:14:97:0A:4D`

## Testing Authentication

The IDP accepts any email with password "password" and supports optional first_name and last_name parameters. Authentication logic is in `SamlIdpController#idp_authenticate`.

### Controller Implementation

The `SamlIdpController` includes three main methods:
- `idp_authenticate(email, password)`: Returns user object if password matches "password"
- `optional_attributes`: Extracts first_name and last_name from params
- `idp_make_saml_response(found_user)`: Generates SAML response with optional audience_uri

## Key Files

- `app/controllers/saml_idp_controller.rb`: Main authentication logic
- `config/initializers/saml_idp.rb`: SAML configuration including attributes and name ID formats
- `config/routes.rb`: SAML endpoint routing
- `test/controllers/saml_idp_controller_test.rb`: Controller tests
- `test/test_helper.rb`: Test configuration

## Testing Framework

The project uses **Minitest** with Rails test integration:
- **Test Helper**: Configures Rails test environment with minitest/rails
- **Controller Tests**: Tests all three SAML endpoints (auth form, authentication, metadata)
- **Test Coverage**: 
  - GET /saml/auth (auth form display)
  - GET /saml/metadata (metadata XML response)
  - POST /saml/auth (authentication with correct/incorrect passwords)
  - POST /saml/auth (authentication with optional first_name/last_name attributes)

## Notes

- Uses Puma as the web server
- Includes pry-byebug and pry-rails for debugging in development
- Test suite covers core SAML functionality