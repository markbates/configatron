# Configatron

Configatron makes configuring your applications and scripts incredibly easy. No longer is a there a need to use constants or global variables. Now you can use a simple and painless system to configure your life. And, because it's all Ruby, you can do any crazy thing you would like to!

## IMPORTANT NOTES ON V3

V3 is still a work in progress. It is also a complete rewrite of the library. Because V3 is a rewrite there is a lot that has been thrown out, modified, etc... There is a good chance that some feature or method that you were using doesn't exist, or works differently now. Hopefully you'll find these changes for the best. If not, you know how to submit a Pull Request. :)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'configatron'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install configatron
```

## Usage

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
configatron.letters.c # => {}
```

## Rails

Configatron works great with Rails. Use the built-in generate to generate an initializer file and a series of environment files for you to use to configure your applications.

``` bash
$ rails generate configatron:install
```

Configatron will read in the `config/configatron/defaults.rb` file first and then the environment specific file, such as `config/configatron/development.rb`. Settings in the environment file will merge into and replace the settings in the `defaults.rb` file.

### Example

```ruby
# config/configatron/defaults.rb
configatron.letters.a = 'A'
configatron.letters.b = 'B'
```

```ruby
# config/configatron/development.rb
configatron.letters.b = 'BB'
configatron.letters.c = 'C'
```

```ruby
configatron.to_h # => {:letters=>{:a=>"A", :b=>"BB", :c=>"C"}}
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
* Greg Brockman
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