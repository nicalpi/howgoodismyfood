# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_howgoodismyfood_session',
  :secret      => 'eeaa930561417244b55a2e6eafeda5131f639e432c4c00083f7146d0d59dc2c7d72e16c8f3a7fe9cf21b9e64f055e606c2fadccf22d4ec1612bfc4349af0dcc2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
