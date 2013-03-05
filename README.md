# Configatron [![Build Status](https://travis-ci.org/markbates/configatron.png?branch=master)](https://travis-ci.org/markbates/configatron)

Configatron makes configuring your applications and scripts incredibly easy. No longer is a there a need to use constants or global variables. Now you can use a simple and painless system to configure your life. And, because it's all Ruby, you can do any crazy thing you would like to!

## Installation

Installation of Configatron is easy, as it is just a RubyGem:

```ruby
  $ sudo gem install configatron
```

If you'd like to live on the bleedin' edge you can install the development version from GitHub:

```
  $ sudo gem install markbates-configatron --source=http://gems.github.com
```

Once installed you just need to require it:

```ruby
  require 'configatron'
```

## Examples

### Simple

```ruby
  configatron.email = 'me@example.com'
  configatron.database_url = "postgres://localhost/mack_framework_rocks"
```

Now, anywhere in your code you can do the following:

```ruby
  configatron.email # => "me@example.com"
  configatron.database_url # => "postgres://localhost/mack_framework_rocks"
```

Viola! Simple as can be.

Now you're saying, what if I want to have a 'default' set of options, but then override them later, based on other information? Simple again. Let's use our above example. We've configured our @database_url@ option to be @postgres://localhost/mack_framework_rocks@. The problem with that is that is our production database url, not our development url. Fair enough, all you have to do is redeclare it:

```ruby
  configatron.database_url = "postgres://localhost/mack_framework_rocks_development"
```

becomes:

```ruby
  configatron.email # => "me@example.com"
  configatron.database_url # => "postgres://localhost/mack_framework_rocks_development"
```

Notice how our other configuration parameters haven't changed? Cool, eh?

### Hash/YAML

You can configure configatron from a hash as well (this is really only useful in testing or for data driven configurat, it's not recommended for actual configuration):

```ruby
  configatron.configure_from_hash({:email => {:pop => {:address => 'pop.example.com', :port => 110}}, :smtp => {:address => 'smtp.example.com'}})#### 
  configatron.email.pop.address # => 'pop.example.com'
  configatron.email.pop.port # => 110
  # and so on...
```

#### YAML

Support for YAML has been deprecated and will be removed in version 2.9 of Configatron. Please switch to Ruby based configuration of Configatron. Trust me, it's a lot nicer and easier to use. Why would you _not_ want to?

### Namespaces

The question that should be on your lips is what I need to have namespaced configuration parameters. It's easy! Configatron allows you to create namespaces.

```ruby
  configatron.website_url = "http://www.mackframework.com"
  configatron.email.pop.address = "pop.example.com"
  configatron.email.pop.port = 110
  configatron.email.smtp.address = "smtp.example.com"
  configatron.email.smtp.port = 25
```

becomes:

```ruby
  configatron.email.pop.address # => "pop.example.com"
  configatron.email.smtp.address # => "smtp.example.com"
  configatron.website_url # => "http://www.mackframework.com"
```
####onfigatron allows you to nest namespaces to your hearts content! Just keep going, it's that easy.

Of course you can update a single parameter n levels deep as well:

```ruby
  configatron.email.pop.address = "pop2.example.com"
  
  configatron.email.pop.address # => "pop2.example.com"
  configatron.email.smtp.address # => "smtp.example.com"
```

### Temp Configurations

Sometimes in testing, or other situations, you want to temporarily change some settings. You can do this with the @temp@ method:

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

You can also pass in an optional Hash to the @temp@:

```ruby
  configatron.one = 1
  configatron.letters.a = 'A'
  configatron.letters.b = 'B'
  configatron.temp(:letters => {:b => 'bb', :c => 'c'}) do
 ####one == 1
    configatron.letters.a # => 'A'
    configatron.letters.b # => 'bb'
    configatron.letters.c # => 'c'
  end
  configatron.one == 1
  configatron.letters.a # => 'A'
  configatron.letters.b # => 'B'
  configatron.letters.c # => nil
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

### Misc.

Even if parameters haven't been set, you can still call them, but you'll get a @Configatron::Store@ object back. The Configatron::Store class, however, will respond true to @.nil?@ if there are no parameters configured on it.

```ruby
  configatron.i.dont.exist.nil? # => true
  configatron.i.dont.exist # => Configatron::Store
```

If you want to get back an actual @nil@ then you can use the @retrieve@ method:

```ruby
  configatron.i.do.exist = [:some, :array]
  configatron.i.dont.retrieve(:exist, nil) # => nil
  configatron.i.do.retrieve(:exist, :foo) # => [:some, :array]
```

You can set 'default' values for parameters. If there is already a setting, it won't be replaced. This is useful if you've already done your 'configuration' and you call a library, that needs to have parameters set. The library can set its defaults, without worrying that it might have overridden your custom settings.

```ruby
  configatron.set_default(:name, 'Mark Bates')
  configatron.name # => 'Mark Bates'
  configatron.set_default(:name, 'Me')
  configatron.name # => 'Mark Bates'
```

Enjoy!

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