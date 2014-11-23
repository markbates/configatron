# Configatron
[![Build Status](https://travis-ci.org/markbates/configatron.png)](https://travis-ci.org/markbates/configatron) [![Code Climate](https://codeclimate.com/github/markbates/configatron.png)](https://codeclimate.com/github/markbates/configatron)

Configatron makes configuring your applications and scripts incredibly easy. No longer is a there a need to use constants or global variables. Now you can use a simple and painless system to configure your life. And, because it's all Ruby, you can do any crazy thing you would like to!

One of the more important changes to V3 is that it now resembles more a `Hash` style interface. You can use `[]`, `fetch`, `each`, etc... Actually the hash notation is a bit more robust since the dot notation won't work for a few property names (a few public methods from `Configatron::Store` itself).

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
$ gem install configatron --pre
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

Voila! Simple as can be.

Now you're saying, what if I want to have a 'default' set of options, but then override them later, based on other information? Simple again. Let's use our above example. We've configured our `database.url` option to be `postgres://localhost/foo`. The problem with that is that is our production database url, not our development url. Fair enough, all you have to do is redeclare it:

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

You can configure Configatron from a hash as well (this is particularly useful if you'd like to have configuration files):

```ruby
configatron.configure_from_hash(email: {pop: {address: 'pop.example.com', port: 110}}, smtp: {address: 'smtp.example.com'})

configatron.email.pop.address # => 'pop.example.com'
configatron.email.pop.port # => 110
# and so on...
```

### Method vs hash access

As a note, method (`configatron.foo`) access will be shadowed by public methods defined on the configatron object. (The configatron object descends from [`BasicObject`](http://apidock.com/ruby/BasicObject) and adds a few methods to resemble the `Hash` API and to play nice with `puts`, so it should have a pretty bare set of methods.)

If you need to use keys that are themselves method names, you can just use hash access (`configatron['foo']`).

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

Sometimes in testing, or other situations, you want to temporarily change some settings. You can do this with the `temp` method (only available on the top-level configatron `RootStore`):

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

### Delayed and Dynamic Configurations

There are times when you want to refer to one configuration setting in another configuration setting. Let's look at a fairly contrived example:

```ruby
configatron.memcached.servers = ['127.0.0.1:11211']
configatron.page_caching.servers = configatron.memcached.servers
configatron.object_caching.servers = configatron.memcached.servers

if Rails.env == 'production'
  configatron.memcached.servers = ['192.168.0.1:11211']
  configatron.page_caching.servers = configatron.memcached.servers
  configatron.object_caching.servers = configatron.memcached.servers
elsif Rails.env == 'staging'
  configatron.memcached.servers = ['192.168.0.2:11211']
  configatron.page_caching.servers = configatron.memcached.servers
  configatron.object_caching.servers = configatron.memcached.servers
end
```

Now, we could've written that slightly differently, but it helps to illustrate the point. With Configatron you can create `Delayed` and `Dynamic` settings.

#### Delayed

With `Delayed` settings execution of the setting doesn't happen until the first time it is executed.

```ruby
configatron.memcached.servers = ['127.0.0.1:11211']
configatron.page_caching.servers = Configatron::Delayed.new {configatron.memcached.servers}
configatron.object_caching.servers = Configatron::Delayed.new {configatron.memcached.servers}

if Rails.env == 'production'
  configatron.memcached.servers = ['192.168.0.1:11211']
elsif Rails.env == 'staging'
  configatron.memcached.servers = ['192.168.0.2:11211']
end
```

Execution occurs once and after that the result of that execution is returned. So in our case the first time someone calls the setting `configatron.page_caching.servers` it will find the `configatron.memcached.servers` setting and return that. After that point if the `configatron.memcached.servers` setting is changed, the original settings are returned by `configatron.page_caching.servers`.

#### Dynamic

`Dynamic` settings are very similar to `Delayed` settings, but with one big difference. Every time you call a `Dynamic` setting is executed. Take this example:

```ruby
configatron.current.time = Configatron::Dynamic.new {Time.now}
```

Each time you call `configatron.current.time` it will return a new value to you. While this seems a bit useless, it is pretty useful if you have ever changing configurations.

### Reseting Configurations

In some testing scenarios, it can be helpful to restore Configatron to its default state. This can be done with:

```ruby
configatron.reset!
``` 

### Checking keys

Even if parameters haven't been set, you can still call them, but you'll get a `Configatron::Store` object back. You can use `.has_key?` to determine if a key already exists.

```ruby
configatron.i.dont.has_key?(:exist) # => false
```

#### (key)!

You can also append a `!` to the end of any key. If the key exists it will return it, otherwise it will raise a `Configatron::UndefinedKeyError`.

``` ruby
configatron.a.b = 'B'
configatron.a.b # => 'B'
configatron.a.b! # => 'B'
configatron.a.b.c! # => raise Configratron::UndefinedKeyError
```

### Kernel

The `configatron` "helper" method is stored in the `Kernel` module. You can opt-out of this global monkey-patching by requiring `configatron/core` rather than `configatron`. You'll have to set up your own `Configatron::RootStore` object.

Example:

```ruby
require 'configatron/core'

store = Configatron::RootStore.new
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
* Greg Brockman
* Kurtis Rainbolt-Greene
* Rob Sanheim
* Jérémy Lecour
* Cody Maggard
* Jean-Denis Vauguet
* chatgris
* Simon Menke
* Mat Brown
* Torsten Schönebaum
* Gleb Pomykalov
* Casper Gripenberg
* Artiom Diomin
* mattelacchiato
* Dan Pickett
* Tim Riley
* Rick Fletcher
* Jose Antonio Pio
* Brandon Dimcheff
* joe miller
* Josh Nichols
