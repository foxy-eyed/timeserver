## Task

Написать на ruby web-сервер, который возвращает текущее время UTC. Опционально сервер может принимать названия городов и показывать текущее время для них.

Также сервер должен максимально быстро возвращать результат и поддерживать большое кол-во соединений.

Примеры запросов:
```
/time

UTC: 2015-04-11 10:30:50

/time?Moscow,New%20York

UTC: 2015-04-11 10:30:50
Moscow: 2015-04-11 13:30:50
New York: 2015-04-11 02:30:50
```
--------------

## Built With
* Ruby 2.4.0
* Redis

## Local installation

* Clone this repository by run `git clone https://github.com/foxy-eyed/timeserver.git`.
* Go to project folder and run `bundle install` to install all dependencies.
* It it not necessary for start, but recommended to get Google API key. It allows to make more requests to Google services.
    * Register new app at [Google Developers Console](http://console.developers.google.com).
    * Create new API key for your new app.
    * Activate Google Maps Geocoding API.
    * Activate Google Maps Time Zone API.
    * Set API key value as environment variable: `ENV['API_KEY']`.
* Run `ruby time_sever.rb` to start server.
* Now you can open in browser [http://localhost:2000](http://localhost:2000) to check how it works.
