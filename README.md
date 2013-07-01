# Configatron

Configatron makes configuring your applications and scripts incredibly easy. No longer is a there a need to use constants or global variables. Now you can use a simple and painless system to configure your life. And, because it's all Ruby, you can do any crazy thing you would like to!

## IMPORTANT NOTES ON V3

V3 is still a work in progress. It is also a complete rewrite of the library. Because V3 is a rewrite there is a lot that has been thrown out, modified, etc... There is a good chance that some feature or method that you were using doesn't exist, or works differently now. Hopefully you'll find these changes for the best. If not, you know how to submit a Pull Request. :)

One of the more important changes to V3 is that it now resembles more a `Hash` style interface. You can use `[]`, `fetch`, `each`, etc...

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

Once installed you just need to require it:

```ruby
require 'configatron'
```

### Simple

```ruby
configatron.email = 'me@example.com'
configatron.database.url = "postgres://localhost/foo"
```

Now, anywhere in your code you can do the following:

```ruby
configatron.email # => "me@example.com"
configatron.database.url # => "postgres://localhost/foo"
```

Viola! Simple as can be.

Now you're saying, what if I want to have a 'default' set of options, but then override them later, based on other information? Simple again. Let's use our above example. We've configured our `database.url` option to be @postgres://localhost/foo@. The problem with that is that is our production database url, not our development url. Fair enough, all you have to do is redeclare it:

```ruby
configatron.database.url = "postgres://localhost/foo_development"
```

becomes:

```ruby
configatron.email # => "me@example.com"
configatron.database.url # => "postgres://localhost/foo_development"
```

Notice how our other configuration parameters haven't changed? Cool, eh?

### Hash/YAML

You can configure Configatron from a hash as well (this is really only useful in testing or for data driven configuration, it's not recommended for actual configuration):

```ruby
configatron.configure_from_hash(email: {pop: {address: 'pop.example.com', port: 110}}, smtp: {address: 'smtp.example.com'})

configatron.email.pop.address # => 'pop.example.com'
configatron.email.pop.port # => 110
# and so on...
```

#### YAML

YAML is terrible and should be driven from the face of the Earth. Because of this Configatron V3 does not support it. Sorry.

### Namespaces

The question that should be on your lips is what I need to have namespaced configuration parameters. It's easy! Configatron allows you to create namespaces.

```ruby
configatron.website_url = "http://www.example.com"
configatron.email.pop.address = "pop.example.com"
configatron.email.pop.port = 110
configatron.email.smtp.address = "smtp.example.com"
configatron.email.smtp.port = 25

configatron.to_h # => {:website_url=>"http://www.example.com", :email=>{:pop=>{:address=>"pop.example.com", :port=>110}, :smtp=>{:address=>"smtp.example.com", :port=>25}}}
```

Configatron allows you to nest namespaces to your hearts content! Just keep going, it's that easy.

Of course you can update a single parameter n levels deep as well:

```ruby
configatron.email.pop.address = "pop2.example.com"

configatron.email.pop.address # => "pop2.example.com"
configatron.email.smtp.address # => "smtp.example.com"
```

Configatron will also let you use a block to clean up your configuration. For example the following two ways of setting values are equivalent:

```ruby
configatron.email.pop.address = "pop.example.com"
configatron.email.pop.port = 110

configatron.email.pop do |pop|
  pop.address = "pop.example.com"
  pop.port = 110
end
```

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

### nil

Even if parameters haven't been set, you can still call them, but you'll get a `Configatron::Store` object back. The `Configatron::Store` class, however, will respond true to `.nil?` or `.blank?` if there are no parameters configured on it.

```ruby
configatron.i.dont.exist.nil? # => true
configatron.i.dont.exist.blank? # => true
configatron.i.dont.exist # => Configatron::Store
```

You can use `.has_key?` to determine if a key already exists.

```ruby
configatron.i.dont.has_key?(:exist) # => false
```

### Kernel

The `configatron` "helper" method is store in the `Kernel` module. Some people didn't like that in the V2 of Configatron, so in V3, while that hasn't changed, you don't have to use it.

Instead of requiring `configatron` simply require `configatron/core`, but then you'll have to set up your own `Configatron::Store` object.

Example:

```ruby
require 'configatron/core'

store = Configatron::Store.new
store.foo = 'FOO'

store.to_h #= {foo: 'FOO'}
```

### Locking

Once you have setup all of your configurations you can call the `lock!` method to lock your settings and raise an error should anyone try to change settings or access an unset setting later.

Example:

```ruby
configatron.foo = 'FOO'
configatron.lock!

configatron.foo # => 'FOO'

configatron.bar # => raises Configatron::UndefinedKeyError
configatron.bar = 'BAR' # => raises Configatron::LockedError
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