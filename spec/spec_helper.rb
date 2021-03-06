require 'simplecov'
require 'coveralls'
SimpleCov.start
Coveralls.wear!

require 'dotenv/load'
require 'vcr'
require 'addressable/uri'
require 'gopay'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock # or :fakeweb
  config.configure_rspec_metadata!

  config.filter_sensitive_data('<AUTHORIZATION FILTERED OUT>') do |interaction|
    interaction.request.headers['Authorization'].first if interaction.request.headers['Authorization']
  end

  config.filter_sensitive_data('<SET COOKIE FILTERED OUT>') do |interaction|
    interaction.response.headers['Set-Cookie'].first if interaction.response.headers['Set-Cookie']
  end

  config.filter_sensitive_data('client_id_filtered') do |interaction|
    uri = Addressable::URI.parse interaction.request.uri
    uri.user
  end

  config.filter_sensitive_data('client_secret_filtered') do |interaction|
    uri = Addressable::URI.parse interaction.request.uri
    uri.password
  end
end

VCR_OPTIONS = { match_requests_on: [:host, :path, :query], preserve_exact_body_bytes: false, decode_compressed_response: true }
# we cannot use default :uri matcher because the secret is in the URI https://23423423:secret@testgw.gopay.cz/api/oauth2/token
