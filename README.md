# Maglev

Maglev adds theme and sections support to your rails app so you can
create pages and upload assets for them, like in a CMS.
## Installation
Add this line to your application's Gemfile:

```ruby
gem 'maglev'
```

And then execute:
```bash
$ bundle
```

After installing, you need to run maglev's install generator:

```bash
$ bundle exec rails g maglev:install
```

This will do many things, like ensuring that webpacker is set up,
creating a default theme and section, copy maglev's migrations and run them...

Afterwards, just follow the displayed instructions.

## Creating a site

Maglev provides a task to create the default site:

```bash
$ bundle exec rails app:maglev:create_site
```

You should do this both in developmen and production.

## Testing

If for some reason you want your Maglev site to exist during your tests,
you can use `Maglev::GenerateSite.call` on your setup block.
## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
