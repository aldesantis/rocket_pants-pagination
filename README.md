# RocketPants::Pagination

[![Gem Version](https://badge.fury.io/rb/rocket_pants-pagination.svg)](http://badge.fury.io/rb/rocket_pants-pagination)
[![Build Status](https://travis-ci.org/alessandro1997/rocket_pants-pagination.svg)](https://travis-ci.org/alessandro1997/rocket_pants-pagination)
[![Dependency Status](https://gemnasium.com/alessandro1997/rocket_pants-pagination.svg)](https://gemnasium.com/alessandro1997/rocket_pants-pagination)
[![Code Climate](https://codeclimate.com/github/alessandro1997/rocket_pants-pagination/badges/gpa.svg)](https://codeclimate.com/github/alessandro1997/rocket_pants-pagination)

Pagination support for [RocketPants](https://github.com/Sutto/rocket_pants).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rocket_pants-pagination'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rocket_pants-pagination

## Usage

```ruby
class PostsController < RocketPants::Base
  include RocketPants::Pagination

  def index
    @posts = Post.all
    paginate_and_expose posts: @posts
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
[https://github.com/alessandro1997/rocket_pants-pagination](https://github.com/alessandro1997/rocket_pants-pagination).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
