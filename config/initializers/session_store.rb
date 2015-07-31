# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_eskimodules_session',
  :secret      => '30f01d6d6dcea3cced1b17468a1a1bbba6cd0fcfa5482f5adcecbd6724a4dd50a4f28a4a506e81f9c22d108c622a38ef503529b861faa382ab3099bc5ec5d096'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
