
# PagyCursor
![](https://travis-ci.org/Uysim/pagy-cursor.svg?branch=master)

Extra [Pagy](https://github.com/ddnexus/pagy) to work with cursor pagination


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pagy_cursor'
```

And then execute:

    $ bundle install

## Usage

Include the backend in some controller:

```ruby
require "pagy_cursor/pagy/extras/cursor"

include Pagy::Backend
```
Default

```ruby
pagy_cursor(Post.all)
```

Before and After

```ruby
pagy_cursor(Post.all, after: 10)
pagy_cursor(Post.all, before: 10)
```

With UUID

```ruby
pagy_uuid_cursor(Post.all, after: "ce5d2741-4e52-49b2-bb76-c41b67ab3aad")
pagy_uuid_cursor(Post.all, before: "ce5d2741-4e52-49b2-bb76-c41b67ab3aad")
```

## Credits

Many thanks to:

- [Uysim](https://github.com/Uysim)
- [Eumir Gaspar](https://github.com/corroded)

## Support Databases

- SQLite
- Postgresql
- MySQL

## Tests & Contributing

To run tests in root folder of gem:

- ```export BUNDLE_GEMFILE=gemfiles/active_record_52.gemfile``` to work with Rails 5.2
- ```export DB=sqlite3``` to work with sqlite (see [support databases](#support-databases))
- ```bundle install```
- ```bundle exec rspec ```

To play with app cd test/dummy and rails s -b 0.0.0.0 (before rails db:migrate).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
