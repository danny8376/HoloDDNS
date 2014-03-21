# Be sure to restart your server when you modify this file.

#Holoddns::Application.config.session_store :cookie_store, key: '_holoddns_session'
Holoddns::Application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 1.hour
