# Minifeed

Minimalist self hosted feed reader and its native iOS app.

## Screenshots

<table>
  <tr>
    <td>
      <a href="https://benoitmc.github.io/blobs/minifeed.rails/entries.png">
        <img src="https://benoitmc.github.io/blobs/minifeed.rails/entries.png" />
      </a>
    </td>
    <td>
      <a href="https://benoitmc.github.io/blobs/minifeed.rails/entry.png">
        <img src="https://benoitmc.github.io/blobs/minifeed.rails/entry.png" />
      </a>
    </td>
  </tr>
</table>


Screenshots of iOS app are available in the [iOS repository](https://github.com/BenoitMC/minifeed.ios).



## Features

- Organize feeds by category
- Add bookmarks
- An integrated reader mode
- OPML import and export
- Multi-user
- Keyboard shortcuts
- Simple UI based on Bootstrap
- A native [iOS app](https://github.com/BenoitMC/minifeed.ios)



## Anti-features

- No social/sharing features



## Demo / Deploy to Heroku

Click on the "Deploy" button and follow the instructions.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/benoitmc/minifeed.rails/tree/master)

Your login is `demo@example.org` and your password is `password`.
You can change your email/password and manage your feeds from the "Settings" menu.

Wait a minute for the demo feeds to load.

Warning : if you use free Heroku dynos, feeds are only imported when server is running.



## Docker install

```sh
git clone https://github.com/BenoitMC/minifeed.rails.git
cd minifeed.rails
docker-compose up
```

The first boot can take a few minutes to download all the dependencies.

Minifeed is listening on port `3000`.
Your login is `demo@example.org` and your password is `password`.
You can change your email/password and manage your feeds from the "Settings" menu.

To update an existing instance, simply run `git pull` and `docker-compose up`.

Database is stored in the `pgdata` directory, don't forget to backup it.



## Manual install

You can install Minifeed like any other Rails app :

```sh
git clone https://github.com/BenoitMC/minifeed.rails.git
cd minifeed.rails
bundle install
bundle exec rake db:prepare
bundle exec rails server
```

Your login is `demo@example.org` and your password is `password`.
You can change your email/password and manage your feeds from the "Settings" menu.

And to update an existing instance :


```sh
cd minifeed.rails
git pull origin master
bundle install
bundle exec rake db:migrate
bundle exec rails server
```



## Configuration

You can change some options using environment variables (copy `.env.example` to `.env` and change what you want) and in `config/minifeed.rb` file.



## Requirements / Technical information

Minifeed have a very few dependencies :

- Linux or macOS
- Ruby
- Postgresql

Minifeed is designed to be easy to install and maintain, simplicity is preferred over performances, so it has :

- No extra dependencies like Redis or ElasticSearch
- No file storage
- No extra process for running jobs
- No blockchain
- No 3 weeks old JS framework

By default (it can be changed in `config/minifeed.rb`) feeds are imported in background of the server process using [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler) and only in production environment.
To avoid duplicates, it's recommanded to use only one server instance (but you can have many threads using puma server).
You can also change config to import feeds in only one instance and not in others.
