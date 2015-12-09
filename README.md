# Mom

The mother of our applications.

## TODO

Replace "Mom" by application name in :

- config/application.rb
- config/initializers/session_store.rb
- app/views/layouts/application.html.slim (title + navbar)
- README.md

Change Devise mailer send in initializers/devise.rb

`config.mailer_sender = 'mom@example.com'`

Change ApplicationMailer url options in :

- config/environments/production.rb
- config/environments/staging.rb

`config.action_mailer.default_url_options = {host: "mom.example.org"}`

Change ExceptionNotification config in :

- config/initializers/exception_notification.rb
