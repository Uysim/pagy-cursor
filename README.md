
# PagyCursor

Extra [Pagy](https://github.com/ddnexus/pagy) to work with cursor pagination


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pagy_cursor'
```

And then execute:

    $ bundle

## Usage

Include the backend in some controller:
```ruby
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

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
