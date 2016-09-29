# Mom

The mother of our applications.

## TODO

Replace "Mom" by application name in :

- README.md (this file)
- config/application.rb
- app/views/layouts/application.html.slim (title + navbar)

Change database names :

- config/database.yml

Change ApplicationMailer url options in :

- config/environments/production.rb
- config/environments/staging.rb

`config.action_mailer.default_url_options = {host: "mom.example.org"}`

Change ApplicationMailer default from in :

- app/mailer/application_mailer.rb
