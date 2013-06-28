# Configatron



## Installation

Add this line to your application's Gemfile:

    gem 'configatron'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install configatron

## Use

### Temp Configurations

Sometimes in testing, or other situations, you want to temporarily change some settings. You can do this with the `temp` method:

```ruby
configatron.one = 1
configatron.letters.a = 'A'
configatron.letters.b = 'B'
configatron.temp do
  configatron.letters.b = 'bb'
  configatron.letters.c = 'c'
  configatron.one # => 1
  configatron.letters.a # => 'A'
  configatron.letters.b # => 'bb'
  configatron.letters.c # => 'c'
end
configatron.one # => 1
configatron.letters.a # => 'A'
configatron.letters.b # => 'B'
configatron.letters.c # => nil
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write Tests!
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## Contributors

* Mark Bates
* Kurtis Rainbolt-Greene
* Rob Sanheim
* Cody Maggard
* Jean-Denis Vauguet
* Torsten Schönebaum
* Mat Brown
* Simon Menke
* chatgris
* Gleb Pomykalov
* Casper Gripenberg
* mattelacchiato
* Artiom Diomin
* Tim Riley
* Rick Fletcher
* joe miller
* Brandon Dimcheff
* Dan Pickett
* Josh Nichols